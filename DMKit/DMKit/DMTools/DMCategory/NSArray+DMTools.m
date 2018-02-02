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



@end
