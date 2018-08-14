//
//  BKCameraRecordVideoPreviewViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/8/13.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCameraRecordVideoPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+BKImagePicker.h"
#import "BKImagePickerMacro.h"
#import "BKImagePickerConstant.h"
#import "UIView+BKImagePicker.h"

@interface BKCameraRecordVideoPreviewViewController ()

@property (nonatomic,strong) UIProgressView * progress;//播放进度条(没加载显示)
@property (nonatomic,assign) id timeObserver;

@property (nonatomic,strong) UIView * playerView;
@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) AVPlayerLayer * playerLayer;

@property (nonatomic,strong) UIButton * start_pause;

@end

@implementation BKCameraRecordVideoPreviewViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.topNavView removeFromSuperview];
    
    [self initBottomNav];
    
    [self.view insertSubview:self.playerView atIndex:0];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (_playerView) {
        _playerView.frame = self.view.bounds;
        if (_playerLayer) {
            _playerLayer.frame = _playerView.bounds;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_timeObserver) {
        [_player removeTimeObserver:_timeObserver];
    }
}

#pragma mark - NSNotification

-(void)playbackFinished:(NSNotification *)notification
{
    UIImage * start_image = [UIImage bk_imageWithImageName:@"video_start"];
    [_start_pause setImage:start_image forState:UIControlStateNormal];
    
    [self.player seekToTime:CMTimeMake(0, 1)];
}

#pragma mark - initBottomNav

-(void)initBottomNav
{
    self.bottomLine.hidden = YES;
    self.bottomNavViewHeight = BK_IPONEX ? BK_SYSTEM_TABBAR_HEIGHT : 64;
    
    self.bottomNavView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 0, 64, 64);
    [back setBackgroundColor:[UIColor clearColor]];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:16];
    [back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomNavView addSubview:back];
    
    [self.bottomNavView addSubview:[self start_pause]];
}

-(UIButton*)start_pause
{
    if (!_start_pause) {
        UIImage * start_image = [UIImage bk_imageWithImageName:@"video_start"];
        
        _start_pause = [UIButton buttonWithType:UIButtonTypeCustom];
        _start_pause.frame = CGRectMake((self.bottomNavView.bk_width - 64)/2.0f, 0, 64, 64);
        [_start_pause setImage:start_image forState:UIControlStateNormal];
        [_start_pause setImageEdgeInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
        _start_pause.clipsToBounds = YES;
        _start_pause.adjustsImageWhenHighlighted = NO;
        [_start_pause addTarget:self action:@selector(start_pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _start_pause;
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)start_pauseBtnClick:(UIButton*)button
{
    if (self.player.rate == 0) {
        UIImage * pause_image = [UIImage bk_imageWithImageName:@"video_pause"];
        [_start_pause setImage:pause_image forState:UIControlStateNormal];
        
        [self.player play];
    }else {
        UIImage * start_image = [UIImage bk_imageWithImageName:@"video_start"];
        [_start_pause setImage:start_image forState:UIControlStateNormal];
        
        [self.player pause];
    }
}

#pragma mark - playerView

-(UIView*)playerView
{
    if (!_playerView) {
        _playerView = [[UIView alloc]initWithFrame:self.view.bounds];
        _playerView.backgroundColor = [UIColor blackColor];
        
        self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:self.videoPath]];
        [self.playerView.layer addSublayer:self.playerLayer];
        
        [self addProgressObserver];
    }
    return _playerView;
}

//进度监控
-(void)addProgressObserver
{
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progress;
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (progress) {
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds([playerItem duration]);
            if (current) {
                [progress setProgress:(current/total) animated:YES];
            }
        }
    }];
}

#pragma mark - playerLayer

-(AVPlayerLayer*)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = _playerView.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}

@end
