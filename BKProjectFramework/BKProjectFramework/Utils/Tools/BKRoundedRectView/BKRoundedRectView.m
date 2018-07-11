//
//  BKRoundedRectView.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKRoundedRectView.h"

@implementation BKRoundedRectView

#pragma mark - Setter

-(void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

-(void)setStrokeWidth:(CGFloat)strokeWidth
{
    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}

-(void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

-(void)setWidth:(CGFloat)width
{
    [super setWidth:width];
    [self setNeedsDisplay];
}

-(void)setHeight:(CGFloat)height
{
    [super setHeight:height];
    [self setNeedsDisplay];
}

#pragma mark - 初始方法

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - drawRect

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [(_fillColor?_fillColor:[UIColor clearColor]) setFill];
    [(_strokeColor?_strokeColor:[UIColor clearColor]) setStroke];
    
    CGFloat x = ONE_PIXEL;
    CGFloat y = ONE_PIXEL;
    CGFloat width = self.width - ONE_PIXEL*2;
    CGFloat height = self.height - ONE_PIXEL*2;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, width, height) cornerRadius:_radius?_radius:(height/2)];
    path.lineWidth = self.strokeWidth == 0 ? ONE_PIXEL : self.strokeWidth;
    [path fill];
    [path stroke];
}

@end
