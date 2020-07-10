//
//  MillionCell.m
//  DMKit
//
//  Created by iMac-03 on 2020/7/10.
//  Copyright © 2020 呆木出品. All rights reserved.
//

#import "MillionCell.h"

@interface MillionCell ()

@property (weak, nonatomic) IBOutlet UILabel *oldLab;
@property (weak, nonatomic) IBOutlet UILabel *inLab;
@property (weak, nonatomic) IBOutlet UILabel *changeLab;
@property (weak, nonatomic) IBOutlet UILabel *resultLab;


@end

@implementation MillionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MillionResultModel *)model
{
    _model = model;
    
    _oldLab.text = [NSString stringWithFormat:@"%.2f",model.oldMoney];
    
    _inLab.text = [NSString stringWithFormat:@"%d%% -- %.2f",(int)(model.inRatio*100),model.inMoney];
    
    _changeLab.text = [NSString stringWithFormat:@"%.2f",model.changeMoney];
    _changeLab.textColor = model.isWin ? [UIColor redColor] : [UIColor greenColor];
    
    _resultLab.text = [NSString stringWithFormat:@"%.2f",model.resultMoney];
}

@end
