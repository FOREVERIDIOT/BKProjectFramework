//
//  BKShareManager.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BKShareManager : NSObject

/**
 当前时间戳
 */
@property (nonatomic,assign) NSTimeInterval currentTimestamp;

#pragma mark - 单例方法

+(instancetype)sharedManager;

#pragma mark - 获取当前显示Controller

-(UIViewController *)getCurrentVC;

#pragma mark - 提示

-(void)presentAlert:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod;

-(void)presentActionSheet:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod;

#pragma mark - 打电话

-(void)callPhone:(NSString*)phoneStr;

#pragma mark - 文件共享

-(void)shareFilePath:(NSURL *)filePath;

#pragma mark - 网络时间

/**
 获取当前网络时间
 */
-(void)getCurrentTime;
/**
 开启获取网络时间定时器
 */
-(void)startGetNetworkTimeTimer;
/**
 结束获取网络时间定时器
 */
-(void)stopGetNetworkTimeTimer;

@end
