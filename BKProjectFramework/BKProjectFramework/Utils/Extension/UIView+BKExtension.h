//
//  UIView+BKExtension.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (BKExtension)

#pragma mark - 附加属性

/**
 x
 */
@property (nonatomic, assign) CGFloat x;

/**
 y
 */
@property (nonatomic, assign) CGFloat y;

/**
 width
 */
@property (nonatomic, assign) CGFloat width;

/**
 height
 */
@property (nonatomic, assign) CGFloat height;

/**
 centerX
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 centerY
 */
@property (nonatomic, assign) CGFloat centerY;

#pragma mark - 切角

/**
 切角
 
 @param radius 度数
 */
-(void)cutRadius:(CGFloat)radius;

/**
 加圆形边框(超出切掉)
 
 @param color     颜色
 @param lineWidth 线宽
 @param radius    度数
 */
-(void)addRoundBorderWithColor:(UIColor*)color lineWidth:(CGFloat)lineWidth radius:(CGFloat)radius;

#pragma mark - 查找Controller

/**
 查找controller
 
 @return UIViewController
 */
- (UIViewController *)findViewController;

#pragma mark - 提示框

-(void)showMessage:(NSString *)message;

#pragma mark - 加载框

/**
 显示加载框 （不可点击）
 */
-(MBProgressHUD*)showLoading;

/**
 显示带提示加载框 （不可点击）
 
 @param remind 提示
 */
-(void)showLoading:(NSString*)remind;

/**
 隐藏加载框 （不可点击）
 */
-(void)hideLoading;

/**
 显示加载框 （可点击）
 */
-(MBProgressHUD*)showHUD;

/**
 显示带提示加载框 （可点击）
 
 @param remind 提示
 */
-(void)showHUD:(NSString*)remind;

/**
 隐藏加载框 （可点击）
 */
-(void)hideHUD;

@end
