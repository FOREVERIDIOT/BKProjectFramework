//
//  UILabel+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/10/8.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "UILabel+BKExtension.h"

@implementation UILabel (BKExtension)

#pragma mark - 计算文本大小

/**
 计算文本的宽
 
 @return 宽
 */
-(CGFloat)calculateWidth
{
    if (self.attributedText) {
        return [self.attributedText calculateWidthWithUIHeight:self.height];
    }
    CGSize size = [self.text calculateSizeWithUIHeight:self.height font:self.font];
    return size.width;
}

/**
 计算文本的高
 
 @return 高
 */
-(CGFloat)calculateHeight
{
    if (self.attributedText) {
        return [self.attributedText calculateHeightWithUIWidth:self.width];
    }
    CGSize size = [self.text calculateSizeWithUIWidth:self.width font:self.font];
    return size.height;
}

@end
