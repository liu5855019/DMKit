//
//  DMBasePickerView.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/13.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "DMBasePickerView.h"


#define kPickerH 216

@interface DMBasePickerView ()
{
    CGRect _upRect;
    CGRect _downRect;
}

@property (nonatomic , strong) CADisplayLink *link;

@end

@implementation DMBasePickerView

- (instancetype)initWithBGView:(UIView *)view
{
    if (self = [super initWithFrame:view.frame]) {
        NSLog(@"%@",NSStringFromCGRect(view.frame));
        self.backgroundColor = kGetColorRGBA(0, 0, 0, 0.1);
        [view addSubview:self];
        
        _upRect = CGRectMake(0, kGetH(view) - kPickerH, kGetW(view), kPickerH);
        _downRect  = CGRectMake(0, kGetH(view), kGetW(view), kPickerH);
        
        _picker = [[UIPickerView alloc] initWithFrame:_downRect];
        [self addSubview:_picker];
        _picker.backgroundColor = [UIColor whiteColor];
        
        [super setHidden:YES];
        
        [self createLink];
    }
    return self;
}

#pragma mark - link

- (void)createLink
{
    WeakObj(self);
    _link = [CADisplayLink displayLinkWithBlock:^{
        selfWeak.backgroundColor = [selfWeak anySubViewScrolling:selfWeak.picker] ? [[UIColor redColor] colorWithAlphaComponent:0.1]: kGetColorRGBA(0, 0, 0, 0.1);
    }];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

//检查当前是否有滚动
- (BOOL)anySubViewScrolling:(UIView *)view
{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setHidden:(BOOL)hidden
{
    if (hidden) {
        [self hide];
    }else{
        [self show];
    }
}

- (void)show
{
    [super setHidden:NO];
    WeakObj(self);
    [UIView animateWithDuration:0.3 animations:^{
        selfWeak.picker.frame = _upRect;
    }];
}
- (void)hide
{
    WeakObj(self);
    if (_hideAction) {
        _hideAction();
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        selfWeak.picker.frame = _downRect;
    } completion:^(BOOL finished) {
        [super setHidden:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

- (void)dealloc
{
    [_link invalidate];
    _link = nil;
    MyLog(@" Game Over ... ");
}

@end

