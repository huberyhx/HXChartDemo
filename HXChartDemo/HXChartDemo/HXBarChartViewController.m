//
//  HXBarChartViewController.m
//  HXChartDemo
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXBarChartViewController.h"

@interface HXBarChartViewController ()

@end

@implementation HXBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"柱状图";
    [self addChart];
}

- (void)addChart {
    HXBarChart *barChart = [[HXBarChart alloc]initWithFrame:CGRectMake(18, 77, [UIScreen mainScreen].bounds.size.width - 36, 200)];
    barChart.yValueMax = 100.0;
    barChart.yValueMin = 0.0;
    barChart.barChartValuePositionStyle = HXBarChartValuePositionStyleBetween;
    barChart.dataArray = @[@"2",@"40",@"60",@"100",@"60",@"100",@"60",@"100"];
    barChart.xAxisTextArray = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物"];
    barChart.yAxisTextArray = @[@"0",@"20",@"40",@"60",@"80",@"100"];
    [self.view addSubview:barChart];
}


@end
