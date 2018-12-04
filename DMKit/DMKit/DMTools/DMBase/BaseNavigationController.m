//
//  BaseNavBarController.m
//  TinyBenefit
//
//  Created by 西安旺豆电子 on 2017/6/7.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import "BaseNavigationController.h"


@interface BaseNavigationController ()<UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic , weak) UIViewController *popVC;

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.delegate = self;
    self.navigationBar.tintColor = [UIColor blackColor];
    //self.navigationBar.barTintColor = [UIColor whiteColor];
    
}
/*
 *  设置push的时候隐藏tabbar
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    self.popVC = nil;
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    viewController.navigationItem.backBarButtonItem = back;
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (_popVC) {
        BOOL isHave = NO;
        for (UIViewController *vc in navigationController.viewControllers) {
            if (vc == _popVC) {
                isHave = YES;
                break;
            }
        }
        if (isHave) {
            NSLog(@"发现假的pop : %@",_popVC);
        } else {
            NSLog(@"发现真的pop : %@",_popVC);
            [_popVC willDealloc];
        }
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    self.popVC = vc;
    return vc;
}


#pragma mark - navigationBar

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    //navigationBar.tintColor = self.topViewController.navTintColor;
    //navigationBar.barTintColor = self.topViewController.navBarTintColor;
    navigationBar.navAlpha = self.topViewController.navAlpha;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    //navigationBar.tintColor = self.topViewController.navTintColor;
    //navigationBar.barTintColor = self.topViewController.navBarTintColor;
    navigationBar.navAlpha = self.topViewController.navAlpha;
    return YES;
}

- (void)dealloc
{
    for (UIViewController *vc in self.viewControllers) {
        [vc willDealloc];
    }
}


@end
