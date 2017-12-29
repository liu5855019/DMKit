//
//  DMSegmentView.m
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/18.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import "DMSegmentView.h"
#import "DMDefine.h"


#define kHeaderH 44
#define kUnderLineW kScaleW(40)


@interface DMSegmentView () <UIScrollViewDelegate>

@property (nonatomic , copy) NSArray *views;
@property (nonatomic , copy) NSArray *titles;
@property (nonatomic , copy) void (^showAction)(NSInteger index);

@property (nonatomic , strong) UIFont *titleFont;
@property (nonatomic , strong) UIColor *titleColor;
@property (nonatomic , strong) UIColor *selectedColor;

@property (nonatomic , strong) UIScrollView *headerScroll;
@property (nonatomic , strong) UIView *underLine;

@property (nonatomic , strong) UIScrollView *bgScroll;

@property (nonatomic , assign) NSInteger lastShowTag;

@property (nonatomic , assign) CGFloat titleSpaceW;

@end

@implementation DMSegmentView

- (instancetype)initWithFrame:(CGRect)frame
                        views:(NSArray <UIView *> *)views
                       titles:(NSArray <NSString *>*)titles
                    titleFont:(UIFont *)font
                   titleColor:(UIColor *)titleColor
           titleSelectedColor:(UIColor *)selectedColor
              titlesIsAverage:(BOOL)isAve
                   showAction:(void(^)(NSInteger index))showAction
{
    if (self = [super initWithFrame:frame]) {
        if (views.count > 0) {  // views 必填
            self.views = views;
            self.titles = titles;
            self.titleFont = font;
            self.showAction = showAction;
            self.titleColor = titleColor;
            self.selectedColor = selectedColor;
            
            if (isAve) {
                [self aveTitleSpaceW];
            }
            
            [self setupViews];
        }
    }
    return self;
}

- (void)setupViews
{
    [self setupHeaderViews];
    [self setupPages];
}

#pragma mark - << Action >>

//响应button
-(void)clickTitleBtn:(UIButton *)sender
{
    [self changeBtnColorWithTag:sender.tag];
    
    [_bgScroll setContentOffset:CGPointMake((sender.tag - 1000) * kGetW(self), 0) animated:YES];
}

- (void)changeBtnColorWithTag:(NSInteger)tag
{
    if (tag == _lastShowTag) {
        return;
    }
    _lastShowTag = tag;
    
    if (_showAction) {
        _showAction(tag - 1000);
    }
    
    for (UIButton *aView in _headerScroll.subviews) {
        if ([aView isKindOfClass:[UIButton class]]) {
            [aView setTitleColor:aView.tag == tag ? self.selectedColor : self.titleColor forState:UIControlStateNormal];
        }
    }
    
    UIView *sender = [_headerScroll viewWithTag:tag];
    CGPoint centre = _underLine.center;
    centre.x = [sender center].x;
    WeakObj(self);
    [UIView animateWithDuration:0.25 animations:^{
        selfWeak.underLine.center = centre;
    }];
    
    if (kGetX(sender) < _headerScroll.contentOffset.x) {
        [_headerScroll setContentOffset:CGPointMake(kGetX(sender), 0) animated:YES];
    }
    if (kGetMaxX(sender) > _headerScroll.contentOffset.x + kGetW(self)) {
        CGFloat offset = kGetMaxX(sender) - kGetW(self);
        [_headerScroll setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

- (void)aveTitleSpaceW
{
    CGFloat spaceW = 0;
    //获取所有title的总w
    for (int i = 0; i < _views.count; i++) {
        NSString *title = [_titles dm_objectAtIndex:i];
        title = title ? title : @"";
        CGSize size = kGetTextSize(title, self.titleFont);
        spaceW += size.width + 1;
    }
    //获取剩余W
    spaceW = kGetW(self) - spaceW;
    if (spaceW <= 0) {
        _titleSpaceW = 0;
    }else{
        _titleSpaceW = spaceW / (_views.count * 2);
    }
}

#pragma mark - << Setter/Getter >>

- (CGFloat)titleSpaceW
{
    if (_titleSpaceW == 0) {
        _titleSpaceW = kScaleW(20);
    }
    return _titleSpaceW;
}

- (UIFont *)titleFont
{
    if (_titleFont == nil) {
        _titleFont = kFont(kScaleW(15));
    }
    return _titleFont;
}

- (UIColor *)titleColor
{
    if (_titleColor == nil) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

- (UIColor *)selectedColor
{
    if (_selectedColor == nil) {
        _selectedColor = [UIColor blueColor];
    }
    return _selectedColor;
}

#pragma mark - << Delegate >>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (int)(scrollView.contentOffset.x / kGetW(self));
    [self changeBtnColorWithTag:index + 1000];
}

#pragma mark - << Setup >>

- (void)setupPages
{
    //创建并添加newsHeadScrollView
    _bgScroll = [[UIScrollView alloc] init];
    [self addSubview:_bgScroll];
    [_bgScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerScroll.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    _bgScroll.showsVerticalScrollIndicator = NO;
    _bgScroll.showsHorizontalScrollIndicator = NO;
    _bgScroll.backgroundColor = [UIColor whiteColor];
    _bgScroll.pagingEnabled = YES;
    _bgScroll.delegate = self;
    
    
    
    CGFloat viewW = kGetW(self);
    CGFloat viewH = kGetH(self) - kHeaderH;
    //添加views
    for (int i = 0; i < _views.count; i++) {
        UIView *aView = [_views dm_objectAtIndex:i];
        aView.frame = CGRectMake(i * viewW, 0, viewW, viewH);
        [_bgScroll addSubview:aView];
    }
    _bgScroll.contentSize = CGSizeMake(viewW * _views.count, viewH);
    
}


- (void)setupHeaderViews
{
    //创建并添加headScroll
    _headerScroll = [[UIScrollView alloc] init];
    AdjustsScrollViewInsetNever([UIViewController new], _headerScroll);
    [self addSubview:_headerScroll];
    [_headerScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeaderH);
    }];
    _headerScroll.showsVerticalScrollIndicator = NO;
    _headerScroll.showsHorizontalScrollIndicator = NO;
    
    
    //添加buttons
    for (int i = 0; i < _views.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = self.titleFont;
        NSString *title = [_titles dm_objectAtIndex:i];
        title = title ? title : @"";
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headerScroll addSubview:button];
        
        WeakObj(self);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            CGSize size = kGetTextSize(title, selfWeak.titleFont);
            make.width.mas_equalTo(size.width + 1 + 2*selfWeak.titleSpaceW);
            make.centerY.mas_equalTo(0);
            
            if (i == 0) {
                make.left.mas_equalTo(0);
            }else{
                UIView *aView = [_headerScroll viewWithTag:1000 + i - 1];
                make.left.mas_equalTo(aView.mas_right);
            }
            
            if (i == _views.count - 1) {
                make.right.mas_equalTo(0).priorityHigh();
            }
        }];
    }
    
    //添加underlineView
    _underLine =[[UIView alloc] initWithFrame:CGRectMake(0, kHeaderH - 2, kUnderLineW, 2)];
    [_headerScroll addSubview:_underLine];
    _underLine.backgroundColor = self.selectedColor;
    _underLine.tag = 2000;
    
    [self changeBtnColorWithTag:1000];
    
    //设置underline的初始位置
    NSString *title = [_titles dm_firstObject];
    UIFont *font = kFont(kScaleW(15));
    CGSize size = kGetTextSize(title ? title : @"", font);
    CGFloat w = size.width + 1 + 2*self.titleSpaceW;
    CGPoint centre = _underLine.center;
    centre.x = w/2;
    _underLine.center = centre;
}


@end
