//
//  BKCalendarViewCell.m
//  MySelfFrame
//
//  Created by BIKE on 17/2/23.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import "BKCalendarViewCell.h"
#import "BKCalendar.h"

#define BK_CALENDAR_REDCOLOR [UIColor colorWithRed:252/255.0f green:61/255.0f blue:57/255.0f alpha:1]

@interface BKCalendarViewCell()

@property (nonatomic,strong) NSMutableArray * dayModelArr;
@property (nonatomic,strong) BKMonthModel * monthModel;

@property (nonatomic,strong) UIView * contentView;

@end

@implementation BKCalendarViewCell

-(BKMonthModel*)monthModel
{
    if (!_monthModel) {
        _monthModel = [[BKMonthModel alloc] init];
    }
    return _monthModel;
}

-(NSMutableArray*)dayModelArr
{
    if (!_dayModelArr) {
        _dayModelArr = [NSMutableArray array];
    }
    return _dayModelArr;
}

#pragma mark - init

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthTapRecognizer:)];
        [self addGestureRecognizer:selfTap];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return self;
}

-(void)assignDataWithFirstDayInMonthDate:(NSDate *)date
{
    _contentView.frame = self.bounds;
    [[_contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSInteger yearNumber = [date calcYearNumber];
        NSString * chineseYearStr = [date getChineseYearNumber];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.returnYearMessage) {
                weakSelf.returnYearMessage([NSString stringWithFormat:@"%ld年 (%@年)",yearNumber,chineseYearStr]);
            }
        });
        
        NSInteger allMonthDayNum = [date getNumberOfDaysPerMonth];
        NSInteger weekNumber = [date calcCurrentDateWeek];
        NSInteger monthNumber = [date calcMonthNumber];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/7.0f;
        CGFloat height = width;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel * monthTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(weekNumber*width, 0, width, 30)];
            monthTitleLab.textColor = BK_CALENDAR_REDCOLOR;
            monthTitleLab.font = [UIFont systemFontOfSize:16*[UIScreen mainScreen].bounds.size.width/375.0f];
            monthTitleLab.textAlignment = NSTextAlignmentCenter;
            monthTitleLab.text = [NSString stringWithFormat:@"%ld月",monthNumber];
            [self.contentView addSubview:monthTitleLab];
        });
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
        NSString * nowDay = [formatter stringFromDate:[NSDate date]];
        
        weakSelf.monthModel.yearNumber = yearNumber;
        weakSelf.monthModel.monthNumber = monthNumber;
        weakSelf.monthModel.days = allMonthDayNum;
        weakSelf.monthModel.firstDayDate = date;
        
        NSDate * firstDate = [date getFirstDayInMonth];
        //下一天 是星期几 0是星期天 1是星期一 ... 6是星期六 7时变成0为星期天
        __block NSInteger nextWeekNumber = weekNumber;
        __block CGFloat Y = 30;
        for (int i = 0; i < allMonthDayNum; i++) {
            
            NSDate * dayDate = [firstDate getDayDateAccordingToGapsNumber:i];
            NSString * chineseNumber = [dayDate getChineseNumber];
            
            BKDayModel * dayModel = [[BKDayModel alloc]init];
            dayModel.yearNumber = yearNumber;
            dayModel.monthNumber = monthNumber;
            dayModel.dayNumber = i+1;
            dayModel.chineseDayStr = chineseNumber;
            dayModel.date = dayDate;
            [weakSelf.dayModelArr addObject:dayModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIButton * lastBtn = [self viewWithTag:i];
                
                if (nextWeekNumber > 6) {
                    nextWeekNumber = 0;
                    Y = CGRectGetMaxY(lastBtn.frame);
                }
                CGFloat X = nextWeekNumber * width;
                nextWeekNumber++;
                
                UIButton * dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                dayBtn.frame = CGRectMake(X, Y, width, height);
                dayBtn.tag = i+1;
                [dayBtn addTarget:self action:@selector(dayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:dayBtn];
                
                UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, dayBtn.frame.size.width, 1)];
                line.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1];
                [dayBtn addSubview:line];
                
                UILabel * numberTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, dayBtn.frame.size.height/4, dayBtn.frame.size.width, dayBtn.frame.size.height/4)];
                numberTitle.textAlignment = NSTextAlignmentCenter;
                numberTitle.font = [UIFont systemFontOfSize:15*[UIScreen mainScreen].bounds.size.width/375.0f];
                numberTitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                numberTitle.text = [NSString stringWithFormat:@"%d",i+1];
                [dayBtn addSubview:numberTitle];
                
                UILabel * chineseNumberTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numberTitle.frame), dayBtn.frame.size.width, dayBtn.frame.size.height/4)];
                chineseNumberTitle.textAlignment = NSTextAlignmentCenter;
                chineseNumberTitle.font = [UIFont systemFontOfSize:9*[UIScreen mainScreen].bounds.size.width/375.0f];
                chineseNumberTitle.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
                chineseNumberTitle.text = chineseNumber;
                [dayBtn addSubview:chineseNumberTitle];
                
                if (self.mark == 0) {
                    if ([nowDay intValue] == i+1) {
                        UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(dayBtn.frame.size.width/6, dayBtn.frame.size.height/6, dayBtn.frame.size.width/6*4, dayBtn.frame.size.height/6*4)];
                        colorView.backgroundColor = BK_CALENDAR_REDCOLOR;
                        colorView.userInteractionEnabled = NO;
                        [dayBtn insertSubview:colorView atIndex:0];
                        [self cutView:colorView radius:colorView.frame.size.width/2];
                        
                        numberTitle.textColor = [UIColor whiteColor];
                        chineseNumberTitle.textColor = [UIColor whiteColor];
                    }
                }
            });
        }
    });
}

-(void)dayBtnClick:(UIButton*)button
{
    BKDayModel * model = self.dayModelArr[button.tag-1];
    if (self.dayTap) {
        self.dayTap(model);
    }
}

-(void)monthTapRecognizer:(UITapGestureRecognizer*)recognizer
{
    __weak typeof(self) weakSelf = self;
    if (self.monthTap) {
        self.monthTap(weakSelf.monthModel);
    }
}

-(void)cutView:(UIView*)view radius:(CGFloat)radius
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:radius];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.frame = view.bounds;
    view.layer.mask = maskLayer;
}

@end
