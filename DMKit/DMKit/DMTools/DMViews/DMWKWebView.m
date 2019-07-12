//
//  DMWKWebView.m
//  iOffice
//
//  Created by 西安旺豆电子信息有限公司 on 2018/9/10.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "DMWKWebView.h"

@interface DMWKWebView () <WKNavigationDelegate , WKUIDelegate>

@end

@implementation DMWKWebView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupWebview];
        [self setupProgress];
    }
    return self;
}


- (void)setupWebview
{
    //config
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    
    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
    [self addSubview:_webView];
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    AdjustsScrollViewInsetNever([[UIViewController alloc] init], _webView.scrollView);
    
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)setupProgress
{
    UIView *progress = [[UIView alloc] init];
    progress.frame = CGRectMake(0, 0, kGetW(self), 3);
    progress.backgroundColor = [UIColor  clearColor];
    [self addSubview:progress];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor greenColor].CGColor;
    [progress.layer addSublayer:layer];
    _progressLayer = layer;
    
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
    }];
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        self.progressLayer.frame = CGRectMake(0, 0, kScreenW*[change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        
        if ([change[@"new"]floatValue] == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
                self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = change[@"new"];
    } 
}




#pragma mark - WKNavigationDelegate
/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始加载页面");
}
/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始返回内容");
}
/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载完成");
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载失败 请求数据时发生的error ");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面加载失败 请求之后加载H5发生的error %@ ",error);
}


/* 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSLog(@"request:%@",navigationAction.request.URL.absoluteString);
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"response:%@",navigationResponse.response.URL.absoluteString);
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"认证???");
    
    if([challenge.protectionSpace.authenticationMethod
        isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,cred);
    }
}

#pragma mark - action

- (void)loadRequest:(NSURLRequest *)request
{
    if (@available(iOS 9.0, *)) {
        if (request.URL.fileURL) {
            [self.webView loadFileURL:request.URL allowingReadAccessToURL:request.URL];
        } else {
            [self.webView loadRequest:request];
        }
    } else {
        [self.webView loadRequest:request];
    }
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];

    MyLog(@" Game Over ... ");
}


@end
