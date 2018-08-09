//
//  BKFocusRectangle.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/8/9.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKFocusRectangle.h"
#import "BKImagePickerMacro.h"
#import "UIView+BKImagePicker.h"

const float kLineW = 2;//线长
const float kHalfLineW = 1;//线的一半长
const float kTrebleLineW = 6;//线的三倍长
const float kSunSpace = 3;//太阳线与其他的间距
const float kSunLightW = 6;//太阳光线长
const float kSunCircleR = 16;//太阳圆半径

@interface BKFocusRectangle()

@property (nonatomic,assign) CGFloat kFocusW;
@property (nonatomic,assign) CGFloat kFocusH;
@property (nonatomic,assign) CGFloat kSunW;
@property (nonatomic,assign) CGFloat kSunH;

@property (nonatomic,assign) CGPoint initPoint;
@property (nonatomic,assign) BOOL isDisplaySun;
@property (nonatomic,assign) CGFloat drawFocus_x_increment;//画聚焦框时x的增量
@property (nonatomic,assign) CGFloat drawSun_x_increment;//画聚焦框时x的增量

@end

@implementation BKFocusRectangle

#pragma mark - get

-(CGFloat)kFocusW
{
    if (_kFocusW == 0) {
        _kFocusW = BK_SCREENW/3;
    }
    return _kFocusW;
}

-(CGFloat)kFocusH
{
    if (_kFocusH == 0) {
        _kFocusH = BK_SCREENW/3;
    }
    return _kFocusH;
}

-(CGFloat)kSunW
{
    if (_kSunW == 0) {
        _kSunW = 50 * BK_SCREENW / 375.0f;
    }
    return _kSunW;
}

-(CGFloat)kSunH
{
    if (_kSunH == 0) {
        _kSunH = self.kSunW;
    }
    return _kSunH;
}

#pragma mark - initWithPoint:isDisplaySun:

-(instancetype)initWithPoint:(CGPoint)point isDisplaySun:(BOOL)isDisplaySun
{
    self = [super initWithFrame:CGRectMake(0, 0, self.kFocusW + self.kSunW, self.kFocusH + self.kSunH * 2)];
    if (self) {
        
        self.initPoint = point;
        self.isDisplaySun = isDisplaySun;
        if (self.isDisplaySun) {
            if (point.x <= BK_SCREENW/2) {
                self.centerX = point.x + self.kSunW/2;
                self.drawFocus_x_increment = 0;
                self.drawSun_x_increment = self.kFocusW;
            }else{
                self.centerX = point.x - self.kSunW/2;
                self.drawFocus_x_increment = self.kSunW;
                self.drawSun_x_increment = 0;
            }
        }else{
            self.centerX = point.x;
        }
        self.centerY = point.y;
        
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - drawRect

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kLineW);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    //聚焦框
    NSArray * focusLineArr = @[@[@(CGPointMake(kHalfLineW, kHalfLineW)),
                            @(CGPointMake(self.kFocusW - kHalfLineW, kHalfLineW)),
                            @(CGPointMake(self.kFocusW - kHalfLineW, self.kFocusH - kHalfLineW)),
                            @(CGPointMake(kHalfLineW, self.kFocusH - kHalfLineW)),
                            @(CGPointMake(kHalfLineW, kHalfLineW))],
                          @[@(CGPointMake(self.kFocusW/2, kLineW)),
                            @(CGPointMake(self.kFocusW/2, kLineW + kTrebleLineW))],
                          @[@(CGPointMake(self.kFocusW - kLineW, self.kFocusH/2)),
                            @(CGPointMake(self.kFocusW - kLineW - kTrebleLineW, self.kFocusH/2))],
                          @[@(CGPointMake(self.kFocusW/2, self.kFocusH - kLineW)),
                            @(CGPointMake(self.kFocusW/2, self.kFocusH - kLineW - kTrebleLineW))],
                          @[@(CGPointMake(kLineW, self.kFocusH/2)),
                            @(CGPointMake(kLineW + kTrebleLineW, self.kFocusH/2))]];
    for (NSArray * arr in focusLineArr) {
        [self context:context drawFocusLineArr:arr];
    }
    
    if (self.isDisplaySun) {
        //太阳
        CGFloat totalH = self.kFocusH + self.kSunH*2;
        CGFloat normalL = (totalH - (self.kSunH + kSunSpace*2 + kHalfLineW*2))/2;
        CGFloat topL = 0;
        CGFloat bottomL = 0;
        if (self.sunLevel > 0) {
            topL = (1 - self.sunLevel) * normalL;
            bottomL = normalL*2 - topL;
        }else if (self.sunLevel < 0) {
            bottomL = -(-1 - self.sunLevel) * normalL;
            topL = normalL*2 - bottomL;
        }else{
            topL = normalL;
            bottomL = normalL;
        }
        
        CGPoint originalPoint = CGPointMake(self.kSunW/2, kHalfLineW + topL + kSunSpace + kSunLightW + kSunSpace + kSunCircleR);
        CGFloat start_hypotenuseL = kSunLightW + kSunSpace + kSunCircleR;//开始点斜边长
        CGFloat end_hypotenuseL = kSunSpace + kSunCircleR;//结束点斜边长
        
        CGPoint point1_start = CGPointMake(originalPoint.x, originalPoint.y - kSunCircleR - kSunSpace - kSunLightW);
        CGPoint point1_end = CGPointMake(originalPoint.x, originalPoint.y - kSunCircleR - kSunSpace);
        
        CGPoint point2_start = CGPointMake(originalPoint.x + cos(M_PI_4)*start_hypotenuseL, originalPoint.y + sin(M_PI_4)*start_hypotenuseL);
        CGPoint point2_end = CGPointMake(originalPoint.x + cos(M_PI_4)*end_hypotenuseL, originalPoint.y + sin(M_PI_4)*end_hypotenuseL);
        
        CGPoint point3_start = CGPointMake(originalPoint.x + kSunCircleR + kSunSpace + kSunLightW, originalPoint.y);
        CGPoint point3_end = CGPointMake(originalPoint.x + kSunCircleR + kSunSpace, originalPoint.y);
        
        CGPoint point4_start = CGPointMake(originalPoint.x + cos(M_PI_4)*start_hypotenuseL, originalPoint.y - sin(M_PI_4)*start_hypotenuseL);
        CGPoint point4_end = CGPointMake(originalPoint.x + cos(M_PI_4)*end_hypotenuseL, originalPoint.y - sin(M_PI_4)*end_hypotenuseL);
        
        CGPoint point5_start = CGPointMake(originalPoint.x, originalPoint.y + kSunCircleR + kSunSpace + kSunLightW);
        CGPoint point5_end = CGPointMake(originalPoint.x, originalPoint.y + kSunCircleR + kSunSpace);
        
        CGPoint point6_start = CGPointMake(originalPoint.x - cos(M_PI_4)*start_hypotenuseL, originalPoint.y - sin(M_PI_4)*start_hypotenuseL);
        CGPoint point6_end = CGPointMake(originalPoint.x - cos(M_PI_4)*end_hypotenuseL, originalPoint.y - sin(M_PI_4)*end_hypotenuseL);
        
        CGPoint point7_start = CGPointMake(originalPoint.x - kSunCircleR - kSunSpace - kSunLightW, originalPoint.y);
        CGPoint point7_end = CGPointMake(originalPoint.x - kSunCircleR - kSunSpace, originalPoint.y);
        
        CGPoint point8_start = CGPointMake(originalPoint.x - cos(M_PI_4)*start_hypotenuseL, originalPoint.y + sin(M_PI_4)*start_hypotenuseL);
        CGPoint point8_end = CGPointMake(originalPoint.x - cos(M_PI_4)*end_hypotenuseL, originalPoint.y + sin(M_PI_4)*end_hypotenuseL);
        
        NSArray * sunLineArr = @[@[@(CGPointMake(self.kSunW/2, kHalfLineW)),
                                   @(CGPointMake(self.kSunW/2, kHalfLineW + topL))],
                                 @[@(CGPointMake(self.kSunW/2, totalH - kHalfLineW - bottomL)),
                                   @(CGPointMake(self.kSunW/2, totalH - kHalfLineW))],
                                 @[@(point1_start),
                                   @(point1_end)],
                                 @[@(point2_start),
                                   @(point2_end)],
                                 @[@(point3_start),
                                   @(point3_end)],
                                 @[@(point4_start),
                                   @(point4_end)],
                                 @[@(point5_start),
                                   @(point5_end)],
                                 @[@(point6_start),
                                   @(point6_end)],
                                 @[@(point7_start),
                                   @(point7_end)],
                                 @[@(point8_start),
                                   @(point8_end)],
                                 ];
        for (NSArray * arr in sunLineArr) {
            [self context:context drawSunLineArr:arr];
        }
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, self.drawSun_x_increment + originalPoint.x, originalPoint.y, kSunCircleR, 0, M_PI*2, YES);
        CGContextFillPath(context);
    }
}

/**
 画聚焦框按偏移量重新计算point
 */
-(CGPoint)resetDrawFocusPoint:(CGPoint)point
{
    return CGPointMake(self.drawFocus_x_increment + point.x, self.kSunH + point.y);
}

/**
 画聚焦框
 */
-(void)context:(CGContextRef)context drawFocusLineArr:(NSArray*)lineArr
{
    [lineArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [self resetDrawFocusPoint:[obj CGPointValue]];
        if (idx == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        }else{
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }];
    CGContextStrokePath(context);
}

/**
 画太阳按偏移量重新计算point
 */
-(CGPoint)resetDrawSunPoint:(CGPoint)point
{
    return CGPointMake(self.drawSun_x_increment + point.x, point.y);
}

/**
 画太阳
 */
-(void)context:(CGContextRef)context drawSunLineArr:(NSArray*)lineArr
{
    [lineArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [self resetDrawSunPoint:[obj CGPointValue]];
        if (idx == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        }else{
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }];
    CGContextStrokePath(context);
}

@end
