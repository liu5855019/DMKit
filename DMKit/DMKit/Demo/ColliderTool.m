//
//  ColliderTool.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/16.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "ColliderTool.h"

@interface ColliderTool ()



@property (nonatomic , assign) BOOL isRuning;

@end

@implementation ColliderTool

+ (instancetype)shareTool
{
    static ColliderTool *tool;
    if (tool) {
        return tool;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
        tool.results = [NSMutableArray array];
    });
    return tool;
}

- (void)begin
{
    if (_isRuning) {
        return;
    }
    _isRuning = YES;
    
    BACK((^{
        
        NSString *str = @"123456";
        NSString *md5 = str.MD5;
        
        NSLog(@"begin");
        for (NSInteger i = 0; i < 1000000000; i++) {
            @autoreleasepool{
                NSString *str1 = [[NSString alloc] initWithFormat:@"%ld",i];
                if ([str1.MD5 isEqualToString:md5]) {
                    [_results addObject:str1];
                    if (self.getResult) {
                        MAIN(^{
                            self.getResult([self.results copy]);
                        });
                    }
                }
                if (i % 100000 == 0) {
                    if (self.runAt) {
                        MAIN(^{
                            self.runAt(str1);
                        });
                    }
                }
            }
        }
        _isRuning = NO;
        NSLog(@"The end");
    }));
}


@end
