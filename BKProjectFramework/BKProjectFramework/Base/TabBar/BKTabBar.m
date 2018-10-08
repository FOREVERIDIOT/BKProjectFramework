//
//  BKTabBar.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKTabBar.h"

@interface BKTabBar()

@property (nonatomic,weak) BKTabBarBtn * selectedBtn;

@end

@implementation BKTabBar

-(UIColor *)titleNormalColor
{
    return kColor_999999;
}

-(UIColor *)titleSelectColor
{
    return kColor_333333;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.clipsToBounds = NO;
        
        self.backgroundColor = kColor_F2F2F2;
    }
    return self;
}

-(void)creatMyTabBarItemsWithNormalImageArr:(NSArray*)normal selectImageArr:(NSArray*)select tittleArr:(NSArray*)tittle
{
    CGFloat buttonW = SCREENW/[tittle count];
    CGFloat buttonH = get_system_tabbar_ui_height();
    for (int i = 0; i<[tittle count]; i++) {
        BKTabBarBtn * button = [BKTabBarBtn buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*buttonW, 0, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        button.tag = (i+1)*100;
        [self addSubview:button];
        
        CGFloat tittleHeight = 15.0f;
        UILabel * tittleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonH-tittleHeight-5, buttonW, tittleHeight)];
        tittleLab.text = tittle[i];
        tittleLab.font = [UIFont systemFontOfSize:12];
        tittleLab.textAlignment = NSTextAlignmentCenter;
        tittleLab.textColor = self.titleNormalColor;
        tittleLab.tag = button.tag + 1;
        [button addSubview:tittleLab];
        
        CGFloat tabBarImageHeight = buttonH - tittleHeight - 15;
        BKImageView * tabBarImage = [[BKImageView alloc]initWithImage:[UIImage imageNamed:normal[i]]];
        tabBarImage.frame = CGRectMake((buttonW-tabBarImageHeight)/2, 7.5, tabBarImageHeight, tabBarImageHeight);
        tabBarImage.tag = button.tag + 2;
        tabBarImage.clipsToBounds = YES;
        tabBarImage.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:tabBarImage];
        
        //    默认选中第一个按钮
        if (i == self.defaultSelectNum) {
            tittleLab.textColor = self.titleSelectColor;
            tabBarImage.image = [UIImage imageNamed:select[i]];
            [self buttonClick:button];
        }
    }
}

-(void)changeSelectNum:(NSInteger)fromIndex to:(NSInteger)toIndex normalImageArr:(NSArray*)normal selectImageArr:(NSArray*)select
{
    //            把原来高亮的图片变成普通的图片
    UIButton * fromBtn = (UIButton*)[self viewWithTag:(fromIndex+1)*100];
    BKImageView * normalImageView = (BKImageView*)[fromBtn viewWithTag:fromBtn.tag+2];
    UILabel * normalLab = (UILabel*)[fromBtn viewWithTag:fromBtn.tag+1];
    normalImageView.image = [UIImage imageNamed:normal[fromIndex]];
    normalLab.textColor = self.titleNormalColor;
    //            把选中的图片变成高亮的图片
    UIButton * toBtn = (UIButton*)[self viewWithTag:(toIndex+1)*100];
    BKImageView * selectImageView = (BKImageView*)[toBtn viewWithTag:toBtn.tag+2];
    UILabel * selectLab = (UILabel*)[toBtn viewWithTag:toBtn.tag+1];
    selectImageView.image = [UIImage imageNamed:select[toIndex]];
    selectLab.textColor = self.titleSelectColor;
}

//  点击不同button跳转到不同界面
-(void)buttonClick:(BKTabBarBtn*)mybutton
{
    NSInteger fromIndex = _selectedBtn?self.selectedBtn.tag/100-1:0;
    NSInteger toIndex = mybutton.tag/100-1;
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFromIndex:toIndex:)]) {
        [self.delegate tabBar:self didSelectButtonFromIndex:fromIndex toIndex:toIndex];
    }
    
    self.selectedBtn = mybutton;
}

-(void)clickBtnWhichNum:(NSInteger)num
{
    BKTabBarBtn * theButton = (BKTabBarBtn*)[self viewWithTag:(num+1)*100];
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFromIndex:toIndex:)]) {
        [self.delegate tabBar:self didSelectButtonFromIndex:self.selectedBtn.tag/100-1 toIndex:num];
    }
    
    self.selectedBtn = theButton;
}

@end
