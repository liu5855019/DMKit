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

@interface VisionDebugVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) ImagePickerTool *tool;

@property (nonatomic , strong) UIBarButtonItem *rightItem;

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , strong) UIImage *currentImg;

@property (nonatomic , strong) NSArray *subImgs;

@end

@implementation VisionDebugVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"本页需要 iOS 11+";
    
    self.navigationItem.rightBarButtonItem = self.rightItem;

    [self.view addSubview:self.tabV];

}

- (void)makeImage
{
    if (@available(iOS 11.0, *)) {
        [self cutMaxRectImage];
    } else {
        // Fallback on earlier versions
    }
    
    [_tabV reloadData];
}

- (void)cutMaxRectImage API_AVAILABLE(ios(11.0))
{
    VNDetectRectanglesRequest *request = [[VNDetectRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        
        NSArray * result = request.results;
        
        if (result.count == 0) {
            NSLog(@"没有找到最大矩形");
            return ;
        }
        
        VNRectangleObservation *maxOb = result.firstObject;
        for (int i = 1 ; i < result.count ; i++)
        {
            VNRectangleObservation *ob = result[i];
            if (ob.boundingBox.size.width * ob.boundingBox.size.height > maxOb.boundingBox.size.width * maxOb.boundingBox.size.height)
            {
                maxOb = ob;
            }
        }
        
        
        
        
        
    }];
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:_currentImg.CGImage options:@{}];
    
    [handler performRequests:@[request] error:nil];
    
    
//
//    return image.preprocessor.perspectiveCorrection(boundingBox: maxObservation.boundingBox,
//                                                    topLeft: maxObservation.topLeft,
//                                                    topRight: maxObservation.topRight,
//                                                    bottomLeft: maxObservation.bottomLeft,
//                                                    bottomRight: maxObservation.bottomRight)
}


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
