//
//  HXColor.h
//  HXChart
//
//  Created by hubery on 2017/9/20.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HXLightGreen    [UIColor colorWithRed:77.0 / 255.0 green:216.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
#define HXGreen         [UIColor colorWithRed:70.0 / 255.0 green:169.0 / 255.0 blue:111.0 / 255.0 alpha:1.0f]
#define HXGrey    [UIColor colorWithRed:141.0 / 255.0 green:141.0 / 255.0 blue:141.0 / 255.0 alpha:1.0f]
#define HXShallowGrey          [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0f]
#define HXShallowCircleColor [UIColor colorWithRed:136.5 / 255.0 green:174.2 / 255.0 blue:202.8 / 255.0 alpha:1.0]
#define HXCircleColor [UIColor colorWithRed:105.0 / 255.0 green:134.0 / 255.0 blue:156.0 / 255.0 alpha:1.0]
#define HXRed           [UIColor colorWithRed:245.0 / 255.0 green:94.0 / 255.0 blue:78.0 / 255.0 alpha:1.0f]
#define HXBarColor           [UIColor colorWithRed:0.0 / 255.0 green:50.0 / 255.0 blue:100.0 / 255.0 alpha:1.0f]
#define HXShallowBarColor           [UIColor colorWithRed:0.0 / 255.0 green:100.0 / 255.0 blue:200.0 / 255.0 alpha:1.0f]
#define HXTwitterColor  [UIColor colorWithRed:0.0 / 255.0 green:171.0 / 255.0 blue:243.0 / 255.0 alpha:1.0]
#define HXAxisColor [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.f]
#define HXCustomColor(r , g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0  alpha:(a)/1.0 ]
#define HXLightGrey     [UIColor colorWithRed:225.0 / 255.0 green:225.0 / 255.0 blue:225.0 / 255.0 alpha:1.0f]
#define HXFreshGreen    [UIColor colorWithRed:77.0 / 255.0 green:196.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
#define HXDeepGreen     [UIColor colorWithRed:77.0 / 255.0 green:176.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
#define HXRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
@interface HXColor : NSObject
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIColor *)shallowColorWithColor:(UIColor *)color withRatio:(CGFloat)ratio;
@end
