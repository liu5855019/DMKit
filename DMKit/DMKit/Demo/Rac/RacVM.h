//
//  RacVM.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/5/8.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RacVM : NSObject

@property (nonatomic , assign) BOOL isLoading;

@property (nonatomic , copy) NSArray *datas;

- (void)loadMyDatas;

@end
