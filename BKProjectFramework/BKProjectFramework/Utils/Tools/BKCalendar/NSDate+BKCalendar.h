//
//  NSDate+BKCalendar.h
//  BKCalendar
//
//  Created by zhaolin on 2018/10/16.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BKCalendar)

#pragma mark - 关于年

/**
 以系统时间为准 计算date的年份
 
 @return 年份
 */
+(NSInteger)calcYearNumber;

/**
 以对象时间为准 计算date的年份
 
 @return 年份
 */
-(NSInteger)calcYearNumber;

/**
 以系统时间为准 根据间隔数获取某年date
 例子 当前时间为2018-01-01 16:00 number为1 返回结果为2019-01-01 16:00
 
 @param number 2为后年 1为明年 0为今年 -1为去年 -2为前年 以此类推
 @return 某年date
 */
+(NSDate*)getYearDateAccordingToGapsNumber:(NSInteger)number;

/**
 以对象时间为准 根据间隔数获取某年date
 例子 当前时间为2018-01-01 16:00 number为1 返回结果为2019-01-01 16:00
 
 @param number 2为后年 1为明年 0为今年 -1为去年 -2为前年 以此类推
 @return 某年date
 */
-(NSDate*)getYearDateAccordingToGapsNumber:(NSInteger)number;

/**
 以系统时间为准 获取当年第一天
 
 @return 当年第一天
 */
+(NSDate*)getFirstDayInYear;

/**
 以对象时间为准 获取当年第一天
 
 @return 当年第一天
 */
-(NSDate*)getFirstDayInYear;

/**
 以系统时间为准 获取当年有多少天数
 
 @return 一年天数
 */
+(NSInteger)getNumberOfDaysPerYear;

/**
 以对象时间为准 获取当年有多少天数
 
 @return 一年天数
 */
-(NSInteger)getNumberOfDaysPerYear;

/**
 以系统时间为准 获取当年最后一天
 
 @return 当年最后一天
 */
+(NSDate*)getLastDayInYear;

/**
 以对象时间为准 获取当年最后一天
 
 @return 当年最后一天
 */
-(NSDate*)getLastDayInYear;

#pragma mark - 关于月

/**
 以系统时间为准 计算date的月份
 
 @return 月份
 */
+(NSInteger)calcMonthNumber;

/**
 以对象时间为准 计算date的月份
 
 @return 月份
 */
-(NSInteger)calcMonthNumber;

/**
 以系统时间为准 根据间隔数获取某月date
 例子 当前时间为2018-01-01 16:00 number为1 返回结果为2018-02-01 16:00

 @param number 2为下下个月 1为下个月 0为当月 -1为上个月 -2为上上个月 以此类推
 @return 某月date
 */
+(NSDate*)getMonthDateAccordingToGapsNumber:(NSInteger)number;

/**
 以对象时间为准 根据间隔数获取某月date
 例子 当前时间为2018-01-01 16:00 number为1 返回结果为2018-02-01 16:00

 @param number 2为下下个月 1为下个月 0为当月 -1为上个月 -2为上上个月 以此类推
 @return 某月date
 */
-(NSDate*)getMonthDateAccordingToGapsNumber:(NSInteger)number;

/**
 以系统时间为准 获取当月第一天
 
 @return 当月第一天
 */
+(NSDate*)getFirstDayInMonth;

/**
 以对象时间为准 获取当月第一天
 
 @return 当月第一天
 */
-(NSDate*)getFirstDayInMonth;

/**
 以系统时间为准 获取当月有多少天数

 @return 一个月天数
 */
+(NSInteger)getNumberOfDaysPerMonth;

/**
 以对象时间为准 获取当月有多少天数

 @return 一个月天数
 */
-(NSInteger)getNumberOfDaysPerMonth;

/**
 以系统时间为准 获取当月最后一天
 
 @return 当月最后一天
 */
+(NSDate*)getLastDayInMonth;

/**
 以对象时间为准 获取当月最后一天
 
 @return 当月最后一天
 */
-(NSDate*)getLastDayInMonth;

#pragma mark - 关于天

/**
 以系统时间为准 计算date在一月中是几号
 
 @return 几号
 */
+(NSInteger)calcDayNumberInMonth;

/**
 以对象时间为准 计算date在一月中是几号
 
 @return 几号
 */
-(NSInteger)calcDayNumberInMonth;

/**
 以系统时间为准 根据间隔数获取某天date
 例子 当前时间为2018-01-01 16:00 number为1 返回结果为2018-01-02 16:00
 
 @param number 2为后天 1为明天 0为今天 -1为昨天 -2为前天 以此类推
 @return 某天date
 */
+(NSDate*)getDayDateAccordingToGapsNumber:(NSInteger)number;

/**
 以对象时间为准 根据间隔数获取某天date
 例子 当前时间为2018-01-01 16:00 number为1 返回结果为2018-01-02 16:00
 
 @param number 2为后天 1为明天 0为今天 -1为昨天 -2为前天 以此类推
 @return 某天date
 */
-(NSDate*)getDayDateAccordingToGapsNumber:(NSInteger)number;

#pragma mark - 关于星期

/**
 以系统时间为准 获取当日为星期几
 
 @return 0是星期天 1是星期一 2是星期二 3是星期三 4是星期四 5是星期五 6是星期六
 */
+(NSInteger)calcCurrentDateWeek;

/**
 以对象时间为准 获取当日为星期几

 @return 0是星期天 1是星期一 2是星期二 3是星期三 4是星期四 5是星期五 6是星期六
 */
-(NSInteger)calcCurrentDateWeek;

/**
 以系统时间为准 根据间隔数获取某星期date
 例子 当前时间为2018-01-01 16:00 星期二 number为1 返回结果为2018-01-08 16:00 星期二
 
 @param number 2为下下星期 1为下星期 0为这个星期 -1为上星期 -2为上上星期 以此类推
 @return 星期date
 */
+(NSDate*)getWeekDateAccordingToGapsNumber:(NSInteger)number;

/**
 以对象时间为准 根据间隔数获取某星期date
 例子 当前时间为2018-01-01 16:00 星期二 number为1 返回结果为2018-01-08 16:00 星期二
 
 @param number 2为下下星期 1为下星期 0为这个星期 -1为上星期 -2为上上星期 以此类推
 @return 星期date
 */
-(NSDate*)getWeekDateAccordingToGapsNumber:(NSInteger)number;

#pragma mark - 转化系统时区时间

/**
 转化系统时区时间
 
 @return 转化时区后date
 */
-(NSDate*)transformLocaleDate;

@end

NS_ASSUME_NONNULL_END
