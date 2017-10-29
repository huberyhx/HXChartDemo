//
//  HXWaveRateChartViewController.m
//  HXChartDemo
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXWaveRateChartViewController.h"

@interface HXWaveRateChartViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property(nonatomic,strong) HXWaveRateChart *waveRateChart;
@end

@implementation HXWaveRateChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"波浪进度图";
    [self addChart];
}

- (void)addChart {
    self.waveRateChart = [[HXWaveRateChart alloc]init];
    self.waveRateChart.isShowValue = YES;
    self.waveRateChart.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100);
    [self.view addSubview:self.waveRateChart];
}

- (IBAction)changeClick:(UISlider *)sender {
    self.waveRateChart.value =  sender.value;
}

- (IBAction)add:(UIButton *)sender {
    CGFloat value = self.waveRateChart.value+ 20;
    self.waveRateChart.value =  value;
    self.slider.value = value;
}

- (IBAction)cut:(UIButton *)sender {
    CGFloat value = self.waveRateChart.value+ 20;
    self.waveRateChart.value =  value;
    self.slider.value = value;
}

@end
