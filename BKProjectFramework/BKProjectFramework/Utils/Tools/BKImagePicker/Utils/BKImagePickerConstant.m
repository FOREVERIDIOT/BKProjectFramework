//
//  BKImagePickerConstant.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/19.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const BKFinishTakePhotoNotification = @"BKFinishTakePhotoNotification";//拍照完成通知
NSString * const BKFinishRecordVideoNotification = @"BKFinishRecordVideoNotification";//拍视频完成通知
NSString * const BKFinishSelectImageNotification = @"BKFinishSelectImageNotification";//选择完成通知

NSString * const BKRecordVideoMaxTimeRemind = @"录制时间已达上限";//录制到最大时间提示

float const BKAlbumImagesSpacing = 1;//相簿图片间距
float const BKExampleImagesSpacing = 10;//查看的大图图片间距
float const BKCheckExampleImageAnimateTime = 0.5;//查看大图图片过场动画时间
float const BKCheckExampleGifAndVideoAnimateTime = 0.3;//查看Gif、Video过场动画时间
float const BKThumbImageCompressSizeMultiplier = 0.5;//图片长宽压缩比例 (小于1会把图片的长宽缩小)
float const BKRecordVideoMaxTime = 10;//录制视频最大时长
