//
//  HXWaveRateChart.m
//  HXSchome
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//  http://www.jianshu.com/p/ff8dd3e56de5 我的简书中有详细的代码介绍和使用方法,也可以联系到我

#import "HXWaveRateChart.h"
#import "HXColor.h"

typedef NS_ENUM(NSUInteger , HXWavePathType) {
    /** sin */
    HXWavePathTypeSin = 0,
    /** cos*/
    HXWavePathTypeCos = 1
};

@interface HXWaveRateChart()<CAAnimationDelegate>
@property(nonatomic,strong) CALayer *mainLayer;
@property(nonatomic,strong) CALayer *secondLayer;
@property(nonatomic,strong) CAShapeLayer *sinLayer;
@property(nonatomic,strong) CAShapeLayer *cosLayer;
@property(nonatomic,strong) CADisplayLink *displayLink;
@property(nonatomic,assign) CGFloat scale;
@property(nonatomic,assign) CGPoint targetPosition;
@property(nonatomic,strong) CATextLayer *valueText;
@end

@implementation HXWaveRateChart

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
    self.borderColor = [UIColor lightGrayColor];
    self.borderWidth = 1.5;
    self.mainColor = HXCustomColor(103, 179, 93, 1);
    self.secondColor = HXCustomColor(194, 224, 190, 1);
    self.valueTextColor = HXGrey;
    self.isShowValue = YES;
    self.valueTextFont = [UIFont boldSystemFontOfSize:19];
    self.valueTextFontSize = 19;
    self.sumTime = 6.0;
}

- (void)setValue:(CGFloat)value {
    if ((value > 100)||(value < 0)) {
        return;
    }
    CGFloat gap = fabs(_value - value);
    _value = value;
    CATransition *anima = [CATransition animation];
    anima.duration = 0.6;
    self.valueText.string = [NSString stringWithFormat:@"%.2f%%",_value];
    [self.valueText addAnimation:anima forKey:nil];
    //每个单位所占高度
    CGFloat scale = self.bounds.size.width * 0.01;
    CGPoint position = self.sinLayer.position;
    CGFloat y = self.bounds.size.width - (_value * scale) + self.bounds.size.width * 0.5;
    position.y = y;
    CGFloat duration = gap * 0.01 * self.sumTime;
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    self.sinLayer.position = position;
    self.cosLayer.position = position;
    [CATransaction commit];
}

- (void)drawRect:(CGRect)rect {
    [self.layer addSublayer:self.secondLayer];
    [self.layer addSublayer:self.mainLayer];
    self.secondLayer.mask = self.cosLayer;
    self.mainLayer.mask = self.sinLayer;
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    [self.displayLink setPaused:NO];
    if (_isShowValue) {
        [self.layer addSublayer:self.valueText];
    }
}

- (void)updateWave {
    self.scale += 6;
    self.sinLayer.path = [self createPathWithType:HXWavePathTypeSin].CGPath;
    self.cosLayer.path = [self createPathWithType:HXWavePathTypeCos].CGPath;
}

- (UIBezierPath *)createPathWithType:(HXWavePathType)type {
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    CGFloat width = ceil(self.bounds.size.width);
    CGFloat y = 0.0;
    CGFloat peak = self.bounds.size.width / 30.0;
    for (NSInteger x = 0; x <= width; x++) {
        if (type == HXWavePathTypeSin) {
            //峰值  周期   速度
            y =  peak * sin((0.8 * (x / self.bounds.size.width * 360.0 * (M_PI / 180)) + self.scale * (M_PI / 180)));
        }else{
            y =  peak * cos((0.8 * (x / self.bounds.size.width * 360.0 * (M_PI / 180)) + self.scale * (M_PI / 180)));
        }
        if (x == 0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        }else{
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    [wavePath addLineToPoint:CGPointMake(width, self.bounds.size.height)];
    [wavePath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [wavePath closePath];
    return wavePath;
}


#pragma 懒加载
- (CALayer *)mainLayer {
    if (!_mainLayer) {
        _mainLayer = [CALayer layer];
        _mainLayer.masksToBounds = YES;
        _mainLayer.backgroundColor = self.mainColor.CGColor;
        CGRect rect = self.bounds;
        //应该是一个正圆
        _mainLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.width);
        _mainLayer.cornerRadius = rect.size.width * 0.5;
    }
    return _mainLayer;
}

- (CALayer *)secondLayer {
    if (!_secondLayer) {
        _secondLayer = [CALayer layer];
        _secondLayer.masksToBounds = YES;
        _secondLayer.backgroundColor = self.secondColor.CGColor;
        CGRect rect = self.bounds;
        //应该是一个正圆
        _secondLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.width);
        _secondLayer.cornerRadius = rect.size.width * 0.5;
    }
    return _secondLayer;
}

- (CAShapeLayer *)sinLayer {
    if (!_sinLayer) {
        _sinLayer = [CAShapeLayer layer];
        _sinLayer.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.width);
        _sinLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _sinLayer;
}

- (CAShapeLayer *)cosLayer {
    if (!_cosLayer) {
        _cosLayer = [CAShapeLayer layer];
        _cosLayer.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.width);
        _cosLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _cosLayer;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _displayLink;
}

- (CATextLayer *)valueText {
    if (!_valueText) {
        _valueText = [CATextLayer layer];
        _valueText.font = (__bridge CFTypeRef _Nullable)self.valueTextFont;
        _valueText.fontSize = self.valueTextFontSize;
        _valueText.alignmentMode = kCAAlignmentCenter;
        NSString *str = @"0%";
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName : self.valueTextFont}];
        _valueText.frame = CGRectMake(0, (self.bounds.size.width - size.height) * 0.5, self.bounds.size.width, size.height);
        _valueText.contentsScale = [UIScreen mainScreen].scale;
        _valueText.foregroundColor =self.valueTextColor.CGColor;
        self.value = 0.0;
    }
    return _valueText;
}
@end
