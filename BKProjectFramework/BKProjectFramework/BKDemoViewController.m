//
//  BKDemoViewController.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKDemoViewController.h"

NSString * const kRegisterTableViewCellID = @"UITableViewCell";

@interface BKDemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,strong) BKTableView * tableView;

@end

@implementation BKDemoViewController

-(NSArray*)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@"拍小视频"];
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
    
    _tableView.frame = CGRectMake(0, self.topNavViewHeight, self.view.width, self.view.height - self.topNavViewHeight - SYSTEM_TABBAR_HEIGHT);
}

#pragma mark - BKTableView

-(BKTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[BKTableView alloc] initWithFrame:CGRectMake(0, self.topNavViewHeight, self.view.width, self.view.height - self.topNavViewHeight - SYSTEM_TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kRegisterTableViewCellID];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kRegisterTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
