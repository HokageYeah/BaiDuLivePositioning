//
//  AnnotationControl.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "AnnotationControl.h"
#import "MyAnimatedAnnotationView.h"
#import "CustomOverlayView.h"
#import "CustomOverlay.h"
@interface AnnotationControl () {
    BMKCircle* circle;  //圆
    BMKPolygon* polygon;//多边形
    BMKPolygon* polygon2;
    BMKPolyline* polyline;//一段折线
    BMKPolyline* colorfulPolyline;
    BMKArcline* arcline; //一段圆弧
    BMKGroundOverlay* ground2;//一个图片图层
    BMKPointAnnotation* pointAnnotation;//表示一个点的annotation
    BMKPointAnnotation* animatedAnnotation;
}

@end


//pis c++语法,c++原因 new delete

@implementation AnnotationControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"标注显示" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem:)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addOverlayView];
    [self customeOverlay];
}

#pragma mark - other


- (void)customeOverlay {
    CLLocationCoordinate2D coor1;
    coor1.latitude = 39.915;
    coor1.longitude = 116.404;
    BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
    CLLocationCoordinate2D coor2;
    coor2.latitude = 40.015;
    coor2.longitude = 116.404;
    BMKMapPoint pt2 = BMKMapPointForCoordinate(coor2);
    BMKMapPoint * temppoints = new BMKMapPoint[2];    //初始化
    temppoints[0].x = pt2.x;
    temppoints[0].y = pt2.y;
    temppoints[1].x = pt1.x;
    temppoints[1].y = pt1.y;
    CustomOverlay* custom = [[CustomOverlay alloc] initWithPoints:temppoints count:2];
    [self.mapView addOverlay:custom];
    delete temppoints;                                 //删除
    CLLocationCoordinate2D coor3;
    coor3.latitude = 39.915;
    coor3.longitude = 116.504;
    BMKMapPoint pt3 = BMKMapPointForCoordinate(coor3);
    CLLocationCoordinate2D coor4;
    coor4.latitude = 40.015;
    coor4.longitude = 116.504;
    BMKMapPoint pt4 = BMKMapPointForCoordinate(coor4);
    CLLocationCoordinate2D coor5;
    coor5.latitude = 39.965;
    coor5.longitude = 116.604;
    BMKMapPoint pt5 = BMKMapPointForCoordinate(coor5);
    BMKMapPoint * temppoints2 = new BMKMapPoint[3];   //初始化
    
    temppoints2[0].x = pt3.x;
    temppoints2[0].y = pt3.y;
    temppoints2[1].x = pt4.x;
    temppoints2[1].y = pt4.y;
    temppoints2[2].x = pt5.x;
    temppoints2[2].y = pt5.y;
    CustomOverlay* custom2 = [[CustomOverlay alloc] initWithPoints:temppoints2 count:3];
    [self.mapView addOverlay:custom2];
    delete temppoints2;                             //删除
}

- (void)addGroundOverlay {
    //添加图片图层覆盖物
    if (ground2 == nil) {
        CLLocationCoordinate2D coords[2] = {0};
        coords[0].latitude = 39.910;
        coords[0].longitude = 116.370;
        coords[1].latitude = 39.950;
        coords[1].longitude = 116.430;
        
        BMKCoordinateBounds bound;
        bound.southWest = coords[0];
        bound.northEast = coords[1];
        ground2 = [BMKGroundOverlay groundOverlayWithBounds:bound icon:[UIImage imageNamed:@"test.png"]];
        ground2.alpha = 0.8;
    }
    [self.mapView addOverlay:ground2];
    //    _mapView.zoomLevel = 14;
    //    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.9255, 116.3995);
}

//添加内置覆盖物
- (void)addOverlayView {
    // 添加圆形覆盖物
    if (circle == nil) {
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        circle = [BMKCircle circleWithCenterCoordinate:coor radius:5000];
    }
    [self.mapView addOverlay:circle];
    
    // 添加多边形覆盖物
    if (polygon == nil) {
        CLLocationCoordinate2D coords[4] = {0};
        coords[0].latitude = 39.915;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.815;
        coords[1].longitude = 116.404;
        coords[2].latitude = 39.815;
        coords[2].longitude = 116.504;
        coords[3].latitude = 39.915;
        coords[3].longitude = 116.504;
        polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
    }
    [self.mapView addOverlay:polygon];
    
    // 添加多边形覆盖物
    if (polygon2 == nil) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.604;
        coords[1].latitude = 39.865;
        coords[1].longitude = 116.604;
        coords[2].latitude = 39.865;
        coords[2].longitude = 116.704;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.654;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.704;
        polygon2 = [BMKPolygon polygonWithCoordinates:coords count:5];
    }
    [self.mapView addOverlay:polygon2];
    
    //添加折线覆盖物
    if (polyline == nil) {
        CLLocationCoordinate2D coors[2] = {0};
        coors[1].latitude = 39.895;
        coors[1].longitude = 116.354;
        coors[0].latitude = 39.815;
        coors[0].longitude = 116.304;
        polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
    }
    [self.mapView addOverlay:polyline];
    
    //添加折线(分段颜色绘制)覆盖物
    if (colorfulPolyline == nil) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.925;
        coords[1].longitude = 116.454;
        coords[2].latitude = 39.955;
        coords[2].longitude = 116.494;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.554;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.604;
        //构建分段颜色索引数组
        NSArray *colorIndexs = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:2], nil];
        
        //构建BMKPolyline,使用分段颜色索引，其对应的BMKPolylineView必须设置colors属性
        colorfulPolyline = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:colorIndexs];
    }
    [self.mapView addOverlay:colorfulPolyline];
    
    // 添加圆弧覆盖物
    if (arcline == nil) {
        CLLocationCoordinate2D coords[3] = {0};
        coords[0].latitude = 40.065;
        coords[0].longitude = 116.124;
        coords[1].latitude = 40.125;
        coords[1].longitude = 116.304;
        coords[2].latitude = 40.065;
        coords[2].longitude = 116.404;
        arcline = [BMKArcline arclineWithCoordinates:coords];
    }
    [self.mapView addOverlay:arcline];
    
}

//添加标注
- (void)addPointAnnotation
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = @"test";
        pointAnnotation.subtitle = @"此Annotation可拖拽!";
    }
    [self.mapView addAnnotation:pointAnnotation];
}

// 添加动画Annotation
- (void)addAnimatedAnnotation {
    if (animatedAnnotation == nil) {
        animatedAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 40.115;
        coor.longitude = 116.404;
        animatedAnnotation.coordinate = coor;
        animatedAnnotation.title = nil;
    }
    [self.mapView addAnnotation:animatedAnnotation];
}

#pragma mark - 事件监听

- (void)rightBarButtonItem:(UIBarButtonItem *)sender {
    //都是添加的坐标，大小，样式在代理里面设置
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if ([sender.title isEqualToString:@"标注显示"]) {
        sender.title = @"覆盖物显示";
        [self addPointAnnotation];
        [self addAnimatedAnnotation];
        [self addGroundOverlay];
    }else {
        sender.title = @"标注显示";
         [self addOverlayView];
    }
}

#pragma mark - BMKMapViewDelegate

//和tableview的cell差不多
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        circleView.lineWidth = 5.0;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == colorfulPolyline) {
            polylineView.lineWidth = 5;
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:
                                   [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5], nil];
        } else {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 20.0;
            [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        }
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = (overlay == polygon2);
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    //自定义的图
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        cutomView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        cutomView.lineWidth = 5.0;
        return cutomView;
        
        
    }
    return nil;
}
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    
    //动画annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    MyAnimatedAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
        [images addObject:image];
    }
    annotationView.annotationImages = images;
    return annotationView;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}
@end
