//
//  ImageDebugVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/26.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "ImageDebugVC.h"
#import "ImageDebugCell.h"
#import "YYFPSLabel.h"


@interface ImageDebugVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , strong) NSMutableArray *images;

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@property (nonatomic , strong) ImagePickerTool *tool;

@end

@implementation ImageDebugVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"Debug Image";
    
    _images = [NSMutableArray array];
    
    [self.view addSubview:self.tabV];
    
    
    
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.y = 100;
    _fpsLabel.x = 10;
    _fpsLabel.alpha = 1;
    [self.view addSubview:_fpsLabel];
    
    
    WeakObj(self);
    BACK(^{
//        [selfWeak testUIimgCGimgCIimg];
//
//        [selfWeak testImageFps];
        
        [selfWeak testImageInfo];
        
        [selfWeak testColors];
//        [selfWeak testImageOrientation];
    });
}

- (ImagePickerTool *)tool
{
    if (_tool == nil) {
        _tool = [[ImagePickerTool alloc] initWithViewController:self isCamera:YES];
    }
    return _tool;
}

- (void)testColors
{
    UIImage *img = [UIImage imageWithContentsOfFile:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Downloads/01.png"];
    
    
    [_images addObject:img];
   
    
   
    UIImage *resultUIImage = img.grayImage;
    
    [_images addObject:resultUIImage];
    
    
    
    
    WeakObj(self);
    MAIN(^{
        [selfWeak.tabV reloadData];
    });
}

- (void)testImageOrientation
{
    NSString *path = @"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/001.png";
    UIImage *img1 =  [UIImage imageWithContentsOfFile:path];
    
    [_images addObject:img1];
    
    NSLog(@"%@ %ld",img1,(long)img1.imageOrientation);
    
    
    UIImage *img2 = [UIImage imageWithCGImage:img1.CGImage scale:img1.scale orientation:UIImageOrientationLeft];
    [_images addObject:img2];
    NSLog(@"%@ %ld",img2,(long)img2.imageOrientation);
    
    
    
    path = @"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/002.png";
    UIImage *img3 =  [UIImage imageWithContentsOfFile:path];
    [_images addObject:img3];
    NSLog(@"%@ %ld",img3,(long)img3.imageOrientation);
    
    WeakObj(self);
    MAIN(^{
        [selfWeak.tabV reloadData];
    });
}

- (void)changeImage:(UIImage *)img
{
    
    
}


- (void)testUIimgCGimgCIimg
{
    UIImage *img = [UIImage imageWithColor:kRandomColor size:CGSizeMake(200, 200)];
    
    [_images addObject:img];
    
    //imgWithCGimg 会重新生成img  //同时会把生成它的cgimg存下来
    CGImageRef ref = img.CGImage;
    img = [UIImage imageWithCGImage:ref];
    if (ref == img.CGImage) {
        NSLog(@"把生成它的cgimg存下来了");
    }
    if (!img.CIImage) {
        NSLog(@"ciimg == nil");
    }
    [_images addObject:img];
    
    //测试cgimg >> data
    NSData *data = UIImagePNGRepresentation(img);
    if (data.length) {
        NSLog(@"cgimg >> uiimg >> data  成功!");
    } else {
        NSLog(@"cgimg >> uiimg >> data  失败!");
    }
    
    
    
    //imgWithCIImg  也会重新生成img   //同时会把生成它的ciimg存下来
    CIImage *ciImg = [[CIImage alloc] initWithImage:img];
    img = [UIImage imageWithCIImage:ciImg];
    if (ciImg == img.CIImage) {
        NSLog(@"把生成它的ciimg存下来了");
    }
    if (!img.CGImage) {
        NSLog(@"cgimg == nil");
    }
    [_images addObject:img];
    
    //测试ciimg >> data
    data = UIImagePNGRepresentation(img);
    if (data.length) {
        NSLog(@"ciimg >> uiimg >> data  成功!");
    } else {
        NSLog(@"ciimg >> uiimg >> data  失败!");
    }
    
    img = img.imageCreateWithCGImage;
    
    NSLog(@"%@",img.CGImage);
    data = UIImagePNGRepresentation(img);
    if (data.length) {
        NSLog(@"cgimg >> uiimg >> data  成功!");
    } else {
        NSLog(@"cgimg >> uiimg >> data  失败!");
    }
    
    WeakObj(self);
    MAIN(^{
        [selfWeak.tabV reloadData];
    });
}

- (void)testImageFps
{
    UIColor *color1 = kRandomColor;
    UIColor *color2 = kRandomColor;
    
    //create from CIImage
    for (int i = 0; i < 20; i++) {
        UIImage *img = [UIImage imageWithColor:color1 size:CGSizeMake(200, 200)];
        CIImage *ciImg = [CIImage imageWithCGImage:img.dm_CGImage];
        img = [UIImage imageWithCIImage:ciImg];
        [_images addObject:img];
    }
    
    //create from CGImage
    for (int i = 0; i < 20; i++) {
        [_images addObject:[UIImage imageWithColor:color2 size:CGSizeMake(200, 200)]];
    }
    
    WeakObj(self);
    MAIN(^{
        [selfWeak.tabV reloadData];
    });
}


- (void)testImageInfo
{
    UIColor *color = kRandomColor;
    
    UIImage *img = [UIImage imageWithColor:color size:CGSizeMake(200, 200) scale:3];
    [_images addObject:img];
    NSLog(@"%@ , scale: %f",img,img.scale); 
    
    img = [UIImage imageWithColor:color size:CGSizeMake(200, 200) scale:2];
    [_images addObject:img];
    NSLog(@"%@ , scale: %f",img,img.scale);
    
    img = [UIImage imageWithColor:color size:CGSizeMake(200, 200) scale:1];
    [_images addObject:img];
    NSLog(@"%@ , scale: %f",img,img.scale);
    
    img = [UIImage imageWithColor:color size:CGSizeMake(200, 200) scale:0.1];
    [_images addObject:img];
    NSLog(@"%@ , scale: %f",img,img.scale);
    
    WeakObj(self);
    MAIN(^{
        [selfWeak.tabV reloadData];
    });
}



#pragma mark - TableView
- (UITableView *)tabV{
    if (_tabV == nil) {
        _tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, kNAV_HEIGHT, kScreenW, kScreenH - kNAV_HEIGHT - kSAFE_BOTTOM_HEIGHT) style:UITableViewStylePlain];
        AdjustsScrollViewInsetNever(self, _tabV);
        
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tabV.estimatedRowHeight = 60;
        _tabV.rowHeight = UITableViewAutomaticDimension;
        _tabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_tabV registerClass:[ImageDebugCell class] forCellReuseIdentifier:@"ImageDebugCell"];
    }
    return _tabV;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _images.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageDebugCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageDebugCell"];
    
    cell.img = _images[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenW;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
