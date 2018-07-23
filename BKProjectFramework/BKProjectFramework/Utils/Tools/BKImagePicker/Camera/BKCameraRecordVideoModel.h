//
//  BKCameraRecordVideoModel.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/23.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKCameraRecordVideoModel : NSObject

/**
 暂停线layer
 */
@property (nonatomic,strong) CAShapeLayer * stopLayer;
/**
 暂停时间
 */
@property (nonatomic,assign) CFTimeInterval pauseTime;

@end
