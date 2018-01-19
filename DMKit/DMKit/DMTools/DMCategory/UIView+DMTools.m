//
//  UIView+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/29.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "UIView+DMTools.h"

@implementation UIView (DMTools)

#pragma mark - << setter/getter >>

- (CGFloat)x
{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}


#pragma mark - << blockSet >>

- (UIView * (^)(CGRect rect))dm_frame
{
    return ^(CGRect rect){
        self.frame = rect;
        return self;
    };
}

- (UIView * (^)(UIColor *color))dm_bgColor
{
    return ^(UIColor *color){
        self.backgroundColor = color;
        return self;
    };
}



/** 根据类名加载xib ---> View */
+ (__kindof UIView *) viewWithXibClassName:(NSString *)className
{
    return [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil][0];
}




@end
