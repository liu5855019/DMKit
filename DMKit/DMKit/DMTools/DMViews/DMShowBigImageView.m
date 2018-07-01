//
//  DMShowBigImageView.m
//  iOffice_sh
//
//  Created by 西安旺豆电子信息有限公司 on 2018/6/19.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "DMShowBigImageView.h"

@interface DMShowBigImageView ()

@property (nonatomic , strong) UIImageView *originIV;

@property (nonatomic , strong) UIImageView *imgV;

@end

@implementation DMShowBigImageView

+ (void)showAtWindowWithOriginIV:(UIImageView *)originIV
{
    if (originIV == nil || originIV.image == nil) {
        return;
    }
    
    DMShowBigImageView *view = [[DMShowBigImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    view.originIV = originIV;
    
    [view show];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _imgV = [UIImageView new];
        [self addSubview:_imgV];
        
        //添加点击手势（即点击图片后退出全屏）
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeImageView)];
        [_imgV addGestureRecognizer:tapGesture];
        _imgV.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setOriginIV:(UIImageView *)originIV
{
    _originIV = originIV;
    _imgV.frame = [originIV convertRect:originIV.bounds toView:[UIApplication sharedApplication].keyWindow];
    _imgV.image = originIV.image;
}


- (void)show
{
    float imageViewW = kScreenW * 0.88;
    float imageViewH = imageViewW * _originIV.image.size.height / _originIV.image.size.width ;
    
    CGRect rect = CGRectMake((kScreenW - imageViewW) / 2 , (kGetH(self) - imageViewH) / 2, imageViewW, imageViewH);
    
    WeakObj(self);
    [UIView animateWithDuration:0.25 animations:^{
        selfWeak.imgV.frame = rect;
        selfWeak.alpha = 1;
    }];
}

-(void)closeImageView
{
    WeakObj(self);
    [UIView animateWithDuration:0.25 animations:^{
        selfWeak.imgV.frame = [selfWeak.originIV convertRect:selfWeak.originIV.bounds toView:[UIApplication sharedApplication].keyWindow];
        selfWeak.alpha = 0;
    } completion:^(BOOL finished) {
        [selfWeak.imgV removeFromSuperview];
        [selfWeak removeFromSuperview];
    }];
}

- (void)dealloc
{
    MyLog(@" Game Over ... ");
}

@end
