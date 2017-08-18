//
//  ShareUrlControl.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/22.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "ShareUrlControl.h"

@interface ShareUrlControl ()<BMKShareURLSearchDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong)BMKShareURLSearch *shareurlsearch;
@property (nonatomic,strong)BMKGeoCodeSearch *geocodesearch;

@end

@implementation ShareUrlControl


#pragma mark - 懒加载

- (BMKShareURLSearch *)shareurlsearch {
    if (!_shareurlsearch) {
        _shareurlsearch = [[BMKShareURLSearch alloc]init];
    }
    return _shareurlsearch;
}

- (BMKGeoCodeSearch *)geocodesearch {
    if (!_geocodesearch) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}

#pragma mark - 生命周期

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shareurlsearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.geocodesearch.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.shareurlsearch.delegate = nil; // 不用时，置nil
    self.geocodesearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reverseGeoShortUrlShare];
}

//1.点击［反向地理编码结果分享］先发起反geo搜索
-   (void)reverseGeoShortUrlShare
{
    //坐标
    NSString* _coordinateXText = @"104.040327";
    NSString* _coordinateYText = @"30.638028";
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){[_coordinateYText floatValue], [_coordinateXText floatValue]};
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

//2.搜索成功后在回调中根据参数发起geo短串搜索
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:self.mapView.overlays];
    [self.mapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [self.mapView addAnnotation:item];
        self.mapView.centerCoordinate = result.location;
        //保存数据用于分享用
        //发起短串搜索获取反geo分享url
        BMKLocationShareURLOption *option = [[BMKLocationShareURLOption alloc]init];
        option.snippet = result.address;
        option.name = @"我们在这里呀";
        option.location = result.location;
        BOOL flag = [self.shareurlsearch requestLocationShareURL:option];
        if(flag)
        {
            NSLog(@"反geourl检索发送成功");
        }
        else
        {
            NSLog(@"反geourl检索发送失败");
        }
        
    }
}

- (void)onGetLocationShareURLResult:(BMKShareURLSearch *)searcher result:(BMKShareURLResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (error == BMK_SEARCH_NO_ERROR)
    {
        NSLog(@"%@",result.url);
    }
}

@end
