//
//  UIViewController+Extension.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)setTranslucent {
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

@end
