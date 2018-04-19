//
//  VisionDebugCell.m
//  DMKit
//
//  Created by 呆木 on 2018/4/19.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "VisionDebugCell.h"

@interface VisionDebugCell ()

@property (nonatomic , strong) UIImageView *imgV;

@end

@implementation VisionDebugCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    _imgV = [UIImageView new];
    [self.contentView addSubview:_imgV];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5).priorityHigh();
        make.centerX.mas_equalTo(0);
    }];
}

- (void)setImg:(UIImage *)img
{
    _imgV.image = img;
    
    if (img == nil) {
        return;
    }
    
    [_imgV mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat w = img.size.width > kScreenW-10 ? kScreenW-10 : img.size.width;
        CGFloat h = img.size.height / img.size.width * w;
        
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
    }];
}

@end
