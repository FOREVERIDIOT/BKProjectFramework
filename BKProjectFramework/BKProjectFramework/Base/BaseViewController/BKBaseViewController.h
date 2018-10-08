//
//  BKBaseViewController.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKNavButton.h"

@interface BKBaseViewController : UIViewController

#pragma mark - 顶部导航

@property (nonatomic,strong) UIView * topNavView;//高度为 get_system_nav_height()
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) NSArray<BKNavButton*> * leftNavBtns;
@property (nonatomic,strong) NSArray<BKNavButton*> * rightNavBtns;
@property (nonatomic,strong) BKImageView * topLine;
@property (nonatomic,assign) CGFloat topNavViewHeight;//topNavView的高度 默认高度为 get_system_nav_height()

#pragma mark - 底部导航

@property (nonatomic,strong) UIView * bottomNavView;//高度为 SYSTEM_TABBAR_HEIGHT
@property (nonatomic,strong) BKImageView * bottomLine;
@property (nonatomic,assign) CGFloat bottomNavViewHeight;//bottomNavView的高度 默认高度为 0

#pragma mark - 状态栏

@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;//状态栏样式
@property (nonatomic,assign) BOOL statusBarHidden;//状态栏是否隐藏
@property (nonatomic,assign) UIStatusBarAnimation statusBarUpdateAnimation;//状态栏更新动画

/**
 状态栏是否隐藏(带动画)

 @param hidden 是否隐藏
 @param animation 动画类型
 */
-(void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

@end
