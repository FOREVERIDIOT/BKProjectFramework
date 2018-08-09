//
//  BKFocusRectangle.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/8/9.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKFocusRectangle : UIView

/**
 太阳级别 -1~1 默认0
 */
@property (nonatomic,assign) CGFloat sunLevel;

/**
 创建方法

 @param point 手指点的位置
 @param isDisplaySun 是否显示太阳
 @return 聚焦框
 */
-(instancetype)initWithPoint:(CGPoint)point isDisplaySun:(BOOL)isDisplaySun;

@end
