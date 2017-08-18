//
//  AppDelegate.h
//  BaiDuLivePositioning
//
//  Created by 余晔 on 2017/7/26.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}


@property (strong, nonatomic) UIWindow *window;


@end

