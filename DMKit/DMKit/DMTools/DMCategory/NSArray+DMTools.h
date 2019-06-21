//
//  NSArray+DMTools.h
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/8.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DMTools)


- (id)dm_firstObject;

- (id)dm_objectAtIndex:(NSUInteger)index;

/** 归类函数:返回归类排序结果 block:用于类似通讯录的排序 */
- (NSMutableArray *)classifyWithKey:(NSString *)key block:(void (^)(NSMutableArray *keys , NSMutableArray *valueArrays))block;

- (BOOL)hasString:(NSString *)string;
- (BOOL)hasObject:(NSObject *)object;


@end
