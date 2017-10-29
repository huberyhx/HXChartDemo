//
//  HXPieChartViewControllerViewController.m
//  HXChartDemo
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  

#import "HXPieChartViewController.h"

@interface HXPieChartViewController ()

@end

@implementation HXPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"饼图";
    [self addChart];
}

- (void)addChart {
    //数据
    HXPieChartDataItem *item = [HXPieChartDataItem dataItemWithValue:70 color:HXFreshGreen describe:@"购物"];
    item.valueTextColor = [UIColor redColor];
    item.pieChartValueTextLocationType = HXPieChartValueTextLocationTypeBottom;
    NSArray *items = @[
                       [HXPieChartDataItem dataItemWithValue:15 color:HXLightGreen describe:@"出行"],
                       item,
                       [HXPieChartDataItem dataItemWithValue:15 color:HXDeepGreen]
                       ];
    //图表
    HXPieChart *pieChart = [HXPieChart initWithFrame:CGRectMake(50, 150, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100) dataArray:items];
    [self.view addSubview:pieChart];
}


@end
