//
//  HXCircleChartViewControllerViewController.m
//  HXChartDemo
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXCircleChartViewController.h"

@interface HXCircleChartViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property(nonatomic,strong) HXCircleChart *circleChart;
@end

@implementation HXCircleChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进度图";
    [self addChart];
}

- (void)addChart {
    self.circleChart = [[HXCircleChart alloc]init];
    self.circleChart.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100);
    [self.view addSubview:self.circleChart];
}

- (IBAction)change:(UISlider *)sender {
    self.circleChart.value = sender.value;
}

- (IBAction)add:(UIButton *)sender {
    CGFloat value = self.circleChart.value + 20;
    self.circleChart.value = value;
    self.slider.value = value;
}

- (IBAction)cut:(UIButton *)sender {
    CGFloat value = self.circleChart.value - 20;
    self.circleChart.value = value;
    self.slider.value = value;
}

@end
