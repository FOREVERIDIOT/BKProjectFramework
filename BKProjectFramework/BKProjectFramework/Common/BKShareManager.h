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

#pragma mark - 计算文本大小

-(CGSize)sizeWithString:(NSString *)string UIWidth:(CGFloat)width font:(UIFont*)font;
-(CGSize)sizeWithString:(NSString *)string UIHeight:(CGFloat)height font:(UIFont*)font;
-(CGFloat)changeWidthLabel:(UILabel*)label;
-(CGFloat)changeHeightLabel:(UILabel*)label;

-(CGFloat)heightSizeFromAttrString:(NSAttributedString*)string width:(CGFloat)width;
-(CGFloat)widthSizeFromAttrString:(NSAttributedString*)string height:(CGFloat)height;

#pragma mark - 弹框提示

+(void)showMessage:(NSString*)message;

#pragma mark - 获取当前显示Controller

+(UIViewController *)getCurrentVC;

#pragma mark - 提示

+(void)presentAlert:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod;

+(void)presentActionSheet:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod;

#pragma mark - 打电话

-(void)callPhone:(NSString*)phoneStr;

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
