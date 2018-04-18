//
//  DMPickerView.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/13.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "DMPickerView.h"

@interface DMPickerView ()
<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation DMPickerView

- (instancetype)initWithBGView:(UIView *)view
{
    if (self = [super initWithBGView:view]) {
        self.picker.delegate = self;
        self.picker.dataSource = self;
    }
    return self;
}


- (void)setDatas:(NSArray *)datas
{
    _datas = [datas copy];
    [self.picker reloadAllComponents];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _datas.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",_datas[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_didSelectedIndex) {
        _didSelectedIndex(row);
    }
}

- (void)show
{
    [super show];
    
    if (_didSelectedIndex) {
        _didSelectedIndex([self.picker selectedRowInComponent:0]);
    }
}


- (void)hide
{
    if (_viewWillHide) {
        _viewWillHide();
    }
    [super hide];
}


@end
