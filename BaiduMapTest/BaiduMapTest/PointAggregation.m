//
//  PointAggregation.m
//  BaiduMapTest
//
//  Created by 幻想无极（谭启宏） on 16/9/20.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "PointAggregation.h"

#import "FateMapAnnotationView.h"
#import "BMKClusterManager.h" //点聚合管理类，使用百度的点聚合算法
#import "FateModel.h"
#import "UIView+Extension.h"

@interface PointAggregation (){
    BMKPointAnnotation* pointAnnotation;//表示一个点的annotation
    
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
    
}

@end

@implementation PointAggregation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.isSelectedAnnotationViewFront = YES;
//    [self addPointAnnotation];
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
   
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        FateModel *model = [FateModel new];
        model.lon = 116.404;
        model.lat = 39.915+i*0.05;
        [array addObject:model];
    }
    [self addPointJuheWithCoorArray:array];
}

- (void)addPointAnnotation
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        pointAnnotation.coordinate = coor;
        //        pointAnnotation.title = @"test";
        //        pointAnnotation.subtitle = @"此Annotation可拖拽!";
    }
    [self.mapView addAnnotation:pointAnnotation];
}

//添加模型数组
- (void)addPointJuheWithCoorArray:(NSArray *)array {
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
    [array enumerateObjectsUsingBlock:^(FateModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake(obj.lat, obj.lon);
        clusterItem.model = obj;
        [_clusterManager addClusterItem:clusterItem];
    }];
    [self updateClusters];
}

//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)self.mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        if (clusters.count > 0) {
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //聚合后的数组
                    for (BMKCluster *item in array) {
                        FateMapAnnotation *annotation = [[FateMapAnnotation alloc] init];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.cluster = item;
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        [clusters addObject:annotation];
                    }
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    [self.mapView addAnnotations:clusters];
                });
            });
        }
    }
}



#pragma mark - BMKMapViewDelegate

//地图改变的时候发送请求
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CGPoint point = CGPointMake(mapView.width, 0);
    CGPoint point1 = CGPointMake(0, mapView.width);
    CLLocationCoordinate2D rightTop = [mapView convertPoint:point toCoordinateFromView:mapView];
    CLLocationCoordinate2D leftBottom = [mapView convertPoint:point1 toCoordinateFromView:mapView];
//    if (self.isSearch) {
//        if (self.store.locationFinished) {
//            
//            [self.store requestLocationWithView:self.view left:leftBottom right:rightTop block:^(NSArray *array) {
//                //添加action
//                [self addPointJuheWithCoorArray:array];
//            }];
//        }
//    }else {
//        [self.store requestNearbyWithView:self.view left:leftBottom right:rightTop block:^(NSArray *array) {
//            [self addPointJuheWithCoorArray:array];
//        }];
//    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        FateModel *model = [FateModel new];
        model.lon = 116.404;
        model.lat = 39.915+i*0.05;
        [array addObject:model];
    }
     [self addPointJuheWithCoorArray:array];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    FateMapAnnotationView* annotationView = (FateMapAnnotationView*)[view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[FateMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.paopaoView = nil;
        
    }
    FateMapAnnotation *cluster = (FateMapAnnotation*)annotation;
    annotationView.size = cluster.size;
    annotationView.cluster = cluster.cluster;
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = NO;
    
    return annotationView;
}
//- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
//{
//    //    [mapView bringSubviewToFront:view];
//    //    [mapView setNeedsDisplay];
//    FateMapAnnotation* annotationView = (FateMapAnnotation*)view.annotation;
//    
//    if (annotationView.size > 1) {
//        [self pushResultWithCluster:annotationView.cluster];
//    }else {
//        [self pushUserInfo];
//    }
//    
//    
//}


@end
