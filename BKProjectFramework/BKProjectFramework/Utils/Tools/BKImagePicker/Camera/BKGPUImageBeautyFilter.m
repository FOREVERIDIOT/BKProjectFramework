//
//  BKGPUImageBeautyFilter.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/27.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKGPUImageBeautyFilter.h"

@interface BKGPUImageBeautyFilter()

/**
 美颜滤镜
 */
@property (nonatomic,strong) FSKGPUImageBeautyFilter * beautyFilter;

/**
 饱和度
 */
@property (nonatomic,strong) GPUImageSaturationFilter * saturationFilter;

/**
 阴影和高光
 */
@property (nonatomic,strong) GPUImageHighlightShadowFilter * highlightShadowFilter;

@end

@implementation BKGPUImageBeautyFilter

#pragma mark - 美颜等级

-(void)setBeautyLevel:(BKBeautyLevel)beautyLevel
{
    _beautyLevel = beautyLevel;
    
    [self removeFilter];
   
    switch (_beautyLevel) {
        case BKBeautyLevelOne:
        {
            [self addFilter];
            self.beautyFilter.beautyLevel = 0.2;
        }
            break;
        case BKBeautyLevelTwo:
        {
            [self addFilter];
            self.beautyFilter.beautyLevel = 0.4;
        }
            break;
        case BKBeautyLevelThree:
        {
            [self addFilter];
            self.beautyFilter.beautyLevel = 0.6;
        }
            break;
        case BKBeautyLevelFour:
        {
            [self addFilter];
            self.beautyFilter.beautyLevel = 0.8;
        }
            break;
        case BKBeautyLevelFive:
        {
            [self addFilter];
            self.beautyFilter.beautyLevel = 1;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 滤镜

-(FSKGPUImageBeautyFilter*)beautyFilter
{
    if (!_beautyFilter) {
        _beautyFilter = [[FSKGPUImageBeautyFilter alloc] init];
        _beautyFilter.brightLevel = 0.5;
        _beautyFilter.toneLevel = 0.35;
    }
    return _beautyFilter;
}

-(GPUImageSaturationFilter *)saturationFilter
{
    if (!_saturationFilter) {
        _saturationFilter = [[GPUImageSaturationFilter alloc] init];
        _saturationFilter.saturation = 0.9;
    }
    return _saturationFilter;
}

-(GPUImageHighlightShadowFilter*)highlightShadowFilter
{
    if (!_highlightShadowFilter) {
        _highlightShadowFilter = [[GPUImageHighlightShadowFilter alloc] init];
        _highlightShadowFilter.shadows = 0;
        _highlightShadowFilter.highlights = 1;
    }
    return _highlightShadowFilter;
}

#pragma mark - 添加滤镜

-(void)addFilter
{
    [self addTarget:self.beautyFilter];
    [self addTarget:self.saturationFilter];
    [self addTarget:self.highlightShadowFilter];
    
    [self.beautyFilter addTarget:self.saturationFilter];
    [self.saturationFilter addTarget:self.highlightShadowFilter];
    
    self.initialFilters = @[self.beautyFilter];
    self.terminalFilter = self.highlightShadowFilter;
}

#pragma mark - 删除滤镜

-(void)removeFilter
{
    [self removeAllTargets];
    
    [self.beautyFilter removeAllTargets];
    [self.saturationFilter removeAllTargets];
    [self.highlightShadowFilter removeAllTargets];
    
    self.initialFilters = nil;
    self.terminalFilter = nil;
    
    self.beautyFilter = nil;
    self.saturationFilter = nil;
    self.highlightShadowFilter = nil;
}

@end
