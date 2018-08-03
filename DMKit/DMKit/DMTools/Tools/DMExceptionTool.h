//
//  DMExceptionTool.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/10.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#define DMLog(...) do{\
NSLog(__VA_ARGS__);\
[DMExceptionTool writeLog:[NSString stringWithFormat:@"%@ %s 第%d行 :%@\n",[[NSDate date] getStringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"],__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]]];\
}while(0)

static NSString * const kNeedUoloadID = @"-- need uoload id --";


#import <Foundation/Foundation.h>

@interface DMExceptionTool : NSObject

+ (void)start;

/** 发送信息 */
+ (void)sendInfo:(id)info code:(NSString *)code desc:(NSString *)desc;

+ (void)writeLog:(NSString *)log;

@end
