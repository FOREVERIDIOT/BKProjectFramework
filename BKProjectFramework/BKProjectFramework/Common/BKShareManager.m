//
//  BKShareManager.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKShareManager.h"

@interface BKShareManager()

@property (nonatomic,strong) dispatch_source_t networkTimer;

@end

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
    [[BKNetworkRequest shareClient] getWithURL:@"" params:nil requestView:nil success:^(id json) {
        self.currentTimestamp = [[NSDate date] timeIntervalSince1970];
        [self startGetNetworkTimeTimer];
    } failure:^(NSError *error) {
        [self startGetNetworkTimeTimer];
    }];
}

/**
 开启获取网络时间定时器
 */
-(void)startGetNetworkTimeTimer
{
    if (self.currentTimestamp == 0) {
        self.currentTimestamp = [[NSDate date] timeIntervalSince1970];
    }
    
    if (self.networkTimer) {
        [self stopGetNetworkTimeTimer];
    }
    
    self.networkTimer = [[BKTimer sharedManager] bk_setupTimerWithTimeInterval:0.1 totalTime:kRepeatsTime handler:^(BKTimerModel *timerModel) {
        self.currentTimestamp = self.currentTimestamp + 0.1;
    }];
}

/**
 结束获取网络时间定时器
 */
-(void)stopGetNetworkTimeTimer
{
    [[BKTimer sharedManager] bk_removeTimer:self.networkTimer];
}

@end
