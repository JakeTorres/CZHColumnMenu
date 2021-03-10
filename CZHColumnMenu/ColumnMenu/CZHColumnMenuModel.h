//
//  CZHColumnMenuModel.h
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#include "CZHColumnViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZHColumnMenuModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 是否选择
@property (nonatomic, assign) BOOL selected;

/// 是否显示加号
@property (nonatomic, assign) BOOL showAdd;

/// 是否允许删除
@property (nonatomic, assign) BOOL resident;

/// 展示的类型
@property (nonatomic, assign) ColumnMenuType type;
@end

NS_ASSUME_NONNULL_END
