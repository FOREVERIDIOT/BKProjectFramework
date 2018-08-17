//
//  BKCameraFilterView.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/8/8.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCameraFilterView.h"
#import "BKImagePickerMacro.h"
#import "UIView+BKImagePicker.h"

@interface BKCameraFilterView()

@property (nonatomic,strong) NSArray<NSString*> * menuArr;
@property (nonatomic,strong) UIScrollView * menuScrollView;
@property (nonatomic,strong) UIView * contentView;

@property (nonatomic,weak) UIButton * selectBtn;

@end

@implementation BKCameraFilterView

-(NSArray*)menuArr
{
    if (!_menuArr) {
        _menuArr = @[@"美颜"];
    }
    return _menuArr;
}

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BKCameraFilterBackgroundColor;
        self.alpha = 0;
        
        [self addSubview:self.menuScrollView];
        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - menuScrollView

-(UIScrollView*)menuScrollView
{
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bk_width, 60)];
        _menuScrollView.backgroundColor = BKClearColor;
        _menuScrollView.showsVerticalScrollIndicator = NO;
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _menuScrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        }
        
        CGFloat width = _menuScrollView.bk_width / 5.5;
        [self.menuArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel * menuLab = [[UILabel alloc] initWithFrame:CGRectMake(idx*width, 0, width, self.menuScrollView.bk_height)];
            menuLab.text = obj;
            menuLab.textAlignment = NSTextAlignmentCenter;
            menuLab.font = [UIFont systemFontOfSize:16];
            menuLab.textColor = BKCameraFilterTitleColor;
            [self.menuScrollView addSubview:menuLab];
        }];
    }
    return _menuScrollView;
}

#pragma mark - contentView

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuScrollView.frame), self.bk_width, self.bk_height - CGRectGetMaxY(self.menuScrollView.frame))];
        
        NSArray<NSString*> * levelArr = @[@"0",@"1",@"2",@"3",@"4",@"5"];
        CGFloat width = 45 * BK_SCREENW / 375.0f;
        CGFloat space = (_contentView.bk_width - width*6) / 7;
        [levelArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            levelBtn.frame = CGRectMake(space + (space + width) * idx, (self.contentView.bk_height - width) / 2 - 15, width, width);
            levelBtn.tag = idx;
            [levelBtn setTitle:obj forState:UIControlStateNormal];
            [levelBtn setTitleColor:BKCameraFilterTitleColor forState:UIControlStateNormal];
            [levelBtn setTitleColor:BKCameraFilterTitleColor forState:UIControlStateHighlighted];
            [levelBtn setTitleColor:BKCameraFilterTitleSelectColor forState:UIControlStateSelected];
            levelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [levelBtn setBackgroundColor:BKCameraFilterLevelBtnBackgroundColor];
            [levelBtn addTarget:self action:@selector(levelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            levelBtn.clipsToBounds = YES;
            levelBtn.layer.cornerRadius = levelBtn.bk_height/2;
            [self.contentView addSubview:levelBtn];
            if (idx == 0) {
                self.selectBtn = levelBtn;
                self.selectBtn.selected = YES;
            }
        }];
    }
    return _contentView;
}

-(void)levelBtnClick:(UIButton*)button
{
    self.selectBtn.userInteractionEnabled = YES;
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    self.selectBtn.selected = YES;
    self.selectBtn.userInteractionEnabled = NO;
    
    if (self.switchBeautyFilterLevelAction) {
        self.switchBeautyFilterLevelAction(button.tag);
    }
}

@end
