//
//  HXColor.m
//  HXChart
//
//  Created by hubery on 2017/9/20.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXColor.h"

@implementation HXColor
+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma 生成浅色
//ratio > 1 颜色会变浅
//ratio < 1 颜色会变深
+ (UIColor *)shallowColorWithColor:(UIColor *)color withRatio:(CGFloat)ratio {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [UIColor colorWithRed:(red * ratio) green:(green * ratio) blue:(blue * ratio) alpha:1];
}

@end
