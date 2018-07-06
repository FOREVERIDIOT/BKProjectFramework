//
//  BKNetworkUploadModel.h
//  MySelfFrame
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKNetworkUploadModel : NSObject

/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

//图片
+(BKNetworkUploadModel*)saveImageData:(NSData*)imageData name:(NSString*)name fileName:(NSString*)fileName;

//录音
+(BKNetworkUploadModel*)saveRecordData:(NSData*)recordData name:(NSString*)name fileName:(NSString*)fileName;

@end
