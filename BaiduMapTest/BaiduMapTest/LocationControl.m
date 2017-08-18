//
//  LocationControl.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "LocationControl.h"

@interface LocationControl ()<BMKLocationServiceDelegate>

@property (nonatomic,strong)BMKLocationService *locService;

@end

@implementation LocationControl

#pragma mark - 懒加载

- (BMKLocationService *)locService {
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
    }
    return _locService;
}

#pragma mark -生命周期

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.locService.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.locService.delegate = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self startLocation];
    [self customLocationAccuracyCircle];
}

#pragma mark - other

//自定义精度圈
- (void)customLocationAccuracyCircle {
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    param.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
    [self.mapView updateLocationViewWithParam:param];
}

//开始定位
- (void)startLocation {
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
}

//停止定位
- (void)stopLocation {
    [self.locService stopUserLocationService];
    self.mapView.showsUserLocation = NO;
}


#pragma mark - BMKLocationServiceDelegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self startLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}



@end
