//
//  BKDemoViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKDemoViewController.h"

@interface BKDemoViewController ()

@end

@implementation BKDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"示例";
    
    UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonClick:(UIButton*)button
{
    BKDemoViewController * vc = [[BKDemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
