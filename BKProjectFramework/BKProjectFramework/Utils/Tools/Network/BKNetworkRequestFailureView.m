//
//  BKNetworkRequestFailureView.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKNetworkRequestFailureView.h"
#import "BKNetworkRequest.h"

#define kMessageColor [UIColor colorWithWhite:0.4 alpha:1]

@interface BKNetworkRequestFailureView()

/**
 失败类型
 */
@property (nonatomic,assign) BKRequestFailureType failureType;
/**
 私有请求Url
 */
@property (nonatomic,copy) NSString * private_requestUrl;
/**
 请求参数
 */
@property (nonatomic,strong) NSDictionary * params;
/**
 刷新网络请求方法
 */
@property (nonatomic,copy) void (^refreshRequestMethod)(void);

@property (nonatomic,strong) UIScrollView * bgScrollView;//滑动背景
@property (nonatomic,strong) UILabel * messageLab;//失败显示文本
@property (nonatomic,strong) UIButton * refreshBtn;//刷新按钮

@end

@implementation BKNetworkRequestFailureView

#pragma mark - 初始化方法

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initDataAndUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataAndUI];
    }
    return self;
}

-(void)initDataAndUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.messageLab];
    [self.bgScrollView addSubview:self.refreshBtn];
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        self.frame = newSuperview.bounds;
        if (!CGRectEqualToRect(self.bgScrollView.bounds, self.bounds)) {
            self.bgScrollView.frame = self.bounds;
            self.bgScrollView.hidden = NO;
            [self resetUIFrame];
        }
    }
}

//-(void)dealloc
//{
//    NSLog(@"view释放");
//}

#pragma mark - 界面

/**
 网络请求失败更新失败界面信息
 
 @param failureMessage 失败原因
 @param failureType 失败类型(是网络错误还是后台返回错误)
 @param requestUrl 请求url
 @param params 请求参数
 */
-(void)setupFailureMessage:(NSString*)failureMessage failureType:(BKRequestFailureType)failureType requestUrl:(NSString*)requestUrl params:(NSDictionary*)params
{
    _failureType = failureType;
    _requestUrl = requestUrl;
    _private_requestUrl = requestUrl;
    _params = params;
    
    if (![_messageLab.text isEqualToString:failureMessage]) {
        _messageLab.text = failureMessage;
        [self resetUIFrame];
    }
}

-(void)resetUIFrame
{
    _messageLab.frame = CGRectMake(30, 30, _bgScrollView.frame.size.width - 60, 0);
    [_messageLab sizeToFit];
    
    _refreshBtn.frame = CGRectMake((_bgScrollView.frame.size.width - 80)/2, CGRectGetMaxY(_messageLab.frame) + 15, 80, 40);
    
    CGFloat messageY = 30;
    CGFloat allContentHeight = _messageLab.frame.size.height + 15 + 40;
    if (_bgScrollView.frame.size.height > allContentHeight + messageY * 2) {
        messageY = (_bgScrollView.frame.size.height - allContentHeight) / 2;
        _messageLab.frame = CGRectMake(30, messageY, _bgScrollView.frame.size.width - 60, _messageLab.frame.size.height);
        _refreshBtn.frame = CGRectMake((_bgScrollView.frame.size.width - 80)/2, CGRectGetMaxY(_messageLab.frame) + 15, 80, 40);
        _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width, _bgScrollView.frame.size.height);
    }else {
        _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width, CGRectGetMaxY(_refreshBtn.frame) + 30);
    }
}

-(UIScrollView*)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.hidden = YES;
        if (@available(iOS 11.0, *)) {
            _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _bgScrollView;
}

-(UILabel*)messageLab
{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] init];
        _messageLab.font = [UIFont systemFontOfSize:15];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.textColor = kMessageColor;
        _messageLab.numberOfLines = 0;
    }
    return _messageLab;
}

-(UIButton*)refreshBtn
{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.layer.masksToBounds = YES;
        _refreshBtn.layer.cornerRadius = 6;
        _refreshBtn.layer.borderColor = kMessageColor.CGColor;
        _refreshBtn.layer.borderWidth = 1;
        [_refreshBtn setTitleColor:kMessageColor forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_refreshBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

-(void)refreshBtnClick:(UIButton*)button
{
    if (self.refreshRequestMethod) {
        self.refreshRequestMethod();
    }
}

#pragma mark - 刷新回调

-(void)refreshRequestMethod:(void (^)(NSString * requestUrl, NSDictionary * params))refreshMethod
{
    __weak typeof(self) weakSelf = self;
    self.refreshRequestMethod = ^{
        if (refreshMethod) {
            refreshMethod(weakSelf.private_requestUrl, weakSelf.params);
        }
    };
}

@end
