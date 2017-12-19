//
//  BaseViewController.m
//  YiTieRAS
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/6.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()



@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(UILabel *)mainTitleLabel
{
    if (_mainTitleLabel == nil) {
        _mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW *0.4, 30)];
        _mainTitleLabel.textAlignment =NSTextAlignmentCenter;
        [_mainTitleLabel setText:@""];
        _mainTitleLabel.textColor = [UIColor whiteColor];
        _mainTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.navigationItem.titleView = _mainTitleLabel;
    }
    return _mainTitleLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
