//
//  NSArray+DMTools.m
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/8.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import "NSArray+DMTools.h"

@implementation NSArray (DMTools)

- (id)dm_firstObject
{
    return [self dm_objectAtIndex:0];
}

- (id)dm_objectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}


- (NSMutableArray *)classifyWithKey:(NSString *)key block:(void (^)(NSMutableArray *keys , NSMutableArray *valueArrays))block
{
    // 生成归类的keys
    NSMutableArray *muKeys = [NSMutableArray array];
    for (id object in self) {
        NSString *classifyKey = [object valueForKey:key];
        if (classifyKey &&
            [classifyKey isKindOfClass:[NSString class]] &&
            ![muKeys hasString:classifyKey]) {
            [muKeys addObject:classifyKey];
        }
    }
    
    NSMutableArray *muValueArrays = [NSMutableArray array];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *classifyKey in muKeys) {
        NSMutableArray *muValues = [NSMutableArray array];
        for (id object in self) {
            NSString *classifyKey1 = [object valueForKey:key];
            if ([classifyKey1 isEqualToString:classifyKey]) {
                [muValues addObject:object];
            }
        }
        [muValueArrays addObject:muValues];
        [result addObjectsFromArray:muValues];
    }
    
    if (block) {
        block(muKeys , muValueArrays);
    }
    return result;
}

- (BOOL)hasString:(NSString *)string
{
    for (NSString *string1 in self) {
        if ([string isEqualToString:string1]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasObject:(NSObject *)object
{
    for (NSObject *obj in self) {
        if (obj == object) {
            return YES;
        }
    }
    return NO;
}

@end
