//
//  UIColor+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/26.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "UIColor+DMTools.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIColor (DMTools)

- (void)getValueR:(CGFloat *)red G:(CGFloat *)green B:(CGFloat *)blue A:(CGFloat *)alpha
{
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    size_t length = CGColorGetNumberOfComponents(self.CGColor);
    
    switch (length) {
        case 2:
            if (red) *red = rgba[0];
            if (green) *green = rgba[0];
            if (blue) *blue = rgba[0];
            if (alpha) *alpha = rgba[1];
            break;
        case 4:
            if (red) *red = rgba[0];
            if (green) *green = rgba[1];
            if (blue) *blue = rgba[2];
            if (alpha) *alpha = rgba[3];
            break;
        default:
            NSLog(@"获取色值失败:%zu", length);
            if (red) *red = 0;
            if (green) *green = 0;
            if (blue) *blue = 0;
            if (alpha) *alpha = 0;
            break;
    }
}

@end
