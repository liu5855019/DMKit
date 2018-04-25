//
//  VisionDebugVC.m
//  DMKit
//
//  Created by 呆木 on 2018/4/19.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "VisionDebugVC.h"
#import "VisionDebugCell.h"
#import <Vision/Vision.h>
#import <CoreImage/CoreImage.h>

@interface VisionDebugVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) ImagePickerTool *tool;

@property (nonatomic , strong) UIBarButtonItem *rightItem;

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , strong) UIImage *currentImg;

@property (nonatomic , strong) NSMutableArray *subImgs;

@end

@implementation VisionDebugVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"本页需要 iOS 11+";
    
    self.navigationItem.rightBarButtonItem = self.rightItem;

    [self.view addSubview:self.tabV];
    
    _subImgs = [NSMutableArray array];

}

- (void)makeImage
{
    [_subImgs removeAllObjects];
    WeakObj(self);
    if (@available(iOS 11.0, *)) {
        BACK(^{
            [selfWeak cutMaxRectImage];
        });
    } else {
        // Fallback on earlier versions
    }
    
    [_tabV reloadData];
}

#pragma mark - cutMaxRectImage

- (void)cutMaxRectImage API_AVAILABLE(ios(11.0))
{
    WeakObj(self);
    VNDetectRectanglesRequest *request = [[VNDetectRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        
        NSArray * result = request.results;
        
        if (result.count == 0) {
            NSLog(@"没有找到最大矩形");
            return ;
        }
        
        //查找最大的矩形
        VNRectangleObservation *maxOb = result.firstObject;
        for (int i = 1 ; i < result.count ; i++)
        {
            VNRectangleObservation *ob = result[i];
            if (ob.boundingBox.size.width * ob.boundingBox.size.height > maxOb.boundingBox.size.width * maxOb.boundingBox.size.height)
            {
                maxOb = ob;
            }
        }
        
        //在图中选中最大的矩形
        CGSize size = selfWeak.currentImg.size;

        CGFloat w = maxOb.boundingBox.size.width * size.width;
        CGFloat h = maxOb.boundingBox.size.height * size.height;
        CGFloat x = maxOb.boundingBox.origin.x * size.width;
        CGFloat y = size.height - maxOb.boundingBox.origin.y * size.height - h;
        
        CGRect rect = CGRectMake(x,y,w,h);
        
        //标出最大矩形位置
        UIImage *img = [selfWeak drawLineInImg:selfWeak.currentImg rect:rect];
        [selfWeak.subImgs addObject:img];
        
        
        //填充最大矩形位置   获取到的位置原点在左下角,
        CGPoint topLeft = CGPointMake(maxOb.topLeft.x * size.width, size.height - maxOb.topLeft.y * size.height);
        CGPoint topRight = CGPointMake(maxOb.topRight.x * size.width, size.height -maxOb.topRight.y * size.height);
        CGPoint bottomLeft = CGPointMake(maxOb.bottomLeft.x * size.width, size.height - maxOb.bottomLeft.y * size.height);
        CGPoint bottomRight = CGPointMake(maxOb.bottomRight.x * size.width, size.height - maxOb.bottomRight.y * size.height);
        img = [selfWeak drawFillImImg:selfWeak.currentImg topL:topLeft topR:topRight bottomL:bottomLeft bottomR:bottomRight];
        [selfWeak.subImgs addObject:img];
        
        
        //透视矫正
        img = [selfWeak perspectiveCorrectionUIimg:selfWeak.currentImg box:maxOb.boundingBox topL:maxOb.topLeft topR:maxOb.topRight bottomL:maxOb.bottomLeft bottomR:maxOb.bottomRight];
        [selfWeak.subImgs addObject:img];
        
        
        [selfWeak.subImgs addObjectsFromArray:[img process]];
        //[selfWeak.subImgs addObject:img];
        
        
        MAIN(^{
            [selfWeak.tabV reloadData];
        });
        
        [selfWeak cutTextImg:selfWeak.subImgs.lastObject];

    }];
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:_currentImg.CGImage options:@{}];
    
    [handler performRequests:@[request] error:nil];

}


#pragma mark  cutTextImg

- (void)cutTextImg:(UIImage *)oImg API_AVAILABLE(ios(11.0))
{
    WeakObj(self);
    VNDetectTextRectanglesRequest *request = [[VNDetectTextRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        
        NSArray *result = request.results;
        
        if (result.count == 0) {
            NSLog(@"没有找到文字");
            return;
        }
        
        NSLog(@"找到%ld组文字",result.count);
        
        CGSize size = oImg.size;
        
        UIImage *resultImg = oImg;
        for (VNTextObservation *text in result) {
            //在图中选中矩形
            CGFloat w = text.boundingBox.size.width * size.width;
            CGFloat h = text.boundingBox.size.height * size.height;
            CGFloat x = text.boundingBox.origin.x * size.width;
            CGFloat y = size.height - text.boundingBox.origin.y * size.height - h;
            
            CGRect rect = CGRectMake(x,y,w,h);
            
            //标出矩形位置
            resultImg = [resultImg drawLineWithRect:rect lineColor:[UIColor redColor] lineWidth:3];
            [selfWeak.subImgs addObject:resultImg];
//            //剪切矩形
//            UIImage *subImg = [oImg cutWithRect:rect];
//            [selfWeak.subImgs addObject:subImg];
//
//            //处理图片
//            [selfWeak.subImgs addObjectsFromArray:[subImg process]];
//
//            subImg = selfWeak.subImgs.lastObject;
//            CGSize subSize = subImg.size;
            NSLog(@"字数: %ld ",text.characterBoxes.count);
            for (int i = 0 ; i < text.characterBoxes.count ; i ++) {
                CGRect box = [text.characterBoxes[i] boundingBox];

                w = box.size.width * size.width;
                h = box.size.height * size.height;
                x = box.origin.x * size.width;
                y = size.height - box.origin.y * size.height - h;

                CGRect subRect = CGRectMake(x,y, w, h);
                resultImg = [resultImg drawLineWithRect:subRect lineColor:[UIColor blueColor] lineWidth:2];
                [selfWeak.subImgs addObject:resultImg];
                NSLog(@"%d ...",i);
            }
            
            
            NSLog(@"处理完一条");
            
            MAIN(^{
            
                [selfWeak.tabV reloadData];
                NSLog(@"刷新了列表");
            });
            
        }
        
        MAIN(^{
            [selfWeak.tabV reloadData];
        });
    }];
    
    
    request.reportCharacterBoxes = YES;
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:oImg.dm_CGImage options:@{}];
    
    [handler performRequests:@[request] error:nil];
}




#pragma mark -



// 矩形透视矫正
- (UIImage *)perspectiveCorrectionUIimg:(UIImage *)img
                               box:(CGRect)box
                              topL:(CGPoint)topL
                              topR:(CGPoint)topR
                           bottomL:(CGPoint)bottomL
                           bottomR:(CGPoint)bottomR
{
    
    CGSize size = img.size;
    
    //计算出要剪切的矩形位置
    CGFloat w = box.size.width * size.width;
    CGFloat h = box.size.height * size.height;
    CGFloat x = box.origin.x * size.width;
    CGFloat y = box.origin.y * size.height;
    CGRect rect = CGRectMake(x,y,w,h);
    
    //剪切矩形
    CIImage *ciImg = [[CIImage imageWithCGImage:img.CGImage] imageByCroppingToRect:rect];
    
    
    //矫正
    CGPoint topLeft = CGPointMake(topL.x * size.width, topL.y * size.height);
    CGPoint topRight = CGPointMake(topR.x * size.width, topR.y * size.height);
    CGPoint bottomLeft = CGPointMake(bottomL.x * size.width, bottomL.y * size.height);
    CGPoint bottomRight = CGPointMake(bottomR.x * size.width, bottomR.y * size.height);
    
    NSDictionary *para = @{
                           @"inputTopLeft": [CIVector vectorWithCGPoint:topLeft],
                           @"inputTopRight": [CIVector vectorWithCGPoint:topRight],
                           @"inputBottomLeft": [CIVector vectorWithCGPoint:bottomLeft],
                           @"inputBottomRight": [CIVector vectorWithCGPoint:bottomRight]
                           };
    
    ciImg = [ciImg imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:para];
    
    return [UIImage imageWithCGImage:[[CIContext context] createCGImage:ciImg fromRect:ciImg.extent]];
}

//填充img区域
- (UIImage *)drawFillImImg:(UIImage *)img
                      topL:(CGPoint)topL
                      topR:(CGPoint)topR
                   bottomL:(CGPoint)bottomL
                   bottomR:(CGPoint)bottomR
{
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:topL];
    [path addLineToPoint:bottomL];
    [path addLineToPoint:bottomR];
    [path addLineToPoint:topR];
    [path addLineToPoint:topL];
    
    [[[UIColor orangeColor] colorWithAlphaComponent:0.3] setFill];
    [path fill];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)drawLineInImg:(UIImage *)img rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];

    //绘制颜色区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    [[UIColor redColor] setStroke];
    [path setLineWidth:2];
    [path stroke];

   
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - imgtool

- (ImagePickerTool *)tool
{
    if (_tool == nil) {
        _tool = [[ImagePickerTool alloc] initWithViewController:self isCamera:NO];
        WeakObj(self);
        _tool.didGetImage = ^(UIImage *image) {
            selfWeak.currentImg = image;
            [selfWeak makeImage];
        };
    }
    return _tool;
}

#pragma mark - rightItem

-(UIBarButtonItem *)rightItem
{
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    }
    return _rightItem;
}

-(void)clickRightItem
{
    [self.tool open];
}


#pragma mark - TableView
- (UITableView *)tabV{
    if (_tabV == nil) {
        _tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tabV.estimatedRowHeight = 60;
        _tabV.rowHeight = UITableViewAutomaticDimension;
        _tabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_tabV registerClass:[VisionDebugCell class] forCellReuseIdentifier:@"VisionDebugCell"];
    }
    return _tabV;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_currentImg ? 1 : 0) + _subImgs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VisionDebugCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisionDebugCell"];

    if (indexPath.row == 0) {
        cell.img = _currentImg;
    } else {
        cell.img = _subImgs[indexPath.row -1];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    MyLog(@" Game Over ... ");
}

@end
