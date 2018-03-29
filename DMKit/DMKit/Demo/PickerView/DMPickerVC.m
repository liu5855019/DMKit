//
//  DMPickerVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/13.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "DMPickerVC.h"

@interface DMPickerVC ()

@end

@implementation DMPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"Test DMPicker";
    
    UIButton *btn1 = [UIButton new];
    [btn1 setTitle:@"ShowDMPicker" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(50, 100, 100, 50);
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    
}

- (void)clickBtn1
{
    
}



@end
