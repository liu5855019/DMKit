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

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size scale:(CGFloat)scale;


#pragma mark - property

/** 是否含有alpha通道 //此处参考了yykit */
- (BOOL)hasAlphaChannel;

/** 解决 create img with CIImage 的时候 , cgimg = NULL问题 */
- (CGImageRef)dm_CGImage;
/** 结果 create img with CGImage 的时候 , ciimg = nil 问题 */
- (CIImage *)dm_CIImage;
/** 返回一个CGImage创建的UIImage  ps:如果本身就是cg创建的返回自己, 否则重新创建 */
- (UIImage *)imageCreateWithCGImage;
/** 返回灰度图 */
- (UIImage *)grayImage;


#pragma mark - draw
/** 在矩形上划线 */
- (UIImage *)drawLineWithRect:(CGRect)rect lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

/** 裁剪矩形图片 */
- (UIImage *)cutWithRect:(CGRect)rect;

/** 按比例重置图片Size */
- (UIImage *)reSizeWithScale:(CGFloat)scale;

/** 重置图片size */
- (UIImage *)reSize:(CGSize)size;

- (UIImage *)reSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;


- (NSArray *)process;

- (UIImage *)writeTexts:(NSArray <NSString *>*)texts;





@end
