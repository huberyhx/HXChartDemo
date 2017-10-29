//
//  HXCircleChart.h
//  HXSchome
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import <UIKit/UIKit.h>

@interface HXCircleChart : UIView
#pragma 非必需属性
/** 当前值 默认取值0~100*/
@property(nonatomic,assign) CGFloat value;

/** 线宽度 - 默认8*/
@property(nonatomic,assign) CGFloat lineWidth;

/** 是否自动计算并显示当先数值  - 默认YES - 如果设置NO,需要自己传入valueText属性*/
@property(nonatomic,assign) BOOL isAutomaticCalculationValue;

/** 值内容 - 可不传自动生成*/
@property(nonatomic,strong) NSString *valueText;

/** 最大值 - 默认100*/
@property(nonatomic,assign) CGFloat maxValue;

/** 最小值 - 默认0*/
@property(nonatomic,assign) CGFloat minValue;

/** 颜色 - 默认深灰色 */
@property(nonatomic,strong) UIColor *color;

/** 是否动画 - 默认YES*/
@property(nonatomic,assign) BOOL isAnimation;

/** 动画总时间时间 - 默认4秒 (根据值跨度,计算具体时间)*/
@property(nonatomic,assign) CGFloat duration;

/** 是否显示Label - 默认显示 */
@property(nonatomic,assign) BOOL isShowValue;

/** label字体 */
@property(nonatomic,strong) UIFont *valueTextFont;

/** label字体大小 - 默认12*/
@property(nonatomic,assign) CGFloat valueTextSize;

/** label颜色 - 默认灰色 */
@property(nonatomic,strong) UIColor *valueTextColor;

/** 是否显示背景Layer */
@property(nonatomic,assign) BOOL isShowBack;

/** 背景Layer颜色 */
@property(nonatomic,strong) UIColor *backColor;
@end
