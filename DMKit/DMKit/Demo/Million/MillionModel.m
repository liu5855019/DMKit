//
//  MillionModel.m
//  DMKit
//
//  Created by iMac-03 on 2020/7/10.
//  Copyright © 2020 呆木出品. All rights reserved.
//

#import "MillionModel.h"

@interface MillionModel ()

@end

@implementation MillionModel

+ (instancetype)shareInstance
{
    static MillionModel *millionModel;
       if (millionModel) {
           return millionModel;
       }
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           NSString *filePath = [DMTools filePathInDocuntsWithFile:@"MillionModel"];
           millionModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

           if (!millionModel) {
               millionModel = [[self alloc] init];
               millionModel.money = 5000;
           }
       });

       return millionModel;
}



- (void)saveDatas
{
    NSString *filePath = [DMTools filePathInDocuntsWithFile:@"MillionModel"];

    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

- (void)removeDatas
{
    //删除归档的文件
    NSString *filePath = [DMTools filePathInDocuntsWithFile:@"MillionModel"];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

#pragma mark - NSCoding

//  解档协议方法
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.money = [coder decodeDoubleForKey:@"money"];
    }
    return self;
}

//  归档协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.money forKey:@"money"];
}


@end
