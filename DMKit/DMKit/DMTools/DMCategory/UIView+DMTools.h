//
//  UIView+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/29.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DMTools)

#pragma mark - <<setter/getter>>
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (UIView * (^)(CGRect rect))dm_frame;

@end
