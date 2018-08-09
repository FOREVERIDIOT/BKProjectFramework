//
//  BKCameraRecordProgress.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/8/2.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKCameraRecordProgress : UIView

/**
 当前进度时间
 */
@property (nonatomic,assign) CGFloat currentTime;

/**
 暂停录制
 */
-(void)pauseRecord;

/**
 删除最后一次录制
 */
-(void)deleteLastRecord;

@end
