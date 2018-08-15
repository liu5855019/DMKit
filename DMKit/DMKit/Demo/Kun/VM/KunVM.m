//
//  KunVM.m
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "KunVM.h"

#define kKunShop @"kunshop"
#define kKunOwn @"kunown"
#define kKunData @"kundata"


@interface KunVM ()

@property (nonatomic , assign) long long index;

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
    for (int i = 1; i < kun.leave; i++) {
        kun.costMoney = kun.costMoney * kun.ratio;
    }
}

- (void)mergeKun:(KunModel *)kun
{
    for (KunModel *model in _ownList) {
        if (!model.running &&
            [model.name isEqualToString:kun.name] &&
            model != kun) {
            [self mergeKun:kun andKun:model];
            return;
        }
    }
    NSLog(@"没有可以合并的kun");
}

- (void)mergeKun:(KunModel *)kun andKun:(KunModel *)kun1
{
    [_ownList removeObject:kun];
    [_ownList removeObject:kun1];
    
    NSInteger nameid = [kun.name integerValue];
    nameid += 1;
    NSString *name = [NSString stringWithFormat:@"%ld",(long)nameid];
    for (KunModel *model in _shopList) {
        if ([model.name isEqualToString:name]) {
            [_ownList addObject:[KunModel modelWithDict:model.dictionary]];
            if (!model.enable) {
                model.enable = YES;
                NSLog(@"您已解锁kun : %@",model);
            }
            break;
        }
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
    NSMutableArray *muarray = [NSMutableArray array];
    for (KunModel *kun in _shopList) {
        [muarray addObject:kun.dictionary];
    }
    NSString *json = [DMTools getJsonFromDictOrArray:muarray];
    NSString *path = [DMTools filePathInDocuntsWithFile:kKunShop];
    [json writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


- (void)update
{
    _index++;
    
    if (_index % 1 == 0) {
        [self updateMoney];
    }
}

- (void)updateMoney
{
    long long money = 0;
    
    for (KunModel *kun in _ownList) {
        if (kun.running) {
            money += kun.outputMoney;
        }
    }
    _money += money;
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
