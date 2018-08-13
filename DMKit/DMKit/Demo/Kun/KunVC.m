//
//  KunVC.m
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "KunVC.h"
#import "KunVM.h"
#import "KunShopVC.h"
#import "KunCell.h"

@interface KunVC () <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) KunVM *vm;

@property (nonatomic , strong) UIBarButtonItem *rightItem;

@property (nonatomic , strong) UITableView *tabV;


@end

@implementation KunVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self vm];
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self.view addSubview:self.tabV];
}

- (KunVM *)vm
{
    if (_vm == nil) {
        _vm = [[KunVM alloc] init];
    }
    return _vm;
}

-(UIBarButtonItem *)rightItem
{
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Shop" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    }
    return _rightItem;
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
        
        [_tabV registerClass:[KunCell class] forCellReuseIdentifier:@"KunCell"];
        
    }
    return _tabV;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vm.ownList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KunCell"];
    
    cell.kun = self.vm.ownList[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)clickRightItem
{
    KunShopVC *vc = [[KunShopVC alloc] init];
    vc.vm = self.vm;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
