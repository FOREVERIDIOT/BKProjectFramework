//
//  UINavigationController+BKNavExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "UINavigationController+BKNavExtension.h"
#import "BKNavViewController.h"

@implementation UINavigationController (BKNavExtension)

#pragma mark - direction

-(void)setDirection:(BKTransitionAnimaterDirection)direction
{
    if ([self isKindOfClass:[BKNavViewController class]]) {
        [self changeValue:@(direction) forProperty:@"_private_direction"];
    }
}

-(BKTransitionAnimaterDirection)direction
{
    if ([self isKindOfClass:[BKNavViewController class]]) {
        return [[self getValueForProperty:@"_private_direction"] intValue];
    }else{
        return 0;
    }
}

#pragma mark - popGestureRecognizerEnable

-(void)setPopGestureRecognizerEnable:(BOOL)popGestureRecognizerEnable
{
    if ([self isKindOfClass:[BKNavViewController class]]) {
        [self changeValue:@(popGestureRecognizerEnable) forProperty:@"_private_popGestureRecognizerEnable"];
    }
}

-(BOOL)popGestureRecognizerEnable
{
    if ([self isKindOfClass:[BKNavViewController class]]) {
        return [[self getValueForProperty:@"_private_popGestureRecognizerEnable"] boolValue];
    }else{
        return NO;
    }
}

#pragma mark - popVC

-(void)setPopVC:(UIViewController*)popVC
{
    if ([self isKindOfClass:[BKNavViewController class]]) {
        [self changeValue:popVC forProperty:@"_private_popVC"];
    }
}

-(UIViewController*)popVC
{
    if ([self isKindOfClass:[BKNavViewController class]]) {
        return [self getValueForProperty:@"_private_popVC"];
    }else{
        return nil;
    }
}

@end
