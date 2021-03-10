//
//  CZHColumnMenuHeaderView.m
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import "CZHColumnMenuHeaderView.h"
#import "UIView+CZH.h"

@interface CZHColumnMenuHeaderView()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 描述
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation CZHColumnMenuHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.textColor = [UIColor linkColor];
        [self addSubview:self.detailLabel];

        self.ediButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.ediButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.ediButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.ediButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.ediButton.layer.masksToBounds = YES;
        self.ediButton.layer.cornerRadius = 6.0f;
        self.ediButton.layer.borderColor = [UIColor redColor].CGColor;
        self.ediButton.layer.borderWidth = 1.0f;
        self.ediButton.hidden = YES;
        [self addSubview:self.ediButton];

        [self initFrame];
    }
    return self;
}



- (void)initFrame {
    CGFloat titleX = 12;
    CGFloat titleW = [self returnTitleSize].width;
    CGFloat titleH = 16;
    CGFloat titleY = self.height * 0.5 - titleH * 0.5;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);

    CGFloat detailW = 160;
    CGFloat detailH = 16;
    CGFloat detailY = titleY;
    CGFloat detailX = CGRectGetMaxX(self.titleLabel.frame) + 10;
    self.detailLabel.frame = CGRectMake(detailX, detailY, detailW, detailH);

    self.ediButton.centerY = self.titleLabel.centerY;
    self.ediButton.size = CGSizeMake(50, 24);
    self.ediButton.x = self.width - 60;
}

- (CGSize)returnTitleSize {
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    return size;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
    [self initFrame];
}

- (void)setDetailString:(NSString *)detailString {
    _detailString = detailString;
    self.detailLabel.text = detailString;
    [self initFrame];
}
@end
