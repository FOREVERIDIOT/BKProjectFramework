//
//  UIImageView+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "UIImageView+BKExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (BKExtension)

#pragma mark - 虚线

/**
 添加虚线
 
 @param color 虚线颜色
 */
-(void)addDottedLineImageWithColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.frame.size.height);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {3, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    CGContextStrokePath(context);
    UIImage * dottedLine = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = dottedLine;
}

#pragma mark - 加载图片

-(void)setThumbImageWithURL:(NSString*)imageUrl
{
    [self setThumbImageWithURL:imageUrl placeholderImage:nil];
}

-(void)setThumbImageWithURL:(NSString*)imageUrl complete:(void (^)(UIImage * image, NSURL * imageURL))complete
{
    [self setThumbImageWithURL:imageUrl placeholderImage:nil complete:^(UIImage *image, NSURL *imageURL) {
        if (complete) {
            complete(image,imageURL);
        }
    }];
}

-(void)setThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage
{
    [self setThumbImageWithURL:imageUrl placeholderImage:placeholderImage complete:nil];
}

-(void)setThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage complete:(void (^)(UIImage * image, NSURL * imageURL))complete
{
    if (!imageUrl) {
        return;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:[self jointImageUrl:imageUrl]] placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (complete) {
            complete(image,imageURL);
        }
    }];
}

-(void)setCircleThumbImageWithURL:(NSString*)imageUrl
{
    [self setCircleThumbImageWithURL:imageUrl placeholderImage:DEFAULT_USER_HEADER];
}

-(void)setCircleThumbImageWithURL:(NSString*)imageUrl complete:(void (^)(UIImage * image, NSURL * imageURL))complete
{
    [self setCircleThumbImageWithURL:imageUrl placeholderImage:DEFAULT_USER_HEADER complete:^(UIImage *image, NSURL *imageURL) {
        if (complete) {
            complete(image,imageURL);
        }
    }];
}

-(void)setCircleThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage
{
    [self setCircleThumbImageWithURL:imageUrl placeholderImage:placeholderImage complete:nil];
}

-(void)setCircleThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage complete:(void (^)(UIImage * image, NSURL * imageURL))complete
{
    if (!imageUrl) {
        return;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:[self jointImageUrl:imageUrl]] placeholderImage:[placeholderImage getCircleImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image) {
            image = [image getCircleImage];
            self.image = image;
        }
        
        if (complete) {
            complete(image,imageURL);
        }
    }];
}

-(void)setOriginalImageWithUrl:(NSString*)imageUrl
{
    [self setOriginalImageWithUrl:imageUrl placeholderImage:nil];
}

-(void)setOriginalImageWithUrl:(NSString*)imageUrl complete:(void (^)(UIImage * image, NSURL * imageURL))complete
{
    [self setOriginalImageWithUrl:imageUrl placeholderImage:nil complete:^(UIImage *image, NSURL *imageURL) {
        if (complete) {
            complete(image,imageURL);
        }
    }];
}

-(void)setOriginalImageWithUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage
{
    [self setOriginalImageWithUrl:imageUrl placeholderImage:placeholderImage complete:nil];
}

-(void)setOriginalImageWithUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage complete:(void (^)(UIImage * image, NSURL * imageURL))complete
{
    if (!imageUrl) {
        return;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (complete) {
            complete(image,imageURL);
        }
    }];
}

#pragma mark - 拼接imageUrl

-(NSString*)jointImageUrl:(NSString*)imageUrl
{
//    if (self.width <= 50) {
//        return [NSString stringWithFormat:@"%@?imageView2/2/w/100&sign=%@",imageUrl,IMAGE_CLOUD_SIGN];
//    }else if (self.width > 50 && self.width <= 200) {
//        return [NSString stringWithFormat:@"%@?imageView2/2/w/400&sign=%@",imageUrl,IMAGE_CLOUD_SIGN];
//    }else {
//        return [NSString stringWithFormat:@"%@?imageView2/2/w/750&sign=%@",imageUrl,IMAGE_CLOUD_SIGN];
//    }
    
    return imageUrl;
}

@end
