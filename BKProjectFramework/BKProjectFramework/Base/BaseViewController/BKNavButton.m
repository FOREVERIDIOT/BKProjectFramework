//
//  BKNavButton.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKNavButton.h"

@interface BKNavButton()

/**
 图片
 */
@property (nonatomic,strong) UIImage * image;
/**
 图片内边距
 */
@property (nonatomic,assign) UIEdgeInsets imageInsets;
/**
 标题
 */
@property (nonatomic,copy) NSString * title;
/**
 标题大小
 */
@property (nonatomic,strong) UIFont * font;
/**
 标题颜色
 */
@property (nonatomic,strong) UIColor * titleColor;
/**
 标题内边距
 */
@property (nonatomic,assign) UIEdgeInsets titleInsets;

@end

@implementation BKNavButton

#pragma mark - 图片init

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageInsets:(UIEdgeInsets)imageInsets
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        _imageInsets = imageInsets;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 标题init

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor titleInsets:(UIEdgeInsets)titleInsets
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _font = font;
        _titleColor = titleColor;
        _titleInsets = titleInsets;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 图片&标题init

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageInsets:(UIEdgeInsets)imageInsets title:(NSString*)title titleInsets:(UIEdgeInsets)titleInsets
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        _imageInsets = imageInsets;
        _title = title;
        _titleInsets = titleInsets;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageInsets:(UIEdgeInsets)imageInsets title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor titleInsets:(UIEdgeInsets)titleInsets
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        _imageInsets = imageInsets;
        _title = title;
        _font = font;
        _titleColor = titleColor;
        _titleInsets = titleInsets;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 初始化数据

-(void)setupData
{
    self.backgroundColor = [UIColor clearColor];
    
    if (_image) {
        if (UIEdgeInsetsEqualToEdgeInsets(_imageInsets, UIEdgeInsetsZero)) {
            self.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        }
    }
    
    if (_title) {
        if (!_font) {
            self.font = [UIFont systemFontOfSize:16];
        }
        if (!_titleColor) {
            self.titleColor = kColor_333333;
        }
        if (UIEdgeInsetsEqualToEdgeInsets(_titleInsets, UIEdgeInsetsZero)) {
            self.titleInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        }
    }
    
    [self setNeedsDisplay];
}

#pragma mark - drawRect

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_image && [_title length] == 0) {
        CGRect imageRect = CGRectMake(_imageInsets.left,
                                      _imageInsets.top,
                                      self.bounds.size.width - _imageInsets.left - _imageInsets.right,
                                      self.bounds.size.height - _imageInsets.top - _imageInsets.bottom);
        [_image drawInRect:imageRect];
    }else if (!_image && [_title length] != 0) {
        CGRect titleRect = CGRectMake(_titleInsets.left,
                                      _titleInsets.top,
                                      self.bounds.size.width - _titleInsets.left - _titleInsets.right,
                                      self.bounds.size.height - _titleInsets.top - _titleInsets.bottom);

        NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSAttributedString * titleStr = [[NSAttributedString alloc] initWithString:_title attributes:@{NSFontAttributeName:_font,
                         NSForegroundColorAttributeName:_titleColor,
                         NSParagraphStyleAttributeName:paragraphStyle}];
        
        titleRect.size.height = [[BKShareManager sharedManager] heightSizeFromAttrString:titleStr width:titleRect.size.width];
        titleRect.origin.y = (self.frame.size.height - titleRect.size.height)/2;
        
        [titleStr drawInRect:titleRect];
    }else if (_image && [_title length] > 0) {
        
    }
}

@end
