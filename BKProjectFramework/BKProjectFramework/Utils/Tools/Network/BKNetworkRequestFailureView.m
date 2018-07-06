//
//  BKNetworkRequestFailureView.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKNetworkRequestFailureView.h"

@implementation BKNetworkRequestFailureView

#pragma mark - 初始化方法

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData
{
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - 界面

/**
 网络请求失败更新失败界面信息
 
 @param failureMessage 失败原因
 @param failureType 失败类型
 */
-(void)setupFailureMessage:(NSString*)failureMessage failureType:(BKRequestFailureType)failureType
{
    
}

@end
