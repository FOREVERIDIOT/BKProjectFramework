//
//  BKTabBarController.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKTabBarController.h"
#import "BKTabBar.h"

#import "BKDemoViewController.h"

@interface BKTabBarController ()<BKTabBarDelegate>

@property (nonatomic,strong) NSArray * normalImageArr;
@property (nonatomic,strong) NSArray * selectImageArr;
@property (nonatomic,strong) NSArray * titleArr;

@property (nonatomic,strong) BKTabBar * myTabBar;

@end

@implementation BKTabBarController

-(NSArray*)normalImageArr
{
    if (!_normalImageArr) {
        _normalImageArr = @[@"demo_n", @"demo_n"];
    }
    return _normalImageArr;
}

-(NSArray*)selectImageArr
{
    if (!_selectImageArr) {
        _selectImageArr = @[@"demo_s", @"demo_s"];
    }
    return _selectImageArr;
}

-(NSArray*)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"demo", @"demo"];
    }
    return _titleArr;
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBar.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    
    [self addChildViewController];
    [self.tabBar addSubview:self.myTabBar];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.tabBar.frame;
    frame.size.height = SYSTEM_TABBAR_HEIGHT;
    frame.origin.y = self.view.height - frame.size.height;
    self.tabBar.frame = frame;
    
    _myTabBar.frame = self.tabBar.bounds;
}

#pragma mark - 添加控制器

-(void)addChildViewController
{
    BKDemoViewController * demoVC = [[BKDemoViewController alloc] init];
    BKNavViewController * demoNav = [[BKNavViewController alloc] initWithRootViewController:demoVC];
    
    BKDemoViewController * demoVC1 = [[BKDemoViewController alloc] init];
    BKNavViewController * demoNav1 = [[BKNavViewController alloc] initWithRootViewController:demoVC1];
    
    self.viewControllers = @[demoNav, demoNav1];
    for (int i = 0; i < [self.viewControllers count]; i++) {
        UITabBarItem * item = self.tabBar.items[i];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateDisabled];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateSelected];
    }
}

#pragma mark - myTabBar

-(BKTabBar*)myTabBar
{
    if (!_myTabBar) {
        _myTabBar = [[BKTabBar alloc]initWithFrame:self.tabBar.bounds];
        _myTabBar.delegate = self;
        _myTabBar.defaultSelectNum = 0;
        [_myTabBar creatMyTabBarItemsWithNormalImageArr:self.normalImageArr selectImageArr:self.selectImageArr tittleArr:self.titleArr];
        
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _myTabBar.frame.size.width, ONE_PIXEL)];
        line.backgroundColor = kColor_E8E8E8;
        [_myTabBar addSubview:line];
    }
    return _myTabBar;
}

#pragma mark - BKTabBarDelegate

-(void)tabBar:(BKTabBar *)tabBar didSelectButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [tabBar changeSelectNum:fromIndex to:toIndex normalImageArr:self.normalImageArr selectImageArr:self.selectImageArr];
    
    //    tabBar界面跳转
    self.selectedIndex = toIndex;
}

#pragma mark - 修改选中index

-(void)changeSelectIndex:(NSInteger)index
{
    [_myTabBar clickBtnWhichNum:index];
}

//#pragma iPhoneX黑条隐藏
//
//-(BOOL)prefersHomeIndicatorAutoHidden
//{
//    return YES;
//}

#pragma mark - 屏幕旋转处理

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
