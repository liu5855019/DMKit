//
//  LocationTool.h
//  Apartment
//
//  Created by 西安旺豆电子信息有限公司 on 16/12/16.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

//@property (nonatomic , strong) LocationTool *locationTool;
//-(void)setupLocation
//{
//    LocationTool *tool = [[LocationTool alloc] init];
//    _locationTool = tool;
//    tool.vc = self;
//    tool.didUpdateLocation = ^(CLLocation * location){
//        NSLog(@"%f---%f",location.coordinate.latitude,location.coordinate.longitude);
//    };
//    WeakObj(self);
//    tool.didUpdateAddr = ^(NSString *addr,CLLocation *location){
//        NSLog(@"%@",addr);
//        NSLog(@"%f---%f",location.coordinate.latitude,location.coordinate.longitude);
//    };
//}

//懒加载
//@property (nonatomic , strong) LocationTool *locationTool;
//-(LocationTool *)locationTool
//{
//    if (_locationTool == nil) {
//        LocationTool *tool = [[LocationTool alloc] init];
//        _locationTool = tool;
//        tool.vc = self;
//        WeakObj(self);
//        tool.didUpdateAddr = ^(NSString *addr,CLLocation *location){
//            NSLog(@"%@",addr);
//            NSLog(@"%f---%f",location.coordinate.latitude,location.coordinate.longitude);
//            selfWeak.locationLabel.text = addr;
//        };
//        tool.didEndUpdate = ^{
//            [selfWeak stopUpdateUI];
//        };
//    }
//    return _locationTool;
//}





#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTool : NSObject

/** 定位管理器 */
@property (nonatomic , strong) CLLocationManager *manager;

@property (nonatomic , assign) CGFloat collectTime;     ///<收集时间s    默认收集2秒,从获取到第一个location开始计时 2秒后停止收集location,然后取精度最高的location进行转地理位置


/** 获取到最新经纬度block */
@property (nonatomic , strong) void (^didUpdateLocation)(CLLocation *location);
/** 获取到最新地理位置block  只有获取到str的时候才会调用 */
@property (nonatomic , strong) void (^didUpdateAddr)(NSString *addrStr,CLLocation *location,CLPlacemark *placemark);
/** 定位结束(当定位失败/定位到地址名称时) */
@property (nonatomic , strong) void (^didEndUpdate)(void);



- (void)start;



@end
