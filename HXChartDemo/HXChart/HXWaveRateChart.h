//
//  HXWaveRateChart.h
//  HXSchome
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import <UIKit/UIKit.h>

@interface HXWaveRateChart : UIView
#pragma 非必需属性
/** 当前百分比 - 外界传入 - 范围0-100 */
@property(nonatomic,assign) CGFloat value;

/** 上层颜色 - 默认绿色 */ 
@property(nonatomic,strong) UIColor *mainColor;

/** 底层颜色 - 默认浅绿色 */
@property(nonatomic,strong) UIColor*secondColor;

/** 是否显示数字 - 默认YES */
@property(nonatomic,assign) BOOL isShowValue;

/** 数值颜色 - 默认灰色*/
@property(nonatomic,strong) UIColor *valueTextColor;

/** 数字字体大小 */
@property(nonatomic,assign) CGFloat valueTextFontSize;

/** 数字字体 */
@property(nonatomic,strong) UIFont *valueTextFont;

/** 动画总时长- 默认6.0秒 - 这是从0-100用的时间, 每次传入新的刻度 会按比例计算动画所需时间 */
@property(nonatomic,assign) CGFloat sumTime;

/** 边界宽度 - 默认1.5 */
@property(nonatomic,assign) CGFloat borderWidth;

/** 边界颜色 - 默认灰色 */
@property(nonatomic,strong) UIColor *borderColor;
@end
