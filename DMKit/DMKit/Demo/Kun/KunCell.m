//
//  KunCell.m
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "KunCell.h"
#import "KunModel.h"

@interface KunCell ()

@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UIButton *runBtn;
@property (nonatomic , strong) UIButton *mergeBtn;

@end

@implementation KunCell

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
        [self setupLayouts];
    }
    return self;
}

-(void)setupViews
{
    _nameLab = [[UILabel alloc] init];
    _runBtn = [[UIButton alloc] init];
    _mergeBtn = [[UIButton alloc] init];
    
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_runBtn];
    [self.contentView addSubview:_mergeBtn];
    
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.font = kFont(kScaleW(15));
    
    [_mergeBtn setTitle:@"merge" forState:UIControlStateNormal];
    [_mergeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mergeBtn addTarget:self action:@selector(clickMergeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_runBtn setTitle:@"run" forState:UIControlStateNormal];
    [_runBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_runBtn addTarget:self action:@selector(clickRunBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setupLayouts
{
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kScaleW(15));
    }];
    
    [_runBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScaleW(10));
        make.right.mas_equalTo(_mergeBtn.mas_left).offset(kScaleW(-15));
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    [_mergeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScaleW(10));
        make.right.mas_equalTo(kScaleW(-15));
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(kScaleW(-10)).priorityHigh();
    }];
    
    
}

- (void)setKun:(KunModel *)kun
{
    _kun = kun;
    
    _nameLab.text = kun.name;
}

- (void)clickMergeBtn
{
    
}

- (void)clickRunBtn
{
    
}

@end
