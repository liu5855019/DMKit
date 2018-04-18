//
//  CADisplayLink+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/9.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (DMTools)

/** 解决link造成循环引用问题 */
+ (CADisplayLink *)displayLinkWithBlock:(void (^)(void))block;


@property (nonatomic, strong) void (^linkBlock)(void);  ///<此block不要使用

@end
