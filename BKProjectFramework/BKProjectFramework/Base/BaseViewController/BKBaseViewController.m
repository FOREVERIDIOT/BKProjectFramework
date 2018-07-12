//
//  BKBaseViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKBaseViewController.h"
#import "BKNavButton.h"

@interface BKBaseViewController ()

@end

@implementation BKBaseViewController

#pragma mark -  viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kColor_FFFFFF;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.topNavView];
    [self.view addSubview:self.bottomNavView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _topNavView.frame = CGRectMake(0, 0, SCREENW, _topNavViewHeight);
    _bottomNavView.frame = CGRectMake(0, self.view.height - _bottomNavViewHeight, SCREENW, _bottomNavViewHeight);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[BKShareManager sharedManager] getCurrentTime];
}

#pragma mark - 顶部导航

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _titleLab.text = title;
}

-(UIView*)topNavView
{
    if (!_topNavView) {
        
        _topNavViewHeight = SYSTEM_NAV_HEIGHT;
        
        _topNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, _topNavViewHeight)];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(64, SYSTEM_STATUSBAR_HEIGHT, SCREENW-64*2, SYSTEM_NAV_UI_HEIGHT)];
        _titleLab.textColor = kColor_333333;
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = self.title;
        [_topNavView addSubview:_titleLab];
        
//        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _leftBtn.frame = CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, 64, SYSTEM_NAV_UI_HEIGHT);
//        _leftBtn.backgroundColor = [UIColor clearColor];
//        [_leftBtn addTarget:self action:@selector(leftNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_topNavView addSubview:_leftBtn];
//
//        _leftLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _leftBtn.width, _leftBtn.height)];
//        _leftLab.font = [UIFont systemFontOfSize:15];
//        _leftLab.textColor = HEX_RGB(0xffffff);
//        _leftLab.textAlignment = NSTextAlignmentCenter;
//        [_leftBtn addSubview:_leftLab];
//
//        _leftImageView = [[BKImageView alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
//        _leftImageView.centerY = _leftLab.centerY;
//        if ([self.navigationController.viewControllers count] != 1) {
//            _leftImageView.image = [UIImage imageNamed:@"nav_back"];
//        }
//        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _leftImageView.clipsToBounds = YES;
//        [_leftBtn addSubview:_leftImageView];
//
//        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _rightBtn.frame = CGRectMake(SCREENW-64, SYSTEM_STATUSBAR_HEIGHT, 64, SYSTEM_NAV_UI_HEIGHT);
//        _rightBtn.backgroundColor = [UIColor clearColor];
//        [_rightBtn addTarget:self action:@selector(rightNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_topNavView addSubview:_rightBtn];
//
//        _rightLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _rightBtn.width, _rightBtn.height)];
//        _rightLab.font = [UIFont systemFontOfSize:15];
//        _rightLab.textAlignment = NSTextAlignmentCenter;
//        _rightLab.textColor = HEX_RGB(0xffffff);
//        _rightLab.backgroundColor = [UIColor clearColor];
//        [_rightBtn addSubview:_rightLab];
//
//        _rightImageView = [[BKImageView alloc]initWithFrame:CGRectMake(_rightBtn.width - 20 - 20, 0, 20 , 20)];
//        _rightImageView.centerY = _rightLab.centerY;
//        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _rightImageView.clipsToBounds = YES;
//        [_rightBtn addSubview:_rightImageView];
        
        BKNavButton * button = [[BKNavButton alloc] initWithFrame:CGRectMake(6, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT) title:@"设置"];
        [_topNavView addSubview:button];
        
        NSLog(@"%f,%f",_topNavView.width,SYSTEM_NAV_UI_HEIGHT);
        NSLog(@"%f",_topNavView.width - SYSTEM_NAV_UI_HEIGHT);
        BKNavButton * button_r = [[BKNavButton alloc] initWithFrame:CGRectMake(_topNavView.width - SYSTEM_NAV_UI_HEIGHT, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT) image:[UIImage imageNamed:@"demo_n"]];
        [_topNavView addSubview:button_r];
        
        _topLine = [[BKImageView alloc]initWithFrame:CGRectMake(0, _topNavView.height - ONE_PIXEL, SCREENW, ONE_PIXEL)];
        _topLine.backgroundColor = kColor_E8E8E8;
        [_topNavView addSubview:_topLine];
    }
    return _topNavView;
}

-(void)setLeftBtns:(NSArray<UIButton *> *)leftBtns
{
    _leftBtns = leftBtns;
    
    NSInteger count = [_leftBtns count];
    UIButton * lastBtn = nil;
    for (UIButton * currentBtn in _leftBtns) {
        
        
        
        lastBtn = currentBtn;
    }
}

-(void)setTopNavViewHeight:(CGFloat)topNavViewHeight
{
    _topNavViewHeight = topNavViewHeight;
    
    _topNavView.height = _topNavViewHeight;
}

-(void)leftNavBtnAction:(UIButton*)button
{
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count] != 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)rightNavBtnAction:(UIButton*)button
{
    
}

#pragma mark - 底部导航

-(UIView*)bottomNavView
{
    if (!_bottomNavView) {
        _bottomNavView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - _bottomNavViewHeight, SCREENW, _bottomNavViewHeight)];
        _bottomNavView.backgroundColor = kColor_F2F2F2;
        
        _bottomLine = [[BKImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, ONE_PIXEL)];
        _bottomLine.backgroundColor = kColor_E8E8E8;
        [_bottomNavView addSubview:_bottomLine];
    }
    return _bottomNavView;
}

-(void)setBottomNavViewHeight:(CGFloat)bottomNavViewHeight
{
    _bottomNavViewHeight = bottomNavViewHeight;
    
    _bottomNavView.height = _bottomNavViewHeight;
    _bottomNavView.y = self.view.height - _bottomNavView.height;
}

//#pragma iPhoneX黑条隐藏
//
//-(BOOL)prefersHomeIndicatorAutoHidden
//{
//    return YES;
//}

#pragma mark - 屏幕旋转处理

// 只支持竖屏
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
