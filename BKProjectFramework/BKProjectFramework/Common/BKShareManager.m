//
//  BKShareManager.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKShareManager.h"

@interface BKShareManager()<UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong) dispatch_source_t networkTimer;
/**
 文件共享(必须全局)
 */
@property (nonatomic,strong) UIDocumentInteractionController * diController;

@end

@implementation BKShareManager

#pragma mark - 单例方法

static BKShareManager * shareManager = nil;

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [super allocWithZone:zone];
    });
    return shareManager;
}

#pragma mark - 获取当前显示Controller

-(UIViewController *)getCurrentVC
{
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    UIViewController *parent = rootVC;
    
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    
    return rootVC; 
}

#pragma mark - 提示

-(void)presentAlert:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (NSString * title in actionTitleArr) {
        
        NSInteger style;
        if ([title isEqualToString:@"取消"]) {
            style = UIAlertActionStyleCancel;
        }else{
            style = UIAlertActionStyleDefault;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (actionMethod) {
                actionMethod([actionTitleArr indexOfObject:title]);
            }
        }];
        [alert addAction:action];
    }
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

-(void)presentActionSheet:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString * title in actionTitleArr) {
        
        NSInteger style;
        if ([title isEqualToString:@"取消"]) {
            style = UIAlertActionStyleCancel;
        }else{
            style = UIAlertActionStyleDefault;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (actionMethod) {
                actionMethod([actionTitleArr indexOfObject:title]);
            }
        }];
        [alert addAction:action];
    }
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 打电话

-(void)callPhone:(NSString*)phoneStr
{
    NSURL * phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]];
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:nil];
    } else {
        [[BKShareManager sharedManager] presentAlert:phoneStr message:nil actionTitleArr:@[@"取消",@"呼叫"] actionMethod:^(NSInteger index) {
            if (index == 1) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
        }];
    }
}

#pragma mark - 文件共享

-(void)shareFilePath:(NSURL *)filePath
{
    self.diController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
    self.diController.delegate = self;
    self.diController.UTI = [self getUTI:filePath.absoluteString];
    [self.diController presentOptionsMenuFromRect:CGRectZero inView:[[BKShareManager sharedManager] getCurrentVC].view animated:YES];
}

-(NSString *)getUTI:(NSString*)filePath
{
    NSString * typeStr = [self getFileTypeStr:filePath.pathExtension];
    
    if ([typeStr isEqualToString:@"PDF"]) {
        return @"com.adobe.pdf";
    }else if ([typeStr isEqualToString:@"Word"]){
        return @"com.microsoft.word.doc";
    }else if ([typeStr isEqualToString:@"PowerPoint"]){
        return @"com.microsoft.powerpoint.ppt";
    }else if ([typeStr isEqualToString:@"Excel"]){
        return @"com.microsoft.excel.xls";
    }
    return @"public.data";
}

-(NSString *)getFileTypeStr:(NSString *)pathExtension
{
    if ([pathExtension isEqualToString:@"pdf"] || [pathExtension isEqualToString:@"PDF"]) {
        return @"PDF";
    }else if ([pathExtension isEqualToString:@"doc"] || [pathExtension isEqualToString:@"docx"] || [pathExtension isEqualToString:@"DOC"] || [pathExtension isEqualToString:@"DOCX"]) {
        return @"Word";
    }else if ([pathExtension isEqualToString:@"ppt"] || [pathExtension isEqualToString:@"PPT"]) {
        return @"PowerPoint";
    }else if ([pathExtension isEqualToString:@"xls"] || [pathExtension isEqualToString:@"XLS"] || [pathExtension isEqualToString:@"xlsx"] || [pathExtension isEqualToString:@"XLSX"]) {
        return @"Excel";
    }
    return @"其它";
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
