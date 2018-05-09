//
//  RacModel.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/5/8.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "RacModel.h"

@implementation RacModel


-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        if (![dict[@"Location_x"] isKindOfClass:[NSNull class]]) {
            self.Location_x = [dict[@"Location_x"] doubleValue];
        }
        if (![dict[@"Location_y"] isKindOfClass:[NSNull class]]) {
            self.Location_y = [dict[@"Location_y"] doubleValue];
        }
        if (![dict[@"date"] isKindOfClass:[NSNull class]]) {
            self.date = [self dateToDateString:dict[@"date"]];
        }
        if (![dict[@"onTime"] isKindOfClass:[NSNull class]]) {
            self.onTime = [self dateToHourString:dict[@"onTime"]];
        }
        if (![dict[@"offTime"] isKindOfClass:[NSNull class]]) {
            self.offTime = [self dateToHourString:dict[@"offTime"]];
        }
        if (![dict[@"Location_Name"] isKindOfClass:[NSNull class]]) {
            self.location = dict[@"Location_Name"];
        }
        
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

-(NSString *)dateToDateString:(NSString *)date{
    NSTimeInterval doubleDate = [NSDate timeIntervalWithString:date];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:doubleDate];
    
    return [date1 getStringWithFormat:yyyyMMdd];
}
-(NSString *)dateToHourString:(NSString *)date{
    NSTimeInterval doubleDate = [NSDate timeIntervalWithString:date];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:doubleDate];
    return [date1 getStringWithFormat:@"HH:mm"];
}


@end
