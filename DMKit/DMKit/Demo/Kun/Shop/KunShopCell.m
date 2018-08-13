//
//  KunShopCell.m
//  DMKit
//
//  Created by 呆木 on 2018/8/11.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "KunShopCell.h"
#import "KunModel.h"

@interface KunShopCell ()

@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UIButton *buyBtn;

@end

@implementation KunShopCell

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
    _moneyLab = [[UILabel alloc] init];
    _buyBtn = [[UIButton alloc] init];
    
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_moneyLab];
    [self.contentView addSubview:_buyBtn];
    
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.font = kFont(kScaleW(15));
    
    _moneyLab.textColor = [UIColor redColor];
    _moneyLab.font = kFont(kScaleW(15));
    
    [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_buyBtn addTarget:self action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
    _buyBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buyBtn.layer.borderWidth = kLineH;
    _buyBtn.layer.cornerRadius = 6;
    
}

-(void)setupLayouts
{
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kScaleW(15));
    }];
    
    [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScaleW(10));
        make.right.mas_equalTo(kScaleW(-15));
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(kScaleW(-10)).priorityHigh();
    }];
}

- (void)clickBuyBtn
{
    if (_buyAction) {
        _buyAction(_kun);
    }
}

- (void)setKun:(KunModel *)kun
{
    _kun = kun;
    
    _nameLab.text = kun.name;
    _moneyLab.text = [@(kun.costMoney) stringValue];
    _buyBtn.enabled = kun.enable;
}

@end
