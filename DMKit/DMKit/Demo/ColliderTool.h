//
//  ColliderTool.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/16.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColliderTool : NSObject

+ (instancetype)shareTool;

- (void)begin;

@property (nonatomic , copy) void (^runAt)(NSString *index);

@property (nonatomic , copy) void (^getResult)(NSArray *result);

@property (nonatomic , strong) NSMutableArray *results;

@end
