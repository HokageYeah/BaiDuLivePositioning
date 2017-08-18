//
//  BaseMapControl.h
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseMapControl : UIViewController<BMKMapViewDelegate>
@property (nonatomic,strong)BMKMapView* mapView;
@end
