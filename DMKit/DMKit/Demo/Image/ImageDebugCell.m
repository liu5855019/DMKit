//
//  ImageDebugCell.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/28.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "ImageDebugCell.h"


@interface ImageDebugCell ()

@property (nonatomic , strong) UIImageView *imgV;

@end


@implementation ImageDebugCell

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
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(kScreenW);
        make.height.mas_lessThanOrEqualTo(kScreenW);
    }];
}

- (void)setImg:(UIImage *)img
{
    _imgV.image = img;
}


@end
