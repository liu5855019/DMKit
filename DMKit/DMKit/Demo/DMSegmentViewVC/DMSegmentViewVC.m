//
//  SegmentViewVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/28.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "DMSegmentViewVC.h"
#import "DMSegmentView.h"

@interface DMSegmentViewVC ()

@property (nonatomic , strong) DMSegmentView *segmentView;

@property (nonatomic , strong) NSArray *tabViews;

@end

@implementation DMSegmentViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"Test for DMSegmentView";
    
    NSMutableArray *views = [NSMutableArray array];
    NSArray *titles = @[@"全部111",@"待付款2222",@"待发货",@"待收货",@"已签收",@"哈哈哈哈哈哈哈哈哈"];
    for (int i = 0; i < 6; i++) {
        UITableView *tabV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        AdjustsScrollViewInsetNever(self, tabV);
        tabV.backgroundColor = kRandomColor;
        WeakObj(tabV);
        tabV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSLog(@"tabV refreshing ...");
            [tabVWeak.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0f];
        }];
        [views addObject:tabV];
    }
    
    _tabViews = views;
    WeakObj(self);
    DMSegmentView *aView = [[DMSegmentView alloc] initWithFrame:CGRectMake(0, kNAV_HEIGHT, kScreenW, kScreenH - kNAV_HEIGHT - kSAFE_BOTTOM_HEIGHT) views:views titles:titles titleFont:nil titleColor:nil titleSelectedColor:nil titlesIsAverage:YES showAction:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
        UITableView *tabView = [selfWeak.tabViews dm_objectAtIndex:index];
        [tabView.mj_header beginRefreshing];
    }];
    
    [self.view addSubview:aView];
    
}




@end
