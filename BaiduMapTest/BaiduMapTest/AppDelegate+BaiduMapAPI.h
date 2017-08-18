//
//  AppDelegate+BaiduMapAPI.h
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate (BaiduMapAPI)<BMKGeneralDelegate> 

- (void)initWithBaiduKey:(NSString *)keyString;

@end
