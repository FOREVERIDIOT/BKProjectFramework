//
//  BKTransitionAnimater.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BKTransitionAnimaterDirection) {//进入时过场动画的方向
    BKTransitionAnimaterDirectionRight = 0,
    BKTransitionAnimaterDirectionLeft
};

typedef NS_ENUM(NSUInteger, BKTransitionAnimaterType) {
    BKTransitionAnimaterTypePush = 0,
    BKTransitionAnimaterTypePop,
};

@interface BKTransitionAnimater : NSObject<UIViewControllerAnimatedTransitioning>

/**
 返回成功回调
 */
@property (nonatomic,copy) void (^backFinishAction)(void);

/**
 是否是手势返回
 */
@property (nonatomic, assign) BOOL interation;

/**
 创建方法
 
 @param type 过场动画的方法
 @param direction 过场动画的方向
 @return BKTransitionAnimater
 */
- (instancetype)initWithTransitionType:(BKTransitionAnimaterType)type transitionAnimaterDirection:(BKTransitionAnimaterDirection)direction;

@end
