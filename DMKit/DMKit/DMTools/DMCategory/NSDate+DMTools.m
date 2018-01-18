//
//  NSDate+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/18.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "NSDate+DMTools.h"

@implementation NSDate (DMTools)


#pragma mark - formatter

/**
 *  根据传入的Str生成formatter
 */
+ (NSDateFormatter *)getDateFormatterWithFormatterString:(NSString *) formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    return formatter;
}

/**
 *  dateformatter : @"yyyy-MM-dd HH:mm:ss"
 */
+ (NSDateFormatter *)getDetailDateFormatter
{
    return [self getDateFormatterWithFormatterString:yyyyMMddHHmmss];
}


#pragma  mark - date

- (NSUInteger)year
{
    NSDateFormatter *formatter = [NSDate getDateFormatterWithFormatterString:@"yyyy"];
    NSString *str = [formatter stringFromDate:self];
    return [str integerValue];
}

- (NSUInteger)month
{
    NSDateFormatter *formatter = [NSDate getDateFormatterWithFormatterString:@"MM"];
    NSString *str = [formatter stringFromDate:self];
    return [str integerValue];
}

- (NSInteger)day
{
    NSDateFormatter *formatter = [NSDate getDateFormatterWithFormatterString:@"dd"];
    NSString *str = [formatter stringFromDate:self];
    return [str integerValue];
}

- (NSUInteger)hour
{
    NSDateFormatter *formatter = [NSDate getDateFormatterWithFormatterString:@"HH"];
    NSString *str = [formatter stringFromDate:self];
    return [str integerValue];
}

- (NSUInteger)minute
{
    NSDateFormatter *formatter = [NSDate getDateFormatterWithFormatterString:@"mm"];
    NSString *str = [formatter stringFromDate:self];
    return [str integerValue];
}

- (NSUInteger)second
{
    NSDateFormatter *formatter = [NSDate getDateFormatterWithFormatterString:@"ss"];
    NSString *str = [formatter stringFromDate:self];
    return [str integerValue];
}

- (NSUInteger)weekDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    //我们的习惯是周一为第一天，那么我们改一下就OK了
    NSUInteger wDay = [weekdayComponents weekday];
    //将第一天设为周日
    if (wDay == 1) {
        wDay = 7;
    }else{
        wDay = wDay - 1;
    }
    return wDay;
}

- (NSString *)weekDayString
{
    NSArray *weekArray =nil;
    if ([DMTools isEnglish]) {
        weekArray = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday", @"Saturday", @"Sunday"];
    } else {
        weekArray = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"];
    }
    
    return weekArray[[self weekDay] - 1];
}



/**
 *  相对现在日期得间隔天数
 */
- (NSString *)getDetailTimeAgoString
{
    if ([DMTools checkIsNullObject:self])
    {
        return nil;
    }
    long long timeNow = [self timeIntervalSince1970];
    
    NSInteger year = self.year;
    NSInteger month = self.month;
    NSInteger day = self.day;
    
    NSDate * today = [NSDate date];
    
    NSInteger t_year = today.year;
    
    NSString* string = nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    if(distance < 60)
        string=@"刚刚";
    else if(distance < 60*60)
        string=[NSString stringWithFormat:@"%lld分钟前",distance/60];
    else if(distance < 60*60*24)
        string=[NSString stringWithFormat:@"%lld小时前",distance/60/60];
    else if(distance < 60*60*24*7)
        string=[NSString stringWithFormat:@"%lld天前",distance/60/60/24];
    else if(year == t_year)
        string=[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
    else
        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    
    return string;
}

/**
 *  相对现在日期得间隔天数
 */
+ (NSString *)getDetailTimeAgoStringByInterval:(long long)timeInterval
{
    return [[self dateWithTimeIntervalSince1970:timeInterval] getDetailTimeAgoString];
}

/**
 *  从字符串获得时间
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [self getDateFormatterWithFormatterString:format];
    return [formatter dateFromString:string];
}

/**
 *  从时间获得字符串
 */
- (NSString *)getStringWithFormat:(NSString *)string
{
    return [[NSDate getDateFormatterWithFormatterString:string] stringFromDate:self];
}

/**
 *  从时间获得字符串: @"yyyy-MM-dd HH:mm:ss"
 */
- (NSString *)getStringWithDetailFormatter
{
    return [self getStringWithFormat:yyyyMMddHHmmss];
}


#pragma mark - NSTimeInterval
/**
 *  /Date(1477297275594+0800)/ ----> 1477297275594
 */
+ (NSTimeInterval)timeIntervalWithString:(NSString *)dateStr
{
    if (dateStr.length == 0) {
        return 0;
    }
    NSArray *strArr = [dateStr componentsSeparatedByString:@"("];
    NSString *str = strArr.lastObject;
    strArr = [str componentsSeparatedByString:@"+"];
    return [strArr.firstObject doubleValue]/1000.0f;
}







@end
