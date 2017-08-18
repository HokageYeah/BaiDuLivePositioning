//
//  POISearchControl.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "POISearchControl.h"

@interface POISearchControl ()<BMKPoiSearchDelegate>

@property (nonatomic,strong)BMKPoiSearch *poisearch;

@end

@implementation POISearchControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    return self;
}

#pragma mark - 懒加载

- (BMKPoiSearch *)poisearch {
    if (!_poisearch) {
        _poisearch = [[BMKPoiSearch alloc]init];
    }
    return _poisearch;
}

#pragma mark -生命周期

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.poisearch.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.poisearch.delegate = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.isSelectedAnnotationViewFront = YES;
}

#pragma mark - 事件监听

- (void)rightBarButtonItem {
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"成都";
    citySearchOption.keyword = @"餐厅";
    BOOL flag = [self.poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }

}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [self.mapView addAnnotations:annotations];
        [self.mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

@end
