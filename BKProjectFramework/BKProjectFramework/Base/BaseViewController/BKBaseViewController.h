//
//  BKBaseViewController.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKNavButton.h"

@interface BKBaseViewController : UIViewController

#pragma mark - 顶部导航

@property (nonatomic,strong) UIView * topNavView;//高度为 SYSTEM_NAV_HEIGHT
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) NSArray<BKNavButton*> * leftNavBtns;
@property (nonatomic,strong) NSArray<BKNavButton*> * rightNavBtns;
@property (nonatomic,strong) BKImageView * topLine;
@property (nonatomic,assign) CGFloat topNavViewHeight;//topNavView的高度 默认高度为 SYSTEM_NAV_HEIGHT

#pragma mark - 底部导航

@property (nonatomic,strong) UIView * bottomNavView;//高度为 SYSTEM_TABBAR_HEIGHT
@property (nonatomic,strong) BKImageView * bottomLine;
@property (nonatomic,assign) CGFloat bottomNavViewHeight;//bottomNavView的高度 默认高度为 0

@end
