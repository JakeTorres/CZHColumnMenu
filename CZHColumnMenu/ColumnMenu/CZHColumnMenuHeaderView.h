//
//  CZHColumnMenuHeaderView.h
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZHColumnMenuHeaderView : UICollectionReusableView

/// 标题
@property (nonatomic, copy) NSString *titleString;

/// 描述
@property (nonatomic, copy) NSString *detailString;

/// 编辑按钮
@property (nonatomic, strong) UIButton *ediButton;
@end

NS_ASSUME_NONNULL_END
