//
//  BKCameraViewController.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/19.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKBaseViewController.h"

typedef NS_ENUM(NSUInteger, BKCameraType) {
    BKCameraTypeTakePhoto = 0, //拍照
    BKCameraTypeRecordVideo,   //录视频
};

@interface BKCameraViewController : BKBaseViewController

/**
 开启类型
 */
@property (nonatomic,assign) BKCameraType cameraType;

@end
