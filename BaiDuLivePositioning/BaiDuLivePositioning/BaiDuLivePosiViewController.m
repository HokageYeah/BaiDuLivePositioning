//
//  BaiDuLivePosiViewController.m
//  BaiDuLivePositioning
//
//  Created by 余晔 on 2017/7/26.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "BaiDuLivePosiViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "BMKClusterManager.h"
#import "JSONKit.h"

#define zScreenHeight [[UIScreen mainScreen] bounds].size.height
#define zScreenWidth [[UIScreen mainScreen] bounds].size.width




// 运动结点信息类
@interface BMKSportNode : NSObject

//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//距离
@property (nonatomic, assign) CGFloat distance;
//速度
@property (nonatomic, assign) CGFloat speed;

@end

@implementation BMKSportNode

@synthesize coordinate = _coordinate;
@synthesize angle = _angle;
@synthesize distance = _distance;
@synthesize speed = _speed;

@end





/*
 *点聚合Annotation
 */
@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;

//所需要显示的id
@property (nonatomic, copy) NSString *cluserID;

@end

@implementation ClusterAnnotation

@synthesize size = _size;


@end





/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationView : BMKAnnotationView {
    
}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong)UIImageView *runimg;

@property (nonatomic, strong) UIImageView *annotationImageView;
@property (nonatomic, strong) NSMutableArray *annotationImages;

@end

@implementation ClusterAnnotationView

@synthesize size = _size;
@synthesize label = _label;
@synthesize annotationImageView = _annotationImageView;
@synthesize annotationImages = _annotationImages;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        self.backgroundColor = [UIColor clearColor];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 60.f)];
        _label.backgroundColor = [UIColor colorWithRed:0/255.0 green:194/255.0 blue:79/255.0 alpha:1.0];
        _label.layer.cornerRadius = 30.0;
        _label.clipsToBounds = YES;
        _label.layer.borderColor = [UIColor whiteColor].CGColor;
        _label.layer.borderWidth = 5.0f;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:13.0];
        _label.textAlignment = NSTextAlignmentCenter;
        
        
        _runimg = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 16.f, 20.f)];
        _runimg.image = [UIImage imageNamed:@"ygj_homepage_fwdt_gps_icon"];
        [self addSubview:_runimg];
        
        [self addSubview:_label];
        self.alpha = 0.85;

        
        //动画image
        _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        _annotationImageView.layer.cornerRadius = 18.0;
        _annotationImageView.clipsToBounds = YES;
        _annotationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_annotationImageView];
        
        
        
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
        popView.backgroundColor = [UIColor clearColor];
        //设置弹出气泡图片
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_bg1"]];
        image.frame = CGRectMake(60, 0, 100, 60);
        [popView addSubview:image];
        //自定义显示的内容
        UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(60, 3, 100, 20)];
        driverName.text = @"张XX师傅";
        driverName.backgroundColor = [UIColor clearColor];
        driverName.font = [UIFont systemFontOfSize:14];
        driverName.textColor = [UIColor whiteColor];
        driverName.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:driverName];
        
        UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 100, 20)];
        carName.text = @"京A123456";
        carName.backgroundColor = [UIColor clearColor];
        carName.font = [UIFont systemFontOfSize:14];
        carName.textColor = [UIColor whiteColor];
        carName.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:carName];
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = CGRectMake(0, 0, 200, 60);
        pView.backgroundColor = [UIColor clearColor];
//        self.paopaoView = nil;
//        self.paopaoView = pView;
    }
    return self;
}

- (void)setSize:(NSInteger)size {
    _size = size;
    if (_size == 1) {
        if(_annotationImages.count>0)
        {
            _annotationImageView.hidden = NO;
            self.runimg.hidden = YES;
        }
        else
        {
            _annotationImageView.hidden = YES;
            self.runimg.hidden = NO;
        }
        self.label.hidden = YES;
        self.image = [UIImage imageNamed:@""];
        return;
    }
    self.image = [UIImage imageNamed:@""];
    _annotationImageView.hidden = YES;
    self.label.hidden = NO;
    self.runimg.hidden = YES;
    if (size > 20) {
        self.label.backgroundColor = [UIColor redColor];
    } else if (size > 10) {
        self.label.backgroundColor = [UIColor purpleColor];
    } else if (size > 5) {
        self.label.backgroundColor = [UIColor blueColor];
    } else {
        self.label.backgroundColor = [UIColor greenColor];
    }
    _label.text = [NSString stringWithFormat:@"%ld", size];
}



- (void)setAnnotationImages:(NSMutableArray *)images {
    _annotationImages = images;
     self.runimg.hidden = YES;
    _annotationImageView.hidden = NO;
    [self updateImageView];
}

- (void)updateImageView {
    if ([_annotationImageView isAnimating]) {
        [_annotationImageView stopAnimating];
    }
    
    _annotationImageView.animationImages = _annotationImages;
    _annotationImageView.animationDuration = 0.5 * [_annotationImages count];
    _annotationImageView.animationRepeatCount = 0;
    [_annotationImageView startAnimating];
}


@end








@interface BaiDuLivePosiViewController ()<BMKMapViewDelegate>{
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
    
    
    BMKPolygon *pathPloygon;
    ClusterAnnotation *sportAnnotation;
    ClusterAnnotationView *sportAnnotationView;
    
    NSMutableArray *sportNodes;//轨迹点
    NSInteger sportNodeNum;//轨迹点数
    NSInteger currentIndex;//当前结点
}

@property (nonatomic,strong)BMKMapView* mapView;

@property (nonatomic,strong)NSMutableArray *bmarray;
@end

@implementation BaiDuLivePosiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地图";
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, zScreenWidth, zScreenHeight-64)];
    [_mapView setZoomLevel:13.0];
//    _mapView.centerCoordinate = (CLLocationCoordinate2D){31.249162, 121.487899};  // 中心
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showMapScaleBar = YES;
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(_mapView.frame.size.width - 70, _mapView.frame.size.height - 68);
    [self.view addSubview:_mapView];
    
    
    UIButton *senders = [UIButton buttonWithType:UIButtonTypeCustom];
    senders.frame = CGRectMake(zScreenWidth-100, 0, 100, 60);
    [senders setTitle:@"变换" forState:UIControlStateNormal];
    [senders addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    senders.backgroundColor = [UIColor blackColor];
    [self.view addSubview:senders];
    
//    BMKCoordinateRegion region;
////    CLLocationCoordinate2D userLocation = (CLLocationCoordinate2D){0, 0};
//    region.center.latitude = 40.056898;         //31.249162;  40.056898
//    region.center.longitude = 116.307626;       //121.487899; 116.307626
//    region.span.latitudeDelta = 0.002;
//    region.span.longitudeDelta = 0.002;
//    _mapView.region = region;
    
    _bmarray = [NSMutableArray array];
    
    //点的聚合表现
    [self Clusterdeo:31.249162 Withlongitude:121.487899];
    
    
    //初始化轨迹点
//    [self initSportNodes];
}


- (void)clickAction:(UIButton *)sender
{
    [self Clusterdeo:31.249162 Withlongitude:121.487899];
    
    [self updateClusters];
}


#pragma mark -- 点的聚合表现
- (void)Clusterdeo:(float)latitude Withlongitude:(float)longitude
{
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
//    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(31.249162, 121.487899);
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitude, longitude);
    //向点聚合管理类中添加标注
    for (NSInteger i = 0; i < 20; i++) {
        double lat =  (arc4random() % 100) * 0.001f;
        double lon =  (arc4random() % 100) * 0.001f;
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        if(i==0)
        {
            clusterItem.coor = CLLocationCoordinate2DMake(coor.latitude + lat, coor.longitude + lat);
            
            NSLog(@"1.看看中心店经度：%f，纬度：%f,放大的倍数：%f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude,_mapView.zoomLevel);
            
            //中心点
//            BMKCoordinateRegion region;
//            //    CLLocationCoordinate2D userLocation = (CLLocationCoordinate2D){0, 0};
//            region.center.latitude = coor.latitude + lat;         //31.249162;  40.056898
//            region.center.longitude = coor.longitude + lat;       //121.487899; 116.307626
////            region.span.latitudeDelta = 0.002;
////            region.span.longitudeDelta = 0.002;
//            _mapView.region = region;
//            _mapView.centerCoordinate = (CLLocationCoordinate2D){coor.latitude + lat, coor.longitude + lat};  // 中心
            
            [_mapView setCenterCoordinate:(CLLocationCoordinate2D){coor.latitude + lat, coor.longitude + lat} animated:YES];
            NSLog(@"2.看看中心店经度：%f，纬度：%f,放大的倍数：%f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude,_mapView.zoomLevel);
            [self performSelector:@selector(afterrgion) withObject:self afterDelay:1.5];
        }
        else{
            clusterItem.coor = CLLocationCoordinate2DMake(coor.latitude + lat, coor.longitude + lon);
        }
        clusterItem.showid = [NSString stringWithFormat:@"%ld",(long)i];
        [_clusterManager addClusterItem:clusterItem];
    }

}

- (void)afterrgion
{
    [_mapView setZoomLevel:13.0];
    NSLog(@"2.看看中心店经度：%f，纬度：%f,放大的倍数：%f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude,_mapView.zoomLevel);
}


#pragma mark -- 运动轨迹示例
//初始化轨迹点
- (void)initSportNodes {
    sportNodes = [[NSMutableArray alloc] init];
    //读取数据
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport_path" ofType:@"json"]];
    if (jsonData) {
        NSArray *array = [jsonData objectFromJSONData];
        for (NSDictionary *dic in array) {
            BMKSportNode *sportNode = [[BMKSportNode alloc] init];
            sportNode.coordinate = CLLocationCoordinate2DMake([dic[@"lat"] doubleValue], [dic[@"lon"] doubleValue]);
            sportNode.angle = [dic[@"angle"] doubleValue];
            sportNode.distance = [dic[@"distance"] doubleValue];
            sportNode.speed = [dic[@"speed"] doubleValue];
            [sportNodes addObject:sportNode];
        }
    }
    sportNodeNum = sportNodes.count;
}

//开始
- (void)start {
    CLLocationCoordinate2D paths[sportNodeNum];
    for (NSInteger i = 0; i < sportNodeNum; i++) {
        BMKSportNode *node = sportNodes[i];
        paths[i] = node.coordinate;
    }
    
    pathPloygon = [BMKPolygon polygonWithCoordinates:paths count:sportNodeNum];
    [_mapView addOverlay:pathPloygon];
    
    sportAnnotation = [[ClusterAnnotation alloc]init];
    sportAnnotation.coordinate = paths[0];
    sportAnnotation.title = @"test";
    [_mapView addAnnotation:sportAnnotation];
    currentIndex = 0;
}

//runing
- (void)running {
    
    ClusterAnnotationView *annotationView = _bmarray[0];
    BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
    annotationView.runimg.transform = CGAffineTransformMakeRotation(node.angle);
    [UIView animateWithDuration:node.distance/node.speed animations:^{
        currentIndex++;
        BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
        sportAnnotation.coordinate = node.coordinate;
    } completion:^(BOOL finished) {
        [self running];
    }];
    
}



#pragma mark - BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    [self running];
}


//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polygonView.lineWidth = 3.0;
        return polygonView;
    }
    return nil;
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"ClusterMark";
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
    NSString *shuID = cluster.cluserID;
    NSLog(@"看看我所要的id ：%@",shuID);
//    cluster.image
    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    if([shuID isEqualToString:@"0"])
    {
        [annotationView setSelected:YES animated:NO];
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i < 3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
            [images addObject:image];
        }
        annotationView.annotationImages = images;
    }
    annotationView.size = cluster.size;
    annotationView.draggable = YES;
    annotationView.annotation = cluster;

    
    
    //移动的
    annotationView.draggable = NO;
    BMKSportNode *node = [sportNodes firstObject];
    annotationView.runimg.transform = CGAffineTransformMakeRotation(node.angle);
    
    [_bmarray addObject:annotationView];
    
    return annotationView;
    
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[ClusterAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if (clusterAnnotation.size > 1) {
            [mapView setCenterCoordinate:view.annotation.coordinate];
            [mapView zoomIn];
        }
    }
}


/**
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    [self updateClusters];
//    [self start];
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapView 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    NSLog(@"缩放级别：%f,旋转角度：%f，俯视角度：%f，屏幕坐标中心店：%f，地理坐标中心店：%f",status.fLevel,status.fRotation,status.fOverlooking,status.targetScreenPt.x,status.targetGeoPt.latitude);
    NSLog(@"二级聚合：%ld，再次聚合：%ld",(long)_clusterZoom,(NSInteger)mapView.zoomLevel);
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}





//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    NSLog(@"聚合点：%ld",(long)_clusterZoom);
//    if(_clusterZoom>11)
//    {
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                NSLog(@"聚合后的标注：%@",array);
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        NSArray *ary = item.clusterItems;
                        BMKClusterItem *itemxz = ary[0];
                        NSLog(@"我想知道的标注：%@",itemxz.showid);
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.cluserID = itemxz.showid;
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        annotation.subtitle = @"我是副标题";
                        [clusters addObject:annotation];
                        
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:clusters];
                });
            });
        }
//    }
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


@end
