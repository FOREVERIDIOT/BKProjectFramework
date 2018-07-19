//
//  UIImage+BKImagePicker.m
//  BKImagePicker
//
//  Created by BIKE on 2017/6/23.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import "UIImage+BKImagePicker.h"

@implementation UIImage (BKImagePicker)

#pragma mark - 调整图片方向

-(UIImage*)bk_editImageOrientation
{
    if ([self isKindOfClass:[UIImage class]]) {
        
        UIImage* tmpImage = self;
        UIImage* contextedImage;
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        if (tmpImage.imageOrientation == UIImageOrientationUp) {
            contextedImage = tmpImage;
            return contextedImage;
        } else {
            
            switch (tmpImage.imageOrientation) {
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.width, tmpImage.size.height);
                    transform = CGAffineTransformRotate(transform, M_PI);
                }
                    break;
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.width, 0);
                    transform = CGAffineTransformRotate(transform, M_PI_2);
                }
                    break;
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, 0,tmpImage.size.height);
                    transform = CGAffineTransformRotate(transform, -M_PI_2);
                }
                    break;
                default:
                    break;
            }
            
            switch (tmpImage.imageOrientation) {
                case UIImageOrientationUpMirrored:
                case UIImageOrientationDownMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.width, 0);
                    transform = CGAffineTransformScale(transform, -1, 1);
                }
                    break;
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRightMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.height, 0);
                    transform = CGAffineTransformScale(transform, -1, 1);
                }
                    break;
                default:
                    break;
            }
            
            CGContextRef ctx = CGBitmapContextCreate(NULL, tmpImage.size.width, tmpImage.size.height, CGImageGetBitsPerComponent(tmpImage.CGImage), 0, CGImageGetColorSpace(tmpImage.CGImage), CGImageGetBitmapInfo(tmpImage.CGImage));
            CGContextConcatCTM(ctx, transform);
            
            switch (tmpImage.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                {
                    CGContextDrawImage(ctx, CGRectMake(0, 0, tmpImage.size.height,tmpImage.size.width), tmpImage.CGImage);
                }
                    break;
                default:
                {
                    CGContextDrawImage(ctx, CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height), tmpImage.CGImage);
                }
                    break;
            }
            
            CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
            contextedImage = [UIImage imageWithCGImage:cgimg];
            CGContextRelease(ctx);
            CGImageRelease(cgimg);
            
            return contextedImage;
        }
    }else{
        return nil;
    }
}

#pragma mark - 图片资源

+(NSString*)bk_getImageResourcePath
{
    NSString * imageBundlePath = [[NSBundle mainBundle] pathForResource:@"BKImage" ofType:@"bundle"];
    NSString * imagePath = [NSString stringWithFormat:@"%@",imageBundlePath];
    return imagePath;
}

/**
 基础模块图片
 
 @param imageName 图片名称
 @return 图片
 */
+(UIImage*)bk_imageWithImageName:(NSString*)imageName
{
    NSString * imagePath = [self bk_getImageResourcePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",imagePath,imageName]];
}

/**
 编辑模块图片
 
 @param imageName 图片名称
 @return 图片
 */
+(UIImage*)bk_editImageWithImageName:(NSString*)imageName
{
    NSString * imagePath = [self bk_getImageResourcePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/EditImage/%@",imagePath,imageName]];
}

/**
 拍照模块图片
 
 @param imageName 图片名称
 @return 图片
 */
+(UIImage*)bk_takePhotoImageWithImageName:(NSString*)imageName
{
    NSString * imagePath = [self bk_getImageResourcePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/TakePhoto/%@",imagePath,imageName]];
}


@end
