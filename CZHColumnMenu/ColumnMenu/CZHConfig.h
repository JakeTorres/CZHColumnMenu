//
//  CZHConfig.h
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import <UIKit/UIKit.h>


// 随机颜色
#define kRandomColor  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

NS_ASSUME_NONNULL_BEGIN



@interface CZHConfig : NSObject

/// 十六进制字符串转换颜色
/// @param hexString 十六进制字符串
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/// 十六进制字符串转换颜色
/// @param hexString 十六进制字符串
/// @param alpha 不透明度
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;


@end

NS_ASSUME_NONNULL_END
