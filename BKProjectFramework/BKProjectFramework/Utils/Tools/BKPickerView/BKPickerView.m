//
//  BKPickerView.m
//  yanglao
//
//  Created by BIKE on 2017/3/30.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#define BK_PICKER_HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BK_PICKER_POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define BK_PICKER_ONE_PIXEL BK_PICKER_POINTS_FROM_PIXELS(1.0)

#define BK_PICKER_TOOLBAR_COLOR BK_PICKER_HEX_RGB(0xF6F6F6)
#define BK_PICKER_TOOLBAR_BUTTON_TITLE_COLOR BK_PICKER_HEX_RGB(0x1E86FF)
#define BK_PICKER_TOOLBAR_REMIND_TITLE_COLOR BK_PICKER_HEX_RGB(0x999999)
#define BK_PICKER_BACKGROUND_COLOR BK_PICKER_HEX_RGB(0xD1D5DB)
#define BK_PICKER_SELECTFRAME_COLOR BK_PICKER_HEX_RGB(0xA8ABB0)

/**
 判断是否是iPhone X系列
 */
NS_INLINE BOOL bk_picker_is_iPhoneX_series() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

float const kToolBarHeight = 50;
float const kPickerHeight = 230;
float const kRowHeight = 40;

#import "BKPickerView.h"

@interface BKPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,assign) BKPickerStyle pickerStyle;
@property (nonatomic,copy) NSString * remind;

@property (nonatomic,assign) CGFloat contentHeight;

@property (nonatomic,strong) UIView * shadowView;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * toolbar;
@property (nonatomic,strong) UIPickerView * defaultPicker;
@property (nonatomic,strong) UIDatePicker * datePicker;

@end

@implementation BKPickerView

#pragma mark - 内容高度

-(CGFloat)contentHeight
{
    if (_contentHeight == 0) {
        if (bk_picker_is_iPhoneX_series()) {//iPhoneX系列高度加10
            _contentHeight = kToolBarHeight + kPickerHeight + 10;
        }else {
            _contentHeight = kToolBarHeight + kPickerHeight;
        }
    }
    return _contentHeight;
}

#pragma mark - 创建方法

-(instancetype)initWithPickerStyle:(BKPickerStyle)pickerStyle remind:(NSString*)remind
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _pickerStyle = pickerStyle;
        _remind = remind;
        
        //如果不是时间选取器 创建失败
        NSAssert(_pickerStyle == BKPickerStyleDate || _pickerStyle == BKPickerStyleMDHMDate, @"此方法只创建时间选取器");
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.shadowView];
    }
    return self;
}

-(instancetype)initWithPickerDataArr:(NSArray *)dataArr remind:(NSString *)remind
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _dataArr = dataArr;
        _remind = remind;
        
        __block Class contentClass = nil;
        [_dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class nextContentClass = [obj class];
            if (!contentClass) {
                contentClass = nextContentClass;
            }else {
                NSAssert([contentClass isSubclassOfClass:nextContentClass], @"初始化选取器数据数组中元素格式不统一");
            }
        }];
        
        if ([contentClass isSubclassOfClass:[NSString class]]) {
            _pickerStyle = BKPickerStyleSingle;
        }else if ([contentClass isSubclassOfClass:[NSArray class]]) {
            _pickerStyle = BKPickerStyleMultilevelLinkage;
        }
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.shadowView];
    }
    return self;
}

#pragma mark - 阴影

-(UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:self.bounds];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.6;
        
        UITapGestureRecognizer * shadowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowTap)];
        [_shadowView addGestureRecognizer:shadowTap];
    }
    return _shadowView;
}

-(void)shadowTap
{
    [self cancelBtnClick];
}

#pragma mark - 内容

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.contentHeight)];
        _contentView.backgroundColor = BK_PICKER_BACKGROUND_COLOR;
        
        [_contentView addSubview:self.toolbar];
    }
    return _contentView;
}

#pragma mark - 工具栏

-(UIView *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, kToolBarHeight)];
        _toolbar.backgroundColor = BK_PICKER_TOOLBAR_COLOR;
        
        UIButton * cancelBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(0, 0, 64, _toolbar.frame.size.height);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:BK_PICKER_TOOLBAR_BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:cancelBtn];
        
        UIButton * button  = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(_toolbar.frame.size.width-64, 0, 64, _toolbar.frame.size.height);
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:BK_PICKER_TOOLBAR_BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(pickerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:button];
        
        UILabel * remindLab = [[UILabel alloc]initWithFrame:CGRectMake(64, 0, _toolbar.frame.size.width - 64*2, _toolbar.frame.size.height)];
        remindLab.text = _remind;
        remindLab.textColor = BK_PICKER_TOOLBAR_REMIND_TITLE_COLOR;
        remindLab.font = [UIFont systemFontOfSize:15];
        remindLab.textAlignment = NSTextAlignmentCenter;
        [_toolbar addSubview:remindLab];
    }
    return _toolbar;
}

-(void)cancelBtnClick
{
    [self hiddenComplete:^{
        [self removeFromSuperview];
    }];
}

-(void)pickerBtnClick
{
    switch (self.pickerStyle) {
        case BKPickerStyleSingle:
        {
            if ([self.dataArr count] == 0) {
                return;
            }
            
            if (self.confirmSelectCallback) {
                self.confirmSelectCallback(self.selectIndex);
            }
        }
            break;
        case BKPickerStyleMultilevelLinkage:
        {
            if ([self.dataArr count] == 0) {
                return;
            }
            
            if (self.confirmSelectIndexsCallback) {
                self.confirmSelectIndexsCallback(self.selectIndexArr);
            }
        }
            break;
        case BKPickerStyleDate:
        case BKPickerStyleMDHMDate:
        {
            NSDate * selectDate = self.datePicker.date;
            
            if (self.confirmSelectDateCallback) {
                self.confirmSelectDateCallback(selectDate);
            }
        }
            break;
        default:
            break;
    }
    
    [self cancelBtnClick];
}

#pragma mark - 隐藏/显示

-(void)showInView:(UIView *)supperView
{
    if (!self.userInteractionEnabled) {
        return;
    }
    self.userInteractionEnabled = NO;
    
    [supperView addSubview:self];
    [self addSubview:self.contentView];
    
    switch (self.pickerStyle) {
        case BKPickerStyleSingle:
        case BKPickerStyleMultilevelLinkage:
        {
            [self.contentView addSubview:self.defaultPicker];
            [self resetDefaultPickerSelectFrame];
        }
            break;
        case BKPickerStyleDate:
        case BKPickerStyleMDHMDate:
        {
            [self.contentView addSubview:self.datePicker];
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = self.frame.size.height - self.contentHeight;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

-(void)hiddenComplete:(void (^)(void))complete
{
    if (!self.userInteractionEnabled) {
        return;
    }
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = self.frame.size.height;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        if (complete) {
            complete();
        }
    }];
}

#pragma mark - DefaultPicker

-(UIPickerView *)defaultPicker
{
    if (!_defaultPicker) {
        
        _defaultPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kToolBarHeight, self.frame.size.width, kPickerHeight)];
        _defaultPicker.delegate = self;
        _defaultPicker.dataSource = self;
        _defaultPicker.backgroundColor = BK_PICKER_BACKGROUND_COLOR;
        
        [self editSelectIndexMethod];
    }
    return _defaultPicker;
}

-(void)editSelectIndexMethod
{
    if (self.pickerStyle == BKPickerStyleSingle) {
        NSInteger selectIndex = self.selectIndex;
        NSInteger maxIndex = [self.dataArr count] - 1;
        if (self.selectIndex > maxIndex) {
            selectIndex = maxIndex;
        }
        [self.defaultPicker selectRow:selectIndex inComponent:0 animated:NO];
    }else if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
        [self.selectIndexArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray * currentIndexDataArr = self.dataArr[idx];
            NSInteger selectIndex = [obj integerValue];
            NSInteger maxIndex = [currentIndexDataArr count] - 1;
            if (selectIndex > maxIndex) {
                selectIndex = maxIndex;
            }
            [self.defaultPicker selectRow:selectIndex inComponent:idx animated:NO];
        }];
    }
    [self.defaultPicker reloadAllComponents];
}

-(void)resetDefaultPickerSelectFrame
{
    UIImageView * upLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.defaultPicker.frame.size.width, BK_PICKER_ONE_PIXEL)];
    upLine.centerY = self.defaultPicker.centerY - kRowHeight/2 - BK_PICKER_ONE_PIXEL;
    upLine.backgroundColor = BK_PICKER_SELECTFRAME_COLOR;
    [self.contentView addSubview:upLine];
    
    UIImageView * bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.defaultPicker.frame.size.width, BK_PICKER_ONE_PIXEL)];
    bottomLine.centerY = self.defaultPicker.centerY + kRowHeight/2 + BK_PICKER_ONE_PIXEL;
    bottomLine.backgroundColor = BK_PICKER_SELECTFRAME_COLOR;
    [self.contentView addSubview:bottomLine];
}

#pragma mark - DatePicker

-(UIDatePicker*)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolBarHeight, self.frame.size.width, kPickerHeight)];
        if (_pickerStyle == BKPickerStyleMDHMDate) {
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        }else if (_pickerStyle == BKPickerStyleDate){
            _datePicker.datePickerMode = UIDatePickerModeDate;
        }
        
        _datePicker.backgroundColor= BK_PICKER_BACKGROUND_COLOR;
        if (_maxDate) {
            _datePicker.maximumDate = _maxDate;
        }
        if (_minDate) {
            _datePicker.minimumDate = _minDate;
        }
        if (_selectDate) {
            _datePicker.date = _selectDate;
        }
    }
    return _datePicker;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
        return [self.dataArr count];
    }else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
        return [self.dataArr[component] count];
    }else {
        return [self.dataArr count];
    }
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    for (UIView * singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    
    UILabel * tittleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kRowHeight)];
    tittleLab.font = [UIFont systemFontOfSize:16];
    tittleLab.textColor = [UIColor blackColor];
    tittleLab.textAlignment = NSTextAlignmentCenter;
    
    if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
        tittleLab.text = self.dataArr[component][row];
    }else{
        tittleLab.text = self.dataArr[row];
    }
    
    return tittleLab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == BKPickerStyleSingle) {
        self.selectIndex = row;
    }else if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
        NSMutableArray * selectIndexArr = [self.selectIndexArr mutableCopy];
        [selectIndexArr replaceObjectAtIndex:component withObject:@(row)];
        
        if (self.changeSelectIndexsCallback) {
            _dataArr = [self.changeSelectIndexsCallback(selectIndexArr) copy];
            [selectIndexArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger index = [obj integerValue];
                NSInteger max_index = [self->_dataArr[idx] count] - 1;
                if (index > max_index) {
                    [selectIndexArr replaceObjectAtIndex:idx withObject:@(max_index)];
                }
            }];
        }
        self.selectIndexArr = [selectIndexArr copy];
        [self.defaultPicker reloadAllComponents];
    }
}

@end
