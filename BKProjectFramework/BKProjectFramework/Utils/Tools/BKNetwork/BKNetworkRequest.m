//
//  BKNetworkRequest.m
//  MySelfFrame
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import "BKNetworkRequest.h"
#import "BKNetworkRequestFailureView.h"
#import "NSObject+BKNetworkExtension.h"

@interface BKNetworkRequest()

@property (nonatomic,copy) NSString * deviceName;

@property (nonatomic,strong) NSMutableArray<NSURLSessionDownloadTask*> * downloadArr;

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

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [super allocWithZone:zone];
    });
    return client;
}

#pragma mark - 请求头

-(void)setRequestHeader
{
    [client.requestSerializer setValue:@"" forHTTPHeaderField:@""];
}

#pragma mark - post

-(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    [self setRequestHeader];
    
    [client POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

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
            [failureView showLoading];
            [self postWithURL:requestUrl params:params requestView:weak_requestView success:^(id json) {
                [failureView hideLoading];
                if (success) {
                    success(json);
                }
            } failure:^(NSError *error) {
                [failureView hideLoading];
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

#pragma mark - 文件下载

-(NSMutableArray<NSURLSessionDownloadTask*> *)downloadArr
{
    if (!_downloadArr) {
        _downloadArr = [NSMutableArray array];
    }
    return _downloadArr;
}

-(NSString *)checkSaveFileDirectory
{
    NSString * directory = [NSTemporaryDirectory() stringByAppendingString:@"CS"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exist = [fileManager fileExistsAtPath:directory isDirectory:&isDir];
    if (!(isDir && exist)) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directory;
}

-(void)downloadFileUrl:(NSString*)fileUrl downloadProgress:(void (^)(CGFloat progress))dlProgress success:(void (^)(NSURL * filePath))success failure:(void (^)(NSError * error))failure
{
    if ([fileUrl length] == 0) {//下载路径为空
        showMessage(@"下载失败");
        return;
    }
    
    NSString * fileName = [fileUrl lastPathComponent];
    NSString * downloadPath = [NSString stringWithFormat:@"%@/%@",[self checkSaveFileDirectory],fileName];
    
    NSURLSessionDownloadTask * downloadTask = [client downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]] progress:^(NSProgress * _Nonnull downloadProgress) {
        if (dlProgress) {
            dlProgress(downloadProgress.fractionCompleted);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath.absoluteString error:nil];
            if (failure) {
                failure(error);
            }
        }else {
            if (success) {
                success(filePath);
            }
        }
    }];
    [downloadTask resume];
    
    [self.downloadArr addObject:downloadTask];
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
        _deviceName = [NSString getDeviceName];
    }
    return _deviceName;
}

@end
