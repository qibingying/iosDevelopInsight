//
//  UIColor+Extension.h
//
//  Created by 冲浪小子（🏄） on 2017/7/3.
//  Copyright © 2017年 小码哥. All rights reserved.
//g这个是颜色的分类 方便设置颜色

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

#pragma mark- 从十六进制字符串获取颜色 color:支持@“#123456”、 @“0X123456”、@“0x123456”、 @“123456”四种格式
/** 默认alpha位1 */
+ (UIColor *)colorWithHexString:(NSString *)color;
/** 支持了透明度 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

#pragma  mark - 不是字符串形式的十六进制  支持0X123456、0x123456、 两种格式
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;

#pragma mark - 简单支持rgb 颜色   最大取值是255
/** return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]; */
+(UIColor *)colorWithFloatRGBRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
@end
