//
//  CloudSearch.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/22.
//  Copyright © 2016年 谭启宏. All rights reserved.
//


/*
 * CloudSearchDemoViewController.mm
 * BaiduMapApiDemo
 * 本示例代码使用了测试ak和测试数据，开发者在检索自己LBS数据之前，需替换 cloudLocalSearch.ak和cloudLocalSearch.geoTableId的值
 *
 * 1、替换cloudLocalSearch.ak的值：
 * （1）请访问http://lbsyun.baidu.com/apiconsole/key申请一个“服务端”的ak，其他类型的ak无效；
 * （2）将申请的ak替换cloudLocalSearch.ak的值；
 *
 * 2、替换cloudLocalSearch.geoTableId值：
 * （1）申请完服务端ak后访问http://lbsyun.baidu.com/datamanager/datamanage创建一张表；
 * （2）在“表名称”处自由填写表的名称，如MyData，点击保存；
 * （3）“创建”按钮右方将会出现形如“MyData(34195)”字样，其中的“34195”即为geoTableId的值；
 * （4）添加或修改字段：点击“字段”标签修改和添加字段；
 * （5）添加数据：
 *  a、标注模式：“数据” ->“标注模式”，输入要添加的地址然后“百度一下”，点击地图蓝色图标，再点击保存即可；
 *  b、批量模式： “数据” ->“批量模式”，可上传文件导入，具体文件格式要求请参见当页的“批量导入指南”；
 * （6）选择左边“设置”标签，“是否发布到检索”选择“是”，然后"保存";
 * （7）数据发布后，替换cloudLocalSearch.geoTableId的值即可；
 * 备注：切记添加、删除或修改数据后要再次发布到检索，否则将会出现检索不到修改后数据的情况
 * Copyright 2011 Baidu Inc. All rights reserved.
 */

#import "CloudSearch.h"

@interface CloudSearch ()<BMKCloudSearchDelegate>

@property (nonatomic,strong)BMKCloudSearch *search;

@end

@implementation CloudSearch

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"检索" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    return self;
}


#pragma mark - 懒加载

- (BMKCloudSearch *)search {
    if (!_search) {
        _search = [[BMKCloudSearch alloc]init];
    }
    return _search;
}

#pragma mark - 生命周期


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.search.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)rightBarButtonItem {
     [self onClickLocalSearch];
}

//发起本地云检索
-(void)onClickLocalSearch

{
    BMKCloudNearbySearchInfo *cloudNearbySearch = [[BMKCloudNearbySearchInfo alloc]init];
    cloudNearbySearch.ak = @"zANRDSUeu1p0KamwdG4ABxVm";
    cloudNearbySearch.geoTableId = 132556;
//    cloudNearbySearch.pageIndex = 0;
//    cloudNearbySearch.pageSize = 10;
    cloudNearbySearch.location = @"116.403402,39.915067";
    cloudNearbySearch.radius = 100000; //范围要弄起来啊啊，不然要不得啊
    cloudNearbySearch.keyword = @"天安门";
    BOOL flag = [self.search nearbySearchWithSearchInfo:cloudNearbySearch];
    if(flag)
    {
        NSLog(@"周边云检索发送成功");
    }
    else
    {
        NSLog(@"周边云检索发送失败");
    }
}

#pragma mark implement BMKSearchDelegate

- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    if (error == BMKErrorOk) {
        BMKCloudPOIList* result = [poiResultList objectAtIndex:0];
        for (int i = 0; i < result.POIs.count; i++) {
            BMKCloudPOIInfo* poi = [result.POIs objectAtIndex:i];
            //自定义字段
            if(poi.customDict!=nil&&poi.customDict.count>1)
            {
                NSString* customStringField = [poi.customDict objectForKey:@"custom"];
                NSLog(@"customFieldOutput=%@",customStringField);
                NSNumber* customDoubleField = [poi.customDict objectForKey:@"double"];
                NSLog(@"customDoubleFieldOutput=%f",customDoubleField.doubleValue);
            }
            
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ poi.longitude,poi.latitude};
            item.coordinate = pt;
            item.title = poi.title;
            [self.mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                self.mapView.centerCoordinate = pt;
            }
        }
    } else {
        NSLog(@"error ==%d",error);
    }
}
- (void)onGetCloudPoiDetailResult:(BMKCloudPOIInfo*)poiDetailResult searchType:(int)type errorCode:(int)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    if (error == BMKErrorOk) {
        BMKCloudPOIInfo* poi = poiDetailResult;
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ poi.longitude,poi.latitude};
        item.coordinate = pt;
        item.title = poi.title;
        [self.mapView addAnnotation:item];
        //将第一个点的坐标移到屏幕中央
        self.mapView.centerCoordinate = pt;
    } else {
        NSLog(@"error ==%d",error);
    }
}


@end
