//
//  HXLineChart.h
//  HXChart
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import <UIKit/UIKit.h>
#import "HXLineChartDataItem.h"
#import "HXColor.h"

@interface HXLineChart : UIView
#pragma 必需属性:

/** 折线数据 */
@property(nonatomic,strong,nonnull) NSArray<HXLineChartDataItem *> *dataArray;

/** Y轴最大值 - 是Y轴最顶端的值*/
@property(nonatomic,assign) CGFloat yValueMax;

/** Y轴最小值 - 是Y轴最低端的值*/
@property(nonatomic,assign) CGFloat yValueMin;

/** X轴坐标值数组 - 数组的顺序是从X轴左向右 - 数组不仅用于显示,而且用于坐标计算,如果不想显示,则可设置isShowXAxisText为NO*/
@property(nonatomic,strong,nonnull) NSArray *xAxisTextArray;

/** Y轴坐标值数组 - 数组的顺序是从Y轴的底部到顶部 - 数组不仅用于显示,而且用于坐标计算,如果不想显示,则可设置isShowYAxisText为NO*/
@property(nonatomic,strong,nonnull) NSArray *yAxisTextArray;

#pragma 非必需属性:

/** 是否显示坐标轴 - 默认YES */
@property(nonatomic,assign) BOOL isShowAxis;

/** 是否显示刻度值虚线 - 默认YES */
@property(nonatomic,assign) BOOL isShowDottedLine;

/** 虚线颜色 - 默认灰色 */
@property(nonatomic,strong) UIColor *dottedLineColor;

/** 虚线宽度 - 默认0.4 */
@property(nonatomic,assign) CGFloat dottedLineWidth;

/** 是否显示X轴刻度值 - 默认YES */
@property(nonatomic,assign) BOOL isShowXAxisText;

/** 是否显示Y轴刻度值 - 默认YES */
@property(nonatomic,assign) BOOL isShowYAxisText;

/** X轴刻度值字体 */
@property(nonatomic,strong) UIFont *xAxisTextFont;

/** Y轴刻度值字体 */
@property(nonatomic,strong) UIFont *yAxisTextFont;

/** X轴刻度值字体颜色 - 默认黑色*/
@property(nonatomic,strong) UIColor *xAxisTextColor;

/** Y轴刻度值字体颜色 - 默认黑色 */
@property(nonatomic,strong) UIColor *yAxisTextColor;

/** X轴刻度值字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat xAxisTextSize;

/** Y轴刻度值字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat yAxisTextSize;

/** 坐标轴宽度 默认1 */
@property(nonatomic,assign) CGFloat axisWidth;

/** 坐标轴颜色  默认灰色*/
@property(nonatomic,strong) UIColor *axisColor;

/** 是否添加动画 - 默认YES */
@property(nonatomic,assign) BOOL isShowAnimate;

/** 动画时长 - 默认1秒 */
@property(nonatomic,assign) CGFloat animateDuration;

/** X轴坐标值单位 - 例如(时间 s) - 默认为空*/
@property(nonatomic,strong) NSString *xAxisUnit;

/** X坐标单位Text字体颜色 - 默认和坐标轴刻度Text颜色一样 */
@property(nonatomic,strong) UIColor *xAxisUnitColor;

/** Y轴坐标值单位 - 例如(路程 m) - 默认为空*/
@property(nonatomic,strong) NSString *yAxisUnit;

/** Y坐标单位Text字体颜色 - 默认和坐标轴刻度Text颜色一样 */
@property(nonatomic,strong) UIColor *yAxisUnitColor;

/** 左内边距 - 用于显示Y轴Label  - 默认25  但是不小于3*/
@property(nonatomic,assign) CGFloat leftMargin;

/** 下内边距 - 用于显示X轴Label - 默认25  但是不小于3*/
@property(nonatomic,assign) CGFloat bottomMargin;

/** 上内边距 - 用于显示Y轴坐标值的单位 - 默认是25 */
@property(nonatomic,assign) CGFloat topMargin;

/** 右内边距 - 用于显示X轴坐标值的单位 - 默认是25 */
@property(nonatomic,assign) CGFloat rightMargin;

@end
