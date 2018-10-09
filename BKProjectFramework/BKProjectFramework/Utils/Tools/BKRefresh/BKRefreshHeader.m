//
//  BKRefreshHeader.m
//  BIKEDistribution
//
//  Created by BIKE on 2018/9/19.
//  Copyright © 2018年 毕珂. All rights reserved.
//

#import "BKRefreshHeader.h"

@interface BKRefreshHeader()

@end

@implementation BKRefreshHeader

-(void)prepare
{
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    
    UIColor * normalColor = [UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1];
    self.stateLabel.textColor = normalColor;
    self.lastUpdatedTimeLabel.textColor = normalColor;
    self.arrowView.tintColor = normalColor;
}

@end
