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

- (UILabel *)mainTitleLabel
{
    if (_mainTitleLabel == nil) {
        _mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW *0.4, 30)];
        _mainTitleLabel.textAlignment =NSTextAlignmentCenter;
        [_mainTitleLabel setText:@""];
        _mainTitleLabel.textColor = [UIColor blackColor];
        _mainTitleLabel.font = [UIFont boldSystemFontOfSize:kScaleW(21)];
        self.navigationItem.titleView = _mainTitleLabel;
    }
    return _mainTitleLabel;
}

#pragma mark - MBHud
- (MBProgressHUD *)mbHud{
    if (_mbHud == nil) {
        _mbHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_mbHud];
        //_mbHud.label.text = kLocStr(@"登录中...");
    }
    return _mbHud;
}

- (void)showHUD
{
    [self.view bringSubviewToFront:self.mbHud];
    
    [self.mbHud showAnimated:YES];
}

- (void)hideHUD
{
    [self.mbHud hideAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
