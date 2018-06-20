//
//  DMShadowView.h
//  iOffice
//
//  Created by 西安旺豆电子信息有限公司 on 2018/6/19.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMShadowView : UIView

@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , strong) UIColor *borderColor;
@property (nonatomic , assign) CGFloat borderWidth;
@property (nonatomic , strong) UIColor *shadowColor;
@property (nonatomic , assign) CGFloat shadowRadius;
@property (nonatomic , assign) CGFloat shadowOpacity;
@property (nonatomic ) CGSize shadowOffset;
@property (nonatomic , assign) CGFloat cornerRadius;

@end
