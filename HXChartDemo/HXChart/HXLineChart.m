//
//  HXLineChart.m
//  HXChart
//
//  Created by hubery on 2017/9/4.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXLineChart.h"


@interface HXLineChart()
/** 表格内容高度 - 除去X轴左侧和Y轴下部的部分 */
@property (nonatomic) CGFloat chartContentHeight;
/** 表格内容宽度 */
@property (nonatomic) CGFloat chartContentWidth;
/** X 轴每个刻度线的横坐标 */
@property(nonatomic,strong) NSMutableArray *xAxisScalePositionArray;
/** Y 轴每个刻度线的横坐标 */
@property(nonatomic,strong) NSMutableArray *yAxisScalePositionArray;
/** X轴每个刻度的长度*/
@property(nonatomic,assign) CGFloat xScaleLength;
/** Y轴每个刻度的长度 */
@property(nonatomic,assign) CGFloat yScaleLength;
/** 拐点圆圈半径 */
@property(nonatomic,assign) CGFloat pointRadius;
/** 二维数组 - 保存每条折线的每个折点的位置 */
@property(nonatomic,strong) NSMutableArray<NSMutableArray *> *linePointArray;
/** 保存每条折线的path */
@property(nonatomic,strong) NSMutableArray<UIBezierPath *> *linePathArray;
/** 保存每条折线对应Layer的path */
@property(nonatomic,strong) NSMutableArray<CAShapeLayer *> *lineLayerArray;
/** line动画 */
@property(nonatomic,strong) CABasicAnimation *linePathAnimation;
@end

@implementation HXLineChart

#pragma mark initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.isShowAxis = YES;
    self.isShowDottedLine = YES;
    self.isShowAnimate = YES;
    self.isShowXAxisText = YES;
    self.isShowYAxisText = YES;
    self.axisWidth = 1.0;
    self.leftMargin = 25.0;
    self.bottomMargin = 25.0;
    self.topMargin = 25.0;
    self.rightMargin = 25.0;
    self.axisColor = HXAxisColor;
    self.yValueMin = -FLT_MAX;
    self.yValueMax = -FLT_MAX;
    self.xAxisUnit = @"";
    self.yAxisUnit = @"";
    self.animateDuration = 1.0;
    self.xAxisTextSize = 12.0;
    self.yAxisTextSize = 12.0;
    self.dottedLineWidth = 0.4;
    self.xAxisTextFont = [UIFont systemFontOfSize:self.xAxisTextSize];
    self.yAxisTextFont = [UIFont systemFontOfSize:self.yAxisTextSize];
    self.xAxisTextColor = [UIColor blackColor];
    self.yAxisTextColor = [UIColor blackColor];
    self.xAxisUnitColor = [UIColor blackColor];
    self.yAxisUnitColor = [UIColor blackColor];
    self.dottedLineColor = [UIColor darkGrayColor];
    self.backgroundColor = [UIColor whiteColor];
}


#pragma drawRect
- (void)drawRect:(CGRect)rect {
    NSAssert(!(self.yValueMax == -FLT_MAX), @"HXLineChart-Error : Y轴坐标值的最大值必须传入,要不没法整啊.");
    NSAssert(!(self.yValueMin == -FLT_MAX), @"HXLineChart-Error : Y轴坐标值的最小值必须传入,要不没法整啊.");
    for (HXLineChartDataItem *data in self.dataArray) {
        NSAssert(data.dataArray, @"HXLineChart-Error : 折线数据都没有传入,没法整啊.");
    }
    NSAssert(self.xAxisTextArray.count, @"HXLineChart-Error : 没有X轴刻度值,没法整啊. (如果刻度值不需要显示,则可设置isShowXAxisText为NO)");
    NSAssert(self.yAxisTextArray.count, @"HXLineChart-Error : 没有Y轴刻度值,没法整啊.(如果刻度值不需要显示,则可设置isShowYAxisText为NO)");
    
    [self calculate];
    [self drawLine];//画线
    [self addPointType];//添加拐点
    [self addPointText];//添加拐点值TextLayer
    [self addXTextLayer];
    [self addYTextLayer];
    
    if (self.isShowAxis) {
        //绘制坐标轴
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPopContext();
        UIGraphicsPushContext(ctx);
        CGContextSetLineWidth(ctx, self.axisWidth);
        CGContextSetStrokeColorWithColor(ctx, self.axisColor.CGColor);
        //绘制XY轴
        CGContextMoveToPoint(ctx, self.leftMargin, self.topMargin);
        CGContextAddLineToPoint(ctx, self.leftMargin, self.topMargin + self.chartContentHeight);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - self.rightMargin, self.topMargin + self.chartContentHeight);
        CGContextStrokePath(ctx);
        
        //绘制Y轴箭头
        CGContextMoveToPoint(ctx, self.leftMargin - 3, self.topMargin + 5);
        CGContextAddLineToPoint(ctx, self.leftMargin, self.topMargin);
        CGContextAddLineToPoint(ctx, self.leftMargin + 3, self.topMargin + 5);
        CGContextStrokePath(ctx);
        
        //绘制X轴箭头
        CGContextMoveToPoint(ctx, CGRectGetWidth(rect) - 5 - self.rightMargin, self.topMargin + self.chartContentHeight - 3);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - self.rightMargin, self.topMargin + self.chartContentHeight);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - 5 - self.rightMargin, self.topMargin + self.chartContentHeight + 3);
        CGContextStrokePath(ctx);

        //绘制X轴刻度线
        for (NSNumber *num in self.xAxisScalePositionArray) {
            CGFloat separateY = self.topMargin + self.chartContentHeight;
            CGContextMoveToPoint(ctx,[num floatValue], separateY);
            CGContextAddLineToPoint(ctx, [num floatValue], separateY - 3);
            CGContextStrokePath(ctx);
        }
        //绘制Y轴刻度线
        for (NSNumber *num in self.yAxisScalePositionArray) {
            CGFloat separateX = self.leftMargin;
            CGContextMoveToPoint(ctx,separateX , [num floatValue]);
            CGContextAddLineToPoint(ctx, separateX + 3, [num floatValue]);
            CGContextStrokePath(ctx);
        }
    }
    if (self.isShowDottedLine) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //绘制虚线
        for (NSNumber *poinyY in self.yAxisScalePositionArray) {
            //设置虚线颜色
            CGContextSetStrokeColorWithColor(ctx, self.dottedLineColor.CGColor);
            //设置虚线宽度
            CGContextSetLineWidth(ctx, self.dottedLineWidth);
            //设置虚线绘制起点
            CGContextMoveToPoint(ctx, self.leftMargin+3, [poinyY floatValue]);
            //设置虚线绘制终点
            CGContextAddLineToPoint(ctx, self.leftMargin + self.chartContentWidth, [poinyY floatValue]);
            //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
            CGFloat arr[] = {4,4};
            //下面最后一个参数“2”代表排列的个数。
            CGContextSetLineDash(ctx, 0, arr, 2);
            CGContextDrawPath(ctx, kCGPathStroke);
        }
    }
}

//计算每个折点的位置
- (void)calculate {
    //刻度的宽度
    self.xScaleLength = self.chartContentWidth  / (self.xAxisTextArray.count) ;
    self.yScaleLength = self.chartContentHeight  / (self.yAxisTextArray.count) ;
    //X轴每个刻度的横坐标数组
    for (NSInteger i= 0; i < self.xAxisTextArray.count; i++) {
        CGFloat separateX = i * self.xScaleLength + self.leftMargin + self.xScaleLength * 0.5;
        [self.xAxisScalePositionArray addObject:@(separateX)];
    }
    //Y轴每个刻度的横坐标数组Y
    for (NSInteger i= 0; i < self.yAxisTextArray.count; i++) {
        CGFloat separateY = self.topMargin + self.chartContentHeight - i * self.yScaleLength - self.yScaleLength * 0.5;
        [self.yAxisScalePositionArray addObject:@(separateY)];
    }
    
    //刻度的总长度
    CGFloat sumLength = self.yScaleLength * (self.yAxisTextArray.count - 1);
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        //pointArrayM存放图表中每条折线的折点
        NSMutableArray *pointArrayM = [NSMutableArray array];
        HXLineChartDataItem *data = self.dataArray[i];
        for (NSInteger j = 0; j < data.dataArray.count; j++) {
            if (self.xAxisScalePositionArray.count <= j) {
                continue;
            }
            CGFloat value = [data.dataArray[j] floatValue];
            CGFloat pointY = self.topMargin + self.chartContentHeight -  (value - self.yValueMin) / (self.yValueMax - self.yValueMin) * sumLength - self.yScaleLength * 0.5;
            [pointArrayM addObject:[NSValue valueWithCGPoint:CGPointMake([self.xAxisScalePositionArray[j] floatValue], pointY)]];
        }
        [self.linePointArray addObject:pointArrayM];
    }
}

#pragma 画线
- (void)drawLine {
    for (NSInteger i = 0; i < self.linePointArray.count; i++) {
        NSMutableArray *arrayM = self.linePointArray[i];
        HXLineChartDataItem *lineData =  self.dataArray[i];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:[arrayM[0] CGPointValue]];
        for (NSInteger j = 1; j < arrayM.count; j++) {
            [path addLineToPoint:[arrayM[j] CGPointValue]];
        }
        [self.linePathArray addObject:path];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = lineData.lineWidth;
        layer.fillColor = nil;
        layer.strokeColor = lineData.lineColor.CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        
        if (self.isShowAnimate) {
            [layer addAnimation:self.linePathAnimation forKey:@""];
        }
    }
}

//创建X轴刻度值文字
- (void)addXTextLayer {
    if (!self.isShowXAxisText) {
        return;
    }
    CGSize size = CGSizeZero;
    for (NSInteger i= 0; i < self.xAxisTextArray.count; i++) {
        CATextLayer *layer = [CATextLayer layer];
//        layer.font = (__bridge CFTypeRef _Nullable)(@"HiraKakuProN-W3");//字体的名字 不是 UIFont
        layer.font = (__bridge CFTypeRef _Nullable)self.xAxisTextFont;//字体的名字 不是 UIFont
        layer.string = self.xAxisTextArray[i];
        layer.fontSize = self.xAxisTextSize;
        layer.alignmentMode = kCAAlignmentCenter;
//        layer.wrapped = YES;//自适应layer 的大小 如果设置了字体大小 则效果失效
        size = [self.xAxisTextArray[i] sizeWithAttributes:@{NSFontAttributeName : self.xAxisTextFont}];
        layer.bounds = CGRectMake(0, 0, self.xScaleLength, size.height);
        layer.position = CGPointMake([self.xAxisScalePositionArray[i] floatValue], self.chartContentHeight + size.height * 0.5 + 1 + self.topMargin);
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.foregroundColor =self.xAxisTextColor.CGColor;//字体的颜色 文本颜色
        [self.layer addSublayer:layer];
    }
    if ([self.xAxisUnit isEqualToString:@""]) {//不需要显示x轴单位
        return;
    }
    CATextLayer *layer = [CATextLayer layer];
    layer.font = (__bridge CFTypeRef _Nullable)self.xAxisTextFont;//字体的名字 不是 UIFont
    layer.string = self.xAxisUnit;
    layer.fontSize = self.xAxisTextSize - 2.0;
//    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.alignmentMode = kCAAlignmentCenter;
    CGSize unitSize = [self.xAxisUnit sizeWithAttributes:@{NSFontAttributeName : self.xAxisTextFont}];
    layer.bounds = CGRectMake(0, 0, unitSize.width, unitSize.height);
    layer.position = CGPointMake([self.xAxisScalePositionArray.lastObject floatValue] + self.xScaleLength*0.5 + unitSize.width*0.5, self.chartContentHeight + size.height * 0.7 + self.topMargin);
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.foregroundColor =self.xAxisUnitColor.CGColor;//字体的颜色 文本颜色
    [self.layer addSublayer:layer];
}

//创建Y轴刻度值文字
- (void)addYTextLayer {
    if (!self.isShowYAxisText) {
        return;
    }
    CGSize size = CGSizeZero;
    for (NSInteger i= 0; i < self.yAxisTextArray.count; i++) {
        NSString *content = self.yAxisTextArray[i];
        size = [content sizeWithAttributes:@{NSFontAttributeName:self.yAxisTextFont}];
        CATextLayer *layer = [CATextLayer layer];
        layer.font = (__bridge CFTypeRef _Nullable)self.yAxisTextFont;//字体的名字 不是 UIFont
        layer.string = content;
        layer.fontSize = self.yAxisTextSize;
        layer.bounds = CGRectMake(0, 0, self.leftMargin - 2, size.height);
        //        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.alignmentMode = kCAAlignmentRight;
        layer.position = CGPointMake(self.leftMargin * 0.5 - 2, [self.yAxisScalePositionArray[i] floatValue]);
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.foregroundColor =self.yAxisTextColor.CGColor;//字体的颜色 文本颜色
        [self.layer addSublayer:layer];
    }
    if ([self.yAxisUnit isEqualToString:@""]) {//不需要显示y轴单位
        return;
    }
    CATextLayer *layer = [CATextLayer layer];
    layer.font = (__bridge CFTypeRef _Nullable)self.yAxisTextFont;//字体的名字 不是 UIFont
    layer.string = self.yAxisUnit;
    layer.fontSize = self.yAxisTextSize - 2.0;
    //    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.alignmentMode = kCAAlignmentCenter;
    CGSize unitSize = [self.yAxisUnit sizeWithAttributes:@{NSFontAttributeName : self.yAxisTextFont}];
    layer.bounds = CGRectMake(0, 0, unitSize.width, unitSize.height);
    layer.position = CGPointMake(self.leftMargin * 0.5 - 2, [self.yAxisScalePositionArray.lastObject floatValue] - self.yScaleLength * 0.5 - unitSize.height * 0.5);
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.foregroundColor =self.yAxisUnitColor.CGColor;//字体的颜色 文本颜色
    [self.layer addSublayer:layer];
}

//添加拐点类型 (圆形或者自定义类型 等 )
- (void)addPointType {
    for (NSInteger i = 0; i < self.linePointArray.count; i++) {
        NSArray *pointArray = self.linePointArray[i];
        HXLineChartDataItem *lineData = self.dataArray[i];
        for (NSInteger j = 0; j < pointArray.count; j++) {
            //这里拿到每一个拐点的位置  并在该位置绘制layer
            NSValue *pointValue = pointArray[j];
            CGPoint point = [pointValue CGPointValue];
            CAShapeLayer *layer = [self pointLayerStyleWithLineData:lineData Point:point];
            if (layer) {
                [self.layer addSublayer:layer];
            }
        }
    }
}

//添加每个折点的Label
- (void)addPointText {
    for (NSInteger i = 0; i < self.linePointArray.count; i++) {
        NSMutableArray *linePointArrayM = self.linePointArray[i];
        HXLineChartDataItem *data = self.dataArray[i];
        for (NSInteger j = 0; j < linePointArrayM.count; j++) {
            if (!data.showPointText) {
                continue;
            }
            //拿到拐点值
            NSString *strValue = [data.dataArray[j] stringValue];
            CATextLayer *layer = [CATextLayer layer];
            layer.font = (__bridge CFTypeRef _Nullable)data.pointTextFont;
            layer.string = strValue;
            layer.fontSize = data.pointTextSize;
            layer.alignmentMode = kCAAlignmentCenter;
            layer.contentsScale = [UIScreen mainScreen].scale;
            layer.foregroundColor = data.pointTextColor.CGColor;
            CGSize size = [strValue sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:data.pointTextSize]}];
            layer.bounds = CGRectMake(0, 0, size.width + 2, size.height);
            //拿到当前拐点坐标
            NSValue *currentPointValue = linePointArrayM[j];
            CGPoint currentPoint = [currentPointValue CGPointValue];
#warning 如果只有一个点的情况没有考虑
            //开始判断label位置
            if (j == linePointArrayM.count - 1) {//如果是最后一个点
                //拿到上一个点
                NSValue *leftPointValue = linePointArrayM[j - 1];
                CGPoint leftPoint = [leftPointValue CGPointValue];
                if (leftPoint.y >= currentPoint.y) {//最后一根折线是上升或水平
                    //那么label就在点的下面
                    layer.position = CGPointMake(currentPoint.x, currentPoint.y - (size.height * 0.5 + 3));
                }else{
                    //否则label就在点的上面
                    layer.position = CGPointMake(currentPoint.x, currentPoint.y + (size.height * 0.5 + 3));
                }
            }else if(j == 0){//如果是第一个点
                //拿到下一个点
                NSValue *rightPointValue = linePointArrayM[j + 1];
                CGPoint rightPoint = [rightPointValue CGPointValue];
                if (rightPoint.y >= currentPoint.y) {//第一根折线是下降或者水平
                    //那么label就在点的下面
                    layer.position = CGPointMake(currentPoint.x, currentPoint.y - (size.height * 0.5 + 3));
                }else{
                    //否则label就在点的上面
                    layer.position = CGPointMake(currentPoint.x, currentPoint.y + (size.height * 0.5 + 3));
                }
            }else{//中间点
                //拿到上一个点
                NSValue *leftPointValue = linePointArrayM[j - 1];
                CGPoint leftPoint = [leftPointValue CGPointValue];
                //拿到下一个点
                NSValue *rightPointValue = linePointArrayM[j+1];
                CGPoint rightPoint = [rightPointValue CGPointValue];
                layer.position = [self textPointWithLeftPoint:leftPoint currentPoint:currentPoint rightPoint:rightPoint height:size.height];
            }
            [self.layer addSublayer:layer];
        }
    }
}

#pragma 工具方法
//根据类型创建拐点Layer
- (CAShapeLayer *)pointLayerStyleWithLineData:(HXLineChartDataItem *)lineData Point:(CGPoint)point{
    CAShapeLayer *layer = [CAShapeLayer layer];
    //画笔的颜色
    layer.strokeColor = lineData.pointColor.CGColor;
    //填充色
    layer.fillColor = self.backgroundColor.CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinBevel;
    layer.lineWidth = 3;
    CGFloat radius = 3;
    if (lineData.pointStyle == HXLineChartPointStyleNone) {//没有拐点
        return nil;
    }else if (lineData.pointStyle == HXLineChartPointStyleCustom){//自定义拐点
        if (lineData.pointStyleGetter) {
            CAShapeLayer *layer = lineData.pointStyleGetter(point);
            return layer;
        }else{
            return nil;
        }
    }else if(lineData.pointStyle == HXLineChartPointStyleTriangle) {
        CGFloat gap1 = radius * sin(M_PI / 6);
        CGFloat gap2 = radius * cos(M_PI / 6);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(point.x, point.y - 3)];
        [path addLineToPoint:CGPointMake(point.x - gap2, point.y + gap1)];
        [path addLineToPoint:CGPointMake(point.x + gap2, point.y + gap1)];
        [path closePath];
        layer.path = path.CGPath;
        return layer;
    }else {//其他情况都认为是圆形
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:point radius:radius startAngle:0 endAngle:(CGFloat) (2 * M_PI) clockwise:YES];
        layer.path = path.CGPath;
        return layer;
    }
}

//根据左右拐点的坐标,计算当前拐点textLayer的位置
- (CGPoint)textPointWithLeftPoint:(CGPoint)leftPoint currentPoint:(CGPoint)currentPoint rightPoint:(CGPoint)rightPoint height:(CGFloat)height{
    //左线段差值
    CGFloat leftGap = fabs(currentPoint.y - leftPoint.y);
    //右线段差值
    CGFloat rightGap = fabs(rightPoint.y - currentPoint.y);
    if (currentPoint.y < leftPoint.y) {//左线段是上升趋势
        if (rightPoint.y > currentPoint.y) {//接下来是下降
            return CGPointMake(currentPoint.x, currentPoint.y - (height * 0.5 + 3));
        }else{//接下来是上升或者平行
            if (leftGap > rightGap) {
                return CGPointMake(currentPoint.x, currentPoint.y - (height * 0.5 + 3));
            }else{
                return CGPointMake(currentPoint.x, currentPoint.y + (height * 0.5 + 3));
            }
        }
    }else{ //左线段是平行或者下降趋势
        if (rightPoint.y < currentPoint.y) {//接下来是上升
            return CGPointMake(currentPoint.x, currentPoint.y + (height * 0.5 + 3));
        }else{//接下来是下降或者平行
            if (leftGap > rightGap) {
                return CGPointMake(currentPoint.x, currentPoint.y + (height * 0.5 + 3));
            }else{
                return CGPointMake(currentPoint.x, currentPoint.y - (height * 0.5 + 3));
            }
        }
    }
}

#pragma set方法
- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    if (_bottomMargin < 3) {
        _bottomMargin = 3;
    }
    self.chartContentHeight = self.frame.size.height - _bottomMargin - self.topMargin;
}

- (void)setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
    self.chartContentHeight = self.frame.size.height - self.bottomMargin - _topMargin;
}

- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    self.chartContentWidth = self.frame.size.width - self.leftMargin - _rightMargin;
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    if (_leftMargin < 3) {
        _leftMargin = 3;
    }
    self.chartContentWidth = self.frame.size.width - _leftMargin - self.rightMargin;
}

- (void)setDataArray:(NSArray<HXLineChartDataItem *> *)dataArray {
    _dataArray = dataArray;
}

/** 如果不显示坐标轴, 那么虚线 和 坐标轴刻度值 应该也不显示 */
- (void)setIsShowAxis:(BOOL)isShowAxis {
    _isShowAxis = isShowAxis;
    self.isShowDottedLine = NO;
    self.isShowXAxisText = NO;
    self.isShowYAxisText = NO;
}


#pragma 懒加载
- (NSMutableArray *)xAxisScalePositionArray {
    if (!_xAxisScalePositionArray) {
        _xAxisScalePositionArray = [[NSMutableArray alloc]init];
    }
    return _xAxisScalePositionArray;
}

- (NSMutableArray *)yAxisScalePositionArray {
    if (!_yAxisScalePositionArray) {
        _yAxisScalePositionArray = [[NSMutableArray alloc]init];
    }
    return _yAxisScalePositionArray;
}

- (NSMutableArray<NSMutableArray *> *)linePointArray {
    if (!_linePointArray) {
        _linePointArray = [[NSMutableArray alloc]init];
    }
    return _linePointArray;
}

- (NSMutableArray<UIBezierPath *> *)linePathArray {
    if (!_linePathArray) {
        _linePathArray = [[NSMutableArray alloc]init];
    }
    return _linePathArray;
}

- (NSMutableArray<CAShapeLayer *> *)lineLayerArray{
    if (!_lineLayerArray) {
        _lineLayerArray = [[NSMutableArray alloc]init];
    }
    return _lineLayerArray;
}

- (NSArray *)xAxisTextArray {
    if (!_xAxisTextArray) {
        _xAxisTextArray = [[NSArray alloc]init];
    }
    return _xAxisTextArray;
}

- (NSArray *)yAxisTextArray {
    if (!_yAxisTextArray) {
        _yAxisTextArray = [[NSArray alloc]init];
    }
    return _yAxisTextArray;
}

- (CABasicAnimation *)linePathAnimation{
    if (!_linePathAnimation) {
        _linePathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _linePathAnimation.duration = self.animateDuration;
        _linePathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _linePathAnimation .fromValue = @0.0f;
        _linePathAnimation.toValue = @1.0f;
    }
    return _linePathAnimation;
}

@end
