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
    
    self.mainTitleLabel.text = @"结果请看log";
    
    NSString *str = @"123456";
    
    NSString *key = @"123456";
    
    NSString *iv = @"tinyprofit_toke";
    
    NSString *encode = [str aesEncryptWithKey:key IV:iv];
    
    NSString *decode = [encode aesDecryptWithKey:key IV:iv];
    
    
    NSLog(@"en : %@",encode);
    NSLog(@"de : %@",decode);
    
    
    NSLog(@"%@",str.md5);
    NSLog(@"%@",str.sha512);
    NSLog(@"%@",[str hmacMD5StringWithKey:key]);
    NSLog(@"%@",[str hmacSHA512StringWithKey:key]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
