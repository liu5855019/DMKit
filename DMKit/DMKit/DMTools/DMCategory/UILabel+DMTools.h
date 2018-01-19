//
//  UILabel+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/19.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DMTools)

- (UILabel *(^)(NSString *str))dm_text;
- (UILabel *(^)(UIFont *font))dm_font;
- (UILabel *(^)(UIColor *textColor))dm_textColor;
- (UILabel *(^)(NSTextAlignment alignment))dm_alignment;
- (UILabel *(^)(NSInteger numberOfLines))dm_numberOfLines;



@end
