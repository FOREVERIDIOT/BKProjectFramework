//
//  BKTabBar.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKTabBarBtn.h"
@class BKTabBar;

@protocol BKTabBarDelegate <NSObject>

@optional

-(void)tabBar:(BKTabBar*)tabBar didSelectButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface BKTabBar : BKImageView

@property (nonatomic,assign) id<BKTabBarDelegate> delegate;

@property (nonatomic,assign) NSInteger defaultSelectNum;

@property (nonatomic,weak) UIColor * titleNormalColor;
@property (nonatomic,weak) UIColor * titleSelectColor;

-(void)creatMyTabBarItemsWithNormalImageArr:(NSArray*)normal selectImageArr:(NSArray*)select tittleArr:(NSArray*)tittle;

-(void)changeSelectNum:(NSInteger)fromIndex to:(NSInteger)toIndex normalImageArr:(NSArray*)normal selectImageArr:(NSArray*)select;

-(void)clickBtnWhichNum:(NSInteger)num;

@end
