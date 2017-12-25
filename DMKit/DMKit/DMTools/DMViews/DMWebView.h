//
//  DMWebView.h
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 17/9/8.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMWebView : UIWebView

@property (nonatomic , assign , getter=isAutoFit) BOOL autoFit;     //默认yes

@property (nonatomic , copy) void (^didClickLink)(NSURL * link);

@property (nonatomic , copy) void (^didFinishHeight)(CGFloat height);

@end
