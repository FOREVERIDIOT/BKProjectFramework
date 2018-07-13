//
//  BKTransitionAnimater.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKTransitionAnimater.h"

@interface BKTransitionAnimater ()

@property (nonatomic,assign) BKTransitionAnimaterType type;
@property (nonatomic,assign) BKTransitionAnimaterDirection direction;

@property (nonatomic,strong) UIView * fromShadowView;
@property (nonatomic,strong) UIView * toShadowView;

@end

@implementation BKTransitionAnimater

- (instancetype)initWithTransitionType:(BKTransitionAnimaterType)type transitionAnimaterDirection:(BKTransitionAnimaterDirection)direction
{
    self = [super init];
    if (self) {
        _type = type;
        _direction = direction;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    if (@available(iOS 11.0, *)) {
        if (_interation) {
            return 0.5;
        }else{
            return 0.25;
        }
    } else {
        return 0.25;
    }
}

#pragma mark - 转场动画

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case BKTransitionAnimaterTypePush:
        {
            [self nextAnimation:transitionContext];
        }
            break;
        case BKTransitionAnimaterTypePop:
        {
            [self backAnimation:transitionContext];
        }
            break;
    }
}

- (void)nextAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UITabBarController * tabBarVC = nil;
    if (fromVC.tabBarController && [[fromVC.navigationController viewControllers] count] == 2) {
        tabBarVC = fromVC.tabBarController;
    }
    
    if (_direction == BKTransitionAnimaterDirectionRight) {
        toVC.view.x = SCREENW;
    }else {
        toVC.view.x = -SCREENW;
    }
    
    UIView * containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    if (tabBarVC) {
        [fromVC.view addSubview:tabBarVC.tabBar];
    }
    
    if (!_fromShadowView) {
        _fromShadowView = [[UIView alloc]initWithFrame:fromVC.view.frame];
        _fromShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        _fromShadowView.alpha = 0;
        [containerView addSubview:_fromShadowView];
    }
    
    if (!_toShadowView) {
        _toShadowView = [[UIView alloc]initWithFrame:toVC.view.frame];
        _toShadowView.backgroundColor = [UIColor whiteColor];
        _toShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _toShadowView.layer.shadowOpacity = 0.45;
        _toShadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _toShadowView.layer.shadowRadius = 7;
        _toShadowView.alpha = 0;
        [containerView addSubview:_toShadowView];
    }
    
    [containerView addSubview:toVC.view];
    
    WEAK_SELF(self);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        STRONG_SELF(weakSelf);
        
        if (strongSelf.direction == BKTransitionAnimaterDirectionRight) {
            fromVC.view.x = -SCREENW/2;
            strongSelf.fromShadowView.x = -SCREENW/2;
        }else {
            fromVC.view.x = SCREENW/2;
            strongSelf.fromShadowView.x = SCREENW/2;
        }
        strongSelf.fromShadowView.alpha = 1;
        toVC.view.x = 0;
        strongSelf.toShadowView.x = 0;
        strongSelf.toShadowView.alpha = 1;
        
    } completion:^(BOOL finished) {
        STRONG_SELF(weakSelf);
        
        [strongSelf.fromShadowView removeFromSuperview];
        strongSelf.fromShadowView = nil;
        [strongSelf.toShadowView removeFromSuperview];
        strongSelf.toShadowView = nil;
        
        [fromVC.view removeFromSuperview];
        
        [transitionContext completeTransition:YES];
        
    }];
}

- (void)backAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UITabBarController * tabBarVC = toVC.tabBarController;
    if (toVC.tabBarController) {
        __block BOOL flag = NO;
        [toVC.tabBarController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UINavigationController class]]) {
                if ([[(UINavigationController*)obj viewControllers] firstObject] == toVC) {
                    flag = YES;
                    *stop = YES;
                }
            }else{
                if (obj == toVC) {
                    flag = YES;
                    *stop = YES;
                }
            }
        }];
        
        if (!flag) {
            if ([[toVC.navigationController viewControllers] count] == 1) {
                flag = YES;
            }
        }
        
        if (flag) {
            tabBarVC.tabBar.hidden = NO;
        }else{
            tabBarVC.tabBar.hidden = YES;
        }
    }
    
    UIView * containerView = [transitionContext containerView];
    
    if (_direction == BKTransitionAnimaterDirectionRight) {
        toVC.view.x = -SCREENW/2;
    }else {
        toVC.view.x = SCREENW/2;
    }
    [containerView addSubview:toVC.view];
    if (!tabBarVC.tabBar.hidden) {
        [toVC.view addSubview:tabBarVC.tabBar];
    }
    
    if (!_toShadowView) {
        _toShadowView = [[UIView alloc]initWithFrame:toVC.view.frame];
        _toShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        [containerView addSubview:_toShadowView];
    }
    
    if (!_fromShadowView) {
        _fromShadowView = [[UIView alloc]initWithFrame:fromVC.view.frame];
        _fromShadowView.backgroundColor = [UIColor whiteColor];
        _fromShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _fromShadowView.layer.shadowOpacity = 0.45;
        _fromShadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _fromShadowView.layer.shadowRadius = 7;
        [containerView addSubview:_fromShadowView];
    }
    
    [containerView addSubview:fromVC.view];
    
    WEAK_SELF(self);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        STRONG_SELF(weakSelf);
        
        if (strongSelf.direction == BKTransitionAnimaterDirectionRight) {
            fromVC.view.x = SCREENW;
            strongSelf.fromShadowView.x = SCREENW;
        }else{
            fromVC.view.x = -SCREENW;
            strongSelf.fromShadowView.x = -SCREENW;
        }
        strongSelf.fromShadowView.alpha = 0;
        toVC.view.x = 0;
        strongSelf.toShadowView.x = 0;
        strongSelf.toShadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        STRONG_SELF(weakSelf);
        
        [strongSelf.fromShadowView removeFromSuperview];
        strongSelf.fromShadowView = nil;
        [strongSelf.toShadowView removeFromSuperview];
        strongSelf.toShadowView = nil;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            fromVC.view.x = 0;
            [toVC.view removeFromSuperview];
        }else {
            if (strongSelf.backFinishAction) {
                strongSelf.backFinishAction();
            }
            [fromVC.view removeFromSuperview];
            if (!tabBarVC.tabBar.hidden) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [tabBarVC.view addSubview:tabBarVC.tabBar];
                });
            }
        }
    }];
}


@end
