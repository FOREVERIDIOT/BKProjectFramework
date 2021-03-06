//
//  NSObject+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSObject+BKExtension.h"
#import <objc/message.h>

@implementation NSObject (BKExtension)

#pragma mark - Tag

-(NSDictionary*)dicTag
{
    return objc_getAssociatedObject(self, @"dicTag");
}

- (void)setDicTag:(NSDictionary *)dicTag
{
    objc_setAssociatedObject(self, @"dicTag", dicTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)strTag
{
    return objc_getAssociatedObject(self, @"strTag");
}

-(void)setStrTag:(NSString *)strTag
{
    objc_setAssociatedObject(self, @"strTag", strTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 属性操作

/**
 打印该对象所有的属性
 */
-(void)printTotalProperty
{
#ifdef DEBUG
    u_int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char * propertyName = ivar_getName(ivars[i]);
        NSString * propertyString = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        NSLog(@"%@",propertyString);
    }
#endif
}

/**
 判断对象中是否有该属性

 @param property 属性名称
 @return 判断结果
 */
-(BOOL)haveProperty:(NSString *)property
{
    u_int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char * propertyName = ivar_getName(ivars[i]);
        NSString * propertyString = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        if ([propertyString isEqualToString:property]){
            return YES;
        }
    }
    return NO;
}

/**
 改变对象属性的值

 @param value 值
 @param property 对象属性
 */
-(void)changeValue:(id)value forProperty:(NSString*)property
{
    u_int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * propertyName = ivar_getName(ivar);
        NSString * propertyString = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        if ([propertyString isEqualToString:property]) {
            //setValue:forKey: 若forKey传入的属性名前加下划线不会执行setter方法
            if ([[property substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {//为了能执行setter方法
                [self setValue:value forKey:[property substringWithRange:NSMakeRange(1, [property length] - 1)]];
            }else{
                [self setValue:value forKey:property];
            }
//            运行时赋值 不执行setter方法
//            object_setIvar(self, ivar, value);
            break;
        }
    }
}

/**
 取出对象属性的值

 @param property 对象属性
 @return 值
 */
-(id)getValueForProperty:(NSString*)property
{
    u_int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * propertyName = ivar_getName(ivar);
        NSString * propertyString = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        if ([propertyString isEqualToString:property]) {
            return [self valueForKey:property];
//            运行时取值 下面方法有时候会崩溃
//            return object_getIvar(self, ivar);
        }
    }
    return nil;
}

#pragma mark - 方法操作

/**
 打印对象所有实例方法
 */
-(void)printTotalInstanceMethods
{
#ifdef DEBUG
    u_int count = 0;
    Method * methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL methodName = method_getName(methods[i]);
        NSString * methodString = NSStringFromSelector(methodName);
        NSLog(@"%@",methodString);
    }
    free(methods);
#endif
}

/**
 判断对象中是否有该实例方法
 
 @param method 实例方法名称
 @return 判断结果
 */
-(BOOL)haveInstanceMethod:(NSString *)method
{
    u_int count = 0;
    Method * methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL methodName  = method_getName(methods[i]);
        NSString * methodString = NSStringFromSelector(methodName);
        if ([method isEqualToString:methodString]){
            free(methods);
            return YES;
        }
    }
    free(methods);
    return NO;
}

/**
 发送消息调用方法
 
 @param methodName 方法名称
 @param object 方法参数
 @return 方法返回
 */
-(id)messageSend:(NSString*)methodName methodParams:(id)object,...NS_REQUIRES_NIL_TERMINATION
{
    SEL selector = nil;
    u_int count = 0;
    Method * methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL aMethodName  = method_getName(methods[i]);
        NSString * methodString = NSStringFromSelector(aMethodName);
        if ([methodName isEqualToString:methodString]){
            selector = aMethodName;
            break;
        }
    }
    free(methods);
    if (selector) {
        NSData * data = ((id (*)(id, SEL, id))objc_msgSend)(self, selector, object);
        return data;
    }
    return nil;
}

@end
