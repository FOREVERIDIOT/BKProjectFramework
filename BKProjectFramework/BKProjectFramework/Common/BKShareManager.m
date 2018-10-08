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

#pragma mark - 弹框提示

+(void)showMessage:(NSString*)message
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    bgView.layer.cornerRadius = 8.0f;
    bgView.clipsToBounds = YES;
    [window addSubview:bgView];
    
    UILabel * remindLab = [[UILabel alloc]init];
    remindLab.textColor = [UIColor whiteColor];
    CGFloat fontSize = 13.0*window.bounds.size.width/320.0f;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    remindLab.font = font;
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.backgroundColor = [UIColor clearColor];
    remindLab.text = message;
    [bgView addSubview:remindLab];
    
    CGFloat width = [message calculateSizeWithUIHeight:window.bounds.size.height font:font].width;
    if (width>window.bounds.size.width/4.0*3.0f) {
        width = window.bounds.size.width/4.0*3.0f;
    }
    CGFloat height = [message calculateSizeWithUIWidth:width font:font].height;
    
    bgView.bounds = CGRectMake(0, 0, width+20, height+20);
    bgView.layer.position = CGPointMake(window.bounds.size.width/2.0f, window.bounds.size.height/2.0f);
    
    remindLab.bounds = CGRectMake(0, 0, width, height);
    remindLab.layer.position = CGPointMake(bgView.bounds.size.width/2.0f, bgView.bounds.size.height/2.0f);
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

#pragma mark - 获取当前显示Controller

+(UIViewController *)getCurrentVC
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

+(void)presentAlert:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod
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

+(void)presentActionSheet:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod
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
        [BKShareManager presentAlert:phoneStr message:nil actionTitleArr:@[@"取消",@"呼叫"] actionMethod:^(NSInteger index) {
            if (index == 1) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
        }];
    }
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
