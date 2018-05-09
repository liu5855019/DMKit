//
//  RacModel.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/5/8.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RacModel : NSObject

@property (nonatomic )double Location_x;
@property (nonatomic )double Location_y;
@property (nonatomic ,copy)NSString *location;
@property (nonatomic ,copy)NSString *date;
@property (nonatomic ,copy)NSString *onTime;
@property (nonatomic ,copy)NSString *offTime;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
