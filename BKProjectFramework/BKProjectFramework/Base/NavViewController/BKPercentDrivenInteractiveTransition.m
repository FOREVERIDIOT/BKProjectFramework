//
//  BKPercentDrivenInteractiveTransition.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKPercentDrivenInteractiveTransition.h"

@interface BKPercentDrivenInteractiveTransition ()

/**
 当前VC
 */
@property (nonatomic, weak) UIViewController * currentVC;

/**
 手势方向
 */
@property (nonatomic, assign) BKPercentDrivenInteractiveTransitionGestureDirection direction;

@end

@implementation BKPercentDrivenInteractiveTransition

#pragma mark - init

- (instancetype)initWithTransitionGestureDirection:(BKPercentDrivenInteractiveTransitionGestureDirection)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
        _enble = YES;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController
{
    self.currentVC = viewController;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    pan.maximumNumberOfTouches = 1;
    [viewController.view addGestureRecognizer:pan];
}

/**
 *  手势过渡的过程
 */
- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    if (!_enble) {
        panGesture.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            panGesture.enabled = YES;
        });
    }
    
    CGPoint point = [panGesture velocityInView:panGesture.view];
    BOOL isPassFlag = NO;
    CGFloat persent = 0;
    switch (_direction) {
        case BKPercentDrivenInteractiveTransitionGestureDirectionRight:
        {
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
            
            if (point.x > 500) {
                isPassFlag = YES;
            }else{
                isPassFlag = NO;
            }
        }
            break;
        case BKPercentDrivenInteractiveTransitionGestureDirectionLeft:
        {
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
            
            if (point.x < -500) {
                isPassFlag = YES;
            }else{
                isPassFlag = NO;
            }
        }
            break;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interation = YES;
            
            switch (_direction) {
                case BKPercentDrivenInteractiveTransitionGestureDirectionRight:
                {
                    if (point.x > 0 && point.x > fabs(point.y)) {
                        if (_backVC) {
                            [_currentVC.navigationController popToViewController:_backVC animated:YES];
                        }else{
                            [_currentVC.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }
                    break;
                case BKPercentDrivenInteractiveTransitionGestureDirectionLeft:
                {
                    if (point.x < 0 && fabs(point.x) > fabs(point.y)) {
                        if (_backVC) {
                            [_currentVC.navigationController popToViewController:_backVC animated:YES];
                        }else{
                            [_currentVC.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:persent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.interation = NO;
            if (persent > 0.5 || isPassFlag) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            self.interation = NO;
            [self cancelInteractiveTransition];
        }
            break;
        default:
            break;
    }
}

@end
