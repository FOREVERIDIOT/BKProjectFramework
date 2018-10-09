//
//  UIView+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "UIView+BKExtension.h"

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

#pragma mark - 提示框

-(void)showMessage:(NSString *)message
{
    if ([message length] <= 0) {
        return;
    }
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    bgView.layer.cornerRadius = 8.0f;
    bgView.clipsToBounds = YES;
    [window addSubview:bgView];
    
    UILabel * remindLab = [[UILabel alloc]init];
    remindLab.textColor = [UIColor whiteColor];
    CGFloat fontSize = 15.0 * window.bounds.size.width / 375.0f;
    UIFont * font = [UIFont systemFontOfSize:fontSize];
    remindLab.font = font;
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.backgroundColor = [UIColor clearColor];
    remindLab.text = message;
    [bgView addSubview:remindLab];
    
    CGFloat width = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, window.bounds.size.height)
                                          options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size.width;
    if (width > window.bounds.size.width/4.0*3.0f) {
        width = window.bounds.size.width/4.0*3.0f;
    }
    CGFloat height = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: font}
                                           context:nil].size.height;
    
    bgView.bounds = CGRectMake(0, 0, width + 20, height + 20);
    bgView.layer.position = CGPointMake(window.bounds.size.width / 2.0f, window.bounds.size.height / 2.0f);
    
    remindLab.bounds = CGRectMake(0, 0, width, height);
    remindLab.layer.position = CGPointMake(bgView.bounds.size.width / 2.0f, bgView.bounds.size.height / 2.0f);
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

#pragma mark - 加载框

/**
 显示加载框 （不可点击）
 */
-(MBProgressHUD*)showLoading
{
    __block MBProgressHUD * hud = nil;
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            hud = obj;
            *stop = YES;
        }
    }];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    return hud;
}

/**
 显示带提示加载框 （不可点击）

 @param remind 提示
 */
-(void)showLoading:(NSString*)remind
{
    MBProgressHUD * hud = [self showLoading];
    hud.label.text = remind;
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
-(MBProgressHUD*)showHUD
{
    __block MBProgressHUD * hud = nil;
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            hud = obj;
            *stop = YES;
        }
    }];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.userInteractionEnabled = NO;
    }
    return hud;
}

/**
 显示带提示加载框 （可点击）
 
 @param remind 提示
 */
-(void)showHUD:(NSString*)remind
{
    MBProgressHUD * hud = [self showHUD];
    hud.label.text = remind;
}

/**
 隐藏加载框 （可点击）
 */
-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
