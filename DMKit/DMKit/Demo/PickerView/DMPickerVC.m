//
//  DMPickerVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/13.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "DMPickerVC.h"

@interface DMPickerVC ()

@property (nonatomic , strong) DMPickerView *dmPV;



@end

@implementation DMPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"Test DMPicker";
    
    UIButton *btn1 = [UIButton new];
    [btn1 setTitle:@"DMPicker" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(50, 150, 150, 50);
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitle:@"DMBasePicker" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(50, 250, 150, 50);
    [btn2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

- (DMPickerView *)dmPV
{
    if (_dmPV == nil) {
        _dmPV = [[DMPickerView alloc] initWithBGView:self.view isHasBtn:YES];
        _dmPV.didSelectedIndex = ^(NSInteger index) {
            NSLog(@"已经选中: %ld",index);
        };
        
        _dmPV.datas = @[@1,@"data1",@"data2",@"data3",@"data4",@"data5"];
    }
    return _dmPV;
}

- (void)clickBtn1
{
    [self.dmPV show];
}

- (void)clickBtn2
{
    
}

-(void)dealloc{
    MyLog(@" Game Over ... ");
}

@end
