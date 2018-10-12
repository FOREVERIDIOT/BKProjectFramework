//
//  BKNetworkRequest.h
//  MySelfFrame
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "BKNetworkUploadModel.h"

@interface BKNetworkRequest : AFHTTPSessionManager

/**
 *  网络监测 0、无网  1、WIFI网络  2、4G网络 使用前调用方法(startNetworkReachability)
 */
@property (nonatomic,assign) NSInteger netStatus;

+(instancetype)shareClient;

#pragma mark - POST

/**
 POST请求
 
 @param url          链接
 @param params       参数
 @param success      成功
 @param failure      失败
 */
-(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;

/**
 POST请求

 @param url          链接
 @param params       参数
 @param requestView  请求界面(如果请求失败会加载请求失败界面 传nil代表请求失败不加载请求失败界面)
 @param success      成功
 @param failure      失败
 */
-(void)postWithURL:(NSString *)url params:(NSDictionary *)params requestView:(UIView*)requestView success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;

/**
 POST带上传数据流请求

 @param url             链接
 @param params          参数
 @param formDataArray   数据流数组(参数类型NetworkUploadModel)
 @param requestProgress 进度
 @param success         成功
 @param failure         失败
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray requestProgress:(void (^)(NSProgress*progress))requestProgress success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

#pragma mark - GET

/**
 GET请求

 @param url     链接
 @param params  参数
 @param success 成功
 @param failure 失败
 */
-(void)getWithURL:(NSString *)url params:(NSDictionary *)params requestView:(UIView*)requestView success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;

/**
 文件下载
 
 @param fileUrl 文件链接
 @param dlProgress 下载百分比
 @param success 下载成功
 @param failure 下载失败
 */
-(void)downloadFileUrl:(NSString*)fileUrl downloadProgress:(void (^)(CGFloat progress))dlProgress success:(void (^)(NSURL * filePath))success failure:(void (^)(NSError * error))failure;

#pragma mark - 取消网络请求

/**
 取消所有请求
 */
- (void)cancelAllRequestOperations;

#pragma mark - 开启网络监测

/**
 开启网络监测 0、无网  1、WIFI网络  2、4G网络 (调用一次后,可以直接调用netStatus属性)
 */
- (void)startNetworkReachability:(void (^)(NSInteger status))networkStatus;



@end
