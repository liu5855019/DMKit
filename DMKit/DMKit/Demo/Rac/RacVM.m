//
//  RacVM.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/5/8.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "RacVM.h"
#import "RacModel.h"

@implementation RacVM

- (void)loadMyDatas
{
    self.isLoading = YES;
    
    NSDictionary *para = @{
                           @"id":@"6",
                           @"date":[[NSDate date] getStringWithFormat:yyyyMMddHHmmss]
                           };
    NSString *url = @"http://113.140.67.190:8002/Attend.svc/IAttendList";
    
    WeakObj(self);
    [DMTools postWithUrl:url para:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *array = responseObject[@"AttendListResult"];
        NSMutableArray *datas = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            RacModel *model = [RacModel modelWithDictionary:dict];
            [datas addObject:model];
        }
        
        
        NSMutableArray *muArray = [NSMutableArray arrayWithArray:datas];
        NSString *dateString;
        for (int i = 0; i < datas.count; i++) {
            RacModel *model = datas[i];
            if ([dateString isEqualToString:model.date]) {
                RacModel *model1 = muArray[i];
                model1.date = nil;
            }else if (![dateString isEqualToString:model.date]){
                dateString = model.date;
            }
        }
        
        selfWeak.datas = muArray;
        selfWeak.isLoading = NO;
    
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        selfWeak.isLoading = NO;
    }];

}


@end
