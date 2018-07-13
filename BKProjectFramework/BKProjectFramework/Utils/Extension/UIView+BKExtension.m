//
//  UIView+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "UIView+BKExtension.h"
#import "MBProgressHUD.h"

@implementation UIView (BKExtension)

#pragma mark - 附加属性

-(void)setX:(CGFloat)x
{
    if (x == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y
{
    if (y == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width
{
    if (width == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height
{
    if (height == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX
{
    if (centerX == NAN) {
        return;
    }
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerY
{
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY
{
    if (centerY == NAN) {
        return;
    }
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

#pragma mark - 切角

-(void)cutRadius:(CGFloat)radius
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
}

-(void)addRoundBorderWithColor:(UIColor*)color lineWidth:(CGFloat)lineWidth radius:(CGFloat)radius
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
    
    for (UIView * view in [self subviews]) {
        if ([view isKindOfClass:[BKRoundedRectView class]]) {
            [view removeFromSuperview];
        }
    }
    
    BKRoundedRectView * colorView = [[BKRoundedRectView alloc]initWithFrame:self.bounds];
    colorView.strokeColor = color;
    colorView.fillColor = [UIColor clearColor];
    colorView.radius = radius;
    colorView.userInteractionEnabled = NO;
    [self addSubview:colorView];
}

#pragma mark - 查找Controller

- (UIViewController *)findViewController
{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 加载框

/**
 显示加载框 （不可点击）
 */
-(void)showLoading
{
    __block BOOL isExist = NO;
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
}

/**
 隐藏加载框 （不可点击）
 */
-(void)hideLoading
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

/**
 显示加载框 （可点击）
 */
-(void)showHUD
{
    __block BOOL isExist = NO;
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.userInteractionEnabled = NO;
    }
}

/**
 隐藏加载框 （可点击）
 */
-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
