//
//  BKTableView.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKTableView.h"

@implementation BKTableView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        if (@available(iOS 11.0, *)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (@available(iOS 11.0, *)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        if (@available(iOS 11.0, *)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        if (@available(iOS 11.0, *)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
