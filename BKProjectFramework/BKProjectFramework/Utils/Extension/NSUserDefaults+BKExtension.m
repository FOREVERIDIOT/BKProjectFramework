//
//  NSUserDefaults+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSUserDefaults+BKExtension.h"

@implementation NSUserDefaults (BKExtension)

+(void)saveDataUseMethodUserDefaults:(id)object key:(NSString*)key
{
    [[self standardUserDefaults] setObject:object forKey:key];
    
    [[self standardUserDefaults] synchronize];
}

+(instancetype)takeDataUseMethodUserDefaults:(NSString*)key
{
    return [[self standardUserDefaults] objectForKey:key];
}

+(NSDictionary*)takeAllUserDefaults
{
    return [[self standardUserDefaults] dictionaryRepresentation];
}

+(void)deleteUserDefaultsKey:(NSString*)resetKey
{
    [[self standardUserDefaults] removeObjectForKey:resetKey];
    
    [[self standardUserDefaults] synchronize];
}

+(void)resetAllUserDefaults
{
    NSDictionary* dict = [self takeAllUserDefaults];
    
    for(id key in dict) {
        [[self standardUserDefaults] removeObjectForKey:key];
    }
    
    [[self standardUserDefaults] synchronize];
}

@end
