//
//  CZHColumnCollectionViewCell.h
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "CZHColumnMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZHColumnViewCell : UICollectionViewCell

/// 标题
@property (nonatomic, strong) UILabel *titleLable;

/// 关闭的按钮
@property (nonatomic, strong) UIButton *closeButton;

/// 添加的按钮
@property (nonatomic, strong) UIButton *addButton;

/// 数据模型
@property (nonatomic, strong) CZHColumnMenuModel *model;
@end

NS_ASSUME_NONNULL_END
