//
//  UIImage+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "UIImage+BKExtension.h"

@implementation UIImage (BKExtension)

#pragma mark - 图片调整方向

/**
 调整图片为正常方向(iPhone照出的照片是倒着的)
 
 @return 调整后的图片
 */
-(UIImage*)editImageOrientation
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

#pragma mark - 图片压缩

/**
 图片压缩
 
 @return 压缩后的数据
 */
-(NSData*)compress
{
    if (!self) {
        return nil;
    }
    
    UIImage * compressImage = nil;
    
    if (self.size.width > self.size.height) {
        if (self.size.width < 1242) {
            compressImage = self;
        }else{
            compressImage = [self compressImage:self];
        }
    }else{
        if (self.size.height < 2208) {
            compressImage = self;
        }else{
            compressImage = [self compressImage:self];
        }
    }
    
    return UIImageJPEGRepresentation(compressImage, 0.7);
}

-(UIImage*)compressImage:(UIImage*)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float width = imageWidth*0.7;
    float height = imageHeight*0.7;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width , height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 图片合成

-(void)synthesisImage:(UIImage *)image withFrame:(CGRect)frame complete:(void (^)(UIImage*image))complete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(self.size,0, [UIScreen mainScreen].scale);
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        [image drawInRect:frame];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(resultingImage);
            });
        }
        UIGraphicsEndImageContext();
    });
}

#pragma mark - 图片切角

-(UIImage*)getCircleImage
{
    float length = 0;
    if (self.size.width > self.size.height) {
        length = self.size.height;
    }else{
        length = self.size.width;
    }
    
    CGRect rect = CGRectMake((self.size.width - length)/2.0f, (self.size.height - length)/2.0f, length, length);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect newBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(newBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, newBounds, subImageRef);
    UIImage* newImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return [newImage cutCircleImage];
}

-(UIImage*)cutCircleImage
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*)getRectCircleImage
{
    float length = 0;
    if (self.size.width > self.size.height) {
        length = self.size.height;
    }else{
        length = self.size.width;
    }
    
    CGRect rect = CGRectMake((self.size.width - length)/2.0f, (self.size.height - length)/2.0f, length, length);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect newBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(newBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, newBounds, subImageRef);
    UIImage* newImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return [newImage cutRectCircleImage];
}

-(UIImage*)cutRectCircleImage
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGFloat r = w/10;
    
    CGContextMoveToPoint(ctx, w-r, 0);
    CGContextAddArcToPoint(ctx, w, 0, w, r, r);
    CGContextAddArcToPoint(ctx, w, h, w-r, h, r);
    CGContextAddArcToPoint(ctx, 0, h, 0, h-r, r);
    CGContextAddArcToPoint(ctx, 0, 0, r, 0, r);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 重绘图片

-(UIImage *)reSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - 生成占位图

+(UIImage*)createPlaceholderImageWithSize:(CGSize)size
{
    UIImage * placeholderImage = [UIImage imageNamed:@""];
    
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    [kColor_EEEEEE set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (size.width > size.height) {
        height = size.height/3.0f;
        width = height;
    }else{
        width = size.width/3.0f;
        height = width;
    }
    
    CGRect rect = CGRectMake((size.width - width)/2.0f, (size.height - height)/2.0f, width, height);
    [placeholderImage drawInRect:rect];
    UIImage * new_placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return new_placeholderImage;
}

@end
