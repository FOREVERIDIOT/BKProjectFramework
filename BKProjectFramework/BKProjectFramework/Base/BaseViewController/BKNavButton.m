//
//  BKNavButton.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/12.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKNavButton.h"

float const kImageInsets = 4;//图片内边距只有图片时不算
float const kTitleInsets = 8;//文本内边距

@interface BKNavButton()

/**
 图片
 */
@property (nonatomic,strong) UIImage * image;
/**
 图片大小
 */
@property (nonatomic,assign) CGSize imageSize;
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
 图片位置
 */
@property (nonatomic,assign) BKImagePosition imagePosition;

/**
 图片Rect
 */
@property (nonatomic,assign) CGRect imageRect;
/**
 标题Rect
 */
@property (nonatomic,assign) CGRect titleRect;
/**
 富文本标题
 */
@property (nonatomic,strong) NSAttributedString * titleStr;

@end

@implementation BKNavButton

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        [self setupData];
    }
    return self;
}

#pragma mark - 图片init

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _image = image;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 标题init

-(instancetype)initWithTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _title = title;
        _font = font;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title titleColor:(UIColor*)titleColor
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _title = title;
        _titleColor = titleColor;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _title = title;
        _font = font;
        _titleColor = titleColor;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 图片&标题init

-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _image = image;
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title imagePosition:(BKImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _image = image;
        _title = title;
        _imagePosition = imagePosition;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title imagePosition:(BKImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        _title = title;
        _imagePosition = imagePosition;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor imagePosition:(BKImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, SYSTEM_STATUSBAR_HEIGHT, SYSTEM_NAV_UI_HEIGHT, SYSTEM_NAV_UI_HEIGHT)];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        _title = title;
        _font = font;
        _titleColor = titleColor;
        _imagePosition = imagePosition;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 点击手势

-(void)selfTapGestureRecognizer
{
    if (self.clickMethod) {
        self.clickMethod(self);
    }
}

#pragma mark - 初始化数据

-(void)setupData
{
    self.backgroundColor = [UIColor clearColor];
    
    if (!_titleColor) {
        self.titleColor = kColor_333333;
    }
    
    [self setupRect];
    
    UITapGestureRecognizer * selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapGestureRecognizer)];
    [self addGestureRecognizer:selfTap];
    
    [self setNeedsDisplay];
}

/**
 初始化Rect
 */
-(void)setupRect
{
    if (_image && [_title length] == 0) {
        
        if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
            _imageSize = CGSizeMake(23, 23);
        }
        
        _imageRect = CGRectMake((self.width - _imageSize.width)/2,
                                (self.height - _imageSize.height)/2,
                                _imageSize.width,
                                _imageSize.height);;
        
    }else if (!_image && [_title length] != 0) {
        
        if (!_font) {
            _font = [UIFont systemFontOfSize:15];
        }
        
        _titleStr = [self setupTitleStr];
        
        _titleRect.size.height = [[BKShareManager sharedManager] heightSizeFromAttrString:_titleStr width:FLT_MAX];
        _titleRect.origin.y = (self.frame.size.height - _titleRect.size.height)/2;
        _titleRect.origin.x = kTitleInsets;
        _titleRect.size.width = [[BKShareManager sharedManager] widthSizeFromAttrString:_titleStr height:_titleRect.size.height];
        if (_titleRect.size.width + kTitleInsets * 2 < self.width) {
            _titleRect.origin.x = (self.width - _titleRect.size.width)/2;
        }else{
            self.width = _titleRect.size.width + kTitleInsets * 2;
        }
        
    }else if (_image && [_title length] > 0) {
        
        switch (_imagePosition) {
            case BKImagePositionLeft:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(23, 23);
                }
                if (!_font) {
                    _font = [UIFont systemFontOfSize:14];
                }
                _titleStr = [self setupTitleStr];
                CGFloat titleHeight = [[BKShareManager sharedManager] heightSizeFromAttrString:_titleStr width:FLT_MAX];
                
                _imageRect = CGRectMake(kImageInsets,
                                        (self.height - _imageSize.height)/2,
                                        _imageSize.width,
                                        _imageSize.height);
                
                _titleRect.size.height = titleHeight;
                _titleRect.origin.y = (self.frame.size.height - _titleRect.size.height)/2;
                _titleRect.size.width = [[BKShareManager sharedManager] widthSizeFromAttrString:_titleStr height:_titleRect.size.height];
                _titleRect.origin.x = CGRectGetMaxX(_imageRect);
                
                self.width = CGRectGetMaxX(_titleRect) + kTitleInsets;
            }
                break;
            case BKImagePositionTop:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(20, 20);
                }
                if (!_font) {
                    _font = [UIFont systemFontOfSize:13];
                }
                _titleStr = [self setupTitleStr];
                CGFloat titleHeight = [[BKShareManager sharedManager] heightSizeFromAttrString:_titleStr width:FLT_MAX];
                
                _imageRect = CGRectMake((self.width - _imageSize.width)/2,
                                        0,
                                        _imageSize.width,
                                        _imageSize.height);
                
                _titleRect.size.height = self.height - CGRectGetMaxY(_imageRect);
                if (_titleRect.size.height > titleHeight) {
                    _titleRect.size.height = titleHeight;
                    _imageRect.origin.y = (self.height - _imageSize.height - titleHeight)/2;
                }
                _titleRect.origin.y = CGRectGetMaxY(_imageRect);
                _titleRect.origin.x = 0;
                _titleRect.size.width = self.width;
            }
                break;
            case BKImagePositionRight:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(23, 23);
                }
                if (!_font) {
                    _font = [UIFont systemFontOfSize:14];
                }
                _titleStr = [self setupTitleStr];
                CGFloat titleHeight = [[BKShareManager sharedManager] heightSizeFromAttrString:_titleStr width:FLT_MAX];
                
                _titleRect.size.height = titleHeight;
                _titleRect.origin.y = (self.frame.size.height - _titleRect.size.height)/2;
                _titleRect.size.width = [[BKShareManager sharedManager] widthSizeFromAttrString:_titleStr height:_titleRect.size.height];
                _titleRect.origin.x = kTitleInsets;
                
                _imageRect = CGRectMake(CGRectGetMaxX(_titleRect),
                                        (self.height - _imageSize.height)/2,
                                        _imageSize.width,
                                        _imageSize.height);
                
                self.width = CGRectGetMaxX(_imageRect) + kImageInsets;
            }
                break;
            case BKImagePositionBottom:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(20, 20);
                }
                if (!_font) {
                    _font = [UIFont systemFontOfSize:13];
                }
                _titleStr = [self setupTitleStr];
                CGFloat titleHeight = [[BKShareManager sharedManager] heightSizeFromAttrString:_titleStr width:FLT_MAX];
                
                _titleRect.size.height = self.height - _imageSize.height;
                if (_titleRect.size.height > titleHeight) {
                    _titleRect.size.height = titleHeight;
                    _titleRect.origin.y = (self.height - _imageSize.height - titleHeight)/2;
                }else{
                    _titleRect.origin.y = 0;
                }
                _titleRect.origin.x = 0;
                _titleRect.size.width = self.width;
                
                _imageRect = CGRectMake((self.width - _imageSize.width)/2,
                                        CGRectGetMaxY(_titleRect),
                                        _imageSize.width,
                                        _imageSize.height);
            }
                break;
            default:
                break;
        }
    }
}

/**
 设置文本
 
 @return 文本
 */
-(NSAttributedString*)setupTitleStr
{
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString * titleStr = [[NSAttributedString alloc] initWithString:_title attributes:@{NSFontAttributeName:_font,
                     NSForegroundColorAttributeName:_titleColor,
                     NSParagraphStyleAttributeName:paragraphStyle}];
    
    return titleStr;
}

#pragma mark - drawRect

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_image && [_title length] == 0) {
        [_image drawInRect:_imageRect];
    }else if (!_image && [_title length] != 0) {
        [_titleStr drawInRect:_titleRect];
    }else if (_image && [_title length] > 0) {
        [_image drawInRect:_imageRect];
        [_titleStr drawInRect:_titleRect];
    }
}

@end
