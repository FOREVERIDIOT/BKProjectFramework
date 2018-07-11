//
//  BKRoundedRectView.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKRoundedRectView : UIView

/**
 填充色
 */
@property (nonatomic,strong) UIColor * fillColor;

/**
 边框色
 */
@property (nonatomic,strong) UIColor * strokeColor;

/**
 边框宽度
 */
@property (nonatomic,assign) CGFloat strokeWidth;

/**
 圆角度数 默认自身的一半
 */
@property (nonatomic,assign) CGFloat radius;

@end
