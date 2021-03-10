//
//  CZHConfig.m
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import "CZHConfig.h"

@implementation CZHConfig

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {

    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }

    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }

    if ([cString length] != 6) {
        return [UIColor clearColor];
    }

    // 从六位数值中找到RGB对应的值并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R,G,B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    unsigned int r, g, b;
    /*NSScanner是一个类，用于在字符串中扫描指定的字符，尤其是把它们翻译/转换为数字和别的字符串。可以在创建NSScaner时指定它的string属性，然后scanner会按照你的要求从头到尾地扫描这个字符串的每个字符。

     创建一个Scanner

     NSScanner是一个类族， NSScanner是其中公开的一类。通常，可以用scannerWithString:或localizedScannerWithString:方法初始化一个scanner。这两个方法都返回一个scanner对象并用你传递的字符串参数初始化其string属性。刚创建时scanner对象指向字符串的开头。scanner方法开始扫描，比如scanInt:，scanDouble:，scanString:intoString:。如果你要想扫描多遍，通常需要使用while循环

     */
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
@end
