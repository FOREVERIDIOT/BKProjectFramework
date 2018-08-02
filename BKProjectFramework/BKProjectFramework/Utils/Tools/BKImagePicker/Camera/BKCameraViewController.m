//
//  BKCameraViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/19.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCameraViewController.h"
#import "BKCameraShutterBtn.h"
#import "BKImagePickerMacro.h"
#import "BKCameraRecordProgress.h"
#import "UIView+BKImagePicker.h"
#import "UIImage+BKImagePicker.h"

@interface BKCameraViewController ()<BKCameraManagerDelegate>

@property (nonatomic,strong) BKCameraManager * cameraManager;

@property (nonatomic,strong) BKCameraShutterBtn * shutterBtn;//快门按钮
@property (nonatomic,strong) BKCameraRecordProgress * recordProgress;//记录进度
@property (nonatomic,strong) UIButton * closeBtn;//关闭按钮
@property (nonatomic,strong) UIButton * flashBtn;//闪光按钮
@property (nonatomic,strong) UIButton * switchShotBtn;//镜头按钮

@end

@implementation BKCameraViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.topNavView removeFromSuperview];
    [self.bottomNavView removeFromSuperview];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.shutterBtn];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.switchShotBtn];
    [self.view addSubview:self.flashBtn];
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
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
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

-(BOOL)recordingFailure:(BKRecordVideoFailure)failure
{
    switch (failure) {
        case BKRecordVideoFailureCaptureDeviceError:
        {
            [self.view bk_showRemind:@"取得摄像头时出现问题!"];
            [self dismissViewControllerAnimated:YES completion:nil];
            return YES;
        }
            break;
        case BKRecordVideoFailureWriteVideoInputError:
        {
            [self.view bk_showRemind:@"初始化录像设备出错!"];
            [self dismissViewControllerAnimated:YES completion:nil];
            return YES;
        }
            break;
        case BKRecordVideoFailureWriteAudioInputError:
        {
            [self.view bk_showRemind:@"初始化音频设备出错!"];
            [self dismissViewControllerAnimated:YES completion:nil];
            return NO;
        }
            break;
        case BKRecordVideoFailureVideoInputError:
        {
            [self.view bk_showRemind:@"写入视频失败!"];
            return YES;
        }
            break;
        case BKRecordVideoFailureAudioInputError:
        {
            [self.view bk_showRemind:@"写入音频失败!"];
            return NO;
        }
            break;
    }
}

#pragma mark - 快门按钮

-(BKCameraShutterBtn*)shutterBtn
{
    if (!_shutterBtn) {
        _shutterBtn = [[BKCameraShutterBtn alloc]initWithFrame:CGRectMake((self.view.bk_width - 75)/2, self.view.bk_height - 75 - 40, 75, 75)];
        _shutterBtn.cameraType = _cameraType;
        BK_WEAK_SELF(self);
        [_shutterBtn setTakePictureAction:^{
           
        }];
        [_shutterBtn setRecordVideoAction:^(BKRecordState state) {
            if (state == BKRecordStateRecording) {
                [weakSelf.cameraManager startRecordVideo];
            }else if (state == BKRecordStatePause) {
                [weakSelf.cameraManager pauseRecordVideo];
            }
        }];
    }
    return _shutterBtn;
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

#pragma mark - 闪光灯

-(UIButton*)flashBtn
{
    if (!_flashBtn) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashBtn.frame = CGRectMake(BK_SCREENW - 64, CGRectGetMaxY(self.switchShotBtn.frame), 64, BK_SYSTEM_NAV_UI_HEIGHT);
        [_flashBtn addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * flashImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_flashBtn.bk_width - 25)/2, (_flashBtn.bk_height - 25)/2, 25, 25)];
        flashImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_close_flash"];
        flashImageView.tag = 1;
        [_flashBtn addSubview:flashImageView];
    }
    return _flashBtn;
}

-(void)flashBtnClick:(UIButton*)button
{
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

@end
