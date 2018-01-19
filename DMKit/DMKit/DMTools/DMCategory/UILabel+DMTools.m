//
//  UILabel+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/19.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "UILabel+DMTools.h"

@implementation UILabel (DMTools)

- (UIView * (^)(NSString *str))dm_text
{
    return ^(NSString *str){
        self.text = str;
        return self;
    };
}

- (UIView * (^)(UIFont *font))dm_font
{
    return ^(UIFont *font){
        self.font = font;
        return self;
    };
}

- (UIView * (^)(UIColor *textColor))dm_textColor
{
    return ^(UIColor *textColor){
        self.textColor = textColor;
        return self;
    };
}

- (UIView * (^)(NSTextAlignment alignment))dm_alignment
{
    return ^(NSTextAlignment alignment){
        self.textAlignment = alignment;
        return self;
    };
}

- (UIView * (^)(NSInteger numberOfLines))dm_numberOfLines
{
    return ^(NSInteger numberOfLines){
        self.numberOfLines = numberOfLines;
        return self;
    };
}




@end
