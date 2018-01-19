//
//  UILabel+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/19.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DMTools)

- (UIView * (^)(NSString *str))dm_text;
- (UIView * (^)(UIFont *font))dm_font;
- (UIView * (^)(UIColor *textColor))dm_textColor;
- (UIView * (^)(NSTextAlignment alignment))dm_alignment;
- (UIView * (^)(NSInteger numberOfLines))dm_numberOfLines;


@end
