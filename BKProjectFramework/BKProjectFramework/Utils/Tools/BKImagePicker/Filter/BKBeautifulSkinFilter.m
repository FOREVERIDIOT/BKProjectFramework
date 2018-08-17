//
//  BKBeautifulSkinFilter.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/8/17.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKBeautifulSkinFilter.h"
#import "GPUImage.h"
#import "UIImage+BKImagePicker.h"

@interface BKBeautifulSkinFilter()

/**
 色彩映射滤镜
 */
@property (nonatomic,strong) GPUImageLookupFilter * lookupFilter;

@end

@implementation BKBeautifulSkinFilter

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        UIImage *image = [UIImage bk_filterImageWithImageName:@"filter_clean"];
        GPUImagePicture * imageSource = [[GPUImagePicture alloc] initWithImage:image];
        
        self.lookupFilter = [[GPUImageLookupFilter alloc] init];
        [self addFilter:self.lookupFilter];
        
        [imageSource addTarget:self.lookupFilter atTextureLocation:1];
        [imageSource processImage];
        
        self.initialFilters = @[self.lookupFilter];
        self.terminalFilter = self.lookupFilter;
        
    }
    return self;
}

@end
