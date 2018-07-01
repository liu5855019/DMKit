//
//  DMShadowView.m
//  iOffice
//
//  Created by 西安旺豆电子信息有限公司 on 2018/6/19.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "DMShadowView.h"

@interface DMShadowView ()

@end

@implementation DMShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dm_setupViews];
        [self dm_setupLayouts];
    }
    return self;
}

//避免与子类冲突  起名稍微复杂点
- (void)dm_setupViews
{
    _contentView = [UIView new];
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    
    self.borderColor = [UIColor lightGrayColor];
    self.borderWidth = 0;
    self.shadowColor = [UIColor lightGrayColor];
    self.shadowRadius = 5;
    self.shadowOpacity = 0.25;
    self.shadowOffset = CGSizeMake(0 , 3);
    self.cornerRadius = 6;
}


- (void)dm_setupLayouts
{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - property

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    self.layer.shadowOffset = shadowOffset;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    _contentView.layer.cornerRadius = cornerRadius;
}

@end
