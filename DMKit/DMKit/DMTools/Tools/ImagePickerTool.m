//
//  ImagePickerTool.m
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/2/8.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "ImagePickerTool.h"


@interface ImagePickerTool () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic , assign) BOOL isCamera;

@end

@implementation ImagePickerTool


-(instancetype)initWithViewController:(UIViewController *)vc isCamera:(BOOL)isCamera
{
    if (self = [super init]) {
        _vc = vc;
        _isCamera = isCamera;
    }
    return self;
}


-(UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        if (_isCamera) {//相机
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                
                [DMTools showAlertWithTitle:nil andContent:kLocStr(@"没有可以使用的相机!") andBlock:nil atVC:_vc];
                
                return nil;
            }
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = NO;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //后置摄像头
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            //设置闪光灯为自动
            _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            _imagePicker.showsCameraControls = YES;
            _imagePicker.allowsEditing = _isEditing;
        }else{//相册
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                [DMTools showAlertWithTitle:nil andContent:kLocStr(@"没有可以使用的相册!") andBlock:nil atVC:_vc];
                
                return nil;
            }
            _imagePicker = [[UIImagePickerController alloc]init];
            UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePicker.sourceType = sourcheType;
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = _isEditing;
            
        }
    }
    return _imagePicker;
}


-(void)open
{
    if (self.imagePicker == nil) {
        return;
    }
    
    if (_isCamera) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            NSLog(@"照相服务没有打开");
            [DMTools showAlertWithTitle:nil andContent:@"照相机服务没有打开,是否前往打开?" andSureBlock:^{
                
                if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Photos"]];
                }
                
            } andCancelBlock:nil andSureTitle:@"是" andCancelTitle:@"否" atVC:_vc];
        }else{
            NSAssert(_vc, @"UIViewController for present cannot be nil");
            [_vc presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }else{//相册
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            
            //无权限
            
            [DMTools showAlertWithTitle:nil andContent:@"相册权限没有打开,是否前往打开?" andSureBlock:^{
                
                if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Photos"]];
                }
                
            } andCancelBlock:nil andSureTitle:@"是" andCancelTitle:@"否" atVC:_vc];
            
        }else{
            NSAssert(_vc, @"UIViewController for present cannot be nil");
            [_vc presentViewController:self.imagePicker animated:YES completion:nil];
        }

    }
    
}

#pragma mark - delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    
    UIImage *image = nil;
    
    if (_isEditing) {
        image = info[@"UIImagePickerControllerEditedImage"];
    }else{
        image = info[@"UIImagePickerControllerOriginalImage"];
    }
    
//    if (image.imageOrientation == UIImageOrientationLeft) {
//        image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
//    }else{
//        image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
//    }

    if (_didGetImage) {
        _didGetImage(image);
    }
    
    [_vc dismissViewControllerAnimated:YES completion:nil];

}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}



@end
