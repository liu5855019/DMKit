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

@property (nonatomic , assign) BOOL isHasBtn;

@property (nonatomic , strong) UIView *btnBgView;
@property (nonatomic , strong) UIButton *sureBtn;
@property (nonatomic , strong) UIButton *cancelBtn;

@property (nonatomic , strong) id currentValue;

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

- (instancetype)initWithBGView:(UIView *)view isHasBtn:(BOOL)hasBtn
{
    if (self = [self initWithBGView:view]) {
        _isHasBtn = hasBtn;
        if (hasBtn) {
            [self createBtns];
        }
    }
    return self;
}

- (void)createBtns
{
    _btnBgView = [UIView new];
    _sureBtn = [UIButton new];
    _cancelBtn = [UIButton new];
    
    [self addSubview:_btnBgView];
    [_btnBgView addSubview:_sureBtn];
    [_btnBgView addSubview:_cancelBtn];
    
    _btnBgView.backgroundColor = [UIColor lightGrayColor];
    
    
    
    _sureBtn.backgroundColor = [UIColor grayColor];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:kScaleW(15)];
    
    _cancelBtn.backgroundColor = [UIColor grayColor];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kScaleW(15)];
    
    
    
    CGFloat height = kScaleW(40);

    _downRect = CGRectMake(_downRect.origin.x, _downRect.origin.y+height, _downRect.size.width, _downRect.size.height);
    _btnBgView.frame = CGRectMake(0, CGRectGetMinY(_downRect) - height, _downRect.size.width, height);
    
    [_btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_picker.mas_top);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kScaleW(-10));
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(kScaleW(80));
    }];
    
    
    
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScaleW(10));
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(kScaleW(80));
    }];
    
}

#pragma mark - link

- (void)createLink
{
    WeakObj(self);
    _link = [CADisplayLink displayLinkWithBlock:^{
        selfWeak.sureBtn.enabled = ![selfWeak anySubViewScrolling:selfWeak.picker];
    }];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

//检查当前是否有滚动
- (BOOL)anySubViewScrolling:(UIView *)view
{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating || scrollView.tracking) {
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

#pragma mark - hidden && show

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
        [selfWeak layoutIfNeeded];
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
        [selfWeak layoutIfNeeded];
    } completion:^(BOOL finished) {
        [super setHidden:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isHasBtn) {
        [self hide];
    }
}

- (void)dealloc
{
    [_link invalidate];
    _link = nil;
    MyLog(@" Game Over ... ");
}




@end

