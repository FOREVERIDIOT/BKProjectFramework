//
//  NSAttributedString+BKExtension.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/10/8.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSAttributedString+BKExtension.h"

@implementation NSAttributedString (BKExtension)

/**
 计算文本高度(固定宽)
 
 @param width 固定宽度
 @return 文本大小
 */
-(CGFloat)calculateHeightWithUIWidth:(CGFloat)width
{
    if (!self || width <= 0) {
        return 0;
    }
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.height;
}

/**
 计算文本宽度(固定高)
 
 @param height 固定高度
 @return 文本大小
 */
-(CGFloat)calculateWidthWithUIHeight:(CGFloat)height
{
    if (!self || height <= 0) {
        return 0;
    }
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.width;
}

@end
