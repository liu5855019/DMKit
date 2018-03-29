//
//  ColliderVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/16.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "ColliderVC.h"
#import "ColliderTool.h"

@interface ColliderVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , strong) ColliderTool *tool;

@property (nonatomic , strong) UILabel *headerLab;

@property (nonatomic , copy) NSArray *datas;

@end

@implementation ColliderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"碰撞机";
    
    [self.view addSubview:self.tabV];
    
    _tool = [ColliderTool shareTool];
    
    _datas = _tool.results;
    
    [_tool begin];
    
    WeakObj(self);
    _tool.runAt = ^(NSString *index) {
        selfWeak.headerLab.text = [NSString stringWithFormat:@"计算到: %@",index];
    };
    
    _tool.getResult = ^(NSArray *result) {
        selfWeak.datas = result;
        [selfWeak.tabV reloadData];
    };
    
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
        
        _headerLab = [UILabel new];
        _headerLab.frame = CGRectMake(0, 0, 0, 50);
        _headerLab.font = kFont(20);
        _headerLab.textColor = [UIColor greenColor];
        _tabV.tableHeaderView = _headerLab;
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
    
    cell.textLabel.text = _datas[indexPath.row];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"收到内存警告");
    
}





@end
