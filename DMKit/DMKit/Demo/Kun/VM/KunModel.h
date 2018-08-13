//
//  KunModel.h
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KunModel : NSObject

@property (nonatomic , strong) NSString *name;
@property (nonatomic , assign) long long initMoney;
@property (nonatomic , assign) long long costMoney;
@property (nonatomic , assign) long long outputMoney;
@property (nonatomic , assign) long leave;
@property (nonatomic , assign) double ratio;
@property (nonatomic , assign) BOOL enable;
@property (nonatomic , assign) BOOL running;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (NSDictionary *)dictionary;


@end
