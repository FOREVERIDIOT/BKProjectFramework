//
//  BKPickerView.h
//  yanglao
//
//  Created by BIKE on 2017/3/30.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKPickerStyle) {
    BKPickerStyleSingle = 0,         //单选
    BKPickerStyleMultilevelLinkage,  //多级联动
    BKPickerStyleDate,               //选取时间格式YYYY MM dd
    BKPickerStyleMDHMDate            //选取时间格式MM月dd日 EEEE HH mm
};

@interface BKPickerView : UIView

#pragma mark - 创建方法

/**
 创建方法(时间格式)

 @param pickerStyle 选取器格式
 @param remind 选取器提示
 @return 选取器
 */
-(instancetype)initWithPickerStyle:(BKPickerStyle)pickerStyle remind:(NSString*)remind;

/**
 创建方法(不是时间格式)

 @param dataArr 数据
 当传一维数组时 例子@[@"",@"",@""] BKPickerStyle == BKPickerStyleSingle
 当传二维数组时 例子@[@[@"",@"",@""], @[@"",@"",@""], @[@"",@"",@""]] BKPickerStyle == BKPickerStyleMultilevelLinkage
 @param remind 选取器提示
 @return 选取器
 */
-(instancetype)initWithPickerDataArr:(NSArray*)dataArr remind:(NSString*)remind;

#pragma mark - 显示方法

/**
 显示方法

 @param supperView 父视图
 */
-(void)showInView:(UIView*)supperView;

#pragma mark - Default

/**
 显示数据
 */
@property (nonatomic,copy,readonly) NSArray * dataArr;

#pragma mark - Default - BKPickerStyleSingle

/**
 当前选取索引
 当BKPickerStyle == BKPickerStyleSingle时有效
 */
@property (nonatomic,assign) NSInteger selectIndex;
/**
 完成选择返回索引回调
 当BKPickerStyle == BKPickerStyleSingle时有效
 */
@property (nonatomic,copy) void (^confirmSelectCallback)(NSInteger selectIndex);

#pragma mark - Default - BKPickerStyleMultilevelLinkage

/**
 当前选取索引数组 传一维数组 例子@[@(),@(),@()]
 当BKPickerStyle == BKPickerStyleMultilevelLinkage时有效
 */
@property (nonatomic,copy) NSArray<NSNumber*> * selectIndexArr;
/**
 切换选择返回索引数组回调 用于修改数据源 返回一维数组 例子@[@(),@(),@()]
 提示 修改了当前滑动component的index 大于当前component后的index置为0
 当BKPickerStyle == BKPickerStyleMultilevelLinkage时有效
 */
@property (nonatomic,copy) NSArray * (^changeSelectIndexsCallback)(NSArray<NSNumber*> * selectIndexArr);
/**
 完成选择返回索引数组回调 返回一维数组 例子@[@(),@(),@()]
 当BKPickerStyle == BKPickerStyleMultilevelLinkage时有效
 */
@property (nonatomic,copy) void (^confirmSelectIndexsCallback)(NSArray<NSNumber*> * selectIndexArr);

#pragma mark - Date

/**
 最大选取日期
 */
@property (nonatomic,strong) NSDate * maxDate;
/**
 最小选取日期
 */
@property (nonatomic,strong) NSDate * minDate;
/**
 当前选取日期
 */
@property (nonatomic,strong) NSDate * selectDate;
/**
 确认选取时间返回
 */
@property (nonatomic,copy) void (^confirmSelectDateCallback)(NSDate * date);




@end
