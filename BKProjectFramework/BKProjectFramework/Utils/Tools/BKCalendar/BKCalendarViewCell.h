//
//  BKCalendarViewCell.h
//  MySelfFrame
//
//  Created by BIKE on 17/2/23.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKMonthModel.h"
#import "BKDayModel.h"

@interface BKCalendarViewCell : UIView

@property (nonatomic,assign) NSInteger mark;

@property (nonatomic,copy) void (^returnYearMessage)(NSString * message);

@property (nonatomic,copy) void (^monthTap)(BKMonthModel * model);

@property (nonatomic,copy) void (^dayTap)(BKDayModel * model);

-(void)assignDataWithFirstDayInMonthDate:(NSDate*)date;

@end
