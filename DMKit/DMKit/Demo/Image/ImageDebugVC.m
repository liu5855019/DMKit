//
//  ImageDebugVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/26.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "ImageDebugVC.h"
#import "VisionDebugCell.h"

@interface ImageDebugVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tabV;

@property (nonatomic , strong) NSMutableArray *images;

@end

@implementation ImageDebugVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTitleLabel.text = @"Debug Image";
    
    _images = [NSMutableArray array];
    
    [self.view addSubview:self.tabV];
    
    [self testUIimgCGimgCIimg];
}


- (void)testUIimgCGimgCIimg
{
    UIImage *img = [UIImage imageWithColor:kRandomColor size:CGSizeMake(100, 100)];
    
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
    
    [_tabV reloadData];
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
        
        [_tabV registerClass:[VisionDebugCell class] forCellReuseIdentifier:@"VisionDebugCell"];
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
    
    VisionDebugCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisionDebugCell"];
    
    cell.img = _images[indexPath.row];
    
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







@end
