//
//  RegilDivisionViewController.m
//  BaiDuLivePositioning
//
//  Created by 余晔 on 2017/8/8.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "RegilDivisionViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "BMKClusterManager.h"
#define zScreenHeight [[UIScreen mainScreen] bounds].size.height
#define zScreenWidth [[UIScreen mainScreen] bounds].size.width




/*
 *点聚合Annotation
 */
@interface ClusterAnnotations : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, strong) NSDictionary *Annotationsdic;

@property (nonatomic, assign) BOOL ishidelabel;
@end

@implementation ClusterAnnotations

@synthesize Annotationsdic = _Annotationsdic;
@synthesize ishidelabel = _ishidelabel;

@end



/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationViews : BMKAnnotationView {
    
}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSDictionary *AnnotationViewsdic;
@property (nonatomic, assign) BOOL ishidelabel;
@property (nonatomic, strong)UIImageView *runimg;

@end

@implementation ClusterAnnotationViews

@synthesize label = _label;
@synthesize AnnotationViewsdic = _AnnotationViewsdic;
@synthesize ishidelabel = _ishidelabel;
@synthesize runimg = _runimg;


- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        self.backgroundColor = [UIColor clearColor];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 80.f)];
        _label.backgroundColor = [UIColor colorWithRed:51/255.0 green:187/255.0 blue:111/255.0 alpha:1.0];
        _label.layer.cornerRadius = 40.0;
        _label.clipsToBounds = YES;
        _label.layer.borderColor = [UIColor whiteColor].CGColor;
        _label.layer.borderWidth = 4.0f;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:15.0];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        
        _runimg = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 16.f, 20.f)];
        _runimg.image = [UIImage imageNamed:@"ygj_homepage_fwdt_gps_icon"];
        [self addSubview:_runimg];
        
        [self addSubview:_label];
        self.alpha = 0.90;
        }
    return self;
}

- (void)setAnnotationViewsdic:(NSDictionary *)AnnotationViewsdic
{
    NSString *title = [AnnotationViewsdic objectForKey:@"name"];
    _label.text = title;
}
- (void)setIshidelabel:(BOOL)ishidelabel
{
    _label.hidden = ishidelabel;
    _runimg.hidden = !ishidelabel;
}


@end




@interface RegilDivisionViewController ()<BMKMapViewDelegate>
{
    NSInteger _clusterZoom;//聚合级别
}
@property (nonatomic,strong)BMKMapView* mapView;
@property (nonatomic,strong)NSMutableArray *dataary;
@end

@implementation RegilDivisionViewController

- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地图";
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, zScreenWidth, zScreenHeight-64)];
    [_mapView setZoomLevel:13.0];
    //    _mapView.centerCoordinate = (CLLocationCoordinate2D){31.249162, 121.487899};  // 中心
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showMapScaleBar = YES;
    [_mapView setCenterCoordinate:(CLLocationCoordinate2D){31.249162, 121.487899} animated:YES];
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(_mapView.frame.size.width - 70, _mapView.frame.size.height - 58);
    [self.view addSubview:_mapView];

    
    
    _dataary  = [NSMutableArray array];
    NSDictionary *dic1;
    dic1= @{
            @"name" : @"黄浦区120",
            @"latitude" : @(31.227203),
            @"longitude" : @(121.496072)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"徐汇区30",
            @"latitude" : @(31.169152),
            @"longitude" : @(121.446535)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"长宁区20",
            @"latitude" : @(31.213301),
            @"longitude" : @(121.387616)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"静安区50",
            @"latitude" : @(31.235381),
            @"longitude" : @(121.454756)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"普陀区40",
            @"latitude" : @(31.263743),
            @"longitude" : @(121.398443)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"虹口区60",
            @"latitude" : @(31.282497),
            @"longitude" : @(121.491919)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"杨浦区50",
            @"latitude" : @(31.304510),
            @"longitude" : @(121.535717)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"闵行区10",
            @"latitude" : @(31.093538),
            @"longitude" : @(121.425024)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"宝山区1",
            @"latitude" : @(31.398623),
            @"longitude" : @(121.409041)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"嘉定区20",
            @"latitude" : @(31.364338),
            @"longitude" : @(121.251014)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"浦东新区40",
            @"latitude" : @(31.230895),
            @"longitude" : @(121.638481)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"金山区",
            @"latitude" : @(30.835081),
            @"longitude" : @(121.248408)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"松江区20",
            @"latitude" : @(31.021245),
            @"longitude" : @(121.226791)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"青浦区",
            @"latitude" : @(31.130862),
            @"longitude" : @(121.091425)
            };
    [_dataary addObject:dic1];
    dic1= @{
            @"name" : @"奉贤区30",
            @"latitude" : @(30.915122),
            @"longitude" : @(121.560642)
            };
    [_dataary addObject:dic1];
    _clusterZoom = (NSInteger)_mapView.zoomLevel;

    for (int i =0; i<_dataary.count; i++)
    {
        NSDictionary *lodic = _dataary[i];
            ClusterAnnotations* pointAnnotation = [[ClusterAnnotations alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [[lodic objectForKey:@"latitude"] floatValue];
            coor.longitude = [[lodic objectForKey:@"longitude"] floatValue];
            pointAnnotation.coordinate = coor;
        pointAnnotation.Annotationsdic = lodic;
        pointAnnotation.ishidelabel = NO;
        [_mapView addAnnotation:pointAnnotation];
    }
}


#pragma mark -
#pragma mark implement BMKMapViewDelegate
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
        NSString *AnnotationViewID = @"renameMark";
        ClusterAnnotations *cluster = (ClusterAnnotations*)annotation;
//        ClusterAnnotationViews *annotationView = (ClusterAnnotationViews *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//        if (annotationView == nil) {
            ClusterAnnotationViews *annotationView = [[ClusterAnnotationViews alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            annotationView.AnnotationViewsdic = cluster.Annotationsdic;
            annotationView.ishidelabel = cluster.ishidelabel;
            annotationView.annotation = cluster;
//        }
        return annotationView;
}

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status
{
    NSLog(@"缩放级别：%f,旋转角度：%f，俯视角度：%f，屏幕坐标中心店：%f，地理坐标中心店：%f",status.fLevel,status.fRotation,status.fOverlooking,status.targetScreenPt.x,status.targetGeoPt.latitude);
    NSLog(@"二级聚合：%ld，再次聚合：%ld",(long)_clusterZoom,(NSInteger)mapView.zoomLevel);
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel)
    {
        [self updateClusters];
    }
}


- (void)updateClusters
{
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    if(_clusterZoom==15)
    {
        [_mapView removeAnnotations:_mapView.annotations];
        for (NSInteger i = 0; i < 100; i++)
        {
            double lat =  (arc4random() % 100) * 0.001f;
            double lon =  (arc4random() % 100) * 0.001f;
            ClusterAnnotations* pointAnnotation = [[ClusterAnnotations alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = 31.249162 + lat;
            coor.longitude = 121.487899 + lon;
            pointAnnotation.coordinate = coor;
            pointAnnotation.ishidelabel = YES;
            [_mapView addAnnotation:pointAnnotation];
        }
    }
    else if(_clusterZoom == 13)
    {
        [_mapView removeAnnotations:_mapView.annotations];
        for (int i =0; i<_dataary.count; i++)
        {
            NSDictionary *lodic = _dataary[i];
            ClusterAnnotations* pointAnnotation = [[ClusterAnnotations alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [[lodic objectForKey:@"latitude"] floatValue];
            coor.longitude = [[lodic objectForKey:@"longitude"] floatValue];
            pointAnnotation.coordinate = coor;
            pointAnnotation.Annotationsdic = lodic;
            pointAnnotation.ishidelabel = NO;
            [_mapView addAnnotation:pointAnnotation];
        }
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc
{
    
    if (_mapView) {
        _mapView = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
