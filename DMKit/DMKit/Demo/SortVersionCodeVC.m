//
//  SortVersionCodeVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/22.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "SortVersionCodeVC.h"

@interface SortVersionCodeVC ()

@end

@implementation SortVersionCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"max:%@",[self max:@"3.2.1" str2:@"3.2.0"]);
    NSLog(@"max:%@",[self max:@"3.2" str2:@"3.2.0"]);
    NSLog(@"max:%@",[self max:@"3.2.1" str2:@"3.2.01"]);
    NSLog(@"max:%@",[self max:@"3.02.1" str2:@"3.2.1"]);
    NSLog(@"max:%@",[self max:@"3.02.1" str2:@"3.2.2"]);
    NSLog(@"max:%@",[self max:@"3.02.0" str2:@"3.2.00.00"]);
    NSLog(@"max:%@",[self max:@"3.02.1" str2:@"4"]);
}

- (NSString *)max:(NSString *)str1 str2:(NSString *)str2
{
    NSArray *arr1 = [str1 componentsSeparatedByString:@"."];
    NSArray *arr2 = [str2 componentsSeparatedByString:@"."];
    
    NSUInteger maxCount = arr1.count > arr2.count ? arr1.count : arr2.count;
    
    for (int i = 0; i < maxCount; i++) {
        NSString *intStr1 = arr1.dm_objectAtIndex(i);
        NSString *intStr2 = arr2.dm_objectAtIndex(i);
        NSUInteger int1 = [intStr1 integerValue];
        NSUInteger int2 = [intStr2 integerValue];
        if (int1 > int2) {
            return str1;
        }
        if (int2 > int1) {
            return str2;
        }
    }
    return  arr1.count > arr2.count ? str1 : str2;
}





@end
