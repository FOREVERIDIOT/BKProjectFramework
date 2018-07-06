//
//  NSDate+BKExtension.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BKDateFormat) {
    BKDateFormatYYYY_MM_dd_HH_mm = 0,    //YYYY-MM-dd HH:mm
    BKDateFormatYYYY_MM_dd,              //YYYY-MM-dd
    BKDateFormatYYYY_MM_HH_mm,           //YYYY-MM HH:mm
    BKDateFormatHH_mm,                   //YYYY-MM HH:mm
};

@interface NSDate (BKExtension)

#pragma mark - 单例创建

+(NSCalendar *)sharedCalendar;
+(NSDateFormatter *)sharedDateFormatter;

#pragma mark - 获取当前时间

/**
 获取当前时间戳

 @return 当前时间戳
 */
+(NSTimeInterval)getCurrentTimestamp;

/**
 获取当前时间

 @return 当前时间
 */
+(NSDate*)getCurrentDate;

#pragma mark - 时间转换 Format形式

/**
 时间转换

 @param format 转换形式
 @return 转换结果
 */
-(NSString*)transformStringWithFormat:(BKDateFormat)format;

#pragma mark - 时间转换 XX前

/**
 几(秒、分钟、小时、天、月、年)前
 
 @return 几(秒、分钟、小时、天、月、年)前
 */
-(NSString*)transformStringTimesAgo;

#pragma mark - 获取下一天

/**
 获取下一天

 @return 下一天
 */
-(NSDate*)getNextDayDate;

#pragma mark - 时间相差

/**
 相差几天

 @param date 相比时间
 @return 时间相差几天
 */
-(NSInteger)compareToDateOfDay:(NSDate*)date;

@end
