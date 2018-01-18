//
//  ImagePickerTool.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/2/8.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

//@property (nonatomic , strong) ImagePickerTool *imageTool;
//-(ImagePickerTool *)imageTool
//{
//    if (_imageTool == nil) {
//        _imageTool = [[ImagePickerTool alloc] initWithViewController:self];
//        WeakObj(self);
//        _imageTool.didGetImage = ^(UIImage *image){
//            if (image) {
//                selfWeak.photoImageView.image = image;
//                
//            }
//        };
//        
//    }
//    return _imageTool;
//}

//-(void)clickOpenCamera
//{
//    [self.imageTool open];
//}


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface ImagePickerTool : NSObject

-(instancetype)initWithViewController:(UIViewController *)vc isCamera:(BOOL)isCamera;

@property (nonatomic , strong) UIImagePickerController *imagePicker;

/** 用来弹出失败提示的vc,一般是当前最上层vc */
@property (nonatomic , weak) UIViewController *vc;

@property (nonatomic , assign) BOOL isEditing;

@property (nonatomic , strong) void (^didGetImage)(UIImage *image);



/** 打开相机   (必须有vc) */
-(void)open;


@end
