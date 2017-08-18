//
//  FateModel.h
//  moyou
//
//  Created by 幻想无极（谭启宏） on 16/8/2.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FateModel : NSObject

@property (nonatomic,copy)NSString *uid;//用户名
@property (nonatomic,copy)NSString *pic;//照片地址
@property (nonatomic,assign)NSInteger isvip;//1是，0否
@property (nonatomic,copy)NSString *name;//用户名
@property (nonatomic,assign)NSInteger sex;//性别，1男2女
@property (nonatomic,assign)CGFloat distance;//距离，单位米
@property (nonatomic,assign)NSInteger picnum;//图片数量
@property (nonatomic,assign)NSTimeInterval online;//最后在线时间戳精确到秒，若当前在线则返回-1
@property (nonatomic,assign)CGFloat lon;//经度，地图模式才有
@property (nonatomic,assign)CGFloat lat;//纬度，地图模式才有
@property (nonatomic,copy)NSString *signature;//签名
@property (nonatomic,assign)NSInteger age;//年龄
@end
