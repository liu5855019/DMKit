//
//  DMAlertView.m
//  YiTieRAS
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/9.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "DMAlertView.h"

@interface DMAlertView ()

@property (nonatomic , strong) UIControl *backgroundView;
@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , strong) UIButton *closeBtn;

@end

@implementation DMAlertView

-(instancetype)initWithCustomView:(UIView *)aView
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _isHideWhenTouchBackground = NO;
        
        //backgroundView
        _backgroundView = [[UIControl alloc] init];
        _backgroundView.frame = self.frame;
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        _backgroundView.alpha = 0;
        [_backgroundView addTarget:self action:@selector(clickBackgroundView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
        
        _contentView = aView;
        aView.center = CGPointMake(kScreenW/2, kScreenH/2);
        [self addSubview:aView];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:kGetImage(@"alert_close.png") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(aView.mas_bottom).offset(kScaleW(36));
            make.centerX.mas_equalTo(0);
        }];
    }
    
    return self;
}

-(void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:.25 animations:^{
        _backgroundView.alpha = 1;
        _contentView.alpha = 1;
    }];

}

-(void)hide
{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)clickBackgroundView
{
    [self endEditing:YES];
    
    if (_isHideWhenTouchBackground) {
        [self hide];
    }
}

-(void)clickCloseBtn
{
    [self hide];
    if (_closeAction) {
        _closeAction();
    }
}

-(void)hideCloseBtn
{
    _closeBtn.hidden = YES;
}

@end
