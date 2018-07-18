//
//  BKNetworkUploadModel.m
//  MySelfFrame
//
//  Created by BIKE on 2018/7/5.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import "BKNetworkUploadModel.h"

@implementation BKNetworkUploadModel

+(BKNetworkUploadModel*)saveImageData:(NSData*)imageData name:(NSString*)name fileName:(NSString*)fileName
{
    //模型存储
    BKNetworkUploadModel * model = [[BKNetworkUploadModel alloc]init];
    model.name = name;
    model.data = imageData;
    model.filename = fileName;
    model.mimeType = @"image/jpeg";
    
    return model;
}

+(BKNetworkUploadModel*)saveRecordData:(NSData*)recordData name:(NSString*)name fileName:(NSString*)fileName
{
    //模型存储
    BKNetworkUploadModel * model = [[BKNetworkUploadModel alloc]init];
    model.name = name;
    model.data = recordData;
    model.filename = fileName;
    model.mimeType = @"record/aac";
    
    return model;
}

@end
