//
//  BKNetworkRequest.m
//  MySelfFrame
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import "BKNetworkRequest.h"
#import "sys/utsname.h"
//#import <objc/message.h>
#import "NSObject+BKNetworkExtension.h"

@interface BKNetworkRequest()

@property (nonatomic,copy) NSString * deviceName;

@end

@implementation BKNetworkRequest

#pragma mark - 单例

static BKNetworkRequest * client = nil;
+(instancetype)shareClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [BKNetworkRequest manager];
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        client.requestSerializer.timeoutInterval = 30.0f;
    });
    return client;
}

#pragma mark - 请求头

-(void)setRequestHeader
{
    [client.requestSerializer setValue:@"" forHTTPHeaderField:@""];
}

#pragma mark - post

-(void)postWithURL:(NSString *)url params:(NSDictionary *)params requestView:(UIView*)requestView success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    [self setRequestHeader];
    
    [client POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureMessage:error.description requestUrl:url params:params failureType:BKRequestFailureTypeNetworkFailure appendInView:requestView successComplete:^(id json) {
            if (success) {
                success(json);
            }
        } failureComplete:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
        //第一次请求回调
        if (failure) {
            failure(error);
        }
    }];
}

/**
 带数据流post
 */
-(void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray requestProgress:(void (^)(NSProgress*progress))requestProgress success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [self setRequestHeader];
    
    [client POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (BKNetworkUploadModel * model in formDataArray) {
            [formData appendPartWithFileData:model.data name:model.name fileName:model.filename mimeType:model.mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (requestProgress) {
            requestProgress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

#pragma mark - get

/**
 GET请求
 */
-(void)getWithURL:(NSString *)url params:(NSDictionary *)params requestView:(UIView*)requestView success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    [self setRequestHeader];
    
    [client GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureMessage:error.description requestUrl:url params:params failureType:BKRequestFailureTypeNetworkFailure appendInView:requestView successComplete:^(id json) {
            if (success) {
                success(json);
            }
        } failureComplete:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
        //第一次请求回调
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - POST/GET请求失败结果处理

/**
 请求失败结果处理

 @param failureMessage 失败原因
 @param requestUrl 请求url
 @param params 参数
 @param failureType 失败类型
 @param requestView 请求界面
 @param successComplete 再次请求成功回调
 @param failureComplete 再次请求失败回调
 */
-(void)requestFailureMessage:(NSString*)failureMessage requestUrl:(NSString*)requestUrl params:(NSDictionary*)params failureType:(BKRequestFailureType)failureType appendInView:(UIView*)requestView successComplete:(void (^)(id json))successComplete failureComplete:(void (^)(NSError * error))failureComplete
{
    if (requestView) {
        __weak UIView * weak_requestView = requestView;
        [self displayFailureViewWithErrorMessage:failureMessage requestUrl:requestUrl params:params failureType:failureType appendInView:requestView success:^(id json) {
            [self requestView:weak_requestView deleteFailureViewWithUrl:requestUrl];
            if (successComplete) {
                successComplete(json);
            }
        } failure:^(NSError *error) {
            if (failureComplete) {
                failureComplete(error);
            }
        }];
    }
}

#pragma mark - 请求失败加载界面

/**
 显示加载失败界面
 
 @param errorMessage 失败原因
 @param requestUrl 请求url
 @param params 参数
 @param failureType 失败类型
 @param requestView 请求界面
 @param success 再次请求成功回调
 @param failure 再次请求失败回调
 */
-(void)displayFailureViewWithErrorMessage:(NSString*)errorMessage requestUrl:(NSString*)requestUrl params:(NSDictionary*)params failureType:(BKRequestFailureType)failureType appendInView:(UIView*)requestView success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    BKNetworkRequestFailureView * failureView = nil;
    for (BKNetworkRequestFailureView * aFailureView in requestView.bk_netFailureViews) {
        if ([aFailureView.requestUrl isEqualToString:requestUrl]) {
            failureView = aFailureView;
            break;
        }
    }
    
    if (!failureView) {
        failureView = [[BKNetworkRequestFailureView alloc] init];
        __weak UIView * weak_requestView = requestView;
        [failureView refreshRequestMethod:^(NSString *requestUrl, NSDictionary *params) {
            [self postWithURL:requestUrl params:params requestView:weak_requestView success:^(id json) {
                if (success) {
                    success(json);
                }
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }];
        [requestView addSubview:failureView];
        
        if ([requestView.bk_netFailureViews count] > 0) {
            NSMutableArray * failureViews = [requestView.bk_netFailureViews mutableCopy];
            [failureViews addObject:failureView];
            requestView.bk_netFailureViews = [failureViews copy];
        }else{
            requestView.bk_netFailureViews = @[failureView];
        }
    }
    
    [failureView setupFailureMessage:errorMessage failureType:failureType requestUrl:requestUrl params:params];
}

/**
 在请求界面上删除当时错误的请求失败界面
 
 @param requestView 请求界面
 @param requestUrl 请求url
 */
-(void)requestView:(UIView*)requestView deleteFailureViewWithUrl:(NSString*)requestUrl
{
    for (BKNetworkRequestFailureView * failureView in requestView.bk_netFailureViews) {
        if ([failureView.requestUrl isEqualToString:requestUrl]) {
            
            [failureView removeFromSuperview];
            
            NSMutableArray * failureViews = [requestView.bk_netFailureViews mutableCopy];
            [failureViews removeObject:failureView];
            requestView.bk_netFailureViews = [failureViews copy];
            break;
        }
    }
}

#pragma mark - 取消网络请求

- (void)cancelAllRequestOperations
{
    [client.operationQueue cancelAllOperations];
}

#pragma mark - 开启网络监测

- (void)startNetworkReachability:(void (^)(NSInteger status))networkStatus
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:{
                /**
                 *  无网络
                 */
                self.netStatus = 0;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                /**
                 *  WiFi网络
                 */
                self.netStatus = 1;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                /**
                 *  4G网络
                 */
                self.netStatus = 2;
            }
                 break;
            default:
                break;
        }
        if (networkStatus) {
            networkStatus(self.netStatus);
        }
    }];
}

#pragma mark - 获取设备型号

-(NSString*)deviceName
{
    if (!_deviceName) {
        _deviceName = [self getDeviceName];
    }
    return _deviceName;
}

// 获取设备型号然后手动转化为对应名称
- (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    //#warning 题主呕心沥血总结！！最全面！亲测！全网独此一份！！
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // Japan两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod_Touch 6G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

@end
