//
//  RacCell.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/5/8.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "RacCell.h"

@implementation RacCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    
    _dateLab = [UILabel new];
    _signInLab = [UILabel new];
    _inTimeLab = [UILabel new];
    _addressLab = [UILabel new];
    _signOutLab = [UILabel new];
    _outTimeLab = [UILabel new];
    
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_signInLab];
    [self.contentView addSubview:_inTimeLab];
    [self.contentView addSubview:_signOutLab];
    [self.contentView addSubview:_addressLab];
    [self.contentView addSubview:_outTimeLab];
    
    
    _dateLab.textColor = [UIColor orangeColor];
    _dateLab.font = kFont(kScaleW(15));
    
    _signInLab.textColor = [UIColor blackColor];
    _signInLab.font = kFont(kScaleW(15));
    
    _inTimeLab.textColor = [UIColor lightGrayColor];
    _inTimeLab.font = kFont(kScaleW(15));
    
    _addressLab.textColor = [UIColor blackColor];
    _addressLab.font = kFont(kScaleW(15));
    _addressLab.numberOfLines = 0;
    
    _signOutLab.textColor = [UIColor blackColor];
    _signOutLab.font = kFont(kScaleW(15));
    
    _outTimeLab.textColor = [UIColor lightGrayColor];
    _outTimeLab.font = kFont(kScaleW(15));
    
    _signInLab.text = @"签到";
    _signOutLab.text = @"签退";
}

- (void)setupLayouts
{
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    
    [_signInLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dateLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
    }];
    
    [_inTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_signInLab);
        make.right.mas_equalTo(-15);
    }];
    
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signInLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [_signOutLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10).priorityHigh();
    }];
    
    [_outTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_signOutLab);
        make.right.mas_equalTo(-15);
    }];
    
}




@end
