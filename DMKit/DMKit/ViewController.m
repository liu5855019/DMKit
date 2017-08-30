//
//  ViewController.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 17/8/30.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *lab = [UILabel new];
    lab.frame = CGRectMake(0, 0, kScreenW,50);
    lab.textColor = kGetColorRGB(0, 0, 0);
    lab.font = [UIFont systemFontOfSize:41];
    lab.text = @"DMKit";
    lab.center = self.view.center;
    lab.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:lab];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
