//
//  DMSegmentView.h
//  TinyBenefit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/18.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSegmentView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                        views:(NSArray <UIView *> *)views
                       titles:(NSArray <NSString *>*)titles
                   titleColor:(UIColor *)titleColor
           titleSelectedColor:(UIColor *)selectedColor
                   showAction:(void(^)(NSInteger index))showAction;




@end
