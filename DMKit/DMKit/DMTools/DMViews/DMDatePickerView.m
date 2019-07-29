//
//  DMDatePickerView.m
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/14.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "DMDatePickerView.h"

@implementation DMDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.alpha = 0;
    
    UIView *operateView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kSAFE_BOTTOM_HEIGHT + 208)];
    operateView.backgroundColor = [UIColor whiteColor];
    operateView.layer.cornerRadius = 6;
    operateView.clipsToBounds = YES;
    [self addSubview:operateView];
    
    //垂直分割线
    UILabel *leftVerticalLine = [[UILabel alloc] initWithFrame:CGRectMake(operateView.frame.size.width / 4, 0, 0.5, 45)];
    leftVerticalLine.backgroundColor = [UIColor lightGrayColor];
    leftVerticalLine.alpha = 0.5;
    [operateView addSubview:leftVerticalLine];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, operateView.frame.size.width / 4, 45)];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [operateView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    //垂直分割线
    UILabel *rightVerticalLine = [[UILabel alloc] initWithFrame:CGRectMake(operateView.frame.size.width / 4 * 3, 0, 0.5, 45)];
    rightVerticalLine.backgroundColor = [UIColor lightGrayColor];
    rightVerticalLine.alpha = 0.5;
    [operateView addSubview:rightVerticalLine];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(operateView.frame.size.width / 4 * 3, 0, operateView.frame.size.width / 4, 45)];
    [confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [operateView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    //水平分割线
    UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, operateView.frame.size.width, 0.5)];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    horizontalLine.alpha = 0.5;
    [operateView addSubview:horizontalLine];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(operateView.frame.size.width / 4, 0, operateView.frame.size.width / 4 * 2, 45)];
    timeLabel.text = [[NSDate date] getStringWithFormat:yyyyMMddHHmm];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [operateView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    [operateView addSubview:self.timePicker];
    
    _operateView = operateView;
}


- (UIDatePicker *)timePicker
{
    if (!_timePicker) {
        _timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 46, kScreenW, 162)];
        [_timePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _timePicker;
}

#pragma mark - Actions

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _timeLabel.text = [_timePicker.date getStringWithFormat:yyyyMMddHHmm];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        self.operateView.y = kScreenH - (kSAFE_BOTTOM_HEIGHT + 208);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.0f;
        self.operateView.y = kScreenH;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)datePickerChange:(UIDatePicker *)sender
{
    _timeLabel.text = [sender.date getStringWithFormat:yyyyMMddHHmm];
}

- (void)cancelAction
{
    [self hide];
}

- (void)confirmAction
{
    if (_sureBlock) {
        _sureBlock(_timePicker.date);
    }
    [self hide];
}

- (instancetype)initWithDate:(NSDate *)date block:(void (^)(NSDate *date))block
{
    if (self = [super init]) {
        NSDate *aDate = date ? date : [NSDate date];
        
        self.timePicker.date = aDate;
        self.timeLabel.text = [aDate getStringWithFormat:yyyyMMddHHmm];
        
        self.sureBlock = block;
    }
    return self;
}

+ (DMDatePickerView *)pickerWithDate:(NSDate *)date block:(void (^)(NSDate *date))block
{
    DMDatePickerView *aView = [[self alloc] initWithDate:date block:block];
    
    return aView;
}

+ (DMDatePickerView *)showWithDate:(NSDate *)date block:(void (^)(NSDate * _Nonnull))block
{
    DMDatePickerView *aView = [self pickerWithDate:date block:block];
    [aView show];
    return aView;
}
@end
