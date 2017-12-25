//
//  DMWebView.m
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 17/9/8.
//  Copyright © 2017年 西安旺豆. All rights reserved.
////
//
//处理HTMLString的方法：
//
//NSString *htmls = [NSString stringWithFormat:@"<html> \n"
//                   "<head> \n"
//                   "<style type=\"text/css\"> \n"
//                   "body {font-size:15px;}\n"
//                   "</style> \n"
//                   "</head> \n"
//                   "<body>"
//                   "<script type=‘text/javascript‘>"
//                   "window.onload = function(){\n"
//                   "var $img = document.getElementsByTagName(‘img‘);\n"
//                   "for(var p in  $img){\n"
//                   " $img[p].style.width = ‘100%%‘;\n"
//                   "$img[p].style.height =‘auto‘\n"
//                   "}\n"
//                   "}"
//                   "</script>%@"
//                   "</body>"
//                   "</html>",htmlString];
//处理HTMLString的原理：
//
//原理就是用一个for循环，拿到所有的图片，对每个图片都处理一次，让图片的宽为100%，就是按照屏幕宽度自适应；让图片的高atuo，自动适应。文字的字体大小，可以去改font-size:15px，这里我用的是15px。根据自己的具体需求去改吧。




#import "DMWebView.h"

@interface DMWebView () <UIWebViewDelegate>

@property (nonatomic , assign) BOOL isDidFinish;            ///<是否加载完成
@property (nonatomic , assign) BOOL isCallFinishBlock;      ///<是否已经回调高度block

@end

@implementation DMWebView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        _autoFit = YES;
    }
    return self;
}

-(void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    _isCallFinishBlock = NO;
    _isDidFinish = NO;
    
    if (!_autoFit) {
        [super loadHTMLString:string baseURL:baseURL];
        return;
    }
    //［iOS的WebView自适应内容高度］1.设置内容，这里包装一层div，用来获取内容实际高度（像素），htmlcontent是html格式的字符串
    NSString * sizeFitHeightContent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", string];
    
    //禁用UIWebView中双击和手势缩放页面脚本代码
    NSString *disableGestureCode = @"<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes\" />";
    
    //控制webview使用html5的video播放视频不全屏(inline)的
    //    NSString *inlineMediaPlaybackCode = @"<video id=\"player\" width=\"480\" height=\"320\" webkit-playsinline>";
    
    //iOS中用UIWebView的loadHTMLString后图片和文字失调解决方法:
    //用一个for循环，拿到所有的图片，对每个图片都处理一次，让图片的宽为100%，就是按照屏幕宽度自适应；让图片的高atuo，自动适应。文字的字体大小，可以去改font-size:14px，这里我用的是14px。
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height = 'auto'\n"
                       "}\n"
                       "}"
                       "</script>%@\n%@"
                       "</body>"
                       "</html>",sizeFitHeightContent,disableGestureCode];
    
    [super loadHTMLString:htmls baseURL:baseURL];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = self.scrollView.contentSize.height;
        NSLog(@"-------%f--------",height);
        //只有加载完成才改变高度
        if (_isDidFinish && _didFinishHeight) {
            _isCallFinishBlock = YES;
            _didFinishHeight(height);
        }
    }
}

//如果三秒钟内还没有改变高度,则这个方法改变
-(void)changeHeightIfNeed
{
    CGFloat height = self.scrollView.contentSize.height;
    NSLog(@"=======%f=======",height);
    if (!_isCallFinishBlock && _didFinishHeight) {
        _didFinishHeight(height);
    }
}



#pragma mark - delegata

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if (_didClickLink) {
            _didClickLink(request.URL);
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _isDidFinish = YES;

    //如果三秒钟内还没有改变高度,则这个方法改变
    [self performSelector:@selector(changeHeightIfNeed) withObject:nil afterDelay:3];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}



-(void)dealloc{
    MyLog(@" Game Over ... ");
    
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
}



@end
