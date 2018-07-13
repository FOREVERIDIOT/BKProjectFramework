//
//  BKBaseViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKBaseViewController.h"

@interface BKBaseViewController ()

@property (nonatomic,assign) CGFloat leftNavSpace;
@property (nonatomic,assign) CGFloat rightNavSpace;

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
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, _topNavView.width, SYSTEM_NAV_UI_HEIGHT)];
        _titleLab.textColor = kColor_333333;
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = self.title;
        [_topNavView addSubview:_titleLab];
        
        if ([self.navigationController.viewControllers count] != 1) {
            BKNavButton * backBtn = [[BKNavButton alloc] initWithImage:[UIImage imageNamed:@"back"]];
            [backBtn setClickMethod:^(BKNavButton *button) {
                if (self.navigationController) {
                    if ([self.navigationController.viewControllers count] != 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            self.leftNavBtns = @[backBtn];
        }
        
        _topLine = [[BKImageView alloc]initWithFrame:CGRectMake(0, _topNavView.height - ONE_PIXEL, SCREENW, ONE_PIXEL)];
        _topLine.backgroundColor = kColor_E8E8E8;
        [_topNavView addSubview:_topLine];
    }
    return _topNavView;
}

-(void)setTopNavViewHeight:(CGFloat)topNavViewHeight
{
    _topNavViewHeight = topNavViewHeight;
    
    _topNavView.height = _topNavViewHeight;
}

-(void)setLeftNavBtns:(NSArray<BKNavButton *> *)leftNavBtns
{
    _leftNavBtns = leftNavBtns;
    
    BKNavButton * lastBtn;
    for (BKNavButton * currentBtn in _leftNavBtns) {
        currentBtn.x = CGRectGetMaxX(lastBtn.frame);
        [_topNavView addSubview:currentBtn];
        lastBtn = currentBtn;
    }
    
    _leftNavSpace = CGRectGetMaxX(lastBtn.frame);
    if (_rightNavSpace < _leftNavSpace) {
        _titleLab.width = _topNavView.width - _leftNavSpace*2;
        _titleLab.x = _leftNavSpace;
    }else{
        _titleLab.width = _topNavView.width - _rightNavSpace*2;
        _titleLab.x = _rightNavSpace;
    }
}

-(void)setRightNavBtns:(NSArray<BKNavButton *> *)rightNavBtns
{
    _rightNavBtns = rightNavBtns;
    
    BKNavButton * lastBtn;
    for (BKNavButton * currentBtn in _rightNavBtns) {
        currentBtn.x = lastBtn ? CGRectGetMinX(lastBtn.frame) - currentBtn.width : _topNavView.width - currentBtn.width;
        [_topNavView addSubview:currentBtn];
        lastBtn = currentBtn;
    }
    
    _rightNavSpace = CGRectGetMinX(lastBtn.frame);
    if (_rightNavSpace < _leftNavSpace) {
        _titleLab.width = _topNavView.width - _leftNavSpace*2;
        _titleLab.x = _leftNavSpace;
    }else{
        _titleLab.width = _topNavView.width - _rightNavSpace*2;
        _titleLab.x = _rightNavSpace;
    }
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
