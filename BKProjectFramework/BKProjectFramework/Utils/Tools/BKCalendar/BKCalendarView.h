//
//  BKCalendarView.h
//  MySelfFrame
//
//  Created by BIKE on 17/2/20.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCalendarViewCell.h"
#import "BKMonthModel.h"
#import "BKDayModel.h"

@protocol BKCalendarViewDelegate <NSObject>

@required

-(void)returnYearMessage:(NSString*)yearMessage;

@optional

-(void)dayTap:(BKDayModel *)model;

-(void)monthTap:(BKMonthModel *)model;

@end

@interface BKCalendarView : UIScrollView

@property (nonatomic,assign) id<BKCalendarViewDelegate> customDelegate;

@property (nonatomic,strong) NSMutableArray<BKCalendarViewCell*> * visibleCells;

@end
