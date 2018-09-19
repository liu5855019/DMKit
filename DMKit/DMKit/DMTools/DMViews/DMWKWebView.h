//
//  DMWKWebView.h
//  iOffice
//
//  Created by 西安旺豆电子信息有限公司 on 2018/9/10.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface DMWKWebView : UIView

@property (nonatomic , weak , readonly) CALayer *progressLayer;
@property (nonatomic , strong , readonly) WKWebView *webView;
@property (nonatomic , copy) NSString *title;   //支持kvo



- (void)loadRequest:(NSURLRequest *)request;

@end
