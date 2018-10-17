//
//  NSDate+BKChineseCalendar.h
//  BKCalendar
//
//  Created by zhaolin on 2018/10/16.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BKChineseCalendar)

#pragma mark - 中国日历

/**
 获取中国年份

 @return 中国年份
 */
-(NSString*)getChineseYearNumber;

/**
 获取中国日期

 @return 中国日期
 */
-(NSString*)getChineseNumber;

@end

NS_ASSUME_NONNULL_END
