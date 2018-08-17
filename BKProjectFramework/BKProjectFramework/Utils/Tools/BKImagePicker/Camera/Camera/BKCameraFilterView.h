//
//  BKCameraFilterView.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/8/8.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKCameraFilterView : UIView

/**
 修改美颜等级回调
 */
@property (nonatomic,copy) void (^switchBeautyFilterLevelAction)(NSInteger level);

@end
