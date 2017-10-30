//
//  HXBarChart.h
//  HXChart
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import <UIKit/UIKit.h>

/** 条形柱上数值显示类型 */
typedef NS_ENUM(NSUInteger , HXBarChartValuePositionStyle) {
    /** 不显示数值 - 默认值*/
    HXBarChartValuePositionStyleNone = 0,
    /** 显示在条形柱顶端 */
    HXBarChartValuePositionStyleTop = 1,
    /** 显示在条形柱中间 (如果条形柱没有数值Label高,则显示在条形柱上面)  */
    HXBarChartValuePositionStyleBetween = 2
};

@interface HXBarChart : UIView
#pragma 图标相关属性:
#pragma 必需属性
/** 条形柱数值数组*/
@property(nonatomic,strong) NSArray *dataArray;

/** Y轴最大值 */
@property(nonatomic,assign) CGFloat yValueMax;

/** Y轴最小值 */
@property(nonatomic,assign) CGFloat yValueMin;

/** X轴刻度值Text数组 - 数组不仅用于显示,而且用于坐标计算,如果不想显示,则可设置isShowXAxisText为NO*/
@property(nonatomic,strong) NSArray *xAxisTextArray;

/** Y轴刻度值Text数组 - 数组不仅用于显示,而且用于坐标计算,如果不想显示,则可设置isShowYAxisText为NO*/
@property(nonatomic,strong) NSArray *yAxisTextArray;

#pragma 非必需属性
/** 是否动画 - 默认YES*/
@property(nonatomic,assign) BOOL isAnimate;

/** 动画时长 - 默认0.5秒 */
@property(nonatomic,assign) CGFloat animateDuration;

/** 每个条形柱之间的间距 - 默认1 -  取值是0~1 ,1=柱宽*100%, 0.5=柱宽*50%   */
@property(nonatomic,assign) CGFloat barGap;

/** 是否显示坐标轴 - 默认YES*/
@property(nonatomic,assign) BOOL isShowAxis;

/** 坐标轴颜色 - 默认灰色*/
@property(nonatomic,strong) UIColor *axisColor;

/** 坐标轴宽度 默认1 */
@property(nonatomic,assign) CGFloat axisWidth;

/** 是否显示刻度值虚线 - 默认NO */
@property(nonatomic,assign) BOOL isShowDottedLine;

/** 是否显示X轴Text - 默认Yes*/
@property(nonatomic,assign) BOOL isShowXAxisText;

/** 是否显示Y轴Text  - 默认YES*/
@property(nonatomic,assign) BOOL isShowYAxisText;

/** X轴Text字体 */
@property(nonatomic,strong) UIFont *xAxisTextFont;

/** X轴字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat xAxisTextSize;

/** Y轴字体 */
@property(nonatomic,strong) UIFont *yAxisTextFont;

/** Y轴字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat yAxisTextSize;

/** 左内边距 - 用于显示Y轴Label - 默认25*/
@property(nonatomic,assign) CGFloat leftMargin;

/** 下内边距 - 用于显示X轴Label - 默认25 */
@property(nonatomic,assign) CGFloat bottomMargin;

/** 右内边距 - 用于显示X轴单位 - 默认25*/
@property(nonatomic,assign) CGFloat rightMargin;

/** 上内边距 - 用于显示Y轴单位 - 默认25 */
@property(nonatomic,assign) CGFloat topMargin;

/** 最左边条形柱距Y轴距离 - 默认是0.5 -取值是0~1 ,1=柱宽*100%,0.5=柱宽*50%  */
@property(nonatomic,assign) CGFloat barLeftGap;

/** 最右边边条形柱距边界距离 - 默认是0.5 -取值是0~1 ,1=柱宽*100%,0.5=柱宽*50%   */
@property(nonatomic,assign) CGFloat barRightGap;


#pragma 条形柱相关属性
#pragma 非必需属性:
/** 条形柱数值的显示位置 - 默认是HXBarChartValueStyleNone*/
@property(nonatomic,assign) HXBarChartValuePositionStyle barChartValuePositionStyle;

/** 条形柱颜色 - 默认绿色*/
@property(nonatomic,strong) UIColor *barColor;

/** 条形柱渐变颜色底部 - 默认就是barColor */
@property(nonatomic,strong) UIColor *fromColor;

/** 条形柱渐变颜色上部 - 默认就是barColor  */
@property(nonatomic,strong) UIColor *toColor;

/** 条形柱的圆角半径 - 默认条形柱宽度的15% */
@property(nonatomic,assign) CGFloat barCornerRadius;

/** 条形柱数值颜色 - 默认黑色 */
@property(nonatomic,strong) UIColor *barValueTextColor;

/** 条形柱数值字体 */
@property(nonatomic,strong) UIFont *barValueTextFont;

/** 条形柱数值字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat barValueTextSize;

/** 是否显示条形柱背景 */
@property(nonatomic,assign) BOOL isShowBarBackColor;

/** 条形柱背景颜色 - 默认灰色*/
@property(nonatomic,strong) UIColor *barBackColor;

@end
