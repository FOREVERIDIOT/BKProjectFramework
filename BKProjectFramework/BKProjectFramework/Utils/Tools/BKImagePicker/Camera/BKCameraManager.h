//
//  BKCameraManager.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/24.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BKCameraType) {
    BKCameraTypeTakePhoto = 0, //拍照
    BKCameraTypeRecordVideo,   //录视频
};

typedef NS_ENUM(NSUInteger, BKRecordVideoFailure) {
    BKRecordVideoFailureCaptureDeviceError = 0,        //初始化设备失败
    BKRecordVideoFailureVideoInputError,               //初始化视频输入设备失败
    BKRecordVideoFailureAudioInputError,               //初始化音频输入设备失败
    BKRecordVideoFailureWriteVideoInputError,          //初始化写入视频失败
    BKRecordVideoFailureWriteAudioInputError,          //初始化写入音频失败
};

@protocol BKCameraManagerDelegate <NSObject>

@required

/**
 录制视频失败代理

 @param failure 失败原因
 @return 返回YES 录制视频方法return , 返回NO 录制视频方法继续
 */
-(BOOL)recordingFailure:(BKRecordVideoFailure)failure;

@optional

@end

@interface BKCameraManager : NSObject

/**
 代理
 */
@property (nonatomic,assign) id<BKCameraManagerDelegate> delegate;
/**
 开启类型
 */
@property (nonatomic,assign) BKCameraType cameraType;

/**
 创建方法

 @param currentVC 创建到的vc
 @return BKCameraManager
 */
-(instancetype)initWithCurrentVC:(UIViewController*)currentVC;

/**
 开始捕捉画面(在viewDidAppear中调用)
 */
-(void)captureSessionStartRunning;

/**
 停止捕捉画面(在viewWillDisappear中调用)
 */
-(void)captureSessionStopRunning;

/**
 获取当前捕捉的图像
 */
-(UIImage*)getCurrentCaptureImage;

/**
 开始录制
 */
-(void)startRecordVideo;

/**
 暂停录制
 */
-(void)pauseRecordVideo;

/**
 完成录制
 */
-(void)finishRecordVideo;

/**
 切换镜头

 @param complete flag切换结果是否成功 position镜头方向
 */
-(void)switchCaptureDeviceComplete:(void (^)(BOOL flag, AVCaptureDevicePosition position))complete;

/**
 切换闪光灯 闪光灯只有两种状态 关闭/开启

 @param complete flag切换结果是否成功 flashMode闪光灯状态
 */
-(void)modifyFlashModeComplete:(void (^)(BOOL flag, AVCaptureFlashMode flashMode))complete;

@end
