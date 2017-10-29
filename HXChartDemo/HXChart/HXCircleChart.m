//
//  HXCircleChart.m
//  HXSchome
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import "HXCircleChart.h"
#import "HXColor.h"

@interface HXCircleChart()<CAAnimationDelegate>
@property(nonatomic,strong) CAShapeLayer *circleLayer;
@property(nonatomic,strong) UIBezierPath *circlePath;
@property(nonatomic,strong) CABasicAnimation *animation;
@property(nonatomic,strong) CATextLayer *valueTextLayer;
@end

@implementation HXCircleChart

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
    self.isAutomaticCalculationValue = YES;
    self.maxValue = 100.0;
    self.minValue = 0.0;
    self.color = HXCircleColor;
    self.valueTextColor = HXGrey;
    self.minValue = 0.0;
    self.isAnimation = YES;
    self.isShowValue = YES;
    self.valueTextSize = 16;
    self.valueTextFont = [UIFont boldSystemFontOfSize:self.valueTextSize];
    self.lineWidth = 8;
    self.duration = 4;
    self.backColor = HXShallowGrey;
    self.isShowBack = YES;
}

- (void)setValue:(CGFloat)value {
    if (value > self.maxValue || value < self.minValue) {
        return;
    }
    CGFloat gapValue = fabs(value - _value);
    _value = value;
    //计算新的百分比:
    CGFloat newScale = (_value - self.minValue)/(self.maxValue - self.minValue);
    CGFloat gapScale = (gapValue - self.minValue)/(self.maxValue - self.minValue);
    if (self.isAutomaticCalculationValue) {
        //value动画
        CATransition *anima = [CATransition animation];
        anima.duration = 0.6;
        self.valueTextLayer.string = [NSString stringWithFormat:@"%.2f%%",newScale*100];
        [self.valueTextLayer addAnimation:anima forKey:nil];
    }
    //进度动画
    CGFloat duration = gapScale * self.duration;
    self.animation.duration = duration;
    self.animation.fromValue = @(self.circleLayer.strokeEnd);
    self.animation.toValue = @(newScale);
    self.circleLayer.strokeEnd = newScale;
    [self.circleLayer addAnimation:self.animation forKey:@""];
}

- (void)setValueText:(NSString *)valueText {
    CATransition *anima = [CATransition animation];
    anima.duration = 0.6;
    self.valueTextLayer.string = valueText;
    [self.valueTextLayer addAnimation:anima forKey:nil];
}

-  (void)drawRect:(CGRect)rect {
    [self.layer addSublayer:self.circleLayer];
    if (self.isShowBack) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, self.lineWidth);
        [self.backColor set];
        CGContextAddPath(ctx, self.circlePath.CGPath);
        CGContextStrokePath(ctx);
    }
    if (_isShowValue) {
        [self.layer addSublayer:self.valueTextLayer];
    }
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.path = self.circlePath.CGPath;
        _circleLayer.strokeColor = self.color.CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.lineJoin = kCALineJoinRound;
        _circleLayer.lineWidth = self.lineWidth;
        _circleLayer.strokeEnd = 0.0;
    }
    return _circleLayer;
}

- (UIBezierPath *)circlePath {
    if (!_circlePath) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.width;
        CGPoint center = CGPointMake(width * 0.5, height * 0.5);
       _circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:((width * 0.5) - (self.lineWidth *0.5)) startAngle:-(M_PI_2) endAngle:(M_PI*1.5) clockwise:YES];
    }
    return _circlePath;
}

- (CABasicAnimation *)animation {
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _animation.delegate = self;
    }
    return _animation;
}

- (CATextLayer *)valueTextLayer {
    if (!_valueTextLayer) {
        _valueTextLayer = [CATextLayer layer];
        _valueTextLayer.font = (__bridge CFTypeRef _Nullable)self.valueTextFont;
        _valueTextLayer.fontSize = self.valueTextSize;
        _valueTextLayer.alignmentMode = kCAAlignmentCenter;
        NSString *str = @"100%";
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:self.valueTextFont}];
        _valueTextLayer.frame = CGRectMake(0, (self.bounds.size.width - size.height) * 0.5, self.bounds.size.width, size.height);
        _valueTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _valueTextLayer.foregroundColor = self.valueTextColor.CGColor;
        self.value = 0.0;
    }
    return _valueTextLayer;
}
@end
