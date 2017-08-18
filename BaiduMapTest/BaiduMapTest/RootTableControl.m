//
//  RootTableControl.m
//  BaiduMapTest
//
//  Created by 谭启宏 on 16/1/21.
//  Copyright © 2016年 谭启宏. All rights reserved.
//

#import "RootTableControl.h"
#import "BaseMapControl.h"
#import "LocationControl.h"
#import "AnnotationControl.h"
#import "POISearchControl.h"
#import "GeocodeControl.h"
#import "RouteSearchControl.h"
#import "BusLineSearch.h"
#import "ShareUrlControl.h"
#import "CloudSearch.h" //云检索
#import "PointAggregation.h"

@interface RootTableControl ()

@property (nonatomic,strong)NSArray *titleArray;

@end

@implementation RootTableControl

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"基本地图功能",@"定位功能",@"地图覆盖物",@"poi搜索",@"地理正反编码",@"路径规划",@"公交线路",@"url分享",@"云检索",@"点聚合"];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百度地图测试";
    [self setTranslucent];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *control = nil;
    
    if (indexPath.row == 0) {
        control = [[BaseMapControl alloc]init];
    }else if (indexPath.row == 1) {
        control = [[LocationControl alloc]init];
    }else if (indexPath.row == 2) {
        control = [[AnnotationControl alloc]init];
    }else if (indexPath.row == 3) {
        control = [[POISearchControl alloc]init];
    }else if (indexPath.row == 4) {
        control = [[GeocodeControl alloc]init];
    }else if (indexPath.row == 5) {
        control = [[RouteSearchControl alloc]init];
    }else if (indexPath.row == 6) {
        control = [[BusLineSearch alloc]init];
    }else if (indexPath.row == 7) {
        control = [[ShareUrlControl alloc]init];
    }else if (indexPath.row == 8) {
        control = [[CloudSearch alloc]init];
    }else if (indexPath.row == 9) {
        control = [[PointAggregation alloc]init];
    }
    
    control.title = self.titleArray[indexPath.row];
    [self.navigationController pushViewController:control animated:YES];
}

@end
