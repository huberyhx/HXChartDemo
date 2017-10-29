//
//  HXPieChartDataItem.h
//  HXChart
//
//  Created by hubery on 2017/10/27.
//  Copyright © 2017年 hubery. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , HXPieChartValueTextLocationType) {
    /** 数值在上 描述在下 */
    HXPieChartValueTextLocationTypeTop = 0,
    /** 数值在下 描述在上 */
    HXPieChartValueTextLocationTypeBottom = 1,
};

struct HXAngle {
    CGFloat start;
    CGFloat end;
};

@interface HXPieChartDataItem : NSObject
//快速创建方法
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor *)color;
//快速创建方法
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor *)color describe:(NSString *)describe;


#pragma 必需属性
/** 数值 - 可以是任意值,HXChart会根据总和计算比例*/
@property(nonatomic,assign) CGFloat value;


#pragma 非必需属性
/** 颜色 - 默认随机色*/
@property(nonatomic,strong) UIColor *color;

/** 描述内容- 默认空 */
@property(nonatomic,strong) NSString *describe;

/** 描述内容Text字体 */
@property(nonatomic,strong) UIFont *describeTextFont;

/** 描述内容Text字体颜色 - 默认白色*/
@property(nonatomic,strong) UIColor *describeTextColor;

/** 描述内容Text字体大小 - 默认16*/
@property(nonatomic,assign) CGFloat describeTextSize;

/** 数值Text字体 */
@property(nonatomic,strong) UIFont *valueTextFont;

/** 数值Text字体颜色 - 默认白色*/
@property(nonatomic,strong) UIColor *valueTextColor;

/** 数值Text字体大小 - 默认14*/
@property(nonatomic,assign) CGFloat valueTextSize;

/** 数值位置 - 默认HXPieChartValueTextLocationTypeTop*/
@property(nonatomic,assign) HXPieChartValueTextLocationType pieChartValueTextLocationType;

#pragma 计算属性
/** 百分比 */
@property(nonatomic,assign) CGFloat scale;

/** 在图表中的角度 */
@property(nonatomic,assign) struct HXAngle angle;

/** 数值的位置 */
@property(nonatomic,assign) CGPoint valueTextPoint;
@end
