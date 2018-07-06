//
//  BKCycleScrollCollectionViewCell.h
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCycleScrollView.h"
#import "BKCycleScrollImageView.h"

@interface BKCycleScrollCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) BKCycleScrollImageView * displayImageView;

/** cell圆角度数 */
@property (nonatomic,assign) CGFloat radius;
/** 占位图 无默认 */
@property (nonatomic,strong) UIImage * placeholderImage;
/** 数据 */
@property (nonatomic,strong) NSObject * dataObj;

@end
