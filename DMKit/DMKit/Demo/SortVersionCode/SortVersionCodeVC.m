//
//  SortVersionCodeVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/22.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "SortVersionCodeVC.h"

@interface SortVersionCodeVC ()

@end

@implementation SortVersionCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainTitleLabel.text = @"SortVersionCodeVC";
    
    [DMTools checkVersionWithAppId:@"1210593841"];
    
    
    
    NSLog(@"max:%@",[self maxStr1:@"3.2.1" str2:@"3.2.0"]);
    NSLog(@"max:%@",[self maxStr1:@"3.2" str2:@"3.2.0"]);
    NSLog(@"max:%@",[self maxStr1:@"3.2.1" str2:@"3.2.01"]);
    NSLog(@"max:%@",[self maxStr1:@"3.02.1" str2:@"3.2.1"]);
    NSLog(@"max:%@",[self maxStr1:@"3.02.1" str2:@"3.2.2"]);
    NSLog(@"max:%@",[self maxStr1:@"3.02.0" str2:@"3.2.00.00"]);
    NSLog(@"max:%@",[self maxStr1:@"3.02.1" str2:@"4"]);
    
    
    
}

- (NSString *)maxStr1:(NSString *)str1 str2:(NSString *)str2
{
    return [DMTools version1:str1 greatThanVersion2:str2] ? str1 : str2;
}






@end
