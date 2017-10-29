//
//  HXBarChart.m
//  HXChart
//
//  Created by hubery on 2017/9/20.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXBarChart.h"
#import "HXColor.h"

@interface HXBarChart()
/** 表格内容高度 - 除去上下内边距的部分 */
@property (nonatomic) CGFloat chartContentHeight;
/** 表格内容宽度 - 除去左右内边距的部分 */
@property (nonatomic) CGFloat chartContentWidth;
/** 所有条形柱的坐标数组 (存条形柱的左上角坐标)*/
@property(nonatomic,strong) NSMutableArray<NSValue *> *barPointArray;
/** 条形柱宽度 */
@property(nonatomic,assign) CGFloat barWidth;
/** 条形柱间距 */
@property(nonatomic,assign) CGFloat barGapWidth;
/** 条形柱最大高度 - 也是条形柱背景色的高度*/
@property(nonatomic,assign) CGFloat barMaxHeight;
/** 所有条形柱的path */
@property(nonatomic,strong) NSMutableArray *barPathArray;
/** 所有条形柱的layer */
@property(nonatomic,strong) NSMutableArray *barLayerArray;
/** 颜色是否渐变 - 默认NO, 如果设置了fromColor或者toColor,置为YES*/
@property(nonatomic,assign) BOOL isGradient;
@end

@implementation HXBarChart

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    //图表相关设置
    self.yValueMax = -FLT_MAX;
    self.yValueMin = -FLT_MAX;
    self.axisColor = HXAxisColor;
    self.xAxisTextSize = 12.0;
    self.xAxisTextFont = [UIFont systemFontOfSize:self.xAxisTextSize];
    self.yAxisTextSize = 12.0;
    self.yAxisTextFont = [UIFont systemFontOfSize:self.xAxisTextSize];
    self.leftMargin = 25.0;
    self.bottomMargin = 25.0;
    self.topMargin = 25.0;
    self.rightMargin = 25.0;
    self.barLeftGap = 0.5;
    self.barRightGap = 0.5;
    self.barGap = 1.0;
    self.axisWidth = 1.0;
    self.barCornerRadius = -1;
    self.animateDuration = 0.5;
    
    self.isAnimate = YES;
    self.isShowAxis = YES;
    self.isShowXAxisText = YES;
    self.isShowYAxisText = YES;
    self.isShowDottedLine = NO;
    
    self.barColor = HXGreen;
    self.fromColor = self.barColor;
    self.toColor = self.barColor;
    self.isShowBarBackColor = YES;
    self.barBackColor = HXLightGrey;
    self.barValueTextColor = [UIColor blackColor];
    self.barChartValuePositionStyle = HXBarChartValuePositionStyleTop;
    self.barValueTextSize = 12;
    self.barValueTextFont = [UIFont systemFontOfSize:self.barValueTextSize];
    self.isGradient = NO;
}

- (void)drawRect:(CGRect)rect{
    NSAssert(!(self.yValueMax == -FLT_MAX), @"HXBarChart-Error : Y轴坐标值的最大值必须传入,要不没法整啊.");
    NSAssert(!(self.yValueMin == -FLT_MAX), @"HXBarChart-Error : Y轴坐标值的最小值必须传入,要不没法整啊.");
    NSAssert(self.dataArray, @"HXBarChart-Error : 没有数据没法整");
    NSAssert(self.xAxisTextArray.count, @"HXBarChart-Error : 没有X轴刻度值,没法整啊. (如果刻度值不需要显示,则可设置isShowXAxisText为NO)");
    NSAssert(self.yAxisTextArray.count, @"HXLineChart-Error : 没有Y轴刻度值,没法整啊.(如果刻度值不需要显示,则可设置isShowYAxisText为NO)");

    
    //条形柱最底部的纵坐标 (也就是x轴的纵坐标)
    CGFloat axisY = self.chartContentHeight + self.topMargin;

    
    [self calculateWithAxisY:axisY];
    [self drawBarWithAxisY:axisY];
    [self drawAxisTextWithAxisY:axisY];
    [self addBarValueWithAxisY:axisY];
    
    if (self.isShowAxis) {
        //设置坐标轴属性
        CGContextRef ctx  = UIGraphicsGetCurrentContext();
        UIGraphicsPopContext();
        UIGraphicsPushContext(ctx);
        CGContextSetLineWidth(ctx, self.axisWidth);
        CGContextSetStrokeColorWithColor(ctx, self.axisColor.CGColor);
        CGContextSetLineDash(ctx, 0, nil, 0);
        
        //绘制坐标轴
        CGContextMoveToPoint(ctx, self.leftMargin, self.topMargin);
        CGContextAddLineToPoint(ctx, self.leftMargin, axisY);
        CGContextAddLineToPoint(ctx, self.chartContentWidth + self.leftMargin, axisY);
        CGContextStrokePath(ctx);
    }
}

//进行计算
- (void)calculateWithAxisY:(CGFloat)axisY {
    //先算出条形柱宽度 条形柱间距宽度 条形柱和左右的边距
    //X轴刻度的数量
    CGFloat scaleCount = self.xAxisTextArray.count;
    //间隙数量
    CGFloat barGapCount = scaleCount - 1;
    //条形柱宽度 = 总宽度/(条形柱数量 + 间隙数量 + 左右间距数量)
    self.barWidth = self.chartContentWidth / (scaleCount + barGapCount * self.barGap + (self.barLeftGap + self.barRightGap) * 1.0);
    //如果没设置圆角计算圆角:
    if (self.barCornerRadius < 0) {
        self.barCornerRadius = self.barWidth * 0.15;
    }
    self.barGapWidth = self.barWidth * self.barGap;
    //条形柱最大高度等于表格内容高度
    self.barMaxHeight = self.chartContentHeight;
    
    for (NSInteger i = 0; i < self.xAxisTextArray.count; i++) {
        //坐标X
        CGFloat barX = self.leftMargin + (self.barWidth * self.barLeftGap) + (self.barWidth + self.barGapWidth) * i;
        if (self.dataArray.count <= i) {
            //在这里让barPointArray和xAxisTextArray数目相等,因为就算传入的barPointArray数目少,也要把xAxisTextArray全部绘制,所以需要barPointArray保存坐标
            [self.barPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(barX, axisY)]];
            continue;
        }
        //本柱的数值
        CGFloat value = [self.dataArray[i] floatValue];
        //本条形柱的高度
        CGFloat barHeight = ((value - self.yValueMin) / (self.yValueMax - self.yValueMin)) * self.barMaxHeight;
        //坐标Y
        CGFloat barY = self.topMargin + (self.barMaxHeight - barHeight);
        //保存每个点
        [self.barPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(barX, barY)]];
    }
}

- (void)drawBarWithAxisY:(CGFloat)axisY {
    for (NSInteger i = 0; i < self.barPointArray.count; i++) {
        NSValue *pointValue = self.barPointArray[i];
        CGPoint point = [pointValue CGPointValue];
        CGRect rect = CGRectMake(point.x,point.y, self.barWidth, (axisY - point.y));// - self.axisWidth * 0.5
        
        //添加背景layer
        if (self.isShowBarBackColor) {
            UIBezierPath *barBackPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x, self.topMargin, self.barWidth, axisY - self.topMargin - self.axisWidth * 0.5) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(self.barCornerRadius, self.barCornerRadius)];
            CAShapeLayer *barBackLayer = [CAShapeLayer layer];
            barBackLayer.strokeColor = [UIColor clearColor].CGColor;
            barBackLayer.fillColor = self.barBackColor.CGColor;
            barBackLayer.path = barBackPath.CGPath;
            [self.layer addSublayer:barBackLayer];
        }
        
        //添加barlayer
        CAShapeLayer *barLayer = [CAShapeLayer layer];
        barLayer.strokeColor = [UIColor clearColor].CGColor;
        barLayer.fillColor = self.barColor.CGColor;
        [self.layer addSublayer:barLayer];
        if (self.isGradient) {
            /** 判断是否需要添加渐变色layer
             如果添加就要把下面path的坐标系改为渐变色layer的坐标系
             */
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = rect;
            rect = CGRectMake(0, 0, rect.size.width, rect.size.height);
            gradientLayer.colors = @[(id)self.toColor.CGColor,(id)self.fromColor.CGColor];
            gradientLayer.startPoint = CGPointMake(0.5, 0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            [self.layer addSublayer:gradientLayer];
            gradientLayer.mask = barLayer;
        }
        UIBezierPath *barPath = nil;
        //是否显示条形柱上端的圆角
        if (self.barCornerRadius > 0) {
            barPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(self.barCornerRadius, self.barCornerRadius)];
        }else{
            barPath = [UIBezierPath bezierPathWithRect:rect];
        }
        barLayer.path = barPath.CGPath;
        [self.barPathArray addObject:barPath];
        if (_isAnimate) {
            UIBezierPath *toPath = [UIBezierPath bezierPath];
            [toPath moveToPoint:CGPointMake(rect.origin.x, (rect.origin.y + rect.size.height))];
            [toPath addLineToPoint:CGPointMake(rect.origin.x + self.barWidth, (rect.origin.y + rect.size.height))];
            [toPath addLineToPoint:CGPointMake(rect.origin.x + self.barWidth, rect.origin.y)];
            [toPath addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
            [toPath closePath];
            UIBezierPath *fromPath = [UIBezierPath bezierPath];
            [fromPath moveToPoint:CGPointMake(rect.origin.x, (rect.origin.y + rect.size.height))];
            [fromPath addLineToPoint:CGPointMake(rect.origin.x + self.barWidth, (rect.origin.y + rect.size.height))];
            [fromPath addLineToPoint:CGPointMake(rect.origin.x + self.barWidth, (rect.origin.y + rect.size.height) - 1)];
            [fromPath addLineToPoint:CGPointMake(rect.origin.x,  (rect.origin.y + rect.size.height) - 1)];
            [fromPath closePath];
            CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"path"];
            anima.duration = self.animateDuration;
            anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            anima.fromValue = (__bridge id _Nullable)fromPath.CGPath;
            anima.toValue = (__bridge id _Nullable)toPath.CGPath;
            anima.autoreverses = NO;
            [barLayer addAnimation:anima forKey:nil];
        }
    }
}

- (void)drawAxisTextWithAxisY:(CGFloat)axisY {
    if (self.isShowXAxisText) {
        //绘制X轴Text
        for (NSInteger i = 0; i < self.xAxisTextArray.count; i++) {
            CATextLayer *xAxisTextLayer = [CATextLayer layer];
            xAxisTextLayer.font = (__bridge CFTypeRef _Nullable)(self.xAxisTextFont);
            xAxisTextLayer.fontSize = self.xAxisTextSize;
            xAxisTextLayer.string = self.xAxisTextArray[i];
            xAxisTextLayer.alignmentMode = kCAAlignmentCenter;
            NSString *con = self.xAxisTextArray[i];
            CGSize size = [con sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.xAxisTextSize]}];
            CGRect rect = CGRectMake(0, 0, self.barWidth * 2, size.height);;
            xAxisTextLayer.bounds = rect;
            CGPoint position = CGPointMake([self.barPointArray[i] CGPointValue].x + self.barWidth * 0.5, axisY + size.height * 0.5);
            xAxisTextLayer.position = position;
            xAxisTextLayer.contentsScale = [UIScreen mainScreen].scale;
            xAxisTextLayer.foregroundColor = [UIColor blackColor].CGColor;
            [self.layer addSublayer:xAxisTextLayer];
        }
    }
    
    //每个刻度的高度
    CGFloat yScaleHeight = self.chartContentHeight / (self.yAxisTextArray.count - 1);
    //设置虚线颜色
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(ctx, self.axisWidth);
    CGFloat arr[] = {3,1};
    CGContextSetLineDash(ctx, 0, arr, 2);
    //绘制Y轴Text
    for (NSInteger i = 0; i < self.yAxisTextArray.count; i++) {
        CGFloat y = self.chartContentHeight - yScaleHeight*i + self.topMargin;
        if (self.isShowYAxisText) {
            NSString *contentStr = self.yAxisTextArray[i];
            CGSize size = [contentStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]}];
            CATextLayer *yAxisTextLayer = [CATextLayer layer];
            yAxisTextLayer.string = contentStr;
            yAxisTextLayer.font = (__bridge CFTypeRef _Nullable)self.yAxisTextFont;
            yAxisTextLayer.fontSize = self.yAxisTextSize;
            yAxisTextLayer.alignmentMode = kCAAlignmentCenter;
            yAxisTextLayer.contentsScale = [UIScreen mainScreen].scale;
            yAxisTextLayer.foregroundColor = [UIColor blackColor].CGColor;
            yAxisTextLayer.bounds = CGRectMake(0, 0, size.width, size.height);
            yAxisTextLayer.position = CGPointMake(self.leftMargin - size.width * 0.5 - 1,y);
            [self.layer addSublayer:yAxisTextLayer];
        }

        if (_isShowDottedLine) {
            //绘制虚线
            if (i == 0) {
                //和X轴重合的一条不绘制
                continue;
            }
            CGContextMoveToPoint(ctx, self.leftMargin, y);
            CGContextAddLineToPoint(ctx, self.chartContentWidth + self.leftMargin, y);
            CGContextDrawPath(ctx, kCGPathStroke);
        }
    }
}

- (void)addBarValueWithAxisY:(CGFloat)axisY {
    if (self.barChartValuePositionStyle == HXBarChartValuePositionStyleNone) {
        return;
    }
    //添加每条Bar的数值
    for (NSUInteger i = 0; i < self.dataArray.count; i++) {
        if (self.barPointArray.count <= i) {
            break;
        }
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.font = (__bridge CFTypeRef _Nullable)(self.barValueTextFont);
        textLayer.fontSize = self.barValueTextSize;
        textLayer.alignmentMode = kCAAlignmentCenter;
        NSString *str = self.dataArray[i];
        textLayer.string = [NSString stringWithFormat:@"%@",str];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = self.barValueTextColor.CGColor;
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName : self.barValueTextFont}];
        CGRect rect = CGRectMake(0, 0, self.barWidth, size.height);
        textLayer.bounds = rect;
        if (self.barChartValuePositionStyle == HXBarChartValuePositionStyleTop) {
            CGPoint point = [self.barPointArray[i] CGPointValue];
            CGFloat x =point.x + self.barWidth * 0.5;
            CGFloat y =point.y - size.height * 0.5;
            textLayer.position = CGPointMake(x,y);
        }else if (self.barChartValuePositionStyle == HXBarChartValuePositionStyleBetween){
            CGPoint point = [self.barPointArray[i] CGPointValue];
            CGFloat x =point.x + self.barWidth * 0.5;
            CGFloat y =point.y + (axisY - point.y) * 0.5;
            if ((y + size.height * 0.5) > axisY) {
                y = axisY - size.height * 0.5;
            }
            textLayer.position = CGPointMake(x, y);
        }
        [self.layer addSublayer:textLayer];
    }
}

#pragma set方法
- (void)setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
    /**
     当改变了内边距以后
     表格的内容宽高也会变化
     所以置宽高为0
     让宽高在get方法中重新计算
     */
    self.chartContentHeight = 0;
    self.chartContentWidth = 0;
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    self.chartContentHeight = 0;
    self.chartContentWidth = 0;
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    self.chartContentHeight = 0;
    self.chartContentWidth = 0;
}

- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    self.chartContentHeight = 0;
    self.chartContentWidth = 0;
}

- (void)setFromColor:(UIColor *)fromColor {
    _fromColor = fromColor;
    self.isGradient = YES;
}

- (void)setToColor:(UIColor *)toColor {
    _toColor = toColor;
    self.isGradient = YES;
}
#pragma 懒加载
- (CGFloat)chartContentHeight {
    if (_chartContentHeight == 0) {
        _chartContentHeight = self.frame.size.height - self.topMargin - self.bottomMargin;
    }
    return _chartContentHeight;
}

- (CGFloat)chartContentWidth {
    if (_chartContentWidth == 0) {
        _chartContentWidth = self.frame.size.width - self.leftMargin - self.rightMargin;
    }
    return _chartContentWidth;
}

- (NSMutableArray<NSValue *> *)barPointArray{
    if (!_barPointArray) {
        _barPointArray = [[NSMutableArray alloc]init];
    }
    return _barPointArray;
}

@end
