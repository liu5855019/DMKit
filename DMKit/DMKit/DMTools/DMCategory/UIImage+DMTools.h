//
//  UIImage+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/23.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DMTools)

#pragma mark - create

+ (UIImage *)dm_imageWithCIImage:(CIImage *)ciImage;




/** 解决 create img with CIImage 的时候 , cgimg = NULL问题 */
- (CGImageRef)dm_CGImage;
/** 结果 create img with CGImage 的时候 , ciimg = nil 问题 */
- (CIImage *)dm_CIImage;

/** 在矩形上划线 */
- (UIImage *)drawLineWithRect:(CGRect)rect lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

/** 裁剪矩形图片 */
- (UIImage *)cutWithRect:(CGRect)rect;


- (NSArray *)process;






@end
