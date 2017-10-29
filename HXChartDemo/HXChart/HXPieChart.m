//
//  HXPieChart.m
//  HXChart
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import "HXPieChart.h"

@interface HXPieChart()<CAAnimationDelegate>
@property(nonatomic,assign) CGFloat total;
@property(nonatomic,strong) CABasicAnimation *animation;
@property(nonatomic,strong) CAShapeLayer *animationLayer;
@end

@implementation HXPieChart
+ (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray<HXPieChartDataItem *> *)dataArray {
    HXPieChart *pieChart = [[HXPieChart alloc]init];
    pieChart.frame = frame;
    pieChart.dataArray = dataArray;
    return pieChart;
}

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
    self.backgroundColor = [UIColor whiteColor];
    self.hollowRadius = 0.4;
    self.isAnimation = YES;
    self.isShowValueText = YES;
    self.animationDuration = 0.8;
}

- (void)drawRect:(CGRect)rect {
    [self calculate];
    //当不是正方形的时候 以宽度为标准
    CGFloat radius = self.frame.size.width * 0.5;
    CGPoint center = CGPointMake(radius,radius);
    CGFloat lineWith = (1 - self.hollowRadius) * radius;
    CGFloat realRadius =self.hollowRadius * radius + lineWith * 0.5;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, lineWith);
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        HXPieChartDataItem *item = self.dataArray[i];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:realRadius startAngle:item.angle.start endAngle:item.angle.end clockwise:YES];
        CGContextAddPath(ctx, path.CGPath);
        [item.color set];
        CGContextStrokePath(ctx);
        if (self.isShowValueText) {
            [self calculateItemTextPointWithItem:item center:center lineWith:lineWith];
            [self drawTextWithItem:item];
        }
    }
    if (_isAnimation) {
        UIBezierPath *animaPath = [UIBezierPath bezierPathWithArcCenter:center radius:realRadius startAngle:-M_PI_2 endAngle:M_PI * 1.5 clockwise:YES];
        self.animationLayer.lineWidth = lineWith + 2;
        self.animationLayer.path = animaPath.CGPath;
        [self.layer addSublayer:self.animationLayer];
        [self.animationLayer addAnimation:self.animation forKey:nil];
    }
}

- (void)calculate {
    CGFloat startScale = -M_PI_2;
    CGFloat endScale = -M_PI_2;
    CGFloat scale = 0.0;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        HXPieChartDataItem *item = self.dataArray[i];
        item.scale = item.value / self.total;
        scale = item.scale * M_PI * 2;
        endScale = startScale + scale;
        struct HXAngle angle = {startScale , endScale};
        item.angle = angle;
        startScale = endScale;
    }
}

- (void)calculateItemTextPointWithItem:(HXPieChartDataItem *)item center:(CGPoint)center lineWith:(CGFloat)lineWith {
    CGFloat betweenAngle =(item.angle.end - item.angle.start) * 0.5 + item.angle.start + M_PI_2;
    CGFloat sin = sinf(betweenAngle);
    CGFloat cos = cosf(betweenAngle);
    //当不是正方形的时候 以宽度为标准
    CGFloat radius = self.frame.size.width * 0.5;
    CGFloat scale = 0.5;
    //如果有描述内容,则微调位置
    if (![self isNilValue:item.describe]) {
        if (item.scale > 0.6) {
            scale = 0.4;
        }else if(item.scale > 0.3){
            scale = 0.5;
        }else {
            scale = 0.6;
        }
    }
    CGFloat realRadius =self.hollowRadius * radius + lineWith * scale;
    CGFloat x = center.x + realRadius * sin;
    CGFloat y = center.y - realRadius * cos;
    item.valueTextPoint = CGPointMake(x, y);
}

- (void)drawTextWithItem:(HXPieChartDataItem *)item {
    NSString *valueText = [NSString stringWithFormat:@"%.2f%%",item.scale * 100];
    CATextLayer *textLayer = [self textLayerWithStr:valueText textSize:item.valueTextSize font:item.valueTextFont color:item.valueTextColor];
    if (![self isNilValue:item.describe]) {
        NSString *describeText = item.describe;
        CATextLayer *describeLayer = [self textLayerWithStr:describeText textSize:item.describeTextSize font:item.describeTextFont color:item.describeTextColor];
        if (item.pieChartValueTextLocationType == HXPieChartValueTextLocationTypeTop) {
            textLayer.position = CGPointMake(item.valueTextPoint.x, item.valueTextPoint.y - textLayer.bounds.size.height * 0.5);
            describeLayer.position = CGPointMake(item.valueTextPoint.x, item.valueTextPoint.y + describeLayer.bounds.size.height * 0.5 - 2);
        }else {
            textLayer.position = CGPointMake(item.valueTextPoint.x, item.valueTextPoint.y + textLayer.bounds.size.height * 0.5);
            describeLayer.position = CGPointMake(item.valueTextPoint.x, item.valueTextPoint.y - describeLayer.bounds.size.height * 0.5);
        }
        [self.layer addSublayer:textLayer];
        [self.layer addSublayer:describeLayer];
    }else {
        textLayer.position = item.valueTextPoint;
        [self.layer addSublayer:textLayer];
    }
}

- (CATextLayer *)textLayerWithStr:(NSString *)str textSize:(CGFloat)textSize font:(UIFont *)font color:(UIColor *)color {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.font = (__bridge CFTypeRef _Nullable)font;
    textLayer.fontSize = textSize;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.foregroundColor = color.CGColor;
    textLayer.string = str;
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textSize]}];
    textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    return textLayer;
}

#pragma 懒加载
- (CABasicAnimation *)animation {
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        _animation.fromValue = @(0.0);
        _animation.toValue = @(1.0);
        _animation.duration = self.animationDuration;
        _animation.delegate = self;
        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    }
    return _animation;
}

- (CAShapeLayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeColor = self.backgroundColor.CGColor;
        _animationLayer.strokeStart = 1.0;
        _animationLayer.strokeEnd = 1.0;
    }
    return _animationLayer;
}

#pragma set方法
- (void)setDataArray:(NSArray<HXPieChartDataItem *> *)dataArray {
    NSAssert(!(dataArray.count == 0), @"没有数据是不可以的");
    _dataArray = dataArray;
    self.total = [[_dataArray valueForKeyPath:@"@sum.value"] floatValue];
}

- (void)setHollowRadius:(CGFloat)hollowRadius {
    NSAssert(!((hollowRadius >= 1)||(hollowRadius < 0)), @"空心部分所占比例不正确, 取值是0~1");
    _hollowRadius = hollowRadius;
}

#pragma 工具方法
// 判断是否是空值，空值返回YES，否则返回NO
- (BOOL)isNilValue:(NSString *)value {
    if (value == nil || value.length <= 0 || [value isEqualToString:@""] || [value isEqualToString:@"(null)"]) {
        return YES;
    } else {
        return NO;
    }
}
@end
