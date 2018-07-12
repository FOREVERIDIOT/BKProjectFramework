//
//  BKNavButton.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKNavButton : UIView

/**
 点击回调
 */
@property (nonatomic,copy) void (^clickMethod)(void);

#pragma mark - 图片init

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageInsets:(UIEdgeInsets)imageInsets;

#pragma mark - 标题init

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;
-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor titleInsets:(UIEdgeInsets)titleInsets;

#pragma mark - 图片&标题init

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString*)title;
-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageInsets:(UIEdgeInsets)imageInsets title:(NSString*)title titleInsets:(UIEdgeInsets)titleInsets;
-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageInsets:(UIEdgeInsets)imageInsets title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor titleInsets:(UIEdgeInsets)titleInsets;

@end
