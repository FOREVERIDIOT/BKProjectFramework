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

@end
