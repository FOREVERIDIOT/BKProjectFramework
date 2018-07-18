//
//  BKImageBaseViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/16.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKImageBaseViewController.h"
#import "BKTool.h"

@interface BKImageBaseViewController ()

@end

@implementation BKImageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topNavView.backgroundColor = BKNavBackgroundColor;
    
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    
    self.topLine.backgroundColor = BKLineColor;
    
    if ([self.navigationController.viewControllers count] != 1 && self != [self.navigationController.viewControllers firstObject]) {
        BKNavButton * backBtn = [[BKNavButton alloc] initWithImage:[[BKTool sharedManager] imageWithImageName:@"blue_back"] imageSize:CGSizeMake(20, 20)];
        [backBtn setClickMethod:^(BKNavButton *button) {
            if (self.navigationController) {
                if ([self.navigationController.viewControllers count] != 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        self.leftNavBtns = @[backBtn];
    }
    
    self.bottomNavView.backgroundColor = BKNavBackgroundColor;
    self.bottomLine.backgroundColor = BKLineColor;
}

@end
