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

@property (nonatomic , strong) UILabel *headerLab;

@property (nonatomic) dispatch_source_t timer;



@end

@implementation KunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self vm];
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self.view addSubview:self.tabV];
    _headerLab.text = [NSString stringWithFormat:@"  %lld",_vm.money];
    
    [self startTimer];
    
    @weakify(self);
    [RACObserve(_vm, money) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.mainTitleLabel.text = [NSString stringWithFormat:@"%lld",_vm.money];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabV reloadData];
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
        
        _headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        _headerLab.textColor = [UIColor purpleColor];
        _headerLab.font = kFont(17);
        _tabV.tableHeaderView = _headerLab;
        _tabV.tableFooterView = [[UIView alloc] init];

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
    cell.indexPath = indexPath;
    
    WeakObj(self);
    cell.runAction = ^(NSIndexPath *path) {
        KunModel *kun = selfWeak.vm.ownList[path.row];
        kun.running = !kun.running;
        [selfWeak.tabV reloadData];
    };
    
    cell.mergeAction = ^(NSIndexPath *path) {
        KunModel *kun = selfWeak.vm.ownList[path.row];
        [selfWeak.vm mergeKun:kun];
        [selfWeak.tabV reloadData];
    };
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - timer
-(void)startTimer
{
    //获取一个并行队列 (默认优先级队列)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建 timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    _timer = timer;
    //设置timer间隔和精度
    //interval:间隔 (纳秒),配合NSEC_PER_SEC用就是秒
    //leeway:精度 ,最高精度当然就传0。
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置回调
    WeakObj(self);
    dispatch_source_set_event_handler(timer, ^{
        MAIN((^{
            [selfWeak.vm update];
            selfWeak.headerLab.text = [NSString stringWithFormat:@"  %lld",selfWeak.vm.money];
        }));
    });
    dispatch_resume(_timer);
}
-(void)stopTimer
{
    dispatch_cancel(_timer);
}



#pragma mark - action

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

- (void)dealloc
{
    [self.vm writeToFile];
}

@end
