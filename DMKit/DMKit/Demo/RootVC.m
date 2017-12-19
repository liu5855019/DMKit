//
//  RootVC.m
//  DMKit
//
//  Created by 呆木 on 2017/12/19.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "RootVC.h"

@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *lab = [UILabel new];
//    lab.frame = CGRectMake(0, 0, kScreenW,50);
//    lab.textColor = kGetColorRGB(0, 0, 0);
//    lab.font = [UIFont systemFontOfSize:41];
//    lab.text = @"DMKit";
//    lab.center = self.view.center;
//    lab.textAlignment = NSTextAlignmentCenter;
//
//    [self.view addSubview:lab];
    
    self.mainTitleLabel.text = @"DMKit";

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
