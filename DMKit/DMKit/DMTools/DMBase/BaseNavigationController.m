//
//  BaseNavBarController.m
//  TinyBenefit
//
//  Created by 西安旺豆电子 on 2017/6/7.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import "BaseNavigationController.h"


@interface BaseNavigationController ()<UINavigationControllerDelegate,UINavigationBarDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationBar.barTintColor = [UIColor whiteColor];
    self.delegate = self;
    self.navigationBar.tintColor = [UIColor blackColor];
    
}
/*
 *  设置push的时候隐藏tabbar
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/*
 *  设置状态栏颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/*
 *  设置系统箭头返回按钮
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    viewController.navigationItem.backBarButtonItem = back;
    
}



#pragma mark - navigationBar

-(void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    //navigationBar.tintColor = self.topViewController.navTintColor;
    //navigationBar.barTintColor = self.topViewController.navBarTintColor;
    navigationBar.navAlpha = self.topViewController.navAlpha;
}
-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    //navigationBar.tintColor = self.topViewController.navTintColor;
    //navigationBar.barTintColor = self.topViewController.navBarTintColor;
    navigationBar.navAlpha = self.topViewController.navAlpha;
    return YES;
}





@end
