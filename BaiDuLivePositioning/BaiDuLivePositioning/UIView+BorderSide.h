//
//  UIView+BorderSide.h
//  BaiDuLivePositioning
//
//  Created by 余晔 on 2017/8/8.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 边框类型(位移枚举)
typedef NS_ENUM(NSInteger, UIBorderSideType) {
    UIBorderSideTypeAll    = 0,
    UIBorderSideTypeTop    = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft   = 1 << 2,
    UIBorderSideTypeRight  = 1 << 3,
};

@interface UIView (BorderSide)
- (UIView *)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;
@end
