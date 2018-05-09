//
//  RacVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/5/8.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "RacVC.h"
#import "RacVM.h"
#import "RacCell.h"
#import "ReactiveObjC.h"
#import "RacModel.h"

/**
 v  --- 显示数据
 |
 vc --- 持有view,vm  绑定vm 与 view , 将vm中的数据赋值到view上
 |
 vm --- 持有数据(m) , 网络加载
 |
 m  --- 数据存储
 */


@interface RacVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tabV;
@property (nonatomic , strong) RacVM *vm;

@end

@implementation RacVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tabV];
    
    [self.vm loadMyDatas];
}

- (RacVM *)vm
{
    if (_vm == nil) {
        _vm = [[RacVM alloc] init];
        
        WeakObj(self);
        RACSignal *signal = RACObserve(_vm, isLoading);
        [signal subscribeNext:^(id  _Nullable x) {
            if ([x boolValue]) {
                [selfWeak showHUD];
            } else {
                [selfWeak hideHUD];
            }
        }];
        
        [RACObserve(_vm, datas) subscribeNext:^(id  _Nullable x) {
            [selfWeak.tabV reloadData];
        }];
    }
    return _vm;
}

#pragma mark - TableView
- (UITableView *)tabV{
    if (_tabV == nil) {
        _tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, kNAV_HEIGHT, kScreenW, kScreenH - kNAV_HEIGHT - kSAFE_BOTTOM_HEIGHT) style:UITableViewStylePlain];
        AdjustsScrollViewInsetNever(self, _tabV);
        
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tabV.estimatedRowHeight = 60;
        _tabV.rowHeight = UITableViewAutomaticDimension;
        _tabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_tabV registerClass:[RacCell class] forCellReuseIdentifier:@"RacCell"];
    }
    return _tabV;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _vm.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RacCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RacCell"];
    
    RacModel *model = _vm.datas[indexPath.row];
    
    cell.dateLab.text = model.date;
    cell.inTimeLab.text = model.onTime;
    cell.outTimeLab.text = model.offTime;
    cell.addressLab.text = model.location;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
