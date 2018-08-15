//
//  KunVM.h
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KunModel.h"

@interface KunVM : NSObject

@property (nonatomic , assign) long long money;

@property (nonatomic , copy) NSArray *shopList;
@property (nonatomic , strong) NSMutableArray *ownList;



- (void)buy:(KunModel *)kun;
- (void)mergeKun:(KunModel *)kun;

- (void)update; 
- (void)writeToFile;

@end
