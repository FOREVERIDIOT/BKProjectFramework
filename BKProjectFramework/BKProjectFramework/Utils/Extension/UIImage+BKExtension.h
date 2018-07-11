//
//  UIImage+BKExtension.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BKExtension)

#pragma mark - 图片调整方向

/**
 调整图片为正常方向(iPhone照出的照片是倒着的)
 
 @return 调整后的图片
 */
-(UIImage*)editImageOrientation;

#pragma mark - 图片压缩

/**
 图片压缩
 
 @return 压缩后的数据
 */
-(NSData*)compress;

#pragma mark - 图片合成

/**
 图片合成
 
 @param image 所需合成的图片
 @param frame 合成图片的frame
 @param complete 合成完后的图片
 */
-(void)synthesisImage:(UIImage *)image withFrame:(CGRect)frame complete:(void (^)(UIImage*image))complete;

#pragma mark - 图片切角

/**
 获取圆形图片
 
 @return 圆形图片
 */
-(UIImage*)getCircleImage;

/**
 获取圆角矩形图片
 
 @return 圆形图片
 */
-(UIImage*)getRectCircleImage;

#pragma mark - 重绘图片

/**
 从新设定图片大小
 
 @param reSize 新大小
 @return 新图片
 */
-(UIImage *)reSize:(CGSize)reSize;

#pragma mark - 生成占位图

/**
 生成占位图图片
 
 @param size 大小
 @return 站位图图片
 */
+(UIImage*)createPlaceholderImageWithSize:(CGSize)size;

@end
