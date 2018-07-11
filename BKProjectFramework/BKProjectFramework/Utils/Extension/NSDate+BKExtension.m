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

#pragma mark - 获取当前时间

/**
 获取当前网络时间戳

 @return 当前时间戳
 */
-(NSTimeInterval)getCurrentTimestamp
{
    return [BKShareManager sharedManager].currentTimestamp;
}

/**
 获取当前网络时间

 @return 当前时间
 */
-(NSDate*)getCurrentDate
{
    return [NSDate dateWithTimeIntervalSince1970:[BKShareManager sharedManager].currentTimestamp];
}

#pragma mark - 时间转换 Format形式

/**
 时间转换

 @param format 转换形式
 @return 转换结果
 */
-(NSString*)transformStringWithFormat:(BKDateFormat)format
{
    switch (format) {
        case BKDateFormatYYYY_MM_dd_HH_mm:
        {
            [[self class] sharedDateFormatter].dateFormat = @"YYYY-MM-dd HH:mm";
        }
            break;
        case BKDateFormatYYYY_MM_dd:
        {
            [[self class] sharedDateFormatter].dateFormat = @"YYYY-MM-dd";
        }
            break;
        case BKDateFormatYYYY_MM_HH_mm:
        {
            [[self class] sharedDateFormatter].dateFormat = @"YYYY-MM HH:mm";
        }
            break;
        case BKDateFormatHH_mm:
        {
            [[self class] sharedDateFormatter].dateFormat = @"HH:mm";
        }
            break;
        default:
            break;
    }
    return [[[self class] sharedDateFormatter] stringFromDate:self];
}

#pragma mark - 时间转换 XX前

/**
 几(秒、分钟、小时、天、月、年)前

 @return 几(秒、分钟、小时、天、月、年)前
 */
-(NSString*)transformStringTimesAgo
{
    NSString * text = nil;
    NSInteger agoCount = [self yearsAgo];
    if (agoCount > 0) {
        text = [NSString stringWithFormat:@"%ld年前", (long)agoCount];
    }else{
        NSInteger agoCount = [self monthsAgo];
        if (agoCount > 0) {
            text = [NSString stringWithFormat:@"%ld月前", (long)agoCount];
        }else{
            agoCount = [self dayAgo];
            if (agoCount > 0) {
                text = [NSString stringWithFormat:@"%ld天前", (long)agoCount];
            }else{
                agoCount = [self hoursAgo];
                if (agoCount > 0) {
                    text = [NSString stringWithFormat:@"%ld小时前", (long)agoCount];
                }else{
                    agoCount = [self minutesAgo];
                    if (agoCount > 0) {
                        text = [NSString stringWithFormat:@"%ld分钟前", (long)agoCount];
                    }else{
                        agoCount = [self secondsAgo];
                        if (agoCount > 10) {
                            text = [NSString stringWithFormat:@"%ld秒前", (long)agoCount];
                        }else{
                            text = @"刚刚";
                        }
                    }
                }
            }
        }
    }
    
    return text;
}

-(NSInteger)secondsAgo
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond
                                               fromDate:self
                                                 toDate:[self getCurrentDate]
                                                options:NSCalendarWrapComponents];
    return [components second];
}

-(NSInteger)minutesAgo
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute
                                               fromDate:self
                                                 toDate:[self getCurrentDate]
                                                options:NSCalendarWrapComponents];
    return [components minute];
}

-(NSInteger)hoursAgo
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour
                                               fromDate:self
                                                 toDate:[self getCurrentDate]
                                                options:NSCalendarWrapComponents];
    return [components hour];
}

-(NSInteger)dayAgo
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:self
                                                 toDate:[self getCurrentDate]
                                                options:NSCalendarWrapComponents];
    return [components day];
}

-(NSInteger)monthsAgo
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth
                                               fromDate:self
                                                 toDate:[self getCurrentDate]
                                                options:NSCalendarWrapComponents];
    return [components month];
}

-(NSInteger)yearsAgo
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                               fromDate:self
                                                 toDate:[self getCurrentDate]
                                                options:NSCalendarWrapComponents];
    return [components year];
}

#pragma mark - 获取下一天

/**
 获取下一天

 @return 下一天
 */
-(NSDate*)getNextDayDate
{
    return [NSDate dateWithTimeInterval:24*60*60 sinceDate:self];
}

#pragma mark - 时间相差

/**
 相差几天

 @param date 相比时间
 @return 时间相差几天
 */
-(NSInteger)compareToDateForSpaceDay:(NSDate*)date
{
    NSTimeInterval firstTimeSp = [date timeIntervalSince1970];
    NSTimeInterval secondTimeSp = [self timeIntervalSince1970];
    NSTimeInterval spaceTimeSp = fabs(firstTimeSp - secondTimeSp);
    NSInteger spaceDay = spaceTimeSp/60/60/24;
    return spaceDay;
}

@end
