//
//  HXLineChartViewController.m
//  HXChartDemo
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXLineChartViewController.h"

@interface HXLineChartViewController ()

@end

@implementation HXLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"折线图";
    [self addChart];
}

- (void)addChart {
    //图表
    HXLineChart *chart = [[HXLineChart alloc]initWithFrame:CGRectMake(10, 77, 350, 240)];
    chart.xAxisTextArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月"];
    chart.yAxisTextArray = @[@"30",@"25",@"20",@"15",@"10",@"5",@"1"];
    chart.yValueMax = 0.0;
    chart.yValueMin =30.0;
    chart.xAxisUnit = @"月份";
    chart.yAxisUnit = @"名次";
    chart.yAxisTextFont = [UIFont boldSystemFontOfSize:10];
    
    //数据
    HXLineChartDataItem *data2 = [[HXLineChartDataItem alloc]init];
    data2.pointStyle = HXLineChartPointStyleTriangle;
    data2.dataArray = @[@8,@16,@15,@19,@14,@19,@14,@19,@14];
    chart.dataArray = @[data2];
    [self.view addSubview:chart];
}

@end
