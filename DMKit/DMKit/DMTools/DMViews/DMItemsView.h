//
//  DMItemsView.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 17/8/15.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMItemsView : UIView
/** 行数  默认2 readOnly */
@property (nonatomic , assign) NSInteger numberOfLines;
/** 一行item数  默认4    2<= item <=5  readOnly */
@property (nonatomic , assign) NSInteger numberOfItemsInLine;
/** 字体大小  默认15  readOnly */
@property (nonatomic , assign) CGFloat titleFont;

@property (nonatomic , copy) void (^didClickButton)(NSInteger index);

//  @[
//@{
//@"title":@"考勤签到",
//@"image":kGetImage(@"home_sign.png"),     //或者url
//@"imageH":kGetImage(@"home_sign_h.png")   //或者url
//}]

@property (nonatomic , copy) NSArray *datas;


- (instancetype)initWithFrame:(CGRect)frame
               numberOfLines:(NSInteger)numberOfLines
         numberOfItemsInLine:(NSInteger)numberOfItemsInLine
                   titleFont:(CGFloat)titleFont
                       datas:(NSArray *)datas
              didClickButton:(void(^)(NSInteger index))didClickButton;

@end









@interface ItemBgView : UIView


@property (nonatomic , assign) NSInteger numberOfLines;
@property (nonatomic , assign) NSInteger numberOfItemsInLine;
@property (nonatomic , assign) CGFloat titleFont;


@property (nonatomic , copy) NSArray *datas;
@property (nonatomic , copy) void (^didClickButton)(NSInteger tag);

@end


@interface ItemButton : UIButton

@property (nonatomic,strong) UIImageView* upIV;
@property (nonatomic,strong) UILabel* downLab;

@end






