//
//  RacCell.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/5/8.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RacCell : UITableViewCell

@property (nonatomic , strong) UILabel *dateLab;
@property (nonatomic , strong) UILabel *inTimeLab;
@property (nonatomic , strong) UILabel *addressLab;
@property (nonatomic , strong) UILabel *outTimeLab;


@property (nonatomic , strong) UILabel *signInLab;
@property (nonatomic , strong) UILabel *signOutLab;

@end
