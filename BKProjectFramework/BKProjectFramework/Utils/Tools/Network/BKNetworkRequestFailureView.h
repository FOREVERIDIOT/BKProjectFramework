//
//  BKNetworkRequestFailureView.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKRequestFailureType) {
    BKRequestFailureTypeNetworkNotSuccess = 0,   //网络请求失败
    BKRequestFailureTypeServerDataFailure,       //服务器数据请求失败
};

@interface BKNetworkRequestFailureView : UIView

/**
 网络请求失败更新失败界面信息

 @param failureMessage 失败原因
 @param failureType 失败类型
 */
-(void)setupFailureMessage:(NSString*)failureMessage failureType:(BKRequestFailureType)failureType;

@end
