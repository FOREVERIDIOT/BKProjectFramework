//
//  BKCameraManager.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/24.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCameraManager.h"
#import <AVFoundation/AVFoundation.h>
#import "BKImagePickerMacro.h"
#import "UIView+BKImagePicker.h"
#import "UIImage+BKImagePicker.h"
#import "GPUImage.h"
#import "BKGPUImageBeautyFilter.h"

typedef NS_ENUM(NSInteger, BKRecordVideoState) {
    BKRecordVideoStatePrepareRecording = 0,
    BKRecordVideoStateRecording,
    BKRecordVideoStateFinishRecording
};

@interface BKCameraManager()
//<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic,weak) UIViewController * currentVC;//所在VC
@property (nonatomic,assign) CGPoint startPoint;//记录开始手势的位置

@property (nonatomic,strong) GPUImageVideoCamera * videoCamera;//相机
@property (nonatomic,strong) BKGPUImageBeautyFilter * beautyFilter;//美颜滤镜
@property (nonatomic,strong) GPUImageView * previewView;//预览界面
@property (nonatomic,strong) GPUImageMovieWriter * movieWriter;//视频写入者

//
//@property (nonatomic,assign) BKRecordVideoState writeState;//录制属性
//
//@property (nonatomic,strong) UIView * previewView;//预览界面
//@property (nonatomic,strong) AVCaptureSession * captureSession;//负责输入和输出设备之间的数据传递
//@property (nonatomic,strong) dispatch_queue_t videoQueue;//视频队列
//@property (nonatomic,strong) AVCaptureVideoPreviewLayer * previewLayer;//相机拍摄预览图层
//@property (nonatomic,strong) AVCaptureDeviceInput * videoInput;//视频输入
//@property (nonatomic,strong) AVCaptureDeviceInput * audioInput;//音频输入
//@property (nonatomic,strong) AVCaptureVideoDataOutput * videoOutput;//视频输出
//@property (nonatomic,strong) AVCaptureAudioDataOutput * audioOutput;//音频输出
//
//@property (nonatomic,retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
//@property (nonatomic,retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;
//
//@property (nonatomic,strong) dispatch_queue_t writeQueue;//写入队列
//@property (nonatomic,strong) AVAssetWriter * assetWriter;//视频写
//@property (nonatomic,strong) AVAssetWriterInput * assetWriterVideoInput;//视频写入
//@property (nonatomic,strong) AVAssetWriterInput * assetWriterAudioInput;//音频写入
//@property (nonatomic,assign) BOOL isWritingFlag;//是否正在写入中
//@property (nonatomic,copy) NSString * writeFilePath;//当前写入路径
//@property (nonatomic,strong) NSMutableArray * videoUrlArr;//录制所有片段路径数组
//@property (nonatomic,strong) UIImage * currentImage;//当前图片
//
//@property (nonatomic,strong) UIImageView * focusImageView;//聚焦框
//@property (nonatomic,strong) NSTimer * focusCursorTimer;//聚焦框消失定时器

@end

@implementation BKCameraManager

#pragma mark - 公开方法

/**
 开始捕捉画面(在viewDidAppear中调用)
 */
-(void)captureSessionStartRunning
{
//    [self.captureSession startRunning];
//    if (_videoInput) {
//        AVCaptureDevice * captureDevice = [_videoInput device];
//        [self addNotificationToCaptureDevice:captureDevice];
//    }
    [self.videoCamera startCameraCapture];
}

/**
 停止捕捉画面(在viewWillDisappear中调用)
 */
-(void)captureSessionStopRunning
{
//    [self.captureSession stopRunning];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.videoCamera stopCameraCapture];
}

/**
 获取当前捕捉的图像
 */
-(UIImage*)getCurrentCaptureImage
{
//    return self.currentImage;
    return [self.videoCamera imageFromCurrentFramebuffer];
}

/**
 开始录制
 */
-(void)startRecordVideo
{
//    [self startWrite];
}

/**
 暂停录制
 */
-(void)pauseRecordVideo
{
//    [self stopWrite];
}

/**
 切换镜头
 */
-(void)switchCaptureDeviceComplete:(void (^)(BOOL flag, AVCaptureDevicePosition position))complete
{
    //之前的镜头
    AVCaptureDevicePosition oldPosition = [_videoCamera cameraPosition];
    [self.videoCamera rotateCamera];//切换镜头
    //现在的镜头
    AVCaptureDevicePosition currentPosition = [_videoCamera cameraPosition];
    if (oldPosition != currentPosition) {//判断两次镜头是否一致 一致代表失败 不一致代表成功
        [self editVideoPositionAndVideoMirror];
        if (complete) {
            complete(YES, currentPosition);
        }
    }else{
        if (complete) {
            complete(NO, currentPosition);
        }
    }
}

/**
 切换闪光灯 闪光灯只有两种状态 关闭/开启
 */
-(void)modifyFlashModeComplete:(void (^)(BOOL flag, AVCaptureFlashMode flashMode))complete
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice hasTorch] && [captureDevice hasFlash]) {
            if (captureDevice.flashMode == AVCaptureFlashModeOn) {
                [captureDevice setTorchMode:AVCaptureTorchModeOff];
                [captureDevice setFlashMode:AVCaptureFlashModeOff];
            }else if (captureDevice.flashMode == AVCaptureFlashModeOff) {
                [captureDevice setTorchMode:AVCaptureTorchModeOn];
                [captureDevice setFlashMode:AVCaptureFlashModeOn];
            }
            if (complete) {
                complete(YES, captureDevice.flashMode);
            }
        }else {
            if (complete) {
                complete(NO, captureDevice.flashMode);
            }
        }
    }];
}

#pragma mark - 初始方法

-(instancetype)initWithCurrentVC:(UIViewController*)currentVC
{
    self = [super init];
    if (self) {
        self.currentVC = currentVC;
//        [self.currentVC.view insertSubview:self.previewView atIndex:0];
        [self.currentVC.view insertSubview:self.previewView atIndex:0];
        [self addBeautyFilter];
    }
    return self;
}

#pragma mark - GPUImageView

-(GPUImageView*)previewView
{
    if (!_previewView) {
        _previewView = [[GPUImageView alloc] initWithFrame:self.currentVC.view.bounds];
        [_previewView setBackgroundColorRed:0 green:0 blue:0 alpha:1];
    }
    return _previewView;
}

#pragma mark - GPUImageVideoCamera

-(GPUImageVideoCamera*)videoCamera
{
    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
        [self editVideoPositionAndVideoMirror];
    }
    return _videoCamera;
}

/**
 调整摄像方向和镜像翻转
 */
-(void)editVideoPositionAndVideoMirror
{
    if ([_videoCamera cameraPosition] == AVCaptureDevicePositionBack) {
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }else if ([_videoCamera cameraPosition] == AVCaptureDevicePositionFront) {
        [_videoCamera videoCaptureConnection].videoMirrored = YES;
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark - BKGPUImageBeautyFilter

-(BKGPUImageBeautyFilter*)beautyFilter
{
    if (!_beautyFilter) {
        _beautyFilter = [[BKGPUImageBeautyFilter alloc] init];
        _beautyFilter.beautyLevel = BKBeautyLevelZero;
    }
    return _beautyFilter;
}

/**
 添加滤镜
 */
-(void)addBeautyFilter
{
    if (self.beautyFilter.beautyLevel == BKBeautyLevelZero) {
        [self removeBeautyFilter];
        return;
    }
    
    [self.videoCamera addTarget:self.beautyFilter];
    [self.beautyFilter addTarget:self.previewView];
}

/**
 删除滤镜
 */
-(void)removeBeautyFilter
{
    [self.videoCamera removeAllTargets];
    [self.videoCamera addTarget:self.previewView];
}

//#pragma mark - 预览界面
//
//-(UIView*)previewView
//{
//    if (!_previewView) {
//        _previewView = [[UIView alloc]initWithFrame:self.currentVC.view.bounds];
//        _previewView.backgroundColor = [UIColor blackColor];
//
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewViewTap:)];
//        [_previewView addGestureRecognizer:tap];
//
//        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(previewViewPan:)];
//        [_previewView addGestureRecognizer:pan];
//
//        [_previewView.layer addSublayer:self.previewLayer];
//    }
//    return _previewView;
//}
//
//-(void)previewViewTap:(UITapGestureRecognizer *)tapGesture
//{
//    //获取点击坐标
//    CGPoint point = [tapGesture locationInView:self.previewView];
//    [self setFocusCursorWithPoint:point];
//
//    //将UI坐标转化为摄像头坐标
//    CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
//
//    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
//}
//
//-(void)previewViewPan:(UIPanGestureRecognizer*)panGesture
//{
//    CGPoint point = [panGesture translationInView:self.previewView];
//
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//
//        CGFloat minFactor = 1;
//        CGFloat maxFactor = 4;
//        if (@available(iOS 11.0, *)) {
//            maxFactor = captureDevice.maxAvailableVideoZoomFactor / 2;
//        } else {
//            maxFactor = captureDevice.activeFormat.videoMaxZoomFactor / 2;
//        }
//        CGFloat factor_max_min_gap = maxFactor - minFactor;
//        CGFloat totalHeight = self.previewView.bk_height - 200;
//        CGFloat addFactor = -point.y / totalHeight * factor_max_min_gap;
//
//        CGFloat resultFactor = captureDevice.videoZoomFactor + addFactor;
//        if (resultFactor > maxFactor) {
//            resultFactor = maxFactor;
//        }else if (resultFactor < minFactor) {
//            resultFactor = minFactor;
//        }
//        captureDevice.videoZoomFactor = resultFactor;
//
//    }];
//
//    [panGesture setTranslation:CGPointZero inView:self.previewView];
//}
//
//#pragma mark - AVCaptureSession
//
//-(NSMutableArray*)videoUrlArr
//{
//    if (!_videoUrlArr) {
//        _videoUrlArr = [NSMutableArray array];
//    }
//    return _videoUrlArr;
//}
//
//-(dispatch_queue_t)videoQueue
//{
//    if (!_videoQueue) {
//        _videoQueue = dispatch_queue_create("videoQueue", DISPATCH_QUEUE_SERIAL);
//    }
//    return _videoQueue;
//}
//
//-(AVCaptureDeviceInput*)videoInput
//{
//    if (!_videoInput) {
//        //获得输入设备
//        AVCaptureDevice * captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
//        if (!captureDevice) {
//            captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];//取得前置摄像头
//            if (!captureDevice) {
//                BOOL flag = [self.delegate recordingFailure:BKRecordVideoFailureCaptureDeviceError];
//                if (flag) {
//                    return nil;
//                }
//            }
//        }
//
//        NSError * error = nil;
//        _videoInput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
//        if (error) {
//            BOOL flag = [self.delegate recordingFailure:BKRecordVideoFailureVideoInputError];
//            if (flag) {
//                return nil;
//            }
//        }
//    }
//    return _videoInput;
//}
//
//-(AVCaptureVideoDataOutput*)videoOutput
//{
//    if (!_videoOutput) {
//        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
//        _videoOutput.alwaysDiscardsLateVideoFrames = YES; //立即丢弃旧帧，节省内存，默认YES
//        [_videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
//        [_videoOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA),
//                                         @"Width":@([UIScreen mainScreen].scale * self.previewView.bk_width),
//                                         @"Height":@([UIScreen mainScreen].scale * self.previewView.bk_height),
//                                         }];
//
//        //根据设备输出获得连接
//        AVCaptureConnection * connection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
//
//        AVCaptureDevicePosition currentPosition = [[self.videoInput device] position];
//        //前置摄像头镜像翻转 并且右倒 保证和后置摄像头镜头方向一致
//        if (currentPosition == AVCaptureDevicePositionFront) {
//            connection.videoMirrored = YES;
//        }else{
//            connection.videoMirrored = NO;
//        }
//        if (_cameraType == BKCameraTypeTakePhoto) {
//            connection.videoOrientation = AVCaptureVideoOrientationPortrait;
//        }else if (_cameraType == BKCameraTypeRecordVideo) {//录像视频本是左倒的 所以右倒
//            connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//        }
//    }
//    return _videoOutput;
//}
//
//-(AVCaptureDeviceInput*)audioInput
//{
//    if (!_audioInput) {
//        //添加一个音频输入设备
//        AVCaptureDevice * audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
//
//        NSError *error = nil;
//        _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
//        if (error) {
//            BOOL flag = [self.delegate recordingFailure:BKRecordVideoFailureAudioInputError];
//            if (flag) {
//                return nil;
//            }
//        }
//    }
//    return _audioInput;
//}
//
//-(AVCaptureAudioDataOutput*)audioOutput
//{
//    if (!_audioOutput) {
//        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
//        [_audioOutput setSampleBufferDelegate:self queue:self.videoQueue];
//    }
//    return _audioOutput;
//}
//
//-(AVCaptureSession*)captureSession
//{
//    if (!_captureSession) {
//
//        //初始化会话
//        _captureSession = [[AVCaptureSession alloc]init];
//        if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {//设置分辨率
//            _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
//        }
//
//        if ([_captureSession canAddInput:self.videoInput]) {
//            [_captureSession addInput:self.videoInput];
//        }
//
//        if ([_captureSession canAddOutput:self.videoOutput]) {
//            [_captureSession addOutput:self.videoOutput];
//        }
//
//        if ([_captureSession canAddInput:self.audioInput]) {
//            [_captureSession addInput:self.audioInput];
//        }
//
//        if ([_captureSession canAddOutput:self.audioOutput]) {
//            [_captureSession addOutput:self.audioOutput];
//        }
//    }
//    return _captureSession;
//}
//
//-(AVCaptureVideoPreviewLayer*)previewLayer
//{
//    if (!_previewLayer) {
//        //创建视频预览层，用于实时展示摄像头状态
//        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
//        _previewLayer.frame = self.previewView.bounds;
//        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
//    }
//    return _previewLayer;
//}
//
//#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate AVCaptureAudioDataOutputSampleBufferDelegate
//
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
//{
//    @autoreleasepool {
//
//        if (!sampleBuffer) {
//            return;
//        }
//
//        //视频
//        if (connection == [_videoOutput connectionWithMediaType:AVMediaTypeVideo]) {
//
//            if (self.cameraType == BKCameraTypeTakePhoto) {
//                //获取当前显示图片
//                UIImage * currentImage = [self imageFromSampleBuffer:sampleBuffer];
//                if (currentImage) {
//                    self.currentImage = currentImage;
//                }
//            }else if (self.cameraType == BKCameraTypeRecordVideo) {
//                if (!self.outputVideoFormatDescription) {
//                    @synchronized (self) {
//                        CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
//                        self.outputVideoFormatDescription = formatDescription;
//                    }
//                }else {
//                    @synchronized (self) {
//                        if (self.writeState == BKRecordVideoStateRecording) {
//                            [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
//                        }
//                    }
//                }
//            }
//        }
//
//        if (self.cameraType == BKCameraTypeRecordVideo) {
//            //音频
//            if (connection == [_audioOutput connectionWithMediaType:AVMediaTypeAudio]) {
//                if (!self.outputAudioFormatDescription) {
//                    @synchronized (self) {
//                        CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
//                        self.outputAudioFormatDescription = formatDescription;
//                    }
//                }else {
//                    @synchronized (self) {
//                        if (self.writeState == BKRecordVideoStateRecording) {
//                            [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
///**
// 获取当前显示图片
// */
//-(UIImage*)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
//{
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    if (width == 0 || height == 0) {
//        return nil;
//    }
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    void * baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//
//    UIImage * image = [UIImage imageWithCGImage:quartzImage];
//    CGImageRelease(quartzImage);
//    return image;
//}
//
///**
// 开始写入视频和音频数据
// */
//-(void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType
//{
//    @synchronized(self){
//        if (self.writeState < BKRecordVideoStateRecording){
//            return;
//        }
//    }
//
//    CFRetain(sampleBuffer);
//    dispatch_async(self.writeQueue, ^{
//        @autoreleasepool {
//            @synchronized(self) {
//                if (self.writeState > BKRecordVideoStateRecording){
//                    CFRelease(sampleBuffer);
//                    return;
//                }
//            }
//
//            if (!self.isWritingFlag && mediaType == AVMediaTypeVideo) {
//                [self.assetWriter startWriting];
//                [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
//                self.isWritingFlag = YES;
//            }
//
//            //写入视频数据
//            if (mediaType == AVMediaTypeVideo) {
//                if (self.assetWriterVideoInput.readyForMoreMediaData) {
//                    BOOL success = [self.assetWriterVideoInput appendSampleBuffer:sampleBuffer];
//                    if (!success) {
//                        @synchronized (self) {
//                            [self stopWrite];
//                        }
//                    }
//                }
//            }
//
//            //写入音频数据
//            if (mediaType == AVMediaTypeAudio) {
//                if (self.assetWriterAudioInput.readyForMoreMediaData) {
//                    BOOL success = [self.assetWriterAudioInput appendSampleBuffer:sampleBuffer];
//                    if (!success) {
//                        @synchronized (self) {
//                            [self stopWrite];
//                        }
//                    }
//                }
//            }
//
//            CFRelease(sampleBuffer);
//        }
//    });
//}
//
//#pragma mark - AVAssetWriter
//
//-(dispatch_queue_t)writeQueue
//{
//    if (!_writeQueue) {
//        _writeQueue = dispatch_queue_create("writeQueue", DISPATCH_QUEUE_SERIAL);
//    }
//    return _writeQueue;
//}
//
//-(NSString*)writeFilePath
//{
//    if (!_writeFilePath) {
//        NSInteger dateSp = [[NSDate date] timeIntervalSince1970];
//        _writeFilePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"BKImagePicker_Temp%ld.mp4",dateSp]];
//    }
//    return _writeFilePath;
//}
//
//-(AVAssetWriter*)assetWriter
//{
//    if (!_assetWriter) {
//        _assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:self.writeFilePath] fileType:AVFileTypeMPEG4 error:nil];
//    }
//    return _assetWriter;
//}
//
//#pragma mark - AVAssetWriterVideoInput
//
//-(NSDictionary*)settingVideoCompression
//{
//    //写入视频大小
//    NSInteger numPixels = self.previewView.bk_width * self.previewView.bk_height;
//    //每像素比特
//    CGFloat bitsPerPixel = 12;
//    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
//
//    // 码率和帧率设置
//    NSDictionary * compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
//                                              AVVideoExpectedSourceFrameRateKey : @(30),
//                                              AVVideoMaxKeyFrameIntervalKey : @(30),
//                                              AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel };
//
//    //视频属性
//    NSDictionary * videoCompressionSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
//                                                 AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
//                                                 AVVideoWidthKey : @(self.previewView.bk_height * [UIScreen mainScreen].scale),
//                                                 AVVideoHeightKey : @(self.previewView.bk_width * [UIScreen mainScreen].scale),
//                                                 AVVideoCompressionPropertiesKey : compressionProperties };
//
//    return videoCompressionSettings;
//}
//
//-(AVAssetWriterInput*)assetWriterVideoInput
//{
//    if (!_assetWriterVideoInput) {
//        _assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self settingVideoCompression]];
//        //expectsMediaDataInRealTime 必须设为yes，需要从capture session 实时获取数据
//        _assetWriterVideoInput.expectsMediaDataInRealTime = YES;
//        _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
//    }
//    return _assetWriterVideoInput;
//}
//
//#pragma mark - AVAssetWriterAudioInput
//
//-(NSDictionary*)settingAudioCompression
//{
//    // 音频设置
//    NSDictionary * audioCompressionSettings = @{ AVEncoderBitRatePerChannelKey : @(28000),
//                                                 AVFormatIDKey : @(kAudioFormatMPEG4AAC),
//                                                 AVNumberOfChannelsKey : @(1),
//                                                 AVSampleRateKey : @(22050) };
//
//    return audioCompressionSettings;
//}
//
//-(AVAssetWriterInput*)assetWriterAudioInput
//{
//    if (!_assetWriterAudioInput) {
//        _assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self settingAudioCompression]];
//        _assetWriterAudioInput.expectsMediaDataInRealTime = YES;
//    }
//    return _assetWriterAudioInput;
//}
//
//#pragma mark - 开始写入视频和停止写入视频
//
///**
// 开始写入视频
// */
//-(void)startWrite
//{
//    self.writeState = BKRecordVideoStatePrepareRecording;
//
//    //写入视频
//    if ([self.assetWriter canAddInput:self.assetWriterVideoInput]) {
//        [self.assetWriter addInput:self.assetWriterVideoInput];
//    }else {
//        if ([self.delegate respondsToSelector:@selector(recordingFailure:)]) {
//            BOOL flag = [self.delegate recordingFailure:BKRecordVideoFailureWriteVideoInputError];
//            if (flag) {
//                [self stopWrite];
//                return;
//            }
//        }
//    }
//    //写入音频
//    if ([self.assetWriter canAddInput:self.assetWriterAudioInput]) {
//        [self.assetWriter addInput:self.assetWriterAudioInput];
//    }else {
//        if ([self.delegate respondsToSelector:@selector(recordingFailure:)]) {
//            BOOL flag = [self.delegate recordingFailure:BKRecordVideoFailureWriteAudioInputError];
//            if (flag) {
//                [self stopWrite];
//                return;
//            }
//        }
//    }
//
//    self.writeState = BKRecordVideoStateRecording;
//}
//
///**
// 停止写入视频
// */
//- (void)stopWrite
//{
//    BK_WEAK_SELF(self);
//    if(_assetWriter){
//        dispatch_async(self.writeQueue, ^{
//            BK_STRONG_SELF(weakSelf);
//
//            [strongSelf.assetWriter finishWritingWithCompletionHandler:^{
//                [strongSelf.videoUrlArr addObject:strongSelf.writeFilePath];
//            }];
//
//            strongSelf.writeState = BKRecordVideoStateFinishRecording;
//            strongSelf.assetWriter = nil;
//            strongSelf.assetWriterAudioInput = nil;
//            strongSelf.assetWriterVideoInput = nil;
//            strongSelf.isWritingFlag = NO;
//        });
//    }
//
////    [_progressTimer invalidate];
////    _progressTimer = nil;
////
////    dispatch_async(dispatch_get_main_queue(), ^{
////        if (_current_time < _max_time) {
////            _pauseNum = _pauseNum + 1;
////
////            UIView * pauseView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_progressView.frame) - 1, 0, 1, _progressView.height)];
////            pauseView.backgroundColor = [UIColor whiteColor];
////            pauseView.tag = _pauseNum;
////            pauseView.strTag = [NSString stringWithFormat:@"%f",_current_time];//保存暂停时的时间
////            [self addSubview:pauseView];
////        }
////
////        [_beginRecordBtn setBackgroundImage:[UIImage imageNamed:@"community_publish_start"] forState:UIControlStateNormal];
////    });
//}
//
//#pragma mark - 获取摄像头
//
///**
// *  取得指定位置的摄像头
// *
// *  @param position 摄像头位置
// *
// *  @return 摄像头设备
// */
//- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position
//{
//    if (@available(iOS 10.0, *)) {
//        AVCaptureDeviceDiscoverySession * session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
//
//        NSArray * devices = session.devices;
//        for (AVCaptureDevice * device in devices) {
//            if ([device position] == position) {
//                return device;
//            }
//        }
//        return nil;
//    }else {
//        NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//        for (AVCaptureDevice * device in devices) {
//            if ([device position] == position) {
//                return device;
//            }
//        }
//        return nil;
//    }
//}
//
//#pragma mark - 镜头捕捉区域改变
///**
// *  给输入设备添加通知
// */
//-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice
//{
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
//    }];
//    //捕获区域发生改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
//}
//
///**
// 捕获区域发生改变
//
// @param notification notification
// */
//-(void)areaChange:(NSNotification*)notification
//{
//    //将UI坐标转化为摄像头坐标
//    CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:self.previewView.center];
//    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
//}
//
//#pragma mark - 改变录制属性
//
///**
// *  设置聚焦光标位置
// *
// *  @param point 光标位置
// */
//-(void)setFocusCursorWithPoint:(CGPoint)point
//{
//    if (_focusCursorTimer) {
//        [_focusCursorTimer invalidate];
//        _focusCursorTimer = nil;
//
//        [self.focusImageView removeFromSuperview];
//        self.focusImageView = nil;
//    }
//
//    self.focusImageView.center = point;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.focusImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//    }];
//
//    _focusCursorTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(deleteFocusCursor:) userInfo:nil repeats:NO];
//    [[NSRunLoop mainRunLoop] addTimer:_focusCursorTimer forMode:NSRunLoopCommonModes];
//}
//
///**
// *  设置聚焦点
// *
// *  @param point 聚焦点
// */
//-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
//{
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//
//        if ([captureDevice isFocusModeSupported:focusMode]) {
//            [captureDevice setFocusMode:focusMode];
//        }
//        if ([captureDevice isFocusPointOfInterestSupported]) {
//            [captureDevice setFocusPointOfInterest:point];
//        }
//        if ([captureDevice isExposureModeSupported:exposureMode]) {
//            [captureDevice setExposureMode:exposureMode];
//        }
//        if ([captureDevice isExposurePointOfInterestSupported]) {
//            [captureDevice setExposurePointOfInterest:point];
//        }
//    }];
//}
//
/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(void (^)(AVCaptureDevice *captureDevice))propertyChange
{
    AVCaptureDevice * captureDevice = [self.videoCamera inputCamera];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        if (propertyChange) {
            propertyChange(captureDevice);
        }
        [captureDevice unlockForConfiguration];
    }else{
        [self.currentVC.view bk_showRemind:@"设置设备属性过程发生错误,请重试"];
    }
}
//
//#pragma mark - 聚焦框
//
//-(UIImageView*)focusImageView
//{
//    if (!_focusImageView) {
//        _focusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, BK_SCREENW/4, BK_SCREENW/4)];
//        _focusImageView.clipsToBounds = YES;
//        _focusImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _focusImageView.image = [UIImage bk_takePhotoImageWithImageName:@"takephoto_focus"];
//        [self.currentVC.view insertSubview:_focusImageView aboveSubview:_previewView];
//    }
//    return _focusImageView;
//}
//
//-(void)deleteFocusCursor:(NSTimer*)timer
//{
//    [self.focusImageView removeFromSuperview];
//    self.focusImageView = nil;
//}

@end
