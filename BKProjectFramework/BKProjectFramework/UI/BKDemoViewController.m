//
//  BKDemoViewController.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKDemoViewController.h"
#import "BKImagePickerViewController.h"
#import "BKPhotoBrowserDemoViewController.h"

NSString * const kRegisterTableViewCellID = @"UITableViewCell";
NSString * const kRegisterTableViewHeaderID = @"UITableViewHeaderView";

@interface BKDemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,strong) BKTableView * tableView;

@end

@implementation BKDemoViewController

-(NSArray*)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"相机/图库", @"data":@[@"拍照",@"照片选择",@"拍小视频"]},
                     @{@"title":@"选取器", @"data":@[@"单项选择",@"三级联动",@"选取时间格式YYYY MM dd",@"选取时间格式"]},
                     @{@"title":@"日历", @"data":@[@"日历"]},
                     @{@"title":@"图片选取器", @"data":@[@"图片选取器"]}];
    }
    return _dataArr;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"示例";
    [self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _tableView.frame = CGRectMake(0, self.topNavViewHeight, self.view.width, self.view.height - self.topNavViewHeight - get_system_tabbar_height());
}

#pragma mark - BKTableView

-(BKTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[BKTableView alloc] initWithFrame:CGRectMake(0, self.topNavViewHeight, self.view.width, self.view.height - self.topNavViewHeight - get_system_tabbar_height()) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 40;
        _tableView.rowHeight = 40;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kRegisterTableViewCellID];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kRegisterTableViewHeaderID];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dic = self.dataArr[section];
    return [dic[@"data"] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kRegisterTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel * titleLab = (UILabel*)[cell viewWithTag:1];
    if (!titleLab) {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREENW - 60, 40)];
        titleLab.tag = 1;
        titleLab.textColor = COLOR_GRAY;
        titleLab.font = regular_font(15);
        [cell addSubview:titleLab];
    }
    
    UIImageView * line = (UIImageView*)[cell viewWithTag:2];
    if (!line) {
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40 - ONE_PIXEL, SCREENW, ONE_PIXEL)];
        line.backgroundColor = COLOR_E4E4E4;
        line.tag = 2;
        [cell addSubview:line];
    }
    
    NSDictionary * dic = self.dataArr[indexPath.section];
    NSArray * dataArr = dic[@"data"];
    titleLab.text = dataArr[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kRegisterTableViewHeaderID];
    headerView.contentView.backgroundColor = COLOR_WHITE;
    
    UILabel * titleLab = (UILabel*)[headerView viewWithTag:1];
    if (!titleLab) {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREENW - 30, 40)];
        titleLab.tag = 1;
        titleLab.textColor = COLOR_DARKGRAY;
        titleLab.font = regular_font(17);
        [headerView addSubview:titleLab];
    }
    
    UIImageView * line = (UIImageView*)[headerView viewWithTag:2];
    if (!line) {
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40 - ONE_PIXEL, SCREENW, ONE_PIXEL)];
        line.backgroundColor = COLOR_E4E4E4;
        line.tag = 2;
        [headerView addSubview:line];
    }
    
    NSDictionary * dic = self.dataArr[section];
    titleLab.text = dic[@"title"];
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [[BKImagePicker sharedManager] takePhotoWithComplete:^(UIImage *image, NSData *data) {
                        NSLog(@"image:%@, dataLength:%ld",image, [data length]);
                    }];
                }
                    break;
                case 1:
                {
                    [[BKImagePicker sharedManager] showPhotoAlbumWithTypePhoto:BKPhotoTypeDefault maxSelect:6 isHaveOriginal:YES complete:^(UIImage *image, NSData *data, NSURL *url, BKSelectPhotoType selectPhotoType) {
                        NSLog(@"image:%@, dataLength:%ld, url:%@ selectPhotoType:%ld",image, [data length], url, selectPhotoType);
                    }];
                }
                    break;
                case 2:
                {
                    [[BKImagePicker sharedManager] recordVideoComplete:^(UIImage *image, NSData *data, NSURL *url) {
                        NSLog(@"image:%@, dataLength:%ld, url:%@",image, [data length], url);
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    BKPickerView * pickerView = [[BKPickerView alloc] initWithPickerDataArr:@[@"一",@"二",@"三"] remind:@"单选"];
                    pickerView.selectIndex = 1;
                    [pickerView setConfirmSelectCallback:^(NSInteger selectIndex) {
                        NSLog(@"切换选择%ld",selectIndex);
                    }];
                    [pickerView showInView:self.tabBarController.view];
                }
                    break;
                case 1:
                {
                    NSArray * level1_dataArr = @[@"一-一",@"一-二"];
                    NSArray * level1_2_dataArr = @[@"二-一",@"二-二"];
                    NSArray * level3_dataArr = @[@"三-一",@"三-二"];
                    
                    NSArray * level2_2_dataArr = @[@"二6一",@"二6二"];
                    NSArray * level2_3_dataArr = @[@"三6一",@"三6二"];
                    
                    NSArray * level3_3_dataArr = @[@"三8一",@"三8二",@"三8二"];
                    
                    BKPickerView * pickerView = [[BKPickerView alloc] initWithPickerDataArr:@[level1_dataArr,level2_2_dataArr,level3_3_dataArr] remind:@"三级联动"];
                    pickerView.selectIndexArr = @[@(1),@(1),@(1)];
                    [pickerView setChangeSelectIndexsCallback:^NSArray *(NSArray<NSNumber *> *selectIndexArr) {
                        NSArray * dataArr = nil;
                        
                        NSInteger index1 = [selectIndexArr[0] integerValue];
                        NSInteger index2 = [selectIndexArr[1] integerValue];
                        if (index1 == 0) {
                            if (index2 == 0) {
                                dataArr = @[level1_dataArr,level1_2_dataArr,level3_dataArr];
                            }else {
                                dataArr = @[level1_dataArr,level1_2_dataArr,level3_3_dataArr];
                            }
                        }else if (index1 == 1) {
                            if (index2 == 0) {
                                dataArr = @[level1_dataArr,level2_2_dataArr,level2_3_dataArr];
                            }else if (index2 == 1) {
                                dataArr = @[level1_dataArr,level2_2_dataArr,level3_3_dataArr];
                            }
                        }
                        
                        return dataArr;
                    }];
                    [pickerView setConfirmSelectIndexsCallback:^(NSArray<NSNumber *> *selectIndexArr) {
                        NSLog(@"完成切换选择%ld-%ld-%ld",[selectIndexArr[0] integerValue],[selectIndexArr[1] integerValue],[selectIndexArr[2] integerValue]);
                    }];
                    [pickerView showInView:self.tabBarController.view];
                }
                    break;
                case 2:
                {
                    BKPickerView * pickerView = [[BKPickerView alloc] initWithPickerStyle:BKPickerStyleDate remind:@"时间格式YYYY MM dd"];
                    [pickerView setConfirmSelectDateCallback:^(NSDate *date) {
                        NSLog(@"选取日期为%@",[date transformStringWithFormat:BKDateFormatYYYY_MM_dd_HH_mm]);
                    }];
                    [pickerView showInView:self.tabBarController.view];
                }
                    break;
                case 3:
                {
                    BKPickerView * pickerView = [[BKPickerView alloc] initWithPickerStyle:BKPickerStyleMDHMDate remind:@"时间格式MM月dd日 EEEE HH mm"];
                    [pickerView setConfirmSelectDateCallback:^(NSDate *date) {
                        NSLog(@"选取日期为%@",[date transformStringWithFormat:BKDateFormatYYYY_MM_dd_HH_mm]);
                    }];
                    [pickerView showInView:self.tabBarController.view];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    BKCalendarViewController * vc = [[BKCalendarViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    BKPhotoBrowserDemoViewController * vc = [[BKPhotoBrowserDemoViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

@end
