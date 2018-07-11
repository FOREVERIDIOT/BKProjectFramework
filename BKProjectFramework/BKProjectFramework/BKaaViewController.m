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
    
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, 200, 200, 200)];
    
    
    [[BKNetworkRequest shareClient] postWithURL:kBaseUrl params:nil requestView:aView success:^(id json) {
        
    } failure:^(NSError *error) {
        [self.view addSubview:aView];
    }];
}


@end
