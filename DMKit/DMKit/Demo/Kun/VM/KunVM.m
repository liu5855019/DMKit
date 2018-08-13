//
//  KunVM.m
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "KunVM.h"

@interface KunVM ()

@end

@implementation KunVM

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"init ");
        [self readFromFile];
    }
    return self;
}

- (void)buy:(KunModel *)kun
{
    if (_ownList.count >= 15) {
        NSLog(@"渔场已经满了!");
        return;
    }
    if (_money < kun.costMoney) {
        NSLog(@"金币不够!");
        return;
    }
    
    _money -= kun.costMoney;
    
    [_ownList addObject:[KunModel modelWithDict:kun.dictionary]];
    kun.leave++;
    kun.costMoney = kun.initMoney;
    for (int i = 2; i < kun.leave; i++) {
        kun.costMoney = kun.costMoney * kun.ratio;
    }
}




- (void)readFromFile
{
    NSString *json;
    if (json.length == 0) {
        [self createModels];
        _ownList = [NSMutableArray array];
        [_ownList addObject:[self createFirstKun]];
    }
}

- (void)writeToFile
{
    
}



#pragma mark - create

- (void)createModels
{
    KunModel *firstKun = [self createFirstKun];
    KunModel *currentKun = firstKun;
    NSMutableArray *muarray = [NSMutableArray array];
    [muarray addObject:firstKun];
    for (int i = 2; i < 40; i++) {
        KunModel *model = [[KunModel alloc] init];
        model.name = [NSString stringWithFormat:@"%d",i];
        model.initMoney = currentKun.initMoney * 2 * 1.2;
        model.costMoney = model.initMoney;
        model.outputMoney = currentKun.outputMoney * 2;
        model.leave = 1;
        model.ratio = currentKun.ratio + 0.01;
        model.enable = NO;
        currentKun = model;
        [muarray addObject:model];
    }
    
    self.shopList = muarray;
    
}

- (KunModel *)createFirstKun
{
    KunModel *model = [[KunModel alloc] init];
    model.name = [NSString stringWithFormat:@"%d",1];
    model.initMoney = 100;
    model.costMoney = model.initMoney;
    model.outputMoney = 10;
    model.leave = 1;
    model.ratio = 1.1;
    model.enable = YES;
    return model;
}


@end
