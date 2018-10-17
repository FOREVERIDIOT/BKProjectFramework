//
//  BKCalendarViewController.m
//  MySelfFrame
//
//  Created by BIKE on 17/2/16.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import "BKCalendarViewController.h"
#import "BKCalendarView.h"
#import "BKCalendar.h"

/**
 判断是否是iPhone X系列
 */
NS_INLINE BOOL bk_calendar_is_iPhoneX_series() {
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

/**
 获取系统状态栏高度
 */
NS_INLINE CGFloat bk_calendar_get_system_statusBar_height() {
    return bk_calendar_is_iPhoneX_series() ? 44.f : 20.f;
}

/**
 获取系统导航高度
 */
NS_INLINE CGFloat bk_calendar_get_system_nav_height() {
    return bk_calendar_is_iPhoneX_series() ? (44.f+44.f) : 64.f;
}

/**
 获取系统导航UI高度
 */
NS_INLINE CGFloat bk_calendar_get_system_nav_ui_height() {
    return bk_calendar_get_system_nav_height() - bk_calendar_get_system_statusBar_height();
}

#define BK_CALENDAR_POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define BK_CALENDAR_ONE_PIXEL BK_CALENDAR_POINTS_FROM_PIXELS(1.0)

#define BK_CALENDAR_NAV_BACKGROUNDCOLOR [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1]
#define BK_CALENDAR_NAV_WEEK_TITLECOLOR [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]
#define BK_CALENDAR_NAV_LINE_BACKGROUNDCOLOR [UIColor colorWithWhite:0.75 alpha:1]

float const kNavTitleFontSize = 18.f;
float const kNavWeekFontSize = 10.f;

@interface BKCalendarViewController ()<BKCalendarViewDelegate>

@property (nonatomic,strong) UIView * nav;
@property (nonatomic,strong) UILabel * titleLab;

@property (nonatomic,strong) BKCalendarView * calendarView;

@end

@implementation BKCalendarViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nav];
    [self.view addSubview:self.calendarView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _calendarView.frame = CGRectMake(0, CGRectGetMaxY(self.nav.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.nav.frame));
}

#pragma mark - nav

-(UIView*)nav
{
    if (!_nav) {
        
        _nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, bk_calendar_get_system_nav_height() + 20)];
        _nav.backgroundColor = BK_CALENDAR_NAV_BACKGROUNDCOLOR;
        [self.view addSubview:_nav];
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, bk_calendar_get_system_statusBar_height(), bk_calendar_get_system_nav_ui_height(), bk_calendar_get_system_nav_ui_height());
        [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nav addSubview:leftBtn];
        
        NSString * backPath = [[NSBundle mainBundle] pathForResource:@"BKCalendar" ofType:@"bundle"];
        UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (leftBtn.frame.size.height - 20)/2, 20, 20)];
        backImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/back.png",backPath]];
        backImage.clipsToBounds = YES;
        backImage.contentMode = UIViewContentModeScaleAspectFit;
        [leftBtn addSubview:backImage];

        CGFloat titleFontSize = kNavTitleFontSize * self.view.frame.size.width / 375.0f;
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(bk_calendar_get_system_nav_ui_height(), bk_calendar_get_system_statusBar_height(), self.view.frame.size.width - bk_calendar_get_system_nav_ui_height()*2, bk_calendar_get_system_nav_ui_height())];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        if (@available(iOS 8.2, *)) {
            _titleLab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
        }else {
            _titleLab.font = [UIFont systemFontOfSize:titleFontSize];
        }
        _titleLab.textColor = [UIColor blackColor];
        [_nav addSubview:_titleLab];
        
        UIView * weekView = [[UIView alloc]initWithFrame:CGRectMake(0, _nav.frame.size.height - 24, self.view.frame.size.width, 20)];
        weekView.backgroundColor = [UIColor clearColor];
        [_nav addSubview:weekView];
        
        CGFloat width = weekView.frame.size.width/7.0f;
        CGFloat height = 20;
        
        NSArray * arr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(width*idx, 0, width, height)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:kNavWeekFontSize * self.view.frame.size.width / 375.0f];
            lab.textColor = BK_CALENDAR_NAV_WEEK_TITLECOLOR;
            lab.text = obj;
            [weekView addSubview:lab];
        }];
        
        UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, _nav.frame.size.height - BK_CALENDAR_ONE_PIXEL, self.view.frame.size.width, BK_CALENDAR_ONE_PIXEL)];
        line.backgroundColor = BK_CALENDAR_NAV_LINE_BACKGROUNDCOLOR;
        [_nav addSubview:line];
    }
    return _nav;
}

-(void)leftBtnClick:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BKCalendarView

-(BKCalendarView*)calendarView
{
    if (!_calendarView) {
        _calendarView = [[BKCalendarView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nav.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.nav.frame))];
        _calendarView.customDelegate = self;
        [self.view addSubview:_calendarView];
    }
    return _calendarView;
}

-(void)returnYearMessage:(NSString *)yearMessage
{
    _titleLab.text = yearMessage;
}

-(void)dayTap:(BKDayModel *)model
{
    
}

-(void)monthTap:(BKMonthModel *)model
{
    
}

@end
