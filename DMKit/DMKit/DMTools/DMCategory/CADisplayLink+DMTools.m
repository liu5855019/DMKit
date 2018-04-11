//
//  CADisplayLink+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/9.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "CADisplayLink+DMTools.h"
#import <objc/runtime.h>


static char *kCADisplayLinkBlock = "kCADisplayLinkBlock";

@implementation CADisplayLink (DMTools)

+ (CADisplayLink *)displayLinkWithBlock:(void (^)(void))block
{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkAction:)];
    if (block) {
        link.linkBlock = block;
    }
    return link;
}

+ (void)linkAction:(CADisplayLink *)link
{
    if (link.linkBlock) {
        link.linkBlock();
    }
}


- (void (^)(void))linkBlock
{
    return objc_getAssociatedObject(self, kCADisplayLinkBlock);
}

- (void)setLinkBlock:(void (^)(void))linkBlock
{
    if (linkBlock) {
        objc_setAssociatedObject(self, kCADisplayLinkBlock, linkBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}



@end
