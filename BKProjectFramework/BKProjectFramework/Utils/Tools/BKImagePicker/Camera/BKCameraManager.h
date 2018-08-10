//
//  BKCameraManager.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/24.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKGPUImageBeautyFilter.h"

typedef NS_ENUM(NSUInteger, BKCameraType) {
    BKCameraTypeTakePhoto = 0, //拍照
    BKCameraTypeRecordVideo,   //录视频
};

@protocol BKCameraManagerDelegate <NSObject>

@required

/**
 调用录制完成返回的代理
 
 @param videoUrl 视频路径
 @param imageUrl 第一帧图片路径
 */
-(void)finishRecorded:(NSString*)videoUrl firstFrameImageUrl:(NSString*)imageUrl;

@optional

/**
 录制视频失败代理

 @param failure 失败原因
 */
-(void)recordingFailure:(NSError*)failure;

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
-(void)getCurrentCaptureImageComplete:(void (^)(UIImage * currentImage))complete;

/**
 获取当前摄像头方向
 */
-(AVCaptureDevicePosition)getCurrentCaptureDevicePosition;

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

/**
 增加焦距比例

 @param factorP 焦距比例 (焦距范围1~2 默认1)
 */
-(void)addFactorP:(CGFloat)factorP;

/**
 修改美颜等级

 @param level 等级 0~5
 */
-(void)switchBeautyFilterLevel:(BKBeautyLevel)level;

@end
