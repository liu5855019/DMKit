//
//  KunModel.m
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "KunModel.h"

@implementation KunModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.initMoney = [dict[@"initMoney"] longLongValue];
        self.costMoney = [dict[@"costMoney"] longLongValue];
        self.outputMoney = [dict[@"outputMoney"] longLongValue];
        self.leave = [dict[@"leave"] longValue];
        self.ratio = [dict[@"ratio"] doubleValue];
        self.enable = [dict[@"enable"] boolValue];
        self.running = [dict[@"running"] boolValue];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[KunModel alloc] initWithDict:dict];
}

- (NSDictionary *)dictionary
{
    return @{
             @"name":self.name,
             @"initMoney":[NSNumber numberWithLongLong:self.initMoney],
             @"costMoney":[NSNumber numberWithLongLong:self.costMoney],
             @"outputMoney":[NSNumber numberWithLongLong:self.outputMoney],
             @"leave":[NSNumber numberWithLong:self.leave],
             @"ratio":[NSNumber numberWithDouble:self.ratio],
             @"enable":[NSNumber numberWithBool:self.enable],
             @"running":[NSNumber numberWithBool:self.running]
             };
}

@end
