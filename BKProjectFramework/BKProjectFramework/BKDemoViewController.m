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
    
    UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonClick:(UIButton*)button
{
    self.navigationController.popVC = self;
    NSLog(@"%@",self.navigationController.popVC);
    NSLog(@"%d",self.navigationController.popGestureRecognizerEnable);
    self.navigationController.popVC = [[UIViewController alloc] init];
    NSLog(@"%@",self.navigationController.popVC);
    self.navigationController.direction = BKTransitionAnimaterDirectionLeft;
    NSLog(@"%ld",self.navigationController.direction);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
