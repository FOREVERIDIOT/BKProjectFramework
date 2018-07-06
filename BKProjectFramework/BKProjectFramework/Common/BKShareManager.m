//
//  BKShareManager.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKShareManager.h"

@implementation BKShareManager

#pragma mark - 单例方法

static BKShareManager * shareManager;
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

#pragma mark - 网络时间

/**
 获取当前网络时间
 */
-(void)getCurrentTime
{
    
}

/**
 开启获取网络时间定时器
 */
-(void)startGetNetworkTimeTimer
{
    
}

/**
 结束获取网络时间定时器
 */
-(void)stopGetNetworkTimeTimer
{
    
}

@end
