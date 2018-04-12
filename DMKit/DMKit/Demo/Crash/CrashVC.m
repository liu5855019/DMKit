//
//  CrashVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/12.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "CrashVC.h"

@interface CrashVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , copy) NSArray *datas;

@end

@implementation CrashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"Test Create Crash";
    
    _datas = @[
               @"数组越界",
               @"释放一个没有分配的地址",
               @"内存爆了(真机才行)",
               @"字典存空",
               //@""
               ];
    
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
    
    if (indexPath.row == 0) {
        id value = _datas[_datas.count];
        NSLog(@"%@",value);
    } else if (indexPath.row == 1) {
        void * a = malloc(10);
        free(a);
        free(a);
    } else if (indexPath.row == 2) {
        NSInteger count = 0;
        NSMutableArray *muarray = [NSMutableArray array];
        while (++count) {
            [muarray addObject:[[UITableView alloc] init]];
        }
    } else if (indexPath.row == 3) {
        NSString *str = nil;
        NSDictionary *dict = @{
                               @"key":str
                               };
        NSLog(@"%@",dict);
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    MyLog(@" Game Over ... ");
}

@end
