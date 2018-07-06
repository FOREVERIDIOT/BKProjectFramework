//
//  NSUserDefaults+BKExtension.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (BKExtension)

/**
 *  用 NSUserDefaults 存储
 *
 *  @param object 存储的对象
 *  @param key    存储对象的key
 */
+(void)saveDataUseMethodUserDefaults:(id)object key:(NSString*)key;

/**
 *  用 NSUserDefaults 取数据
 *
 *  @param key 存储对象的key
 *
 *  @return 取出的对象
 */
+(instancetype)takeDataUseMethodUserDefaults:(NSString*)key;

/**
 *  获取 NSUserDefaults 存储的所有数据
 *
 *  @return NSUserDefaults 存储的所有数据
 */
+(NSDictionary*)takeAllUserDefaults;

/**
 *  删除 NSUserDefaults 中所有的key
 */
+(void)resetAllUserDefaults;

/**
 *  删除 NSUserDefaults 中对应的key
 *
 *  @param resetKey 删除的key
 */
+(void)deleteUserDefaultsKey:(NSString*)resetKey;

@end
