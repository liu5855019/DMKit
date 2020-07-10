//
//  MillionVC.m
//  DMKit
//
//  Created by iMac-03 on 2020/7/10.
//  Copyright © 2020 呆木出品. All rights reserved.
//

#import "MillionVC.h"

#import "MillionModel.h"
#import "MillionResultModel.h"

#import "MillionCell.h"

@interface MillionVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , weak) MillionModel *model;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *ratioLab;
@property (weak, nonatomic) IBOutlet UILabel *inMoneyLab;

@property (nonatomic , strong) UITableView *tabV;
@property (nonatomic , strong) NSMutableArray *results;

@property (nonatomic , assign) NSInteger count;
@property (nonatomic , assign) NSInteger countOfWin;


@end

@implementation MillionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self.view addSubview:self.tabV];
}

- (void)setupViews
{
    _model = [MillionModel shareInstance];
    _results = [NSMutableArray array];
    
    _slider.maximumValue = 100;
    _slider.minimumValue = 1;
    _slider.value = 100;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self updateMoneyLabs];
}

- (void)updateMoneyLabs
{
    _moneyLab.text = [NSString stringWithFormat:@"%.2f",_model.money];
    _ratioLab.text = [NSString stringWithFormat:@"%d%%",(int)_slider.value];
    _inMoneyLab.text = [NSString stringWithFormat:@"%.2f",((int)_slider.value/100.0) * _model.money];
}

#pragma mark - TableView
- (UITableView *)tabV
{
    if (_tabV == nil) {
        _tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, kScreenW, kScreenH - 300 - kSAFE_BOTTOM_HEIGHT) style:UITableViewStylePlain];
        AdjustsScrollViewInsetNever(self, _tabV);
        
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tabV.estimatedRowHeight = 150;
        _tabV.rowHeight = UITableViewAutomaticDimension;
        _tabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_tabV registerNib:[UINib nibWithNibName:@"MillionCell" bundle:nil] forCellReuseIdentifier:@"MillionCell"];
    }
    return _tabV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MillionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MillionCell"];
    
    cell.model = _results[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Actions

- (IBAction)clickStartBtn:(id)sender
{
    BOOL isWin = arc4random()%2;
    _count++;
    if (isWin == 1) {
        _countOfWin++;
    }
    double ratioOfWin = (double)_countOfWin/(_count-_countOfWin);
    
    MillionResultModel *result = [[MillionResultModel alloc] init];
    
    result.isWin = isWin;
    result.ratioOfWin = ratioOfWin;
    result.oldMoney = _model.money;
    result.inRatio = (int)_slider.value/100.0;
    result.inMoney = result.inRatio * result.oldMoney;
    result.changeMoney = isWin ? (0.6 * result.inMoney) : (-0.4 * result.inMoney);
    result.resultMoney = result.oldMoney + result.changeMoney;
    
    [_results insertObject:result atIndex:0];
    
    _model.money = result.resultMoney;
    [_model saveDatas];
    
    
    [self updateMoneyLabs];
    [self.tabV reloadData];
    
    
    
    if (_model.money > 1000000) {
        [DMTools showAlertWithTitle:@"您已成为人生赢家, 去潇洒吧!!!" andContent:[NSString stringWithFormat:@"共进行了 %ld 次",_results.count] andBlock:^{
            [self reset:nil];
        } atVC:self];
    } else if (_model.money < 50) {
        [DMTools showAlertWithTitle:@"您已败光财产, 快去打工吧!!!" andContent:[NSString stringWithFormat:@"共进行了 %ld 次",_results.count] andBlock:^{
            [self reset:nil];
        } atVC:self];
    } else {
        [self performSelector:@selector(clickStartBtn:) withObject:nil afterDelay:0.5];
    }
    
    NSLog(@"%d----%f",isWin,ratioOfWin);
}

- (void)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"%f",sender.value);
    
    [self updateMoneyLabs];
}

- (IBAction)reset:(id)sender
{
    _model.money = 5000;
    _slider.value = 100;
    [_model saveDatas];
    [_results removeAllObjects];
    
    [self updateMoneyLabs];
    [self.tabV reloadData];
    
}

@end
