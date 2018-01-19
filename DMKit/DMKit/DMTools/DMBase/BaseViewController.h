//
//  BaseViewController.h
//  YiTieRAS
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/6.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic , strong) UILabel *mainTitleLabel;

@property (nonatomic , strong) MBProgressHUD * mbHud;
- (void)showHUD;
- (void)hideHUD;

@end
