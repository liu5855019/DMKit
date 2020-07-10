//
//  UINavigationBar+DMTools.m
//  DMKit
//
//  Created by iMac-03 on 2017/12/5.
//  Copyright © 2017年 呆木. All rights reserved.
//

#import "UINavigationBar+DMTools.h"

#import "NSArray+DMTools.h"

#import <objc/runtime.h>

#define IOS10Latter [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0

#define IOS13Latter [[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0


@implementation UINavigationBar (DMTools)

static char *navAlphaKey = "navAlphaKey";

- (CGFloat)navAlpha
{
    if (objc_getAssociatedObject(self, navAlphaKey) == nil) {
        return 1;
    }
    return [objc_getAssociatedObject(self, navAlphaKey) floatValue];
}

- (void)setNavAlpha:(CGFloat)navAlpha
{
    CGFloat alpha = MAX(MIN(navAlpha, 1), 0);// 必须在 0~1的范围
    
    UIView *barBackground = self.subviews.dm_firstObject;
    if (self.translucent == NO ||
        [self backgroundImageForBarMetrics:UIBarMetricsDefault] != nil) {
        barBackground.alpha = alpha;
    } else {
        if (IOS13Latter) {
            UIVisualEffectView *effectView = barBackground.subviews.lastObject;
            
            for (UIView *aView in effectView.subviews) {
                aView.alpha = alpha;
            }
        } else if (IOS10Latter) {
            UIView *effectFilterView = barBackground.subviews.lastObject;
            effectFilterView.alpha = alpha;
        } else {
            UIView *effectFilterView = barBackground.subviews.firstObject;
            effectFilterView.alpha = alpha;
        }
    }
    
    /// 黑线
    UIImageView *shadowView;
    if (IOS13Latter) {
        shadowView = barBackground.subviews.firstObject;
    } else {
        shadowView = [barBackground valueForKey:@"_shadowView"];
    }
    if (alpha < 0.01) {
        shadowView.hidden = YES;
    } else {
        shadowView.hidden = NO;
        shadowView.alpha = alpha;
    }
    
    objc_setAssociatedObject(self, navAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
