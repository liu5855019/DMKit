//
//  DMPickerView.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/13.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMPickerView : DMBasePickerView

@property (nonatomic , copy) NSArray <NSString *>*datas;

@property (nonatomic , copy) void (^didSelectedIndex)(NSInteger index);

@property (nonatomic , copy) void (^viewWillHide)(void);

@end
