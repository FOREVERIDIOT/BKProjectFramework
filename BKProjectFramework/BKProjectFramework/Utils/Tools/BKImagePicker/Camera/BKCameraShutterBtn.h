//
//  BKCameraShutterBtn.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/23.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCameraViewController.h"

typedef NS_ENUM(NSUInteger, BKRecordState) {
    BKRecordStateNone = 0,      //未录制
    BKRecordStateBegin,         //录制开始
    BKRecordStatePause,         //录制暂停
    BKRecordStateEnd            //录制结束
};

@interface BKCameraShutterBtn : UIView

/**
 开启类型
 */
@property (nonatomic,assign) BKCameraType cameraType;

/**
 拍照快门回调
 */
@property (nonatomic,copy) void (^takePictureAction)(void);

/**
 录像快门回调
 */
@property (nonatomic,copy) void (^recordVideoAction)(BKRecordState state);

@end
