//
//  NSDate+BKCalendar.m
//  BKCalendar
//
//  Created by zhaolin on 2018/10/16.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSDate+BKCalendar.h"
#import <objc/runtime.h>

@interface NSDate()

@property (nonatomic,strong) NSCalendar * calendar;

@end

@implementation NSDate (BKCalendar)

#pragma mark - 日历创建

-(NSCalendar*)calendar
{
    NSCalendar * calendar = objc_getAssociatedObject(self, @"bk_calendar");
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        objc_setAssociatedObject(self, @"bk_calendar", calendar, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return calendar;
}

+(NSCalendar*)calendar
{
    NSCalendar * calendar = objc_getAssociatedObject(self, @"bk_calendar");
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        objc_setAssociatedObject(self, @"bk_calendar", calendar, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return calendar;
}

#pragma mark - 关于年

+(NSInteger)calcYearNumber
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return components.year;
}

-(NSInteger)calcYearNumber
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

+(NSDate*)getYearDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.year = number;
    NSDate * yearDate = [self.calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return [yearDate transformLocaleDate];
}

-(NSDate*)getYearDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.year = number;
    NSDate * yearDate = [self.calendar dateByAddingComponents:components toDate:self options:NSCalendarMatchStrictly];
    return [yearDate transformLocaleDate];
}

+(NSDate*)getFirstDayInYear
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDate * firstDay = [self.calendar dateFromComponents:components];
    return [firstDay transformLocaleDate];
}

-(NSDate*)getFirstDayInYear
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitYear fromDate:self];
    NSDate * firstDay = [self.calendar dateFromComponents:components];
    return [firstDay transformLocaleDate];
}

+(NSInteger)getNumberOfDaysPerYear
{
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
    return range.length;
}

-(NSInteger)getNumberOfDaysPerYear
{
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    return range.length;
}

+(NSDate*)getLastDayInYear
{
    NSDate * firstDay = [self getFirstDayInYear];
    NSInteger days = [self getNumberOfDaysPerYear];
    NSDate * lastDay = [firstDay getDayDateAccordingToGapsNumber:days-1];
    return lastDay;
}

-(NSDate*)getLastDayInYear
{
    NSDate * firstDay = [self getFirstDayInYear];
    NSInteger days = [self getNumberOfDaysPerYear];
    NSDate * lastDay = [firstDay getDayDateAccordingToGapsNumber:days-1];
    return lastDay;
}

#pragma mark - 关于月

+(NSInteger)calcMonthNumber
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
    return components.month;
}

-(NSInteger)calcMonthNumber
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitMonth fromDate:self];
    return components.month;
}

+(NSDate*)getMonthDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.month = number;
    NSDate * monthDate = [self.calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return [monthDate transformLocaleDate];
}

-(NSDate*)getMonthDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.month = number;
    NSDate * monthDate = [self.calendar dateByAddingComponents:components toDate:self options:NSCalendarMatchStrictly];
    return [monthDate transformLocaleDate];
}

+(NSDate*)getFirstDayInMonth
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDate * firstDay = [self.calendar dateFromComponents:components];
    return [firstDay transformLocaleDate];
}

-(NSDate*)getFirstDayInMonth
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDate * firstDay = [self.calendar dateFromComponents:components];
    return [firstDay transformLocaleDate];
}

+(NSInteger)getNumberOfDaysPerMonth
{
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    return range.length;
}

-(NSInteger)getNumberOfDaysPerMonth
{
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

+(NSDate*)getLastDayInMonth
{
    NSDate * firstDay = [self getFirstDayInMonth];
    NSInteger days = [self getNumberOfDaysPerMonth];
    NSDate * lastDay = [firstDay getDayDateAccordingToGapsNumber:days-1];
    return lastDay;
}

-(NSDate*)getLastDayInMonth
{
    NSDate * firstDay = [self getFirstDayInMonth];
    NSInteger days = [self getNumberOfDaysPerMonth];
    NSDate * lastDay = [firstDay getDayDateAccordingToGapsNumber:days-1];
    return lastDay;
}

#pragma mark - 关于天

+(NSInteger)calcDayNumberInMonth
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
    return components.day;
}

-(NSInteger)calcDayNumberInMonth
{
    NSDateComponents * components = [self.calendar components:NSCalendarUnitDay fromDate:self];
    return components.day;
}

+(NSDate*)getDayDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.day = number;
    NSDate * dayDate = [self.calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return [dayDate transformLocaleDate];
}

-(NSDate*)getDayDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.day = number;
    NSDate * dayDate = [self.calendar dateByAddingComponents:components toDate:self options:NSCalendarMatchStrictly];
    return [dayDate transformLocaleDate];
}

#pragma mark - 关于星期

+(NSInteger)calcCurrentDateWeek
{
    NSArray * weeks = @[[NSNull null],@"7",@"1",@"2",@"3",@"4",@"5",@"6"];
    NSDateComponents * components = [self.calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger index = [[weeks objectAtIndex:components.weekday] integerValue];
    if (index == 7) {
        return 0;
    }
    return index;
}

-(NSInteger)calcCurrentDateWeek
{
    NSArray * weeks = @[[NSNull null],@"7",@"1",@"2",@"3",@"4",@"5",@"6"];
    NSDateComponents * components = [self.calendar components:NSCalendarUnitWeekday fromDate:self];
    NSInteger index = [[weeks objectAtIndex:components.weekday] integerValue];
    if (index == 7) {
        return 0;
    }
    return index;
}

+(NSDate*)getWeekDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.weekdayOrdinal = number;
    NSDate * weekDate = [self.calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return [weekDate transformLocaleDate];
}

-(NSDate*)getWeekDateAccordingToGapsNumber:(NSInteger)number
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.weekdayOrdinal = number;
    NSDate * weekDate = [self.calendar dateByAddingComponents:components toDate:self options:NSCalendarMatchStrictly];
    return [weekDate transformLocaleDate];
}

#pragma mark - 转化系统时区时间

-(NSDate*)transformLocaleDate
{
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate * localeDate = [self dateByAddingTimeInterval:interval];
    return localeDate;
}

@end
