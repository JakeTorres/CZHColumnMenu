//
//  CZHColumnViewController.h
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ColumnMenuType) {
    ColumnMenuTypeTencent, // 模仿腾讯新闻
    ColumnMenuTypeTouTiao, // 模仿头条
};

NS_ASSUME_NONNULL_BEGIN

@protocol ColumnMenuDelegate <NSObject>

/// 页面数据源
/// @param objective 排序后选择的目标数组
/// @param items 排序后待选择的目标数组
- (void)columnMenuObjectiveArray:(NSMutableArray *)objective itemsArray:(NSMutableArray *)items;

/// 选择目标标题
/// @param title 标题
/// @param index 目标对应的序列index
- (void)columnMenuDidSelectedTitle:(NSString *)title index:(NSInteger)index;

@end

@interface CZHColumnViewController : UIViewController

/// 类初始化方法
/// @param objective 目标数组
/// @param items 待选择的数组
/// @param type 实现的类型，见ColumnMenuType
/// @param delegate 代理
+ (instancetype)columnMenuWithObjectiveArray:(NSMutableArray *)objective itemsArray:(NSMutableArray *)items type:(ColumnMenuType)type delegate:(id<ColumnMenuDelegate>)delegate;

/// 实例对象初始化方法
/// @param objective 目标数组
/// @param items 待选择的数组
/// @param type 实现的类型，见ColumnMenuType
/// @param delegate 代理
- (instancetype)columnMenuWithObjectiveArray:(NSMutableArray *)objective itemsArray:(NSMutableArray *)items type:(ColumnMenuType)type delegate:(id<ColumnMenuDelegate>)delegate;

/// 代理
@property (nonatomic, weak) id<ColumnMenuDelegate>delegate;

/// 展示的类型
@property (nonatomic, assign) ColumnMenuType type;

/// 导航栏背景颜色
@property (nonatomic, strong) UIColor *navBackgroundColor;

/// 导航栏标题颜色
@property (nonatomic, strong) UIColor *navTitleColor;

/// 导航栏标题
@property (nonatomic, strong) NSString *navTitle;

/// 右侧关闭按钮文字
@property (nonatomic, strong) UIImage *navRightImage;
@end

NS_ASSUME_NONNULL_END
