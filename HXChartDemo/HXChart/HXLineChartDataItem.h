//
//  HXLineChartDataItem.h
//  HXChart
//
//  Created by hubery on 2017/10/27.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , HXLineChartPointStyle) {
    /** 不显示拐点的类型*/
    HXLineChartPointStyleNone = 0,
    /** 拐点显示的类型为圆圈 - 默认值 */
    HXLineChartPointStyleCircle = 1,
    /** 拐点的类型为三角形 */
    HXLineChartPointStyleTriangle = 2,
    /** 自定义拐点显示的Layer  如果设置了这个值 , 必须调用pointStyleGetter  创建自定义的CAShapeLayer*/
    HXLineChartPointStyleCustom = 3
};

typedef  CAShapeLayer *(^ LinePointStyleGetter)(CGPoint point);

@interface HXLineChartDataItem : NSObject
#pragma 线的属性 :
/** 该折线的数值 (拐点值) */
@property(nonatomic,strong) NSArray *dataArray;
/** 线粗 - 默认2 */
@property(nonatomic,assign) CGFloat lineWidth;
/** 线颜色 - 默认浅绿色*/
@property(nonatomic,strong) UIColor  *lineColor;

#pragma 拐点的属性 :
/** 是否显示拐点Text - 默认YES */
@property(nonatomic,assign) BOOL showPointText;
/** 拐点Text的字体 */
@property(nonatomic,strong) UIFont *pointTextFont;
/** 拐点Text的文字大小 - 默认12*/
@property(nonatomic,assign) CGFloat pointTextSize;
/** 拐点的主色调  - 默认红色*/
@property(nonatomic,strong) UIColor *pointColor;
/** 拐点Text的文字颜色  - 默认黑色*/
@property(nonatomic,strong) UIColor *pointTextColor;
/** 显示的拐点类型  默认圆形*/
@property(nonatomic,assign) HXLineChartPointStyle pointStyle;
/** 自定义拐点类型需要赋值的block */
@property(nonatomic,strong)   LinePointStyleGetter pointStyleGetter;
@end
