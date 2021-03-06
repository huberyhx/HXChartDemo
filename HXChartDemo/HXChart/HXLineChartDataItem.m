//
//  HXLineChartData.m
//  HXChart
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我
#import "HXLineChartDataItem.h"
#import "HXColor.h"

@implementation HXLineChartDataItem

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.lineWidth = 2.0;
    self.lineColor = HXFreshGreen;
    self.showPointText = YES;
    self.pointTextSize = 12.0f;
    self.pointTextFont = [UIFont fontWithName:@"HiraKakuProN-W3" size:self.pointTextSize];
    self.pointStyle = HXLineChartPointStyleCircle;
    self.pointColor = HXRed;
    self.pointTextColor = [UIColor blackColor];
}

@end

