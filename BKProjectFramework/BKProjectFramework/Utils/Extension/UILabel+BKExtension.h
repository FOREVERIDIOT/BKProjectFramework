//
//  UILabel+BKExtension.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/10/8.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (BKExtension)

#pragma mark - 计算文本大小

/**
 计算文本的宽

 @return 宽
 */
-(CGFloat)calculateWidth;

/**
 计算文本的高

 @return 高
 */
-(CGFloat)calculateHeight;

@end

NS_ASSUME_NONNULL_END
