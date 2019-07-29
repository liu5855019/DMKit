//
//  DMDatePickerView.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/14.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDatePickerView : UIView

@property (nonatomic, strong) UIView *operateView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIDatePicker *timePicker;

@property (nonatomic , copy) void (^sureBlock)(NSDate *date);

- (void)show;

- (void)hide;

- (instancetype)initWithDate:(NSDate *)date block:(void (^)(NSDate *date))block;

+ (DMDatePickerView *)pickerWithDate:(NSDate *)date block:(void (^)(NSDate *date))block;

+ (DMDatePickerView *)showWithDate:(NSDate *)date block:(void (^)(NSDate *date))block;

@end
