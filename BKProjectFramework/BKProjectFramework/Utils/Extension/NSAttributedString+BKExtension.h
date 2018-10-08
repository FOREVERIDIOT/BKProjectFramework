//
//  NSAttributedString+BKExtension.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/10/8.
//  Copyright © 2018年 BIKE. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (BKExtension)

#pragma mark - 计算文本大小

/**
 计算文本高度(固定宽)
 
 @param width 固定宽度
 @return 文本大小
 */
-(CGFloat)calculateHeightWithUIWidth:(CGFloat)width;

/**
 计算文本宽度(固定高)
 
 @param height 固定高度
 @return 文本大小
 */
-(CGFloat)calculateWidthWithUIHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
