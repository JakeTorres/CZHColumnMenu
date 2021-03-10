//
//  CZHColumnCollectionViewCell.m
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import "CZHColumnViewCell.h"
#import "UIView+CZH.h"
#include "CZHConfig.h"
#import "CZHColumnMenuModel.h"

@interface CZHColumnViewCell()

/// 没有数据展示空View
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation CZHColumnViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 空View
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    self.emptyView.backgroundColor = [CZHConfig colorWithHexString:@"#f4f4f4"];
    [self.contentView addSubview:self.emptyView];

    // 标题
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLable.font = [UIFont systemFontOfSize:15];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.backgroundColor = [CZHConfig colorWithHexString:@"#f4f4f4"];
    [self.emptyView addSubview:self.titleLable];

    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JMColumnMenu" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:@"close" ofType:@"png"];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    self.closeButton.hidden = YES;
    self.closeButton.backgroundColor = [UIColor clearColor];
    [self.emptyView addSubview:self.closeButton];

    // 添加按钮
    NSString *add_path = [bundle pathForResource:@"add" ofType:@"png"];
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageWithContentsOfFile:add_path] forState:UIControlStateNormal];
    self.addButton.hidden = YES;
    [self.emptyView addSubview:self.addButton];
}

- (void)setModel:(CZHColumnMenuModel *)model {
    _model = model;

    //标题文字处理
    if (model.title.length == 2) {
        self.titleLable.font = [UIFont systemFontOfSize:15];
    } else if (model.title.length == 3) {
        self.titleLable.font = [UIFont systemFontOfSize:14];
    } else if (model.title.length == 4) {
        self.titleLable.font = [UIFont systemFontOfSize:13];
    } else if (model.title.length > 4) {
        self.titleLable.font = [UIFont systemFontOfSize:12];
    }

    if (model.type == ColumnMenuTypeTencent) {
        self.titleLable.text = model.title;
        self.closeButton.hidden = !model.selected;
    } else if (model.type == ColumnMenuTypeTouTiao) {
        self.closeButton.hidden = !model.selected;
        self.titleLable.text = [NSString stringWithFormat:@"%@",model.title];
        if (model.showAdd) {
            self.addButton.hidden = NO;
        } else {
            self.addButton.hidden = YES;
        }
    }

    [self updateAllFrame:model];
}

- (void)updateAllFrame:(CZHColumnMenuModel *)model {
    self.emptyView.frame = CGRectMake(5.0, 5.5, self.contentView.width - 10, self.contentView.height - 13);
    self.titleLable.size = [self returnTitleSize];

    if (model.showAdd) {
        self.titleLable.center = CGPointMake(self.emptyView.width / 2 + 6, self.emptyView.height / 2);
    } else {
        self.titleLable.center = CGPointMake(self.emptyView.width / 2, self.emptyView.height / 2);
    }

    self.closeButton.frame = CGRectMake(self.contentView.width - 18, -3, 18, 18);

    self.addButton.size = CGSizeMake(10, 10);
    self.addButton.centerY = self.titleLable.centerY;
    self.addButton.x = CGRectGetMinX(self.titleLable.frame) - 12;
}

- (CGSize)returnTitleSize {
    CGFloat maxWidth = self.emptyView.width - 12;
    CGSize size = [self.titleLable.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLable.font} context:nil].size;
    return size;
}
@end
