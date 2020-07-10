//
//  MillionModel.h
//  DMKit
//
//  Created by iMac-03 on 2020/7/10.
//  Copyright © 2020 呆木出品. All rights reserved.
//

#import "BaseViewController.h"


@interface MillionModel : NSObject

+ (instancetype)shareInstance;

@property (nonatomic , assign) double money;



// 写入文件
-(void)saveDatas;
// 删除文件
-(void)removeDatas;


@end


