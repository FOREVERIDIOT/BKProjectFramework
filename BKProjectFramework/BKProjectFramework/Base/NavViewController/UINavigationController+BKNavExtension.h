//
//  UINavigationController+BKNavExtension.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKTransitionAnimater.h"

@interface UINavigationController (BKNavExtension)

/**
 过场动画方向
 */
@property (nonatomic,assign) BKTransitionAnimaterDirection direction;

/**
 返回手势是否可用
 */
@property (nonatomic,assign) BOOL popGestureRecognizerEnable;

/**
 当前VC返回过场动画指定VC
 */
@property (nonatomic,strong) UIViewController * popVC;

@end
