//
//  UIImageView+BKExtension.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BKExtension)

#pragma mark - 虚线

/**
 添加虚线
 
 @param color 虚线颜色
 */
-(void)addDottedLineImageWithColor:(UIColor*)color;

#pragma mark - 加载图片

-(void)setThumbImageWithURL:(NSString*)imageUrl;
-(void)setThumbImageWithURL:(NSString*)imageUrl complete:(void (^)(UIImage * image, NSURL * imageURL))complete;
-(void)setThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage;
-(void)setThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage complete:(void (^)(UIImage * image, NSURL * imageURL))complete;

-(void)setCircleThumbImageWithURL:(NSString*)imageUrl;
-(void)setCircleThumbImageWithURL:(NSString*)imageUrl complete:(void (^)(UIImage * image, NSURL * imageURL))complete;
-(void)setCircleThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage;
-(void)setCircleThumbImageWithURL:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage complete:(void (^)(UIImage * image, NSURL * imageURL))complete;

-(void)setOriginalImageWithUrl:(NSString*)imageUrl;
-(void)setOriginalImageWithUrl:(NSString*)imageUrl complete:(void (^)(UIImage * image, NSURL * imageURL))complete;
-(void)setOriginalImageWithUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage;
-(void)setOriginalImageWithUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage complete:(void (^)(UIImage * image, NSURL * imageURL))complete;

@end
