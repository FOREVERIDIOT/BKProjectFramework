//
//  UITextField+BKExtension.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/10/9.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (BKExtension)

/**
 获取光标range
 
 @return range
 */
-(NSRange)selectedRange;

/**
 根据range改变光标位置
 备注：UITextField必须为第一响应者才有效
 
 @param range range
 */
-(void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
