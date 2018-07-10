//
//  BKNetworkRequestFailureView.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKRequestFailureType) {
    BKRequestFailureTypeNetworkFailure = 0,      //网络请求失败
    BKRequestFailureTypeServerDataFailure,       //服务器数据请求失败
};

@interface BKNetworkRequestFailureView : UIView

/**
 请求url
 */
@property (nonatomic,copy,readonly) NSString * requestUrl;

/**
 网络请求失败更新失败界面信息

 @param failureMessage 失败原因
 @param failureType 失败类型(是网络错误还是后台返回错误)
 @param requestUrl 请求url
 @param params 请求参数
 */
-(void)setupFailureMessage:(NSString*)failureMessage failureType:(BKRequestFailureType)failureType requestUrl:(NSString*)requestUrl params:(NSDictionary*)params;

/**
 刷新请求回调

 @param refreshMethod 刷新请求回调
 */
-(void)refreshRequestMethod:(void (^)(NSString * requestUrl, NSDictionary * params))refreshMethod;

@end
