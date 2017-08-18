//
//  BaseMapControl.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "BaseMapControl.h"

@interface BaseMapControl ()



@end

@implementation BaseMapControl

#pragma mark - 懒加载

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
//        _mapView.mapType = BMKMapTypeSatellite;
//        _mapView.zoomLevel = 14;
//        _mapView.logoPosition = BMKLogoPositionRightTop;
//         [_mapView setTrafficEnabled:YES];
//        [_mapView setBuildingsEnabled:YES];
//        [_mapView setBaiduHeatMapEnabled:YES];
//        [_mapView setShowMapPoi:YES];
//         [_mapView takeSnapshot]; //截图
//        _mapView.overlooking //地图俯视角度
//        _mapView.rotation //地图旋转角度
//        _mapView.showMapScaleBar = NO;
//        _mapView.mapPadding = UIEdgeInsetsMake(0, 0, 28, 0);
    }
    return _mapView;
}

#pragma mark - 生命周期

-(void)viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    if (self.mapView) {
        self.mapView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi {
    NSLog(@"点中底图空白处会回调此接口");
    NSLog(@"onClickedMapPoi-%@",mapPoi.text);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了底图标注:%@,\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", mapPoi.text,mapPoi.pt.longitude,mapPoi.pt.latitude, (int)self.mapView.zoomLevel,self.mapView.rotation,self.mapView.overlooking];
    NSLog(@"%@",showmeg);
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
  
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了地图空白处(blank click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)self.mapView.zoomLevel,self.mapView.rotation,self.mapView.overlooking];
    NSLog(@"%@",showmeg);
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
 
    NSLog(@"onDoubleClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您双击了地图(double click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)self.mapView.zoomLevel,self.mapView.rotation,self.mapView.overlooking];
    NSLog(@"%@",showmeg);
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {

    NSString* showmeg = [NSString stringWithFormat:@"您长按了地图(long pressed).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)self.mapView.zoomLevel,self.mapView.rotation,self.mapView.overlooking];
    NSLog(@"%@",showmeg);
}


- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSString* showmeg = [NSString stringWithFormat:@"地图区域发生了变化(x=%d,y=%d,\r\nwidth=%d,height=%d).\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d",(int)self.mapView.visibleMapRect.origin.x,(int)self.mapView.visibleMapRect.origin.y,(int)self.mapView.visibleMapRect.size.width,(int)self.mapView.visibleMapRect.size.height,(int)self.mapView.zoomLevel,self.mapView.rotation,self.mapView.overlooking];
    NSLog(@"%@",showmeg);

    
}

@end
