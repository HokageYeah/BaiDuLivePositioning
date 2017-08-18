//
//  BusLineSearch.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/22.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "BusLineSearch.h"
#import "UIImage+Rotate.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface BusLineAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation BusLineAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface BusLineSearch ()<BMKBusLineSearchDelegate,BMKPoiSearchDelegate> {
     int currentIndex;
}

@property (nonatomic,strong)BMKPoiSearch *poisearch;
@property (nonatomic,strong)BMKBusLineSearch *buslinesearch;
@property (nonatomic,strong)BMKPointAnnotation *annotation;
@property (nonatomic,strong)NSMutableArray*busPoiArray;


@end

@implementation BusLineSearch

#pragma mark - 懒加载

- (BMKBusLineSearch *)buslinesearch {
    if (!_buslinesearch) {
        _buslinesearch = [[BMKBusLineSearch alloc]init];
    }
    return _buslinesearch;
}

- (BMKPoiSearch *)poisearch {
    if (!_poisearch) {
        _poisearch = [[BMKPoiSearch alloc]init];
        _poisearch.delegate = self;
    }
    return _poisearch;
}

- (NSMutableArray *)busPoiArray {
    if (!_busPoiArray ) {
        _busPoiArray = [[NSMutableArray alloc]init];
    }
    return _busPoiArray;
}

#pragma mark - 生命周期

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.buslinesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.buslinesearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self onClickBusLineSearch];
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(BusLineAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        default:
            break;
    }
    
    return view;
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BusLineAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(BusLineAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}


#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKPoiInfo* poi = nil;
        BOOL findBusline = NO;
        for (NSInteger i = 0; i < result.poiInfoList.count; i++) {
            poi = [result.poiInfoList objectAtIndex:i];
            if (poi.epoitype == 2 || poi.epoitype == 4) {
                findBusline = YES;
                [self.busPoiArray addObject:poi];
            }
        }
        //开始bueline详情搜索
        if(findBusline)
        {
            currentIndex = 0;
            NSString* strKey = ((BMKPoiInfo*) [_busPoiArray objectAtIndex:currentIndex]).uid;
            BMKBusLineSearchOption *buslineSearchOption = [[BMKBusLineSearchOption alloc]init];
            buslineSearchOption.city= @"成都";
            buslineSearchOption.busLineUid= strKey;
            BOOL flag = [self.buslinesearch busLineSearch:buslineSearchOption];
            if(flag)
            {
                NSLog(@"busline检索发送成功");
            }
            else
            {
                NSLog(@"busline检索发送失败");
            }
            
        }
    }
}

- (void)onGetBusDetailResult:(BMKBusLineSearch*)searcher result:(BMKBusLineResult*)busLineResult errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:self.mapView.overlays];
    [self.mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BusLineAnnotation* item = [[BusLineAnnotation alloc]init];
        
        //站点信息
        NSInteger size = 0;
        size = busLineResult.busStations.count;
        for (NSInteger j = 0; j < size; j++) {
            BMKBusStation* station = [busLineResult.busStations objectAtIndex:j];
            item = [[BusLineAnnotation alloc]init];
            item.coordinate = station.location;
            item.title = station.title;
            item.type = 2;
            [self.mapView addAnnotation:item];
        }
        
        
        //路段信息
        NSInteger index = 0;
        //累加index为下面声明数组temppoints时用
        for (NSInteger j = 0; j < busLineResult.busSteps.count; j++) {
            BMKBusStep* step = [busLineResult.busSteps objectAtIndex:j];
            index += step.pointsCount;
        }
        //直角坐标划线
        BMKMapPoint * temppoints = new BMKMapPoint[index];
        NSInteger k=0;
        for (NSInteger i = 0; i < busLineResult.busSteps.count; i++) {
            BMKBusStep* step = [busLineResult.busSteps objectAtIndex:i];
            for (NSInteger j = 0; j < step.pointsCount; j++) {
                BMKMapPoint pointarray;
                pointarray.x = step.points[j].x;
                pointarray.y = step.points[j].y;
                temppoints[k] = pointarray;
                k++;
            }
        }
        
        
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:index];
        [self.mapView addOverlay:polyLine];
        delete temppoints;
        
        BMKBusStation* start = [busLineResult.busStations objectAtIndex:0];
        [self.mapView setCenterCoordinate:start.location animated:YES];
        
    }
}

- (void)onClickBusLineSearch {
    [self.busPoiArray removeAllObjects];
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"成都";
    citySearchOption.keyword = @"801";
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

@end
