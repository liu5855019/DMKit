//
//  KunShopVC.m
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "KunShopVC.h"
#import "KunShopCell.h"
#import "KunVM.h"

@interface KunShopVC () <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UITableView *tabV;

@end

@implementation KunShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self vm];
    
    [self.view addSubview:self.tabV];
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
        
        [_tabV registerClass:[KunShopCell class] forCellReuseIdentifier:@"KunShopCell"];
    }
    return _tabV;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _vm.shopList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KunShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KunShopCell"];
    
    cell.kun = _vm.shopList[indexPath.row];
    
    WeakObj(self);
    cell.buyAction = ^(KunModel *kun) {
        [selfWeak.vm buy:kun];
        [selfWeak.tabV reloadData];
    };
    
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
