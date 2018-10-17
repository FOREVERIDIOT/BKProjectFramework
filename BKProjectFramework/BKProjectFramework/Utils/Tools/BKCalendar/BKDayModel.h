//
//  BKDayModel.h
//  MySelfFrame
//
//  Created by BIKE on 17/2/24.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKDayModel : NSObject

@property (nonatomic,assign) NSInteger yearNumber;
@property (nonatomic,assign) NSInteger monthNumber;
@property (nonatomic,assign) NSInteger dayNumber;
@property (nonatomic,copy) NSString * chineseDayStr;
@property (nonatomic,strong) NSDate * date;

@end
