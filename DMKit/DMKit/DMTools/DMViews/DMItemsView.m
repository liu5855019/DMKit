//
//  ItemsView.m
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 17/8/15.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import "DMItemsView.h"
#import "UIImageView+WebCache.h"


@interface DMItemsView () <UIScrollViewDelegate>

@property (nonatomic , copy) NSArray *pageArray;

@property (nonatomic , assign) NSInteger currentPage;

@property (nonatomic , strong) UIScrollView *bgScroll;
@property (nonatomic , strong) UIPageControl *pageControl;


@end



@implementation DMItemsView


- (instancetype)initWithFrame:(CGRect)frame
               numberOfLines:(NSInteger)numberOfLines
         numberOfItemsInLine:(NSInteger)numberOfItemsInLine
                   titleFont:(CGFloat)titleFont
                       datas:(NSArray *)datas
              didClickButton:(void(^)(NSInteger index))didClickButton
{
    if (self = [super initWithFrame:frame]) {
        _numberOfLines = numberOfLines;
        _numberOfItemsInLine = numberOfItemsInLine;
        _titleFont = titleFont;
        self.didClickButton = didClickButton;
        self.datas = datas;
        
        [self makeDatas];
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}


- (void)makeDatas
{
    NSInteger numsOfPage = self.numberOfItemsInLine * self.numberOfLines;
    
    NSInteger pageNum = _datas.count ? (_datas.count-1) / numsOfPage + 1 : 0;
    
    
    NSMutableArray *pageArray = [NSMutableArray array];
    for (int j = 0 ; j < pageNum; j ++) {
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0; i < numsOfPage; i++) {
            NSInteger index = j * numsOfPage + i;
            if (index >= _datas.count) {
                break;
            }
            NSDictionary *dict = _datas[index];
            NSMutableDictionary *mudict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mudict addEntriesFromDictionary:@{@"tag":@(1000 + index)}];
            [items addObject:mudict];
        }
        
        [pageArray addObject:items];
    }
    
    _pageArray = [pageArray copy];
    
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat viewW = kGetW(self) - 20;
    CGFloat viewH = kGetH(self) - 10;
    
    _bgScroll = [[UIScrollView alloc] init];
    _bgScroll.frame = CGRectMake(0, 0, kGetW(self), viewH);

    [self addSubview:_bgScroll];
    
    
    NSInteger index = 0;
    for (NSArray *data in _pageArray) {
        ItemBgView *view = [[ItemBgView alloc] initWithFrame:CGRectMake(10 + (kGetW(self)*index), 0, viewW, viewH)];
        
        view.numberOfLines = self.numberOfLines;
        view.numberOfItemsInLine = self.numberOfItemsInLine;
        view.titleFont = self.titleFont;
        
        view.datas = data;
        WeakObj(self);
        view.didClickButton = ^(NSInteger tag){
            if (selfWeak.didClickButton) {
                selfWeak.didClickButton(tag-1000);
            }
        };
        
        [_bgScroll addSubview:view];
        index++;
    }
    
    _bgScroll.backgroundColor = [UIColor clearColor];
    _bgScroll.delegate = self;
    _bgScroll.pagingEnabled = YES;
    _bgScroll.showsVerticalScrollIndicator = NO;
    _bgScroll.showsHorizontalScrollIndicator = NO;
    _bgScroll.bounces = NO;
    _bgScroll.contentSize = CGSizeMake(kGetW(self) * _pageArray.count, 0);
    
    
    _pageControl = [[UIPageControl alloc] init];
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = 2;
    _pageControl.pageIndicatorTintColor = kGetColorRGB(171, 197, 244);
    _pageControl.currentPageIndicatorTintColor = kGetColorRGB(82, 138, 242);
    _pageControl.defersCurrentPageDisplay = YES;
    
    _pageControl.hidden = !(_pageArray.count > 1);
    
}

- (void)setupLayouts
{
    [_bgScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-kScaleW(10));
        make.right.mas_equalTo(0);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-kScaleW(10));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(kScaleW(20));
    }];
}


//结束拖拽,将要减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        //如果不减速,则滚动结束
        self.pageControl.currentPage = self.bgScroll.contentOffset.x/self.bgScroll.frame.size.width;
        
    }
}

//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = self.bgScroll.contentOffset.x/self.bgScroll.frame.size.width;
    
}


- (UIButton *)getButtonWithTag:(NSInteger)tag
{
    for (UIView *view in _bgScroll.subviews) {
        if ([view isKindOfClass:[ItemBgView class]]) {
            ItemBgView *itemsView = (ItemBgView *)view;
            for (UIView *view in itemsView.subviews) {
                if (view.tag == tag) {
                    return (UIButton *)view;
                }
            }
        }
    }
    return nil;
}



- (NSInteger)numberOfLines
{
    if (_numberOfLines == 0) {
        return 2;
    }
    if (_numberOfLines < 1) {
        return 1;
    }
    return _numberOfLines;
}

- (NSInteger)numberOfItemsInLine
{
    if (_numberOfItemsInLine == 0) {
        return 4;
    }
    if (_numberOfItemsInLine > 5) {
        return 5;
    }
    if (_numberOfItemsInLine < 2) {
        return 2;
    }
    return _numberOfItemsInLine;
}

- (CGFloat)titleFont
{
    if (_titleFont == 0) {
        return 15;
    }
    return _titleFont;
}

@end

#pragma mark - ItemBgView

@implementation ItemBgView

- (void)setDatas:(NSArray *)datas
{
    _datas = [datas copy];
    
    [self setupViews];
    
}

- (void)setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    
    
    CGFloat buttonW = kGetW(self)/self.numberOfItemsInLine;
    CGFloat buttonH = kGetH(self)/self.numberOfLines;
    
    
    NSInteger index = 0;
    for (NSDictionary *dict in _datas) {
        
        ItemButton *button = [[ItemButton alloc] initWithFrame:CGRectMake(index%self.numberOfItemsInLine*buttonW , index/self.numberOfItemsInLine*buttonH, buttonW, buttonH)];
        
        if ([dict[@"image"] isKindOfClass:[NSString class]]) {
            [button.upIV sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:nil];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:dict[@"imageH"]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    button.upIV.highlightedImage = image;
                }else{
                    button.upIV.highlightedImage = nil;
                }
            }];
        }else{
            button.upIV.image = dict[@"image"];
            button.upIV.highlightedImage = dict[@"imageH"];
        }
        
        button.downLab.text = dict[@"title"];
        button.downLab.font = [UIFont systemFontOfSize:kScaleW(self.titleFont)];
        button.tag = [dict[@"tag"] integerValue];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        index++;
    }
    
}

- (void)clickButton:(ItemButton *)sender
{
    if (_didClickButton) {
        _didClickButton(sender.tag);
    }
}


@end


#pragma mark - ItemButton

@implementation ItemButton


- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat imageW = (frame.size.width < frame.size.height) ? frame.size.width * 0.55 : frame.size.height * 0.55;
    CGFloat imageH = imageW;
    CGFloat imageX = (frame.size.width - imageW) / 2;
    CGFloat imageY = frame.size.height * 0.1;
    
    CGFloat labelW = frame.size.width;
    CGFloat labelH = frame.size.height - imageH;
    CGFloat labelX = 0;
    CGFloat labelY = imageH;
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        _upIV = imageView;
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        [self addSubview:label];
        _downLab = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        
    }
    return  self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if (self.upIV.highlightedImage) {
        self.upIV.highlighted = YES;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.upIV.highlighted = NO;
}


@end

