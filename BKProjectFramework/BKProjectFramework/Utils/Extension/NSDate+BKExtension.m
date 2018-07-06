//
//  NSDate+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSDate+BKExtension.h"

@implementation NSDate (BKExtension)

#pragma mark - 单例创建

static NSCalendar *_calendar = nil;
static NSDateFormatter *_dateFormatter = nil;

+(void)initializeStatics
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
#if __has_feature(objc_arc)
                _calendar = [NSCalendar currentCalendar];
#else
                _calendar = [[NSCalendar currentCalendar] retain];
#endif
            }
            if (_dateFormatter == nil) {
                _dateFormatter = [[NSDateFormatter alloc] init];
            }
        }
    });
}

+(NSCalendar *)sharedCalendar
{
    [self initializeStatics];
    return _calendar;
}

+(NSDateFormatter *)sharedDateFormatter
{
    [self initializeStatics];
    return _dateFormatter;
}

//#pragma mark - 获取当前时间
//
///**
// 获取当前时间戳
//
// @return 当前时间戳
// */
//+(NSTimeInterval)getCurrentTimestamp
//{//随后可以改成获取网络时间
//    return [[NSDate date] timeIntervalSince1970];
//}
//
///**
// 获取当前时间
//
// @return 当前时间
// */
//+(NSDate*)getCurrentDate
//{//随后可以改成获取网络时间
//    return [NSDate date];
//}
//
//#pragma mark - 时间转换 Format形式
//
///**
// 时间转换
//
// @param format 转换形式
// @return 转换结果
// */
//-(NSString*)transformStringWithFormat:(BKDateFormat)format
//{
//
//}
//
//#pragma mark - 时间转换 XX前
//
///**
// 几(秒、分钟、小时、天、月、年)前
//
// @return 几(秒、分钟、小时、天、月、年)前
// */
//-(NSString*)transformStringTimesAgo
//{
//
//}
//
//#pragma mark - 获取下一天
//
///**
// 获取下一天
//
// @return 下一天
// */
//-(NSDate*)getNextDayDate
//{
//
//}
//
//#pragma mark - 时间相差
//
///**
// 相差几天
//
// @param date 相比时间
// @return 时间相差几天
// */
//-(NSInteger)compareToDateOfDay:(NSDate*)date
//{
//
//}

@end
