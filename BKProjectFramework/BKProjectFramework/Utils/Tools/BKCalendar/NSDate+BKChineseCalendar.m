//
//  NSDate+BKChineseCalendar.m
//  BKCalendar
//
//  Created by zhaolin on 2018/10/16.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSDate+BKChineseCalendar.h"
#import <objc/runtime.h>

@interface NSDate()

@property (nonatomic,strong) NSCalendar * chineseCalendar;

@end

@implementation NSDate (BKChineseCalendar)

#pragma mark - 日历创建

-(NSCalendar*)chineseCalendar
{
    NSCalendar * chineseCalendar = objc_getAssociatedObject(self, @"bk_chineseCalendar");
    if (!chineseCalendar) {
        chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        objc_setAssociatedObject(self, @"bk_chineseCalendar", chineseCalendar, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return chineseCalendar;
}

+(NSCalendar*)chineseCalendar
{
    NSCalendar * chineseCalendar = objc_getAssociatedObject(self, @"bk_chineseCalendar");
    if (!chineseCalendar) {
        chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        objc_setAssociatedObject(self, @"bk_chineseCalendar", chineseCalendar, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return chineseCalendar;
}

#pragma mark - 中国日历

-(NSString*)getChineseYearNumber
{
    NSArray * chineseYears = [NSArray arrayWithObjects:
                              @"甲子",@"乙丑",@"丙寅",@"丁卯",@"戊辰",@"己巳",@"庚午",@"辛未",@"壬申",@"癸酉",
                              @"甲戌",@"乙亥",@"丙子",@"丁丑",@"戊寅",@"己卯",@"庚辰",@"辛己",@"壬午",@"癸未",
                              @"甲申",@"乙酉",@"丙戌",@"丁亥",@"戊子",@"己丑",@"庚寅",@"辛卯",@"壬辰",@"癸巳",
                              @"甲午",@"乙未",@"丙申",@"丁酉",@"戊戌",@"己亥",@"庚子",@"辛丑",@"壬寅",@"癸丑",
                              @"甲辰",@"乙巳",@"丙午",@"丁未",@"戊申",@"己酉",@"庚戌",@"辛亥",@"壬子",@"癸丑",
                              @"甲寅",@"乙卯",@"丙辰",@"丁巳",@"戊午",@"己未",@"庚申",@"辛酉",@"壬戌",@"癸亥", nil];
    
    NSDateComponents * components = [self.chineseCalendar components:NSCalendarUnitYear fromDate:self];
    NSString * year = [chineseYears objectAtIndex:components.year - 1];
    
    return year;
}

-(NSString*)getChineseNumber
{
    NSArray * chineseDays = [NSArray arrayWithObjects:
                             @"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    NSArray * chineseMonths = [NSArray arrayWithObjects:
                               @"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月",nil];
    
    NSDateComponents * components = [self.chineseCalendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSString * day = [chineseDays objectAtIndex:components.day - 1];
    
    if ([day isEqualToString:@"初一"]) {
        return [chineseMonths objectAtIndex:components.month - 1];
    }
    
    return day;
}

@end
