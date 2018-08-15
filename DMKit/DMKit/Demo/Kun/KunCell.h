//
//  KunCell.h
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KunModel;
@interface KunCell : UITableViewCell

@property (nonatomic , strong) KunModel *kun;
@property (nonatomic , strong) NSIndexPath *indexPath;

@property (nonatomic , copy) void (^runAction)(NSIndexPath *path);
@property (nonatomic , copy) void (^mergeAction)(NSIndexPath *path);

@end
