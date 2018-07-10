//
//  NSObject+BKNetworkExtension.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/9.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSObject+BKNetworkExtension.h"
#import <objc/runtime.h>

@implementation NSObject (BKNetworkExtension)

-(NSArray*)bk_netFailureViews
{
    return objc_getAssociatedObject(self, @"bk_netFailureViews");
}

- (void)setBk_netFailureViews:(NSArray *)bk_netFailureViews
{
    objc_setAssociatedObject(self, @"bk_netFailureViews", bk_netFailureViews, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
