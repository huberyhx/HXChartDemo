HXChart是我自己写的一个简易图表框架
包括:折线图,饼图,进度图
- 集成方式:
  - gitHub:
[这是下载地址](https://github.com/huberyhx/HXChartDemo.git)
  - cocoapods:
```
     pod 'HXChart'
```

先上一些效果图
然后分别介绍使用方法:
![折线图](http://upload-images.jianshu.io/upload_images/2954364-81f62ba96097a1cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![柱状图](http://upload-images.jianshu.io/upload_images/2954364-d8c921b657b81188.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![波浪进度图](http://upload-images.jianshu.io/upload_images/2954364-e372b32b5e9f77d8.gif?imageMogr2/auto-orient/strip)
![饼图](http://upload-images.jianshu.io/upload_images/2954364-ae5b505c008e78ee.gif?imageMogr2/auto-orient/strip)
![进度图.gif](http://upload-images.jianshu.io/upload_images/2954364-b39f9ecb27d7c8cd.gif?imageMogr2/auto-orient/strip)




- 使用方法:
一:折线图HXLineChart:
创建一个最简单的折线图:
```objectivec
-(void)addChart {
    //图表
    HXLineChart *chart = [[HXLineChart alloc]initWithFrame:CGRectMake(10, 77, 350, 240)];
    chart.xAxisTextArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月"];
    chart.yAxisTextArray = @[@"30",@"25",@"20",@"15",@"10",@"5",@"1"];
    chart.yValueMax = 0.0;
    chart.yValueMin =30.0;
    chart.xAxisUnit = @"月份";
    chart.yAxisUnit = @"名次";
    chart.yAxisTextFont = [UIFont boldSystemFontOfSize:10];

    //图表所需数据数据
    HXLineChartDataItem *data2 = [[HXLineChartDataItem alloc]init];
    data2.pointStyle = HXLineChartPointStyleTriangle;
    data2.dataArray = @[@8,@16,@15,@19,@14,@19,@14,@19,@14];
    chart.dataArray = @[data2];
    [self.view addSubview:chart];
}
```

在折线图中,有五个数据是必须传入的:
```objectivec
#pragma 必需属性:
/** 折线数据 */
@property(nonatomic,strong) NSArray<HXLineChartDataItem *> *dataArray;
/** Y轴最大值 - 是Y轴最顶端的值*/
@property(nonatomic,assign) CGFloat yValueMax;
/** Y轴最小值 - 是Y轴最低端的值*/
@property(nonatomic,assign) CGFloat yValueMin;
/** X轴坐标值数组 - 数组的顺序是从X轴左向右 - 数组不仅用于显示,而且用于坐标计算,如果不想显示,则可设置isShowXAxisText为NO*/
@property(nonatomic,strong) NSArray *xAxisTextArray;
/** Y轴坐标值数组 - 数组的顺序是从Y轴的底部到顶部 - 数组不仅用于显示,而且用于坐标计算,如果不想显示,则可设置isShowYAxisText为NO*/
@property(nonatomic,strong) NSArray *yAxisTextArray;
``` 
- dataArray
   是折线数组
   折线图中每一条折线对应一个HXLineChartDataItem
   折线图中可以添加多条折线
- xAxisTextArray和yAxisTextArray
   是X轴和Y轴的刻度值必,须传入,否则不能计算点的位置:
   但是如果不想显示它,可以设置isShowXAxisText, isShowYAxisText为NO
- yValueMax和yValueMin用于计算每个点在图表中的位置
   值得说明的是:yValueMax并不是在数值上最大,yValueMin也不是对应的数值最小
   实际上yValueMax是Y轴顶端的值,yValueMin是Y轴低端的值
   特殊情况: 就像名次这种表格(如上图) ,名次的范围是0-5,5-10,10-15,每一段是五个名次,其中最大值就是第一名,
   可是第一名名次却不是0,而是1. 
   如果yValueMax传入1,那么第一段名次就是1-5(只有四个单位,和后面的5-10,10-15,每阶段单位数量不一样),
   所以为了计算的统一yValueMax还是传入0,显示的时候yAxisTextArray数组第一个元素传入1就可以了)

其他图表相关属性都在头文件中有详细的注释:
```objectivec
#pragma 非必需属性:
/** 是否显示坐标轴 - 默认YES */
@property(nonatomic,assign) BOOL isShowAxis;
/** 是否显示刻度值虚线 - 默认YES */
@property(nonatomic,assign) BOOL isShowDottedLine;
/** 虚线颜色 - 默认灰色 */
@property(nonatomic,strong) UIColor *dottedLineColor;
/** 虚线宽度 - 默认0.4 */
@property(nonatomic,assign) CGFloat dottedLineWidth;
/** 是否显示X轴刻度值 - 默认YES */
@property(nonatomic,assign) BOOL isShowXAxisText;
/** 是否显示Y轴刻度值 - 默认YES */
@property(nonatomic,assign) BOOL isShowYAxisText;
/** X轴刻度值字体 */
@property(nonatomic,strong) UIFont *xAxisTextFont;
/** Y轴刻度值字体 */
@property(nonatomic,strong) UIFont *yAxisTextFont;
/** X轴刻度值字体颜色 - 默认黑色*/
@property(nonatomic,strong) UIColor *xAxisTextColor;
/** Y轴刻度值字体颜色 - 默认黑色 */
@property(nonatomic,strong) UIColor *yAxisTextColor;
/** X轴刻度值字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat xAxisTextSize;
/** Y轴刻度值字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat yAxisTextSize;
/** 坐标轴宽度 默认1 */
@property(nonatomic,assign) CGFloat axisWidth;
/** 坐标轴颜色  默认灰色*/
@property(nonatomic,strong) UIColor *axisColor;
/** 是否添加动画 - 默认YES */
@property(nonatomic,assign) BOOL isShowAnimate;
/** 动画时长 - 默认1秒 */
@property(nonatomic,assign) CGFloat animateDuration;
/** X轴坐标值单位 - 例如(时间 s) - 默认为空*/
@property(nonatomic,strong) NSString *xAxisUnit;
/** X坐标单位Text字体颜色 - 默认和坐标轴刻度Text颜色一样 */
@property(nonatomic,strong) UIColor *xAxisUnitColor;
/** Y轴坐标值单位 - 例如(路程 m) - 默认为空*/
@property(nonatomic,strong) NSString *yAxisUnit;
/** Y坐标单位Text字体颜色 - 默认和坐标轴刻度Text颜色一样 */
@property(nonatomic,strong) UIColor *yAxisUnitColor;
/** 左内边距 - 用于显示Y轴Label  - 默认25  但是不小于3*/
@property(nonatomic,assign) CGFloat leftMargin;
/** 下内边距 - 用于显示X轴Label - 默认25  但是不小于3*/
@property(nonatomic,assign) CGFloat bottomMargin;
/** 上内边距 - 用于显示Y轴坐标值的单位 - 默认是25 */
@property(nonatomic,assign) CGFloat topMargin;
/** 右内边距 - 用于显示X轴坐标值的单位 - 默认是25 */
@property(nonatomic,assign) CGFloat rightMargin;
```
还有折线(HXLineChartDataItem)的相关属性:
```objectivec
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
@property(nonatomic,strong)  LinePointStyleGetter pointStyleGetter;
```
值得说明的是HXLineChartPointStyle这个枚举:
```objectivec
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
```
它包含了折线拐点的类型:三角形 , 圆形 , 自定义类型
如果设置为自定义类型HXLineChartPointStyleCustom
那么需要调用block: pointStyleGetter
来给我创建一个layer用来显示

---
二:柱状图HXBarChart:
创建一个最简单的柱状图:
```objectivec
- (void)addChart {
    HXBarChart *barChart = [[HXBarChart alloc]initWithFrame:CGRectMake(18, 77, [UIScreen mainScreen].bounds.size.width - 36, 200)];
    barChart.yValueMax = 100.0;
    barChart.yValueMin = 0.0;
    barChart.barChartValuePositionStyle = HXBarChartValuePositionStyleBetween;
    barChart.dataArray = @[@"2",@"40",@"60",@"100",@"60",@"100",@"60",@"100"];
    barChart.xAxisTextArray = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物"];
    barChart.yAxisTextArray = @[@"0",@"20",@"40",@"60",@"80",@"100"];
    [self.view addSubview:barChart];
}
```
和折线图一样柱状图也有五个必须传入的属性:
```objectivec
#pragma 必需属性
/** 条形柱数值数组*/
@property(nonatomic,strong) NSArray *dataArray;
/** Y轴最大值 */
@property(nonatomic,assign) CGFloat yValueMax;
/** Y轴最小值 */
@property(nonatomic,assign) CGFloat yValueMin;
/** X轴刻度值Text数组 */
@property(nonatomic,strong) NSArray *xAxisTextArray;
/** Y轴刻度值Text数组 */
@property(nonatomic,strong) NSArray *yAxisTextArray;
```
- dataArray
   是条形柱数值数组
- xAxisTextArray和yAxisTextArray
   是X轴和Y轴的刻度值必,须传入,否则不能计算点的位置:
   但是如果不想显示它,可以设置isShowXAxisText, isShowYAxisText为NO
- yValueMax和yValueMin用于计算每个点在图表中的位置
   值得说明的是:yValueMax并不是在数值上最大,yValueMin也不是对应的数值最小
   实际上yValueMax是Y轴顶端的值,yValueMin是Y轴低端的值
   特殊情况与折线图中一样

关于柱状图的一些其他设置:
```objectivec
#pragma 非必需属性
/** 是否动画 - 默认YES*/
@property(nonatomic,assign) BOOL isAnimate;
/** 动画时长 - 默认0.5秒 */
@property(nonatomic,assign) CGFloat animateDuration;
/** 每个条形柱之间的间距 - 默认1 -  取值是0~1 ,1=柱宽*100%, 0.5=柱宽*50%   */
@property(nonatomic,assign) CGFloat barGap;
/** 是否显示坐标轴 - 默认YES*/
@property(nonatomic,assign) BOOL isShowAxis;
/** 坐标轴颜色 - 默认灰色*/
@property(nonatomic,strong) UIColor *axisColor;
/** 坐标轴宽度 默认1 */
@property(nonatomic,assign) CGFloat axisWidth;
/** 是否显示刻度值虚线 - 默认NO */
@property(nonatomic,assign) BOOL isShowDottedLine;
/** 是否显示X轴Text - 默认Yes*/
@property(nonatomic,assign) BOOL isShowXAxisText;
/** 是否显示Y轴Text  - 默认YES*/
@property(nonatomic,assign) BOOL isShowYAxisText;
/** X轴Text字体 */
@property(nonatomic,strong) UIFont *xAxisTextFont;
/** X轴字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat xAxisTextSize;
/** Y轴字体 */
@property(nonatomic,strong) UIFont *yAxisTextFont;
/** Y轴字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat yAxisTextSize;
/** 左内边距 - 用于显示Y轴Label - 默认25*/
@property(nonatomic,assign) CGFloat leftMargin;
/** 下内边距 - 用于显示X轴Label - 默认25 */
@property(nonatomic,assign) CGFloat bottomMargin;
/** 右内边距 - 用于显示X轴单位 - 默认25*/
@property(nonatomic,assign) CGFloat rightMargin;
/** 上内边距 - 用于显示Y轴单位 - 默认25 */
@property(nonatomic,assign) CGFloat topMargin;
/** 最左边条形柱距Y轴距离 - 默认是0.5 -取值是0~1 ,1=柱宽*100%,0.5=柱宽*50%  */
@property(nonatomic,assign) CGFloat barLeftGap;
/** 最右边边条形柱距边界距离 - 默认是0.5 -取值是0~1 ,1=柱宽*100%,0.5=柱宽*50%   */
@property(nonatomic,assign) CGFloat barRightGap;

#pragma 条形柱相关属性
#pragma 非必需属性:
/** 条形柱数值的显示位置 - 默认是HXBarChartValueStyleNone*/
@property(nonatomic,assign) HXBarChartValuePositionStyle barChartValuePositionStyle;
/** 条形柱颜色 - 默认绿色*/
@property(nonatomic,strong) UIColor *barColor;
/** 条形柱渐变颜色底部 - 默认就是barColor */
@property(nonatomic,strong) UIColor *fromColor;
/** 条形柱渐变颜色上部 - 默认就是barColor  */
@property(nonatomic,strong) UIColor *toColor;
/** 条形柱的圆角半径 - 默认条形柱宽度的15% */
@property(nonatomic,assign) CGFloat barCornerRadius;
/** 条形柱数值颜色 - 默认黑色 */
@property(nonatomic,strong) UIColor *barValueTextColor;
/** 条形柱数值字体 */
@property(nonatomic,strong) UIFont *barValueTextFont;
/** 条形柱数值字体大小 - 默认12 */
@property(nonatomic,assign) CGFloat barValueTextSize;
/** 是否显示条形柱背景 */
@property(nonatomic,assign) BOOL isShowBarBackColor;
/** 条形柱背景颜色 - 默认灰色*/
@property(nonatomic,strong) UIColor *barBackColor;
```
每个属性都有详细说明
值得特殊说明的是fromColor和toColor
当设置了这两个颜色以后,条形柱就是渐变色
从fromColor渐变到toColor
barColor就失效了
---

三:波浪进度图HXWaveRateChart:
创建一个最简单的波浪进度图:
```objectivec
- (void)addChart {
    self.waveRateChart = [[HXWaveRateChart alloc]init];
    self.waveRateChart.isShowValue = YES;
    self.waveRateChart.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100);
    [self.view addSubview:self.waveRateChart];
}
```
创建非常简单
也没有必须传入的的属性
创建之后改变value值就可以
其他的可设置属性:
```objectivec
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
```
图表中是两个波浪才循环流动
只需要设置颜色即可
分别是mainColor和secondColor

---
四:饼图HXPieChartDataItem:
创建一个最简单的饼图:
```objectivec
- (void)addChart {
    //数据
    HXPieChartDataItem *item = [HXPieChartDataItem dataItemWithValue:70 color:HXFreshGreen describe:@"购物"];
    item.valueTextColor = [UIColor redColor];
    item.pieChartValueTextLocationType = HXPieChartValueTextLocationTypeBottom;
    NSArray *items = @[
                       [HXPieChartDataItem dataItemWithValue:15 color:HXLightGreen describe:@"出行"],
                       item,
                       [HXPieChartDataItem dataItemWithValue:15 color:HXDeepGreen]
                       ];

    //图表
    HXPieChart *pieChart = [HXPieChart initWithFrame:CGRectMake(50, 150, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100) dataArray:items];
    [self.view addSubview:pieChart];
}
```
饼图中,只有一个必须传入的属性:
```objectivec
#pragma 必需属性
/** 数据源 */
@property(nonatomic,strong) NSArray<HXPieChartDataItem *> *dataArray;
```
- dataArray:
    存放每一个条形柱,每一个条形柱是一个HXPieChartDataItem

饼图的一些其他设置:
```objectivec
#pragma 非必需属性
/** 是否动画 - 默认YES*/
@property(nonatomic,assign) BOOL  isAnimation;
/** 动画时间 - 默认1秒*/
@property(nonatomic,assign) CGFloat animationDuration;
/** 空心圆所占比例 - 默认是0.4空心圆 - 取值是0~1 */
@property(nonatomic,assign) CGFloat hollowRadius;
/** 是否显示数值 - 默认YES*/
@property(nonatomic,assign) BOOL isShowValueText;
```
条形柱的一些相关设置:
```objectivec
@interface HXPieChartDataItem : NSObject
#pragma 必需属性
/** 数值 - 可以是任意值,HXChart会根据总和计算比例*/
@property(nonatomic,assign) CGFloat value;

#pragma 非必需属性
/** 颜色 - 默认随机色*/
@property(nonatomic,strong) UIColor *color;
/** 描述内容- 默认空 */
@property(nonatomic,strong) NSString *describe;
/** 描述内容Text字体 */
@property(nonatomic,strong) UIFont *describeTextFont;
/** 描述内容Text字体颜色 - 默认白色*/
@property(nonatomic,strong) UIColor *describeTextColor;
/** 描述内容Text字体大小 - 默认16*/
@property(nonatomic,assign) CGFloat describeTextSize;
/** 数值Text字体 */
@property(nonatomic,strong) UIFont *valueTextFont;
/** 数值Text字体颜色 - 默认白色*/
@property(nonatomic,strong) UIColor *valueTextColor;
/** 数值Text字体大小 - 默认14*/
@property(nonatomic,assign) CGFloat valueTextSize;
/** 数值位置 - 默认HXPieChartValueTextLocationTypeTop*/
@property(nonatomic,assign) HXPieChartValueTextLocationType pieChartValueTextLocationType;
```
- value:
    必需属性,创建的时候必需知道条形柱数值是多少
- pieChartValueTextLocationType:
    是一个枚举:
```objectivec
typedef NS_ENUM(NSUInteger , HXPieChartValueTextLocationType) {
    /** 数值在上 描述在下 */
    HXPieChartValueTextLocationTypeTop = 0,
    /** 数值在下 描述在上 */
    HXPieChartValueTextLocationTypeBottom = 1,
};
```
表示每个饼的数值和内容的位置关系
如果内容没有传入,只显示数值的话,默认是HXPieChartValueTextLocationTypeTop
---
五:进度图HXCircleChart:
创建一个最简单的进度图:
```objectivec
- (void)addChart {
    self.circleChart = [[HXCircleChart alloc]init];
    self.circleChart.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100);
    [self.view addSubview:self.circleChart];
}
```
创建非常简单
也没有必须传入的的属性
创建之后改变value值就可以
其他的可设置属性:
```objectivec
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
```
每个属性都有详细的注释

---
框架是空闲时间完成
由于我的技术也粗糙的很
有很多可以改进的地方
我会继续努力
错误与不合理的代码
希望读者能给与纠正
谢谢
