//
//  UIViewController+DMTools.m
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/5.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import "UIViewController+DMTools.h"


static char *vcAlphaKey = "vcAlphaKey";

@implementation UIViewController (DMTools)


-(CGFloat)navAlpha {
    if (objc_getAssociatedObject(self, vcAlphaKey) == nil) {
        return 1;
    }
    return [objc_getAssociatedObject(self, vcAlphaKey) floatValue];
}
-(void)setNavAlpha:(CGFloat)navAlpha {
    CGFloat alpha = MAX(MIN(navAlpha, 1), 0);// 0~1
    self.navigationController.navigationBar.navAlpha = alpha;
    objc_setAssociatedObject(self, vcAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//
///// backgroundColor
//-(UIColor *)navBarTintColor {
//    UIColor *color = objc_getAssociatedObject(self, vcColorKey);
//    if (color == nil) {
//        color = [UINavigationBar appearance].barTintColor;
//    }
//    return color;
//}
//-(void)setNavBarTintColor:(UIColor *)navBarTintColor {
//    self.navigationController.navigationBar.barTintColor = navBarTintColor;
//    objc_setAssociatedObject(self, vcColorKey, navBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
///// tintColor
//-(UIColor *)navTintColor {
//    UIColor *color = objc_getAssociatedObject(self, vcNavtintColorKey);
//    if (color == nil) {
//        color = [UINavigationBar appearance].tintColor;
//    }
//    return color;
//}
//-(void)setNavTintColor:(UIColor *)tintColor {
//    self.navigationController.navigationBar.tintColor = tintColor;
//    objc_setAssociatedObject(self, vcNavtintColorKey, tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//// titleColor
//- (UIColor *)navTitleColor {
//    UIColor *color = objc_getAssociatedObject(self, vcTitleColorKey);
//
//    if (color == nil) {
//        color = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName];
//    }
//    return color;
//}
//
//- (void)setNavTitleColor:(UIColor *)navTitleColor {
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = navTitleColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
//    objc_setAssociatedObject(self, vcTitleColorKey, navTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//}

@end
