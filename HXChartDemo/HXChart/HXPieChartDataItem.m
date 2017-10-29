//
//  HXPieChartDataItem.m
//  HXChart
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我
#import "HXPieChartDataItem.h"
#import "HXColor.h"

@interface HXPieChartDataItem()

@end

@implementation HXPieChartDataItem
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor *)color {
    HXPieChartDataItem *item = [[HXPieChartDataItem alloc]init];
    if (color) {
        item.color = color;
    }
    item.value = value;
    return item;
}

//快速创建方法
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor *)color describe:(NSString *)describe {
    HXPieChartDataItem *item = [[HXPieChartDataItem alloc]init];
    if (color) {
        item.color = color;
    }
    item.value = value;
    item.describe = describe;
    return item;
}

- (instancetype)init {
    if ([super init]) {
        self.color = HXRandomColor;
        self.describe = @"";
        self.describeTextSize = 16.0;
        self.describeTextFont = [UIFont fontWithName:@"Avenir-Medium" size:self.describeTextSize];
        self.describeTextColor = [UIColor whiteColor];
        self.valueTextSize = 12.0;
        self.valueTextFont = [UIFont systemFontOfSize:self.valueTextSize];
        self.valueTextColor = [UIColor whiteColor];
        self.pieChartValueTextLocationType = HXPieChartValueTextLocationTypeTop;
    }
    return self;
}

- (void)setValue:(CGFloat)value {
    NSAssert(value >= 0, @"value应该大于0");
    _value = value;
}

@end
