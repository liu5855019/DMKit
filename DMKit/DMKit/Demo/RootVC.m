//
//  RootVC.m
//  DMKit
//
//  Created by 呆木 on 2017/12/19.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "RootVC.h"
#import "DMSegmentViewVC.h"
#import "AVFoundationVC.h"
#import "SocketClientVC.h"
#import "SocketServerVC.h"
#import "SortVersionCodeVC.h"
#import "DMPickerVC.h"
#import "ColliderVC.h"
#import "PwdVC.h"
#import "PwdDictVC.h"
#import "ShowLogVC.h"
#import "CrashVC.h"
#import "VisionDebugVC.h"
#import "ImageDebugVC.h"
#import "RacVC.h"


@interface RootVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , strong) NSArray *datas;

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"DMKit";
    
    [self.view addSubview:self.tabV];
    AdjustsScrollViewInsetNever(self, _tabV)
    
    _datas = @[@"DMSegmentViewVC",
               @"AVFoundationVC",
               @"SocketClientVC",
               @"SocketServerVC",
               @"SortVersionCodeVC",
               @"DMPickerVC",
               @"ColliderVC",
               @"PwdVC",
               @"PwdDictVC",
               @"ShowLogVC",
               @"CrashVC",
               @"VisionDebugVC",
               @"ImageDebugVC",
               @"RacVC",
               @"KunVC"];
    
    [self testDes];
    
}

- (void)testDes
{
    NSString *content = @"20363652";
    NSString *key = @"05fec77b22ff41a4ba9589c7afc537ea";
    NSString *iv = @"";
    
    
    NSString *result = [content desEncryptWithKey:key IV:iv];
    
    NSLog(@"%@",result);
}

- (void)testDeDes
{
    NSString *content = @"HHP/6bHpzQc=";
    NSString *key = @"123456";
    NSString *iv = @"";
    
    
    NSString *result = [content desDecryptWithKey:key IV:iv];
    
    NSLog(@"%@",result);
}


#pragma mark - TableView
- (UITableView *)tabV{
    if (_tabV == nil) {
        _tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, kNAV_HEIGHT, kScreenW, kScreenH - kNAV_HEIGHT - kSAFE_BOTTOM_HEIGHT) style:UITableViewStylePlain];
        
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tabV.estimatedRowHeight = 60;
        _tabV.rowHeight = UITableViewAutomaticDimension;
        _tabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tabV;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [_datas dm_objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[DMSegmentViewVC new] animated:YES];
        return;
    }
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[AVFoundationVC new] animated:YES];
        return;
    }
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[SocketClientVC new] animated:YES];
        return;
    }
    if (indexPath.row == 3) {
        [self.navigationController pushViewController:[SocketServerVC new] animated:YES];
        return;
    }
    if (indexPath.row == 4) {
        [self.navigationController pushViewController:[SortVersionCodeVC new] animated:YES];
        return;
    }
    
    UIViewController *vc = [NSClassFromString([_datas dm_objectAtIndex:indexPath.row]) new];
    [self.navigationController pushViewController:vc animated:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

