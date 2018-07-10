//
//  BKaaViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/9.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKaaViewController.h"
#import "BKNetworkRequest.h"

@interface BKaaViewController ()

@property (nonatomic,assign) NSInteger nums;
@property (nonatomic,strong) BKNetworkRequestFailureView * failureView;

@end

@implementation BKaaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestUrl:kBaseUrl params:nil];
}

-(void)dealloc
{
    NSLog(@"释放");
}

-(void)requestUrl:(NSString *)url params:(NSDictionary*)params
{
    [[BKNetworkRequest shareClient] postWithURL:url params:params requestView:self.view success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
    
//    [[BKNetworkRequest shareClient] postWithURL:url params:params requestView:self.view success:^(id json) {
//
//    } failure:^(NSError *error, BKNetworkRequestFailureView *failureView) {
//        NSMutableString * string = error.description.mutableCopy;
//        for (int i = 0; i < self.nums; i++) {
//            [string appendString:[NSString stringWithFormat:@"\n%@",error.description]];
//        }
//        [self requestFailureWithErrorMessage:string params:params failureType:BKRequestFailureTypeNetworkNotSuccess];
//
//        self.nums++;
//    }];
}

//-(void)requestFailureWithErrorMessage:(NSString*)errorMessage params:(NSDictionary*)params failureType:(BKRequestFailureType)failureType
//{
//    if (!_failureView) {
//        _failureView = [[BKNetworkRequestFailureView alloc] init];
//        [self.view addSubview:_failureView];
//    }
//    WEAK_SELF(self);
//    [_failureView setupFailureMessage:errorMessage failureType:failureType failureUrl:kBaseUrl params:params refreshMethod:^(BKRequestFailureType failureType, NSString *failureUrl, NSDictionary *params) {
//        [weakSelf requestUrl:failureUrl params:params];
//    }];
//}


@end
