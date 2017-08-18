//
//  SwitchMapViewController.m
//  BaiDuLivePositioning
//
//  Created by 余晔 on 2017/8/8.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "SwitchMapViewController.h"
#import "UIView+BorderSide.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BMKClusterManager.h"



#pragma mark --建立顾问
/*
 *点聚合Annotation
 */
@interface myConsultantAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;

//气泡弹框信息
@property (nonatomic, strong) NSDictionary *datadic;

@end

@implementation myConsultantAnnotation

@synthesize size = _size;
@synthesize datadic = _datadic;


@end


/*
 *点聚合AnnotationView
 */
@interface myConsultantAnnotationView : BMKAnnotationView {
    
}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong)UIImageView *runimg;


@property (nonatomic,strong) UIImageView *guimg;
@property (nonatomic,strong) UILabel *titlestr;
@property (nonatomic,strong) UILabel *subtitle;

//气泡弹框信息
@property (nonatomic, strong) NSDictionary *datadic;
@end

@implementation myConsultantAnnotationView

@synthesize size = _size;
@synthesize label = _label;
@synthesize runimg = _runimg;

@synthesize guimg = _guimg;
@synthesize titlestr = _titlestr;
@synthesize subtitle = _subtitle;
@synthesize datadic = _datadic;


- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 38.f, 38.f)];
        _label.backgroundColor = [UIColor colorWithRed:51/255.0 green:187/255.0 blue:111/255.0 alpha:1.0];
        _label.layer.cornerRadius = 19.0;
        _label.clipsToBounds = YES;
        _label.layer.borderColor = [UIColor whiteColor].CGColor;
        _label.layer.borderWidth = 4.0f;
        _label.font = [UIFont boldSystemFontOfSize:13.0];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
        [self addSubview:_label];
        self.alpha = 0.90;
        
        _runimg = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 24.f, 30.f)];
        _runimg.image = [UIImage imageNamed:@"ygj_homepage_fwdt_gps_icon"];
        [self addSubview:_runimg];
        self.runimg.hidden = YES;
        
        
        
        //设置弹出气泡图片
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 60)];
        popView.layer.shadowOffset = CGSizeMake(0,0);
        popView.layer.shadowColor = [UIColor blackColor].CGColor;
        popView.layer.shadowRadius = 4.f;
        popView.layer.shadowOpacity = 0.8f;
        popView.backgroundColor = [UIColor whiteColor];

        self.guimg = [[UIImageView alloc]init];
        self.guimg.translatesAutoresizingMaskIntoConstraints = NO;
        self.guimg.image = [UIImage imageNamed:@"btn_jyjd_1"];
        [popView addSubview:self.guimg];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_guimg(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg)]];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_guimg(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg)]];
        [popView addConstraint:[NSLayoutConstraint constraintWithItem:self.guimg attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:popView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

        self.titlestr = [[UILabel alloc] init];
        self.titlestr.translatesAutoresizingMaskIntoConstraints = NO;
        self.titlestr.font = [UIFont boldSystemFontOfSize:12.0];
        self.titlestr.textColor = [UIColor blackColor];
        self.titlestr.text = @"王明阳  金牌监理";
        [popView addSubview:self.titlestr];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_guimg]-8-[_titlestr]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg,_titlestr)]];
        [popView addConstraint:[NSLayoutConstraint constraintWithItem:self.titlestr attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.guimg attribute:NSLayoutAttributeTop multiplier:1 constant:0]];


        self.subtitle = [[UILabel alloc] init];
        self.subtitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.subtitle.font = [UIFont systemFontOfSize:10.0];
        self.subtitle.textColor = [UIColor grayColor];
        self.subtitle.numberOfLines = 0;
        self.subtitle.text = @"上海市普陀区南山区科技园南区R2-B三楼步步高";
        [popView addSubview:self.subtitle];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_guimg]-8-[_subtitle]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg,_subtitle)]];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titlestr]-1-[_subtitle]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titlestr,_subtitle)]];
        [popView addConstraint:[NSLayoutConstraint constraintWithItem:self.titlestr attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.guimg attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = CGRectMake(0, 0, 180, 65);
        pView.backgroundColor = [UIColor clearColor];
        self.paopaoView = nil;
        self.paopaoView = pView;

    }
    return self;
}

- (void)setSize:(NSInteger)size {
    _size = size;
    if (_size == 1) {
        self.label.hidden = YES;
        self.runimg.hidden = NO;
        return;
    }
    self.label.hidden = NO;
    self.runimg.hidden = YES;
    _label.text = [NSString stringWithFormat:@"%ld", size];
}
- (void)setDatadic:(NSDictionary *)datadic
{
    NSString *namestr = datadic[@"nametype"];
    NSString *imgstr = datadic[@"portrait"];
    NSString *adress = datadic[@"address"];
    self.titlestr.text = namestr;
    self.guimg.image = [UIImage imageNamed:imgstr];
    self.subtitle.text = adress;
}

@end







#pragma mark --在线工地

@interface mySiteClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, strong) NSDictionary *Annotationsdic;

@property (nonatomic, assign) BOOL ishidelabel;

//气泡弹框信息
@property (nonatomic, strong) NSDictionary *datadic;
@end

@implementation mySiteClusterAnnotation

@synthesize Annotationsdic = _Annotationsdic;
@synthesize ishidelabel = _ishidelabel;

@synthesize datadic = _datadic;

@end




/*
 *点聚合AnnotationView
 */
@interface mySiteClusterAnnotationView : BMKAnnotationView
{
}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSDictionary *AnnotationViewsdic;
@property (nonatomic, assign) BOOL ishidelabel;
@property (nonatomic, strong)UIImageView *runimg;


@property (nonatomic,strong) UIImageView *guimg;
@property (nonatomic,strong) UILabel *titlestr;
@property (nonatomic,strong) UILabel *subtitle;

//气泡弹框信息
@property (nonatomic, strong) NSDictionary *datadic;
@property (nonatomic, strong) BMKActionPaopaoView *pView;
@end

@implementation mySiteClusterAnnotationView

@synthesize label = _label;
@synthesize AnnotationViewsdic = _AnnotationViewsdic;
@synthesize ishidelabel = _ishidelabel;
@synthesize runimg = _runimg;

@synthesize guimg = _guimg;
@synthesize titlestr = _titlestr;
@synthesize subtitle = _subtitle;

@synthesize datadic = _datadic;
@synthesize pView = _pView;


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
        
        
        
        //设置弹出气泡图片
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 60)];
        popView.layer.shadowOffset = CGSizeMake(0,0);
        popView.layer.shadowColor = [UIColor blackColor].CGColor;
        popView.layer.shadowRadius = 4.f;
        popView.layer.shadowOpacity = 0.8f;
        popView.backgroundColor = [UIColor whiteColor];
        
        self.guimg = [[UIImageView alloc]init];
        self.guimg.translatesAutoresizingMaskIntoConstraints = NO;
        self.guimg.image = [UIImage imageNamed:@"btn_jyjd_1"];
        [popView addSubview:self.guimg];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_guimg(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg)]];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_guimg(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg)]];
        [popView addConstraint:[NSLayoutConstraint constraintWithItem:self.guimg attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:popView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        self.titlestr = [[UILabel alloc] init];
        self.titlestr.translatesAutoresizingMaskIntoConstraints = NO;
        self.titlestr.font = [UIFont boldSystemFontOfSize:12.0];
        self.titlestr.textColor = [UIColor blackColor];
        self.titlestr.text = @"王明阳  金牌监理";
        [popView addSubview:self.titlestr];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_guimg]-8-[_titlestr]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg,_titlestr)]];
        [popView addConstraint:[NSLayoutConstraint constraintWithItem:self.titlestr attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.guimg attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        
        self.subtitle = [[UILabel alloc] init];
        self.subtitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.subtitle.font = [UIFont systemFontOfSize:10.0];
        self.subtitle.textColor = [UIColor grayColor];
        self.subtitle.numberOfLines = 0;
        self.subtitle.text = @"上海市普陀区南山区科技园南区R2-B三楼步步高";
        [popView addSubview:self.subtitle];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_guimg]-8-[_subtitle]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_guimg,_subtitle)]];
        [popView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titlestr]-1-[_subtitle]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titlestr,_subtitle)]];
        [popView addConstraint:[NSLayoutConstraint constraintWithItem:self.titlestr attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.guimg attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        
        _pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        _pView.frame = CGRectMake(0, 0, 180, 65);
        _pView.backgroundColor = [UIColor clearColor];


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
    self.paopaoView = nil;
    if(ishidelabel)
    {
        self.paopaoView = _pView;
    }
}

- (void)setDatadic:(NSDictionary *)datadic
{
    NSString *namestr = datadic[@"nametype"];
    NSString *imgstr = datadic[@"portrait"];
    NSString *adress = datadic[@"address"];
    self.titlestr.text = namestr;
    self.guimg.image = [UIImage imageNamed:imgstr];
    self.subtitle.text = adress;
}

@end






#define zScreenHeight [[UIScreen mainScreen] bounds].size.height
#define zScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface SwitchMapViewController ()<BMKMapViewDelegate>
{
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
}
@property (nonatomic,strong) UIView *mapbgview;
@property (nonatomic,strong) UIButton *consultantbtn;
@property (nonatomic,strong) UIButton *Sitebtn;
@property (nonatomic,strong) UIButton *Hotspotsbtn;
@property (nonatomic,strong) UIView *lineview;

@property (nonatomic,strong)BMKMapView* mapView;
@property (nonatomic,strong)NSMutableArray *mySiteary;
@property (nonatomic,strong)NSMutableArray *myConsultantary;

@end

@implementation SwitchMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地图";
    
    _mySiteary  = [NSMutableArray array];
    _myConsultantary  = [NSMutableArray array];

    
    [self.view addSubview:self.mapbgview];
    [self.mapbgview addSubview:self.consultantbtn];
    [self.mapbgview addSubview:self.Sitebtn];
    [self.mapbgview addSubview:self.Hotspotsbtn];
    [self.mapbgview addSubview:self.lineview];
    
    [self.mapbgview borderForColor:[UIColor grayColor] borderWidth:0.1 borderType:UIBorderSideTypeTop];
    [self.mapbgview borderForColor:[UIColor grayColor] borderWidth:0.1 borderType:UIBorderSideTypeBottom];
    [self.consultantbtn borderForColor:[UIColor grayColor] borderWidth:0.1 borderType:UIBorderSideTypeRight];
    [self.Sitebtn borderForColor:[UIColor grayColor] borderWidth:0.1 borderType:UIBorderSideTypeRight];
    [self brightbtn:self.tag];
    
    //地图
    [self.view addSubview:self.mapView];
    
    
    //数据
    [self myConsultantData];
    [self mySiteData];
    switch (self.tag)
    {
        case 0: ////监理顾问
        {
            [self myConsultant];
        }
            break;
        case 1: ////在线工地
        {
            [self mySite];
        }
            break;
        case 2: ////资讯热点
        {
            [self myHotspots];
        }
            break;
        default:
            break;
    }
}


#pragma mark --监理顾问
- (void)myConsultant
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_clusterManager clearClusterItems];
    [_clusterCaches removeAllObjects];
    
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(31.249162, 121.487899);
    _clusterManager = [[BMKClusterManager alloc] init];
    //向点聚合管理类中添加标注
    for (NSInteger i = 0; i < 3; i++)
    {
        NSDictionary *dic = @{
                              @"nametype" : [NSString stringWithFormat:@"姓名%ld  类型%ld",(long)i,(long)i], //监理姓名 监理类型
                              @"portrait" : @"btn_jyjd_1", //监理头像
                              @"address" : [NSString stringWithFormat:@"上海市普陀区南山区科技园区%ld门派步步高",(long)i], //监理地址
                              };
        double lat =  (arc4random() % 100) * 0.001f;
        double lon =  (arc4random() % 100) * 0.001f;
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake(coor.latitude + lat, coor.longitude + lon);
//        if(i==1)clusterItem.coor = CLLocationCoordinate2DMake(coor.latitude, coor.longitude);
        clusterItem.datadic = dic;
        [_clusterManager addClusterItem:clusterItem];
    }
}

//数据
- (void)myConsultantData
{

}

#pragma mark --在建工地
- (void)mySite
{
    [_mapView removeAnnotations:_mapView.annotations];

    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    for (int i =0; i<_mySiteary.count; i++)
    {
        NSDictionary *lodic = _mySiteary[i];
        mySiteClusterAnnotation* pointAnnotation = [[mySiteClusterAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[lodic objectForKey:@"latitude"] floatValue];
        coor.longitude = [[lodic objectForKey:@"longitude"] floatValue];
        pointAnnotation.coordinate = coor;
        pointAnnotation.Annotationsdic = lodic;
        pointAnnotation.ishidelabel = NO;
        [_mapView addAnnotation:pointAnnotation];
    }
}


- (void)mySiteData
{
    NSDictionary *dic1;
    dic1= @{
            @"name" : @"黄浦区120",
            @"latitude" : @(31.227203),
            @"longitude" : @(121.496072)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"徐汇区30",
            @"latitude" : @(31.169152),
            @"longitude" : @(121.446535)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"长宁区20",
            @"latitude" : @(31.213301),
            @"longitude" : @(121.387616)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"静安区50",
            @"latitude" : @(31.235381),
            @"longitude" : @(121.454756)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"普陀区40",
            @"latitude" : @(31.263743),
            @"longitude" : @(121.398443)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"虹口区60",
            @"latitude" : @(31.282497),
            @"longitude" : @(121.491919)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"杨浦区50",
            @"latitude" : @(31.304510),
            @"longitude" : @(121.535717)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"闵行区10",
            @"latitude" : @(31.093538),
            @"longitude" : @(121.425024)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"宝山区1",
            @"latitude" : @(31.398623),
            @"longitude" : @(121.409041)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"嘉定区20",
            @"latitude" : @(31.364338),
            @"longitude" : @(121.251014)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"浦东新区40",
            @"latitude" : @(31.230895),
            @"longitude" : @(121.638481)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"金山区",
            @"latitude" : @(30.835081),
            @"longitude" : @(121.248408)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"松江区20",
            @"latitude" : @(31.021245),
            @"longitude" : @(121.226791)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"青浦区",
            @"latitude" : @(31.130862),
            @"longitude" : @(121.091425)
            };
    [_mySiteary addObject:dic1];
    dic1= @{
            @"name" : @"奉贤区30",
            @"latitude" : @(30.915122),
            @"longitude" : @(121.560642)
            };
    [_mySiteary addObject:dic1];
}


#pragma mark --资讯热点
- (void)myHotspots
{
    [_mapView removeAnnotations:_mapView.annotations];

}





#pragma mark -
#pragma mark implement BMKMapViewDelegate
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if(self.tag == 0) //监理顾问
    {
        //普通annotation
        NSString *AnnotationViewID = @"myConsultantAnnotation";
        myConsultantAnnotation *cluster = (myConsultantAnnotation*)annotation;
        myConsultantAnnotationView *annotationView = [[myConsultantAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.size = cluster.size;
        annotationView.datadic = cluster.datadic;
        annotationView.draggable = YES;
        annotationView.annotation = cluster;
        return annotationView;

    }
    else if(self.tag == 1) //在建工地
    {
        //普通annotation
        NSString *AnnotationViewID = @"renameMark";
        mySiteClusterAnnotation *cluster = (mySiteClusterAnnotation*)annotation;
        //        ClusterAnnotationViews *annotationView = (ClusterAnnotationViews *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        //        if (annotationView == nil) {
        mySiteClusterAnnotationView *annotationView = [[mySiteClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.AnnotationViewsdic = cluster.Annotationsdic;
        annotationView.ishidelabel = cluster.ishidelabel;
        annotationView.annotation = cluster;
        annotationView.datadic = cluster.datadic;
        //        }
        return annotationView;
    }
    
    return nil;
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if ([view isKindOfClass:[myConsultantAnnotationView class]] && self.tag == 0) {
        myConsultantAnnotation *clusterAnnotation = (myConsultantAnnotation*)view.annotation;
        if (clusterAnnotation.size > 1) {
            [mapView setCenterCoordinate:view.annotation.coordinate];
            [mapView zoomIn];
        }
    }
}

/**
 * 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"点击了");
}


/**
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    if(self.tag==0)[self myConsultantClusters];
}

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status
{
    NSLog(@"缩放级别：%f,旋转角度：%f，俯视角度：%f，屏幕坐标中心店：%f，地理坐标中心店：%f",status.fLevel,status.fRotation,status.fOverlooking,status.targetScreenPt.x,status.targetGeoPt.latitude);
    NSLog(@"二级聚合：%ld，再次聚合：%ld，选中：%ld",(long)_clusterZoom,(NSInteger)mapView.zoomLevel,self.tag);
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel)
    {
        switch (self.tag)
        {
            case 0: ////监理顾问
            {
                [self myConsultantClusters];
            }
                break;
            case 1: ////在线工地
            {
                [self mySiteClusters];
            }
                break;
            case 2: ////资讯热点
            {
            }
                break;
            default:
                break;
        }
    }
}


- (void)mySiteClusters
{
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    if(_clusterZoom==15)
    {
        [_mapView removeAnnotations:_mapView.annotations];
        for (NSInteger i = 0; i < 100; i++)
        {
            NSDictionary *dic = @{
                                  @"nametype" : [NSString stringWithFormat:@"姓名%ld  类型%ld",(long)i,(long)i], //监理姓名 监理类型
                                  @"portrait" : @"btn_jyjd_1", //监理头像
                                  @"address" : [NSString stringWithFormat:@"上海市普陀区南山区科技园区%ld门派步步高",(long)i], //监理地址
                                  };
            double lat =  (arc4random() % 100) * 0.001f;
            double lon =  (arc4random() % 100) * 0.001f;
            mySiteClusterAnnotation* pointAnnotation = [[mySiteClusterAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = 31.249162 + lat;
            coor.longitude = 121.487899 + lon;
            pointAnnotation.coordinate = coor;
            pointAnnotation.ishidelabel = YES;
            pointAnnotation.datadic = dic;
            [_mapView addAnnotation:pointAnnotation];
        }
    }
    else if(_clusterZoom == 13)
    {
        [_mapView removeAnnotations:_mapView.annotations];
        for (int i =0; i<_mySiteary.count; i++)
        {
            NSDictionary *lodic = _mySiteary[i];
            mySiteClusterAnnotation* pointAnnotation = [[mySiteClusterAnnotation alloc]init];
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


//更新聚合状态
- (void)myConsultantClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        myConsultantAnnotation *annotation = [[myConsultantAnnotation alloc] init];
                        NSArray *ary = item.clusterItems;
                        NSLog(@"多少个数组：%lu  数组：%@",(unsigned long)ary.count,ary);
                        BMKClusterItem *itemxz = ary[0];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.datadic = itemxz.datadic;
                        [clusters addObject:annotation];
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:clusters];
                });
            });
        }
    }
}



- (void)clickAction:(UIButton *)sender
{
    self.tag = sender.tag;
    [UIView animateWithDuration:0.25 animations:^{
        _lineview.frame = CGRectMake((zScreenWidth/3)*self.tag, 44-3, zScreenWidth/3, 3);
    }];
    [self brightbtn:self.tag];
    if(self.tag == 0)[self myConsultantClusters];
}

- (void)brightbtn:(NSInteger)tags
{
    switch (tags) {
        case 0: //监理顾问
        {
            [_consultantbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_consultantbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [_Sitebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_Sitebtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [_Hotspotsbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_Hotspotsbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [_mapView setCenterCoordinate:(CLLocationCoordinate2D){31.249162, 121.487899} animated:YES];
            [self performSelector:@selector(afterrgion) withObject:self afterDelay:0.20];
            [self myConsultant];
        }
            break;
        case 1: //在线工地
        {
            [_consultantbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_consultantbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [_Sitebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_Sitebtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [_Hotspotsbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_Hotspotsbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [_mapView setCenterCoordinate:(CLLocationCoordinate2D){31.249162, 121.487899} animated:YES];
            [self performSelector:@selector(afterrgion) withObject:self afterDelay:0.20];
            [self mySite];
        }
            break;
        case 2: //资讯热点
        {
            [_consultantbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_consultantbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [_Sitebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_Sitebtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [_Hotspotsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_Hotspotsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [_mapView setCenterCoordinate:(CLLocationCoordinate2D){31.249162, 121.487899} animated:YES];
            [self myHotspots];
        }
            break;
            
        default:
            break;
    }
}

//缩放比例
- (void)afterrgion
{
    switch (self.tag)
    {
        case 0: ////监理顾问
        {
            [_mapView setZoomLevel:13.0];
        }
            break;
        case 1: ////在线工地
        {
            [_mapView setZoomLevel:13.0];
        }
            break;
        case 2: ////资讯热点
        {
        }
            break;
        default:
            break;
    }
}












#pragma mark -- 创建控件

- (UIView *)mapbgview
{
    if(_mapbgview == nil)
    {
        _mapbgview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, zScreenWidth, 44)];
//        _mapbgview.backgroundColor = [UIColor orangeColor];
    }
    return _mapbgview;
}


- (UIButton *)consultantbtn
{
    if(_consultantbtn == nil)
    {
        _consultantbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _consultantbtn.frame = CGRectMake(0, 0, zScreenWidth/3, 44);
        [_consultantbtn setTitle:@"监理顾问" forState:UIControlStateNormal];
        [_consultantbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_consultantbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _consultantbtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _consultantbtn.tag = 0;
        [_consultantbtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _consultantbtn;
}

- (UIButton *)Sitebtn
{
    if(_Sitebtn == nil)
    {
        _Sitebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _Sitebtn.frame = CGRectMake(zScreenWidth/3, 0, zScreenWidth/3, 44);
        [_Sitebtn setTitle:@"在线工地" forState:UIControlStateNormal];
        [_Sitebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_Sitebtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _Sitebtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _Sitebtn.tag = 1;
        [_Sitebtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Sitebtn;
}


- (UIButton *)Hotspotsbtn
{
    if(_Hotspotsbtn == nil)
    {
        _Hotspotsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _Hotspotsbtn.frame = CGRectMake((zScreenWidth/3)*2, 0, zScreenWidth/3, 44);
        [_Hotspotsbtn setTitle:@"咨询热点" forState:UIControlStateNormal];
        [_Hotspotsbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_Hotspotsbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _Hotspotsbtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _Hotspotsbtn.tag = 2;
        [_Hotspotsbtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Hotspotsbtn;
}


- (UIView *)lineview
{
if(_lineview == nil)
{
    _lineview = [[UIView alloc] initWithFrame:CGRectMake((zScreenWidth/3)*self.tag, 44-3, zScreenWidth/3, 3)];
    _lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:194/255.0 blue:79/255.0 alpha:1.0];
}
    return _lineview;
}

- (BMKMapView *)mapView
{
if(_mapView == nil)
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapbgview.frame), zScreenWidth, zScreenHeight-64-44)];
    [_mapView setZoomLevel:13.0];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showMapScaleBar = YES;
    [_mapView setCenterCoordinate:(CLLocationCoordinate2D){31.249162, 121.487899} animated:YES];
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(_mapView.frame.size.width - 70, _mapView.frame.size.height - 58);
}
    return _mapView;
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
    if (_mapView)
    {
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
