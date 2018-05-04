//
//  LocationTool.m
//  Apartment
//
//  Created by 西安旺豆电子信息有限公司 on 16/12/16.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "LocationTool.h"


@interface LocationTool () <CLLocationManagerDelegate>

@property (nonatomic , strong) CLGeocoder *geocoder;

@property (nonatomic , assign) BOOL isCollect;          //是否正在收集中

@property (nonatomic , strong) NSMutableArray *locations;

@end


@implementation LocationTool

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder=[[CLGeocoder alloc] init];
    }
    return _geocoder;
}

-(CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        //设置定位的精度
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        //控制定位服务更新频率。单位是“米”
        _manager.distanceFilter = 100;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
        {
            //[_manager requestWhenInUseAuthorization];   //前台定位
            [_manager requestAlwaysAuthorization];// 前后台同时定位
        }
    }
    return _manager;
}

- (CGFloat)collectTime
{
    if (_collectTime == 0) {
        _collectTime = 2;
    }
    return _collectTime;
}

- (NSMutableArray *)locations
{
    if (_locations == nil) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}


#pragma mark - << Delegate >>

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) { //定位服务没有打开
        NSLog(@"定位服务没有打开");
        [DMTools showAlertWithTitle:kLocStr(@"提示") andContent:kLocStr(@"定位服务没有打开,是否前往打开?") andSureBlock:^{
            
            if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
            
        } andCancelBlock:nil andSureTitle:kLocStr(@"是") andCancelTitle:kLocStr(@"否") atVC:nil];
    }else{
        if(error){
            [DMTools showAlertWithTitle:kLocStr(@"提示") andContent:kLocStr(@"定位失败") andBlock:nil atVC:nil];
        }
    }
    [manager stopUpdatingLocation];
    if (_didEndUpdate) {
        _didEndUpdate();
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //获取最新的位置
    CLLocation * currentLocation = [locations lastObject];
    
    if (_didUpdateLocation) {
        _didUpdateLocation(currentLocation);
    }
    
    if (currentLocation.horizontalAccuracy > 0) {
        [self.locations addObject:currentLocation];
    }
    
    if (_isCollect) {
        return;
    }
    [self performSelector:@selector(stop) withObject:nil afterDelay:self.collectTime];
    _isCollect = YES;//标记正在定位
}

#pragma mark - << Action >>

- (void)start
{
    [self.manager startUpdatingLocation];
}

- (void)stop
{
    [self.manager stopUpdatingLocation];
    _isCollect = NO;
    
    if (_locations.count) {
        [self manageLocations];
    }else{
        [self start];
    }
}

//管理定位到的数据>>>找出精度最高的一个,获取其locationStr,然后保存,其余的全部删除
-(void)manageLocations
{
    CLLocation *location = _locations.firstObject;
    
    for (CLLocation *location1 in _locations) {
        if (location1.horizontalAccuracy <= location.horizontalAccuracy) {
            location = location1;
        }
    }
    
    [_locations removeAllObjects];
    
    [self makeLocationStringWithLocation:location];
    
}

/** 生成地理位置字符串 */
- (void)makeLocationStringWithLocation:(CLLocation *)location
{
    WeakObj(self);
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            
            CLPlacemark *placemark = placemarks.firstObject;
            NSString *locationStr = nil;
            NSString *formatStr = [placemark.addressDictionary[@"FormattedAddressLines"] firstObject];
            NSString *nameStr = placemark.name;
            if ([nameStr isEqualToString:formatStr]) {
                locationStr = nameStr;
            }else{
                //省-市-区-name
                locationStr = [NSString stringWithFormat:@"%@%@%@%@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"],placemark.addressDictionary[@"SubLocality"],placemark.name];
            }
            NSLog(@"%@",locationStr);
            //停止定位
            if (selfWeak.didUpdateAddr) {
                selfWeak.didUpdateAddr(locationStr,location,placemark);
            }
        } else {
            NSLog(@"停止更新");
            if (selfWeak.didEndUpdate) {
                selfWeak.didEndUpdate();
            }
        }
    }];
}


@end
