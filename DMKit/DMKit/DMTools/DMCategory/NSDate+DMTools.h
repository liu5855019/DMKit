//
//  NSDate+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/18.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DMTools)

#define yyyyMMddHHmmss @"yyyy-MM-dd HH:mm:ss"
#define yyyyMMddHHmm  @"yyyy-MM-dd HH:mm"
#define yyyyMMdd @"yyyy-MM-dd"
#define HHmmss @"HH:mm:ss"

#pragma mark - formatter

/**
 *  根据传入的Str生成formatter
 */
+ (NSDateFormatter *)getDateFormatterWithFormatterString:(NSString *) formatterStr;
/**
 *  dateformatter : @"yyyy-MM-dd HH:mm:ss"
 */
+ (NSDateFormatter *)getDetailDateFormatter;


#pragma  mark - date

- (NSUInteger)year;
- (NSUInteger)month;
- (NSInteger)day;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;

- (NSUInteger)weekDay;          ///< 1...7
- (NSString *)weekDayString;    ///< cn || en



/**
 *  相对现在日期得间隔天数
 */
- (NSString *)getDetailTimeAgoString;

/**
 *  相对现在日期得间隔天数
 */
+ (NSString *)getDetailTimeAgoStringByInterval:(long long)timeInterval;

/**
 *  从字符串获得时间
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 *  从时间获得字符串
 */
- (NSString *)getStringWithFormat:(NSString *)string;

/**
 *  从时间获得字符串: @"yyyy-MM-dd HH:mm:ss"
 */
- (NSString *)getStringWithDetailFormatter;


#pragma mark - NSTimeInterval
/**
 *  /Date(1477297275594+0800)/ ----> 1477297275594
 */
+ (NSTimeInterval)timeIntervalWithString:(NSString *)dateStr;





@end
