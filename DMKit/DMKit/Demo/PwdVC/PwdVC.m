//
//  PwdVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/27.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "PwdVC.h"

@interface PwdVC ()

@end

@implementation PwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"123456";
    
    NSString *key = @"tinyprofit_tokentinyprofit_token";
    
    NSString *iv = @"tinyprofit_toke";
    
    NSString *encode = [str aesEncryptWithKey:key IV:iv];
    
    NSString *decode = [encode aesDecryptWithKey:key IV:iv];
    
    
    NSLog(@"en : %@",encode);
    NSLog(@"de : %@",decode);
    
    
    NSLog(@"%@",str.MD5);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
