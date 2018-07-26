//
//  BKCameraShutterBtn.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/23.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCameraShutterBtn.h"
#import "BKImagePickerMacro.h"
#import "BKImagePickerConstant.h"
#import "UIView+BKImagePicker.h"
#import "BKCameraRecordVideoModel.h"
#import "BKTimer.h"

typedef NS_ENUM(NSUInteger, BKShutterState) {
    BKShutterStateCancel = 0,      //没有点中状态
    BKShutterStateLongPress        //长按状态
};

float const kTimerInterval = 0.01;//定时器执行间距

@interface BKCameraShutterBtn()

@property (nonatomic,assign) CGPoint startPoint;//记录开始手势的位置

@property (nonatomic,strong) UIView * blurView;
@property (nonatomic,strong) UIView * middleCircleView;

@property (nonatomic,assign) BKShutterState shutterState;//拍照状态
@property (nonatomic,assign) BKRecordState recordState;//录像状态

@property (nonatomic,assign) CGFloat recordTime;//录制时间
@property (nonatomic,strong) CAShapeLayer * progressLayer;//进度layer
@property (nonatomic,strong) NSMutableArray<BKCameraRecordVideoModel*> * recordVideos;//记录视频暂停model的数组
@property (nonatomic,strong) dispatch_source_t recordTimer;//录制视频倒计时定时器

@end

@implementation BKCameraShutterBtn

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.blurView];
        [self addSubview:self.middleCircleView];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(selfLongPress:)];
        longPress.minimumPressDuration = 0.01;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

-(UIView*)blurView
{
    if (!_blurView) {
        _blurView = [[UIView alloc]initWithFrame:self.bounds];
        _blurView.clipsToBounds = YES;
        _blurView.layer.cornerRadius = _blurView.bk_height/2;
        _blurView.userInteractionEnabled = NO;
        
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.bounds;
        [_blurView addSubview:effectView];
    }
    return _blurView;
}

-(UIView*)middleCircleView
{
    if (!_middleCircleView) {
        _middleCircleView = [[UIView alloc]initWithFrame:CGRectMake(self.bk_width/8, self.bk_height/8, self.bk_width/4*3, self.bk_height/4*3)];
        _middleCircleView.clipsToBounds = YES;
        _middleCircleView.layer.cornerRadius = _middleCircleView.bk_height/2;
        _middleCircleView.backgroundColor = [UIColor whiteColor];
        _middleCircleView.userInteractionEnabled = NO;
    }
    return _middleCircleView;
}

#pragma mark - 长按快门按钮

-(void)selfLongPress:(UILongPressGestureRecognizer*)longPress
{
    if (_cameraType == BKCameraTypeTakePhoto) {
        [self takePictureLongPress:longPress];
    }else if (_cameraType == BKCameraTypeRecordVideo) {
        [self recordVideoLongPress:longPress];
    }
}

#pragma mark - 拍照模式

-(void)takePictureLongPress:(UILongPressGestureRecognizer*)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.shutterState = BKShutterStateLongPress;
            _startPoint = [longPress locationInView:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat tranX = [longPress locationOfTouch:0 inView:self].x - _startPoint.x;
            CGFloat tranY = [longPress locationOfTouch:0 inView:self].y - _startPoint.y;
            
            if (fabs(tranX) > self.bk_width || fabs(tranY) > self.bk_height) {
                self.shutterState = BKShutterStateCancel;
            }else{
                self.shutterState = BKShutterStateLongPress;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_shutterState == BKShutterStateLongPress) {
                [self tapShutterAction];
            }
            
            self.shutterState = BKShutterStateCancel;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            self.shutterState = BKShutterStateCancel;
        }
            break;
        default:
            break;
    }
}

/**
 改变快门按钮的状态
 */
-(void)setShutterState:(BKShutterState)shutterState
{
    _shutterState = shutterState;
    
    [UIView animateWithDuration:0.1 animations:^{
        if (self.shutterState == BKShutterStateCancel) {
            self.blurView.transform = CGAffineTransformIdentity;
            self.middleCircleView.transform = CGAffineTransformIdentity;
        }else if (self.shutterState == BKShutterStateLongPress) {
            self.blurView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.middleCircleView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }
    }];
}

-(void)tapShutterAction
{
    if (self.takePictureAction) {
        self.takePictureAction();
    }
}

#pragma mark - 录制模式

-(NSMutableArray<BKCameraRecordVideoModel *> *)recordVideos
{
    if (!_recordVideos) {
        _recordVideos = [NSMutableArray array];
    }
    return _recordVideos;
}

-(void)recordVideoLongPress:(UILongPressGestureRecognizer*)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.recordState == BKRecordStateNone) {
                [self setRecordState:BKRecordStatePrepare oldRecordState:BKRecordStateNone];
            }else if (self.recordState == BKRecordStatePause) {
                [self setRecordState:BKRecordStateRecording oldRecordState:BKRecordStatePause];
            }else if (self.recordState == BKRecordStateEnd) {
                [[UIApplication sharedApplication].keyWindow bk_showRemind:BKRecordVideoMaxTimeRemind];
                longPress.enabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    longPress.enabled = YES;
                });
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            if (self.recordState == BKRecordStatePrepare) {
                [self setRecordState:BKRecordStateNone oldRecordState:BKRecordStatePrepare];
            }else if (self.recordState == BKRecordStateRecording) {
                [self setRecordState:BKRecordStatePause oldRecordState:BKRecordStateRecording];
            }
        }
            break;
        default:
            break;
    }
}

/**
 改变录制按钮状态

 @param recordState 新状态
 @param oldRecordState 旧状态
 */
-(void)setRecordState:(BKRecordState)recordState oldRecordState:(BKRecordState)oldRecordState
{
    _recordState = recordState;
    
    if (oldRecordState == BKRecordStateNone && recordState == BKRecordStatePrepare) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.blurView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.middleCircleView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
    
            if (self.recordState == BKRecordStateNone) {
                return;
            }
            
            self.recordState = BKRecordStateRecording;
            
            [self changeRecordAction];
            
            [self.layer addSublayer:self.progressLayer];
            if ([self.progressLayer.animationKeys containsObject:@"progressAnimate"]) {
                [self.progressLayer removeAnimationForKey:@"progressAnimate"];
            }
            [self addProgressAnimate];
            [self setupTimer];
        }];
    }else if (oldRecordState == BKRecordStatePrepare && recordState == BKRecordStateNone) {
        [UIView animateWithDuration:0.2 animations:^{
            self.blurView.transform = CGAffineTransformIdentity;
            self.middleCircleView.transform = CGAffineTransformIdentity;
        }];
    }else if (oldRecordState == BKRecordStateRecording && recordState == BKRecordStatePause) {
        [self pauseRecord];
        [self changeRecordAction];
    }else if (oldRecordState == BKRecordStatePause && recordState == BKRecordStateRecording) {
        [self continueRecord];
        [self setupTimer];
    }
}

/**
 进度条
 */
-(CAShapeLayer*)progressLayer
{
    if (!_progressLayer) {
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:self.blurView.center radius:self.blurView.bk_width/2-2 startAngle:-M_PI_2 endAngle:M_PI_2+M_PI clockwise:YES];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.path = path.CGPath;
        _progressLayer.bounds = self.blurView.bounds;
        _progressLayer.position = self.blurView.center;
        _progressLayer.lineWidth = 4;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor redColor].CGColor;
    }
    return _progressLayer;
}

/**
 进度条动画
 */
-(void)addProgressAnimate
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = BKRecordVideoMaxTime;
    animation.autoreverses = NO;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    [self.progressLayer addAnimation:animation forKey:@"progressAnimate"];
}

/**
 进度定时器
 */
-(void)setupTimer
{
    /*
     貌似CABasicAnimation动画比定时以kTimerInterval(即0.01)执行一次速度快一个kTimerInterval(即0.01)
     所以全部时间 - 一次间隔 才会和停止的线相对齐
     */
    CGFloat totalTime = BKRecordVideoMaxTime - self.recordTime - kTimerInterval;
    if (totalTime < 0) {//如果定时器时间小于0 return
        return;
    }
    self.recordTimer = [[BKTimer sharedManager] bk_setupTimerWithTimeInterval:kTimerInterval totalTime:totalTime handler:^(BKTimerModel *timerModel) {
        self.recordTime = BKRecordVideoMaxTime - timerModel.lastTime;
    }];
}

/**
 暂停录制
 */
-(void)pauseRecord
{
    [[BKTimer sharedManager] bk_removeTimer:self.recordTimer];
    
    CFTimeInterval pauseTime = [self.progressLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.progressLayer.timeOffset = pauseTime;
    self.progressLayer.speed = 0;
    
    CAShapeLayer * stopLayer = [self setupStopLayer];
    [self.layer addSublayer:stopLayer];
    
    BKCameraRecordVideoModel * model = [[BKCameraRecordVideoModel alloc] init];
    model.pauseTime = pauseTime;
    model.stopLayer = stopLayer;
    [self.recordVideos addObject:model];
}

/**
 继续录制
 */
-(void)continueRecord
{
    CFTimeInterval pauseTime = self.progressLayer.timeOffset;
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    self.progressLayer.timeOffset = 0;
    [self.progressLayer setBeginTime:begin];
    self.progressLayer.speed = 1;
}

/**
 暂停录制线
 */
-(CAShapeLayer*)setupStopLayer
{
    CGFloat bai = self.recordTime / BKRecordVideoMaxTime;
    CGFloat startAngle = -M_PI_2;
    CGFloat totalAngle = M_PI*2;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:self.blurView.center radius:self.blurView.bk_width/2-2 startAngle:startAngle+totalAngle*(bai-0.01) endAngle:startAngle+totalAngle*bai clockwise:YES];
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.bounds = self.blurView.bounds;
    layer.position = self.blurView.center;
    layer.lineWidth = 4;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blueColor].CGColor;
    
    return layer;
}

-(void)changeRecordAction
{
    if (self.recordVideoAction) {
        self.recordVideoAction(_recordState);
    }
}

@end