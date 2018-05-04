//
//  UIImage+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/23.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "UIImage+DMTools.h"
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>



@implementation UIImage (DMTools)


#pragma mark - create

+ (UIImage *)dm_imageWithCIImage:(CIImage *)ciImage
{
    CGImageRef imgRef = [[CIContext context] createCGImage:ciImage fromRect:ciImage.extent];

    UIImage *newImg = [UIImage imageWithCGImage:imgRef];
    
    CGImageRelease(imgRef);

    return newImg;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    return [self imageWithColor:color size:size scale:1.0];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size scale:(CGFloat)scale
{
    CGFloat alpha;
    [color getValueR:nil G:nil B:nil A:&alpha];
    
    UIGraphicsBeginImageContextWithOptions(size, alpha == 1, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImg;
}

#pragma mark - Property

- (BOOL)hasAlphaChannel
{
    if (self.CGImage == NULL) {
        return NO;
    }
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

/** 解决 create img with CIImage 的时候 , cgimg = NULL问题 */
- (CGImageRef)dm_CGImage
{
    if (self.CGImage) {
        return self.CGImage;
    }
    if (self.CIImage) {
        return [[CIContext context] createCGImage:self.CIImage fromRect:self.CIImage.extent];
    }
    return NULL;
}

/** 结果 create img with CGImage 的时候 , ciimg = nil 问题 */
- (CIImage *)dm_CIImage
{
    if (self.CIImage) {
        return self.CIImage;
    }
    return [[CIImage alloc] initWithImage:self];
}

/** 返回一个CGImage创建的UIImage  ps:如果本身就是cg创建的返回自己, 否则重新创建 */
- (UIImage *)imageCreateWithCGImage
{
    if (self.CGImage) {
        return self;
    }
    if (self.CIImage) {
        return [UIImage dm_imageWithCIImage:self.CIImage];
    }
    return self;
}

#pragma mark - draw

// 在矩形上划线
- (UIImage *)drawLineWithRect:(CGRect)rect lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //绘制颜色区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    [lineColor setStroke];
    [path setLineWidth:lineWidth];
    [path stroke];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 裁剪矩形图片
- (UIImage *)cutWithRect:(CGRect)rect
{
    CGImageRef img = CGImageCreateWithImageInRect(self.dm_CGImage, rect);
    
    UIImage *newImg = [UIImage imageWithCGImage:img];
    
    CGImageRelease(img);
    
    return newImg;
}

/** 按比例重置图片Size */
- (UIImage *)reSizeWithScale:(CGFloat)scale
{
    return [self reSize:CGSizeMake(self.size.width * scale, self.size.height *scale)];
}

- (UIImage *)reSize:(CGSize)size
{
    if (size.width < 0 || size.height < 0) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(size, self.hasAlphaChannel, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImg;
}



//- (UIImage *)reSize:(CGSize)size contentMode:(UIViewContentMode)contentMode
//{
//    UIGraphicsBeginImageContextWithOptions(size, self.hasAlphaChannel, self.scale);
//
//
//    //[self drawInRect:CGRectMake(0, 0, size.width, size.height) withContentMode:contentMode clipsToBounds:NO];
//}

- (NSArray *)process
{
//    colorMonochromeFilterInputColor = CIColor(red: 0.75, green: 0.75, blue: 0.75)
//    colorControls = (0.4, 0.2, 1.1)
//    exposureAdjustEV = 0.7
//    gaussianBlurSigma = 0.4
//    smoothThresholdFilter = (0.35, 0.85)
//    unsharpMask = (2.5, 0.5)
    
    NSMutableArray *muarray= [NSMutableArray array];
    
    CIImage *ciImg = self.dm_CIImage;
    
    //1. 灰度图 --> 主要用来做文字识别所以直接去掉色彩信息
    CIColor *filterInputcolor = [CIColor colorWithRed:0.75 green:0.75 blue:0.75];
    //只有在主动设置的时候才丢弃颜色信息
    //CIColorMonochrome  单色滤镜
    ciImg = [ciImg imageByApplyingFilter:@"CIColorMonochrome" withInputParameters:@{kCIInputColorKey : filterInputcolor}];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    
    //2. 提升亮度 --> 会损失一部分背景纹理 饱和度不能太高
    NSDictionary *para = @{
                           kCIInputSaturationKey : @(0.4),  //饱和度
                           kCIInputBrightnessKey : @(0.2),  //亮度
                           kCIInputContrastKey : @(1.1)     //对比度
                           };
    
    //CIColorControls 调整饱和度、亮度和对比度值
    ciImg = [ciImg imageByApplyingFilter:@"CIColorControls" withInputParameters:para];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    
    //3. 曝光调节  CIExposureAdjust
    ciImg = [ciImg imageByApplyingFilter:@"CIExposureAdjust" withInputParameters:@{kCIInputEVKey : @(0.7)}];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    //4.  高斯模糊
    ciImg = [ciImg imageByApplyingGaussianBlurWithSigma:0.4];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    //5. 去燥
//
//    NSString *colorKernelStr = @"kernel vec4 color(__sample pixel, float inputEdgeO, float inputEdge1){    float luma = dot(pixel.rgb, vec3(0.2126, 0.7152, 0.0722));    float threshold = smoothstep(inputEdgeO, inputEdge1, luma);    return vec4(threshold, threshold, threshold, 1.0);}";
//
//    CIColorKernel *colorKernel = [CIColorKernel kernelWithString:colorKernelStr];
//
//    if (colorKernel) {
//        NSNumber *inputEdgeO = @(0.35);
//        NSNumber *inputEdge1 = @(0.85);
//
//        ciImg = [colorKernel applyWithExtent:ciImg.extent arguments:@[ciImg , inputEdgeO,inputEdge1]];
//
//        [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
//    }
    
    //6. 增强文字轮廓
    para = @{
             kCIInputRadiusKey : @(2.5),
             kCIInputIntensityKey : @(0.5),
             };
    
    ciImg = [ciImg imageByApplyingFilter:@"CIUnsharpMask" withInputParameters:para];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    
    para = @{
             kCIInputRadiusKey : @(2.5),
             kCIInputIntensityKey : @(0.5),
             };
    
    ciImg = [ciImg imageByApplyingFilter:@"CIUnsharpMask" withInputParameters:para];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    
    para = @{
             kCIInputRadiusKey : @(2.5),
             kCIInputIntensityKey : @(0.5),
             };
    
    ciImg = [ciImg imageByApplyingFilter:@"CIUnsharpMask" withInputParameters:para];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    
    para = @{
             kCIInputRadiusKey : @(2.5),
             kCIInputIntensityKey : @(0.5),
             };
    
    ciImg = [ciImg imageByApplyingFilter:@"CIUnsharpMask" withInputParameters:para];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    
    para = @{
             kCIInputRadiusKey : @(2.5),
             kCIInputIntensityKey : @(0.5),
             };
    
    ciImg = [ciImg imageByApplyingFilter:@"CIUnsharpMask" withInputParameters:para];
    
    [muarray addObject:[UIImage dm_imageWithCIImage:ciImg]];
    
    return muarray;
}


//+ (CGRect)fitSize:(CGSize)oSize toSize:(CGSize)toSize withContentMode:(UIViewContentMode)mode
//{
//    oSize.width = oSize.width < 0 ? -oSize.width : oSize.width;
//
//    rect = CGRectStandardize(rect);
//    size.width = size.width < 0 ? -size.width : size.width;
//    size.height = size.height < 0 ? -size.height : size.height;
//    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
//    switch (mode) {
//        case UIViewContentModeScaleAspectFit:
//        case UIViewContentModeScaleAspectFill: {
//            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
//                size.width < 0.01 || size.height < 0.01) {
//                rect.origin = center;
//                rect.size = CGSizeZero;
//            } else {
//                CGFloat scale;
//                if (mode == UIViewContentModeScaleAspectFit) {
//                    if (size.width / size.height < rect.size.width / rect.size.height) {
//                        scale = rect.size.height / size.height;
//                    } else {
//                        scale = rect.size.width / size.width;
//                    }
//                } else {
//                    if (size.width / size.height < rect.size.width / rect.size.height) {
//                        scale = rect.size.width / size.width;
//                    } else {
//                        scale = rect.size.height / size.height;
//                    }
//                }
//                size.width *= scale;
//                size.height *= scale;
//                rect.size = size;
//                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
//            }
//        } break;
//        case UIViewContentModeCenter: {
//            rect.size = size;
//            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
//        } break;
//        case UIViewContentModeTop: {
//            rect.origin.x = center.x - size.width * 0.5;
//            rect.size = size;
//        } break;
//        case UIViewContentModeBottom: {
//            rect.origin.x = center.x - size.width * 0.5;
//            rect.origin.y += rect.size.height - size.height;
//            rect.size = size;
//        } break;
//        case UIViewContentModeLeft: {
//            rect.origin.y = center.y - size.height * 0.5;
//            rect.size = size;
//        } break;
//        case UIViewContentModeRight: {
//            rect.origin.y = center.y - size.height * 0.5;
//            rect.origin.x += rect.size.width - size.width;
//            rect.size = size;
//        } break;
//        case UIViewContentModeTopLeft: {
//            rect.size = size;
//        } break;
//        case UIViewContentModeTopRight: {
//            rect.origin.x += rect.size.width - size.width;
//            rect.size = size;
//        } break;
//        case UIViewContentModeBottomLeft: {
//            rect.origin.y += rect.size.height - size.height;
//            rect.size = size;
//        } break;
//        case UIViewContentModeBottomRight: {
//            rect.origin.x += rect.size.width - size.width;
//            rect.origin.y += rect.size.height - size.height;
//            rect.size = size;
//        } break;
//        case UIViewContentModeScaleToFill:
//        case UIViewContentModeRedraw:
//        default: {
//            rect = rect;
//        }
//    }
//    return rect;
//}


@end
