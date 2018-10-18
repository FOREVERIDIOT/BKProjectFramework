//
//  NSObject+BKExtension.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BKExtension)

#pragma mark - Tag

/**
 字典Tag
 */
@property (nonatomic,strong) NSDictionary * dicTag;

/**
 字符串Tag
 */
@property (nonatomic,strong) NSString * strTag;

#pragma mark - 属性操作

/**
 打印该对象所有的属性
 */
-(void)printTotalProperty;

/**
 判断对象中是否有该属性
 
 @param property 属性名称
 @return 判断结果
 */
-(BOOL)haveProperty:(NSString *)property;

/**
 改变对象属性的值
 
 @param value 值
 @param property 对象属性
 */
-(void)changeValue:(id)value forProperty:(NSString*)property;

/**
 取出对象属性的值
 
 @param property 对象属性
 @return 值
 */
-(id)getValueForProperty:(NSString*)property;

#pragma mark - 方法操作

/**
 打印对象所有实例方法
 */
-(void)printTotalInstanceMethods;

/**
 判断对象中是否有该实例方法
 
 @param method 实例方法名称
 @return 判断结果
 */
-(BOOL)haveInstanceMethod:(NSString *)method;

/**
 发送消息调用方法 调用前必须保证对象中包含即将调用方法 如果没有会崩溃 也可以调用该方法前先调用haveInstanceMethod检测方法
 
 @param methodName 方法名称
 @param object 方法参数
 @return 方法返回
 */
-(id)messageSend:(NSString*)methodName methodParams:(id)object,...NS_REQUIRES_NIL_TERMINATION;

@end
