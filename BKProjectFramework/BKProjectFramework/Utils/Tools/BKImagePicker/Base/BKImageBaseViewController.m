//
//  BKImageBaseViewController.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/16.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKImageBaseViewController.h"
#import "BKImagePickerMacro.h"
#import "UIImage+BKImagePicker.h"

@interface BKImageBaseViewController ()

@end

@implementation BKImageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topNavView.backgroundColor = BKNavBackgroundColor;
    
    self.titleLab.textColor = BKNavTitleColor;
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    
    self.topLine.backgroundColor = BKLineColor;
    
    if ([self.navigationController.viewControllers count] != 1 && self != [self.navigationController.viewControllers firstObject]) {
        BKNavButton * backBtn = [[BKNavButton alloc] initWithImage:[UIImage bk_imageWithImageName:@"blue_back"] imageSize:CGSizeMake(20, 20)];
        [backBtn addTarget:self action:@selector(backBtnClick:) object:backBtn];
        self.leftNavBtns = @[backBtn];
    }
    
    self.bottomNavView.backgroundColor = BKNavBackgroundColor;
    self.bottomLine.backgroundColor = BKLineColor;
}

-(void)backBtnClick:(BKNavButton*)backBtn
{
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count] != 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
