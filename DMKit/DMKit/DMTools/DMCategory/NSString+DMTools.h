//
//  NSString+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/29.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DMTools)




- (BOOL)isNullString;
- (BOOL)isAllWithSpace;
- (BOOL)isHaveSpace;


- (BOOL)isEmail;
- (BOOL)isInArray:(NSArray *)array;


- (NSString *)pinyin;
- (NSString *)MD5;


@end
