//
//  ShowLogVC.m
//  DMKit
//
//  Created by 呆木 on 2018/3/17.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "ShowLogVC.h"

@interface ShowLogVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , strong) NSMutableArray *datas;

@end

@implementation ShowLogVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tabV];
    
    _datas = [[DBManager shareDB] selectAllLogs];
    
    
}




#pragma mark - TableView
- (UITableView *)tabV{
    if (_tabV == nil) {
        _tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dict = _datas[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@    %@",dict[@"page"],dict[@"time"]];
    cell.detailTextLabel.text = dict[@"content"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
