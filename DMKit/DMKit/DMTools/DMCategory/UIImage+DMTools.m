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

/** 返回灰度图 */
- (UIImage *)grayImage
{
    const int RED = 0;
    const int GREEN = 1;
    const int BLUE = 2;
    //const int ALPHA = 3;
    
    CGSize imgSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    
    //申请存储空间
    size_t memSize = imgSize.width * imgSize.height * sizeof(uint32_t);
    uint32_t *pixels = malloc(memSize);
    memset(pixels, 0, memSize);
    
    
    //创建 context
    //顺序  +   rgba  = rgba kCGImageByteOrder32Big | kCGImageAlphaPremultipliedLast 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, imgSize.width, imgSize.height, 8, imgSize.width * sizeof(uint32_t),colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, imgSize.width, imgSize.height), self.dm_CGImage);
    // 读取 修改色值
    for (int y = 0; y < imgSize.height; y++) {
        for (int x = 0; x < imgSize.width; x++) {
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y*(int)imgSize.width + x];
            
            //uint8_t a = rgbaPixel[ALPHA];
            uint8_t r = rgbaPixel[RED];
            uint8_t g = rgbaPixel[GREEN];
            uint8_t b = rgbaPixel[BLUE];
            //NSLog(@"r:%hhu - g:%hhu - b:%hhu - a:%hhu",r,g,b,a);
            
            uint8_t gray = 0.3*r + 0.59*g + 0.11*b;
            
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *newImg = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:UIImageOrientationUp];
    
    //释放空间
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(pixels);
    CGImageRelease(imgRef);
    
    
    return newImg;
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

- (UIImage *)writeTexts:(NSArray <NSString *>*)texts
{
    if (texts.count < 1) {
        return self;
    }
    
    //缩放基数是960来的
    UIFont *font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:30 * self.size.width / 960.0];
    //设置水印字体
    NSDictionary* dict = @{
                           NSFontAttributeName:font,
                           NSForegroundColorAttributeName:[UIColor redColor]
                           };
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    float border = 16; //边框宽度
    border = border * self.size.width / 960.0; //按比例缩放
    
    float textSpace = 16; //行间距
    textSpace = textSpace * self.size.width / 960.0; //按比例缩放
    
    float textBeginHeight = self.size.height - textSpace; //开始写的左下角总高度
    
    //写入
    for (int i = (int)texts.count-1; i >= 0; i--) {
        NSString *str = texts[i];
        CGSize strSize = [str boundingRectWithSize:CGSizeMake(self.size.width - 2 * border, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        //NSLog(@"w:%f---h:%f",strSize.width,strSize.height);
        
        CGRect rect = CGRectMake(border, textBeginHeight-strSize.height, strSize.width, strSize.height);
        
        [str drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
        
        textBeginHeight -= (textSpace + strSize.height);
    }
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
