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
#import "UIView+BKImagePicker.h"
#import "UIImage+BKImagePicker.h"

@interface BKCameraViewController ()

@property (nonatomic,strong) UIView * previewView;//预览界面

@property (nonatomic,strong) BKCameraShutterBtn * shutterBtn;//快门按钮
@property (nonatomic,strong) UIButton * closeBtn;//关闭按钮

@end

@implementation BKCameraViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.topNavView removeFromSuperview];
    [self.bottomNavView removeFromSuperview];
    
    [self.view addSubview:self.previewView];
    
    [self.view addSubview:self.shutterBtn];
    [self.view addSubview:self.closeBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 预览界面

-(UIView*)previewView
{
    if (!_previewView) {
        _previewView = [[UIView alloc]initWithFrame:self.view.bounds];
        _previewView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(previewViewTap:)];
        [_previewView addGestureRecognizer:tap];
    }
    return _previewView;
}

-(void)previewViewTap:(UITapGestureRecognizer *)tapGesture
{
    
}

#pragma mark - 快门按钮

-(BKCameraShutterBtn*)shutterBtn
{
    if (!_shutterBtn) {
        _shutterBtn = [[BKCameraShutterBtn alloc]initWithFrame:CGRectMake((self.view.bk_width - 75)/2, self.view.bk_height - 75 - 40, 75, 75)];
        _shutterBtn.cameraType = _cameraType;
        BK_WEAK_SELF(self);
        [_shutterBtn setTakePictureAction:^{
            BK_STRONG_SELF(weakSelf);
        }];
        [_shutterBtn setRecordVideoAction:^(BKRecordState state) {
            BK_STRONG_SELF(weakSelf);
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

@end
