//
//  AppDelegate+BaiduMapAPI.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "AppDelegate+BaiduMapAPI.h"

BMKMapManager* _mapManager;

@implementation AppDelegate (BaiduMapAPI)

- (void)initWithBaiduKey:(NSString *)keyString {
    //百度地图初始化
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret = [_mapManager start:keyString generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - BMKGeneralDelegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
