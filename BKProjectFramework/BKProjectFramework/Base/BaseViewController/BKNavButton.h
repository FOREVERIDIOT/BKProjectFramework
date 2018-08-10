//
//  BKNavButton.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 当图片和标题同时存在时 图片相对于标题的位置

 - BKImagePositionLeft: 左边
 - BKImagePositionTop: 上边
 - BKImagePositionRight: 右边
 - BKImagePositionBottom: 下边
 */
typedef NS_ENUM(NSUInteger, BKImagePosition) {
    BKImagePositionLeft = 0,
    BKImagePositionTop,
    BKImagePositionRight,
    BKImagePositionBottom,
};

@interface BKNavButton : UIView

/***************************************************************************************************
 默认frame = CGRectMake(自动排列间距0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)
 ***************************************************************************************************/

#pragma mark - 图片init

-(instancetype)initWithImage:(UIImage *)image;
-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize;

#pragma mark - 标题init

-(instancetype)initWithTitle:(NSString*)title;
-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font;
-(instancetype)initWithTitle:(NSString*)title titleColor:(UIColor*)titleColor;
-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor;

#pragma mark - 图片&标题init

-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title;
-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title imagePosition:(BKImagePosition)imagePosition;
-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title;
-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title imagePosition:(BKImagePosition)imagePosition;
-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor imagePosition:(BKImagePosition)imagePosition;

#pragma mark - 点击方法

/**
 点击方法

 @param target 对象
 @param action 方法
 */
-(void)addTarget:(nullable id)target action:(nonnull SEL)action;

/**
 点击方法

 @param target 对象
 @param action 方法
 @param object 参数
 */
-(void)addTarget:(nullable id)target action:(nonnull SEL)action object:(id)object;

@end
