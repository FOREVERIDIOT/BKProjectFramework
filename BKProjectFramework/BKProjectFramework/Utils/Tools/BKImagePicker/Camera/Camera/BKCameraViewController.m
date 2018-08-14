//
//  BKCameraViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/19.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCameraViewController.h"
#import "BKCameraShutterBtn.h"
#import "BKCameraRecordProgress.h"
#import "BKCameraFilterView.h"
#import "BKImagePickerMacro.h"
#import "UIView+BKImagePicker.h"
#import "UIImage+BKImagePicker.h"
#import "BKEditImageViewController.h"
#import "BKCameraRecordVideoPreviewViewController.h"

@interface BKCameraViewController ()<BKCameraManagerDelegate>

@property (nonatomic,strong) BKCameraManager * cameraManager;

@property (nonatomic,strong) BKCameraRecordProgress * recordProgress;//记录进度
@property (nonatomic,strong) UIButton * closeBtn;//关闭按钮
@property (nonatomic,strong) UIButton * flashBtn;//闪光按钮
@property (nonatomic,strong) UIButton * switchShotBtn;//镜头按钮
@property (nonatomic,strong) UIButton * filterBtn;//滤镜按钮
@property (nonatomic,strong) BKCameraFilterView * filterView;//滤镜界面

@property (nonatomic,strong) UIButton * previewBtn;//预览界面
@property (nonatomic,strong) BKCameraShutterBtn * shutterBtn;//快门按钮
@property (nonatomic,strong) UIButton * deleteBtn;//删除按钮
@property (nonatomic,strong) UIButton * finishBtn;//完成按钮

@end

@implementation BKCameraViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.topNavView removeFromSuperview];
    [self.bottomNavView removeFromSuperview];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.recordProgress];
    
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.switchShotBtn];
    [self.view addSubview:self.filterBtn];
    [self.view addSubview:self.flashBtn];
    
    [self.view addSubview:self.previewBtn];
    [self.view addSubview:self.shutterBtn];
    [self.view addSubview:self.deleteBtn];
    [self.view addSubview:self.finishBtn];
    [self.view addSubview:self.filterView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.statusBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //延迟0s 用于优化过场动画显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.cameraManager captureSessionStartRunning];
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.cameraManager captureSessionStopRunning];
    self.statusBarHidden = NO;
}

-(void)dealloc
{
    if (self.cameraType == BKCameraTypeRecordVideo) {
        //删除保存的视频
        [self.cameraManager removeSaveFileDirectory];
    }
}

#pragma mark - BKCameraManager

-(BKCameraManager*)cameraManager
{
    if (!_cameraManager) {
        _cameraManager = [[BKCameraManager alloc] initWithCurrentVC:self];
        _cameraManager.delegate = self;
        _cameraManager.cameraType = _cameraType;
    }
    return _cameraManager;
}

#pragma mark - BKCameraManagerDelegate

-(void)recordingFailure:(NSError *)failure
{
    [self.view bk_showRemind:@"录制失败"];
    //录制失败 停止快门动画 停止进度条 删除录制失败那一段进度
    [self.shutterBtn recordingFailure];
}

-(void)finishRecordedVideo:(NSString*)videoPath firstFrameImage:(UIImage*)image
{
    
}

-(void)previewRecordVideo:(NSString*)videoPath
{
    BKCameraRecordVideoPreviewViewController * vc = [[BKCameraRecordVideoPreviewViewController alloc] init];
    vc.videoPath = videoPath;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)recordViewTapGestureRecognizer
{
    if (self.filterView.alpha == 1) {
        [self filterBtnClick:nil];
    }
}

#pragma mark - 录像进度

-(BKCameraRecordProgress*)recordProgress
{
    if (!_recordProgress) {
        _recordProgress = [[BKCameraRecordProgress alloc] initWithFrame:CGRectMake(0, BK_SYSTEM_STATUSBAR_HEIGHT - 3, self.view.bk_width, 3)];
    }
    return _recordProgress;
}

-(void)switchFinishBtnAlpha
{
    if (self.recordProgress.currentTime > 0) {
        self.previewBtn.alpha = 1;
        self.deleteBtn.alpha = 1;
        self.finishBtn.alpha = 1;
    }else{
        self.previewBtn.alpha = 0;
        self.deleteBtn.alpha = 0;
        self.finishBtn.alpha = 0;
    }
}

#pragma mark - 关闭按钮

-(UIButton*)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, BK_SYSTEM_STATUSBAR_HEIGHT, 64, BK_SYSTEM_NAV_UI_HEIGHT);
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * closeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_closeBtn.bk_width - 25)/2, (_closeBtn.bk_height - 25)/2, 25, 25)];
        closeImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_close"];
        [_closeBtn addSubview:closeImageView];
    }
    return _closeBtn;
}

-(void)closeBtnClick:(UIButton*)button
{
    if (self.filterView.alpha == 1) {
        [self filterBtnClick:nil];
    }
    
    id observer = [[BKImagePicker sharedManager] valueForKey:@"observer"];
    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 镜头翻转

-(UIButton*)switchShotBtn
{
    if (!_switchShotBtn) {
        _switchShotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchShotBtn.frame = CGRectMake(BK_SCREENW - 64, BK_SYSTEM_STATUSBAR_HEIGHT, 64, BK_SYSTEM_NAV_UI_HEIGHT);
        [_switchShotBtn addTarget:self action:@selector(switchShotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * switchShotImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_switchShotBtn.bk_width - 25)/2, (_switchShotBtn.bk_height - 25)/2, 25, 25)];
        switchShotImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_switch_shot"];
        [_switchShotBtn addSubview:switchShotImageView];
    }
    return _switchShotBtn;
}

-(void)switchShotBtnClick:(UIButton*)button
{
    if (self.filterView.alpha == 1) {
        [self filterBtnClick:nil];
    }
    
    [self.cameraManager switchCaptureDeviceComplete:^(BOOL flag, AVCaptureDevicePosition position) {
        if (!flag) {
            [self.view bk_showRemind:@"镜头转换失败"];
            return;
        }
        
        if (position == AVCaptureDevicePositionFront) {
            self.flashBtn.hidden = YES;
            if (self.flashBtn.isSelected) {
                self.flashBtn.selected = NO;
                UIImageView * flashImageView = (UIImageView*)[self.flashBtn viewWithTag:1];
                flashImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_close_flash"];
            }
        }else if (position == AVCaptureDevicePositionBack) {
            self.flashBtn.hidden = NO;
        }
    }];
}

#pragma mark - 滤镜

-(UIButton*)filterBtn
{
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterBtn.frame = CGRectMake(BK_SCREENW - 64, CGRectGetMaxY(self.switchShotBtn.frame), 64, BK_SYSTEM_NAV_UI_HEIGHT);
        [_filterBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * switchShotImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_filterBtn.bk_width - 25)/2, (_filterBtn.bk_height - 25)/2, 25, 25)];
        switchShotImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_filter"];
        [_filterBtn addSubview:switchShotImageView];
    }
    return _filterBtn;
}

-(void)filterBtnClick:(UIButton*)button
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window.userInteractionEnabled) {
        return;
    }
    window.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.shutterBtn.alpha == 1) {
            self.shutterBtn.alpha = 0;
            self.filterView.alpha = 1;
            self.filterView.bk_y = self.view.bk_height - self.filterView.bk_height;
        }else{
            self.shutterBtn.alpha = 1;
            self.filterView.alpha = 0;
            self.filterView.bk_y = self.view.bk_height;
        }
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

#pragma mark - BKCameraFilterView

-(BKCameraFilterView*)filterView
{
    if (!_filterView) {
        _filterView = [[BKCameraFilterView alloc] initWithFrame:CGRectMake(0, self.view.bk_height, self.view.bk_width, 80+75)];
        BK_WEAK_SELF(self);
        [_filterView setSwitchBeautyFilterLevelAction:^(NSInteger level) {
            [weakSelf.cameraManager switchBeautyFilterLevel:(BKBeautyLevel)level];
        }];
    }
    return _filterView;
}

#pragma mark - 闪光灯

-(UIButton*)flashBtn
{
    if (!_flashBtn) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashBtn.frame = CGRectMake(BK_SCREENW - 64, CGRectGetMaxY(self.filterBtn.frame), 64, BK_SYSTEM_NAV_UI_HEIGHT);
        [_flashBtn addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.cameraManager getCurrentCaptureDevicePosition] == AVCaptureDevicePositionFront) {
            _flashBtn.hidden = YES;
        }
        
        UIImageView * flashImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_flashBtn.bk_width - 25)/2, (_flashBtn.bk_height - 25)/2, 25, 25)];
        flashImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_close_flash"];
        flashImageView.tag = 1;
        [_flashBtn addSubview:flashImageView];
    }
    return _flashBtn;
}

-(void)flashBtnClick:(UIButton*)button
{
    if (self.filterView.alpha == 1) {
        [self filterBtnClick:nil];
    }
    
    [self.cameraManager modifyFlashModeComplete:^(BOOL flag, AVCaptureFlashMode flashMode) {
        if (!flag) {
            [self.view bk_showRemind:@"闪光灯转换失败"];
            return;
        }
        
        UIImageView * flashImageView = (UIImageView*)[self.flashBtn viewWithTag:1];
        if (flashMode == AVCaptureFlashModeOn) {
            button.selected = YES;
            flashImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_open_flash"];
        }else if (flashMode == AVCaptureFlashModeOff) {
            button.selected = NO;
            flashImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_close_flash"];
        }
    }];
}

#pragma mark - 预览按钮

-(UIButton*)previewBtn
{
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewBtn.frame = CGRectMake((self.shutterBtn.x - 40)/2, 0, 40, 40);
        _previewBtn.centerY = self.shutterBtn.centerY;
        _previewBtn.alpha = 0;
        [_previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _previewBtn;
}

-(void)previewBtnClick:(UIButton*)button
{
    [self.cameraManager previewRecordVideo];
}

#pragma mark - 快门按钮

-(BKCameraShutterBtn*)shutterBtn
{
    if (!_shutterBtn) {
        _shutterBtn = [[BKCameraShutterBtn alloc]initWithFrame:CGRectMake((self.view.bk_width - 75)/2, self.view.bk_height - 40 - 75, 75, 75)];
        _shutterBtn.cameraType = _cameraType;
        BK_WEAK_SELF(self);
        [_shutterBtn setTakePictureAction:^{
            
            UIImage * currentImage = [weakSelf.cameraManager getCurrentCaptureImage];
            if (!currentImage) {
                [weakSelf.view bk_showRemind:@"图片获取失败"];
                return;
            }
            
            BKEditImageViewController * vc = [[BKEditImageViewController alloc]init];
            vc.editImageArr = @[currentImage];
            vc.fromModule = BKEditImageFromModuleTakePhoto;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        [_shutterBtn setRecordVideoAction:^(BKRecordState state) {
            if (state == BKRecordStateRecording) {
                [weakSelf.cameraManager startRecordVideo];
            }else if (state == BKRecordStatePause || state == BKRecordStateEnd) {
                [weakSelf.cameraManager pauseRecordVideo];
                [weakSelf.recordProgress pauseRecord];
            }else if (state == BKRecordStateRecordingFailure) {
                [weakSelf.recordProgress pauseRecord];
                [weakSelf.recordProgress removeLastRecord];
            }
            [weakSelf switchFinishBtnAlpha];
        }];
        [_shutterBtn setChangeRecordTimeAction:^(CGFloat currentTime) {
            weakSelf.recordProgress.currentTime = currentTime;
        }];
        [_shutterBtn setChangeCaptureDeviceFactorPAction:^(CGFloat factorP) {
            [weakSelf.cameraManager addFactorP:factorP];
        }];
    }
    return _shutterBtn;
}

#pragma mark - 删除按钮

-(UIButton*)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = CGRectGetMaxX(self.shutterBtn.frame) + (self.view.bk_width - CGRectGetMaxX(self.shutterBtn.frame) - 40 *2) / 3;
        _deleteBtn.frame = CGRectMake(x, 0, 40, 40);
        _deleteBtn.centerY = self.shutterBtn.centerY;
        _deleteBtn.alpha = 0;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _deleteBtn;
}

-(void)deleteBtnClick:(UIButton*)button
{
    BOOL flag = [self.cameraManager removeLastRecordVideo];
    if (!flag) {
        [self.view bk_showRemind:@"删除失败"];
        return;
    }
    [self.recordProgress removeLastRecord];
    [self.shutterBtn modifyRecordTime:self.recordProgress.currentTime];
    
    [self switchFinishBtnAlpha];
}

#pragma mark - 完成按钮

-(UIButton*)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = CGRectGetMaxX(self.deleteBtn.frame) + (self.view.bk_width - CGRectGetMaxX(self.shutterBtn.frame) - 40 *2) / 3;
        _finishBtn.frame = CGRectMake(x, 0, 40, 40);
        _finishBtn.centerY = self.shutterBtn.centerY;
        _finishBtn.alpha = 0;
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _finishBtn;
}

-(void)finishBtnClick:(UIButton*)button
{
    
}

@end
