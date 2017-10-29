//
//  HXPieChart.h
//  HXChart
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import <UIKit/UIKit.h>
#import "HXPieChartDataItem.h"
#import "HXColor.h"

@interface HXPieChart : UIView
/** 快速创建 */
+ (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray<HXPieChartDataItem *> *)dataArray;


#pragma 必需属性
/** 数据源 */
@property(nonatomic,strong) NSArray<HXPieChartDataItem *> *dataArray;


#pragma 非必需属性
/** 是否动画 - 默认YES*/
@property(nonatomic,assign) BOOL  isAnimation;

/** 动画时间 - 默认1秒*/
@property(nonatomic,assign) CGFloat animationDuration;

/** 空心圆所占比例 - 默认是0.4空心圆 - 取值是0~1 */
@property(nonatomic,assign) CGFloat hollowRadius;

/** 是否显示数值 - 默认YES*/
@property(nonatomic,assign) BOOL isShowValueText;
@end
