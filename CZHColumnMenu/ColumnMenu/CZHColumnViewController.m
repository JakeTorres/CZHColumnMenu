//
//  CZHColumnViewController.m
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import "CZHColumnViewController.h"
#import "CZHColumnViewCell.h"
#import "CZHColumnMenuHeaderView.h"
#import "CZHColumnMenuFooterView.h"
#import "CZHColumnMenuModel.h"
#import "UIView+CZH.h"

#define CELLID @"CollectionViewCell"
#define HEADERID @"headerId"
#define FOOTERID @"footerId"

@interface CZHColumnViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 导航栏顶层View
@property (nonatomic, weak) UIView *navView;

/// 导航栏标题
@property (nonatomic, weak) UILabel *navTitleLabel;

/// 导航栏右侧按钮
@property (nonatomic, weak) UIButton *navRightButton;

/// 目标数组
@property (nonatomic, strong) NSMutableArray *objectiveArray;

/// 待选择数组
@property (nonatomic, strong) NSMutableArray *itemArray;

/// collection View
@property (nonatomic, strong) UICollectionView *collectionView;

/// 表头视图
@property (nonatomic, weak) CZHColumnMenuHeaderView *headerView;

/// 表底部视图
@property (nonatomic, weak) CZHColumnMenuFooterView *footerView;

/// 长安手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

/// 编辑按钮
@property (nonatomic, copy) NSString *editButtonString;
@end

@implementation CZHColumnViewController

#pragma mark - 懒加载
- (NSMutableArray *)objectiveArray {
    if (!_objectiveArray) {
        _objectiveArray = [NSMutableArray new];
    }
    return _objectiveArray;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray new];
    }
    return _itemArray;
}

+ (instancetype)columnMenuWithObjectiveArray:(NSMutableArray *)objective itemsArray:(NSMutableArray *)items type:(ColumnMenuType)type delegate:(id<ColumnMenuDelegate>)delegate {
    return [[self alloc] columnMenuWithObjectiveArray:objective itemsArray:items type:type delegate:delegate];
}

- (instancetype)columnMenuWithObjectiveArray:(NSMutableArray *)objective itemsArray:(NSMutableArray *)items type:(ColumnMenuType)type delegate:(id<ColumnMenuDelegate>)delegate {
    if (self == [super init]) {
        self.type = type;
        self.delegate = delegate;
        self.editButtonString = @"编辑";

        for (int i = 0; i < objective.count; i ++) {
            CZHColumnMenuModel *model = [[CZHColumnMenuModel alloc] init];
            model.title = [objective objectAtIndex:i];
            model.type = type;

            if (type == ColumnMenuTypeTouTiao) {
                model.showAdd = NO;
                model.selected = NO;
                if (i == 0) {
                    model.resident = YES;
                }
            } else if (type == ColumnMenuTypeTencent) {
                if (i != 0) {
                    model.selected = YES;
                } else {
                    model.selected = NO;
                }
            }

            [self.objectiveArray addObject:model];
        }

        for (NSString *title in items) {
            CZHColumnMenuModel *model = [CZHColumnMenuModel new];
            model.title = title;
            if (self.type == ColumnMenuTypeTouTiao) {
                model.showAdd = YES;
            }

            model.type = type;
            model.selected = NO;
            [self.itemArray addObject:model];
        }

        [self initSubViews];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initSubViews {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    navView.backgroundColor = [UIColor blackColor];
    self.navView = navView;
    [self.view addSubview:navView];

    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.navView.centerX - 100, self.navView.centerY, 200, 20)];
    navLabel.text = @"频道筛选";
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.textColor = [UIColor whiteColor];
    self.navTitleLabel = navLabel;
    [self.navView addSubview:navLabel];

    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(self.navView.width - 30, CGRectGetMinY(self.navTitleLabel.frame), 20, 20);
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JMColumnMenu" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:@"close_one" ofType:@"png"];
    [rightItem setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    self.navRightButton = rightItem;
    [rightItem addTarget:self action:@selector(navCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:rightItem];

    // 表单试图布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navView.frame), self.view.width, self.view.height - self.navView.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[CZHColumnViewCell class] forCellWithReuseIdentifier:CELLID];
    [self.collectionView registerClass:[CZHColumnMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERID];
    [self.collectionView registerClass:[CZHColumnMenuFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTERID];

    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)];
    self.collectionView.userInteractionEnabled = YES;
    [self.collectionView addGestureRecognizer:self.longPress];
}

- (void)longGesturePress:(UIGestureRecognizer *)longPress {
    if ([self.editButtonString containsString:@"完成"] && self.type == ColumnMenuTypeTouTiao) {
        self.editButtonString = @"编辑";
        for (int i = 0; i < self.objectiveArray.count; i ++) {
            CZHColumnMenuModel *model = self.objectiveArray[i];
            if (i != 0) {
                model.selected = YES;
            }
        }

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
    // 获取点击在collectionview的坐标
    CGPoint point = [longPress locationInView:self.collectionView];
    // 从长按开始
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (indexPath.section == 0 && indexPath.item == 0) {
            return;
        }
        if (@available(iOS 9.0, *)) {
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
    } else if(longPress.state == UIGestureRecognizerStateChanged ) {
        if (indexPath.section == 0 && indexPath.item == 0) {
            return;
        }
        if (@available(iOS 9.0, *)) {
            [self.collectionView updateInteractiveMovementTargetPosition:point];
        }
    } else if (longPress.state == UIGestureRecognizerStateEnded) {
        if (@available(iOS 9.0, *)) {
            [self.collectionView endInteractiveMovement];
        }

    } else {
        if (@available(iOS 9.0, *)) {
            [self.collectionView cancelInteractiveMovement];
        }
    }
}

#pragma mark - UICollectionViewDataSource
// 一共有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.itemArray) {
        return 2;
    }
    return 1;
}

// 每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.objectiveArray.count;
    }
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CZHColumnViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        CZHColumnMenuModel *model = self.objectiveArray[indexPath.row];
        cell.model = model;
        if (indexPath.item == 0) { //第一个按钮样式区别
            cell.titleLable.textColor = [UIColor redColor];
        }
    } else {
        cell.model = self.itemArray[indexPath.row];
    }

    // 关闭按钮点击事件
    cell.closeButton.tag = indexPath.item;
    [cell.closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

// 设置collectionViwe头部和尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CZHColumnMenuHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADERID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleString = @"已选频道";
            headerView.detailString = @"按住拖动调整排序";
            if (self.type == ColumnMenuTypeTouTiao) {
                [headerView.ediButton setTitle:self.editButtonString forState:UIControlStateNormal];
                headerView.ediButton.hidden = NO;
                [headerView.ediButton addTarget:self action:@selector(headViewEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        self.headerView = headerView;
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        CZHColumnMenuFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FOOTERID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            footerView.titleString = @"频道推荐";
            footerView.detailString = @"点击添加频道";
        }
        self.footerView = footerView;
        return footerView;
    }
    return nil;
}

#pragma mark - 头部按钮点击事件
- (void)headViewEditBtnClick {
    if ([self.editButtonString containsString:@"编辑"]) {
        self.editButtonString = @"完成";

        for (int i = 0; i < self.objectiveArray.count; i++) {
            CZHColumnMenuModel *model = self.objectiveArray[i];
            if (i == 0) {
                model.selected = NO;
            } else {
                model.selected = YES;
            }
        }
    } else {
        self.editButtonString = @"编辑";

        for (int i = 0; i < self.objectiveArray.count; i++) {
            CZHColumnMenuModel *model = self.objectiveArray[i];
            if (i == 0) {
                model.selected = NO;
            } else {
                model.selected = NO;
            }
        }
    }
    [self.collectionView reloadData];
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 4, 10);
}

//头部视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(self.view.width, 40);
    } else {
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(self.view.width, 40);
    } else {
        return CGSizeMake(0, 0);
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(self.collectionView.width * 0.25 - 10, 53);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CZHColumnMenuModel *model;
    if (indexPath.section == 0) {
        model = self.objectiveArray[indexPath.item];
        //判断是否是编辑状态
        if ([self.editButtonString containsString:@"编辑"]) {
            //判断是否是头条,是就直接回调出去
            if (model.type == ColumnMenuTypeTouTiao) { //头条
                if ([self.delegate respondsToSelector:@selector(columnMenuDidSelectedTitle:index:)]) {
                    [self.delegate columnMenuDidSelectedTitle:model.title index:indexPath.item];
                }
                [self navCloseBtnClick];
                return;
            }
        }

        //判断是否可以删除
        if (model.resident) {
            return;
        }

        model.selected = NO;
        if (model.type == ColumnMenuTypeTencent) {
            model.showAdd = NO;
        } else if (model.type == ColumnMenuTypeTouTiao) {
            model.showAdd = YES;
        }
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];

        [self.objectiveArray removeObjectAtIndex:indexPath.item];
        [self.itemArray insertObject:model atIndex:0];

        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    } else if (indexPath.section == 1) {
        CZHColumnViewCell *cell = (CZHColumnViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.closeButton.hidden = YES;
        model  = self.itemArray[indexPath.item];
        if (model.type == ColumnMenuTypeTencent) {
            model.selected = YES;
        } else if (model.type == ColumnMenuTypeTouTiao) {
            if ([self.editButtonString containsString:@"编辑"]) {
                model.selected = NO;
            } else {
                model.selected = YES;
            }
        }
        model.showAdd = NO;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];

        [self.itemArray removeObjectAtIndex:indexPath.item];
        [self.objectiveArray addObject:model];

        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:self.objectiveArray.count-1 inSection:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }

    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

#pragma mark - item关闭按钮点击事件
- (void)closeButtonClick:(UIButton *)sender {
    CZHColumnMenuModel *model = self.objectiveArray[sender.tag];
    model.selected = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];

    [self.objectiveArray removeObjectAtIndex:sender.tag];
    [self.itemArray insertObject:model atIndex:0];

    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];

    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

//在开始移动是调动此代理方法
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"开始移动");
    return YES;
}

//在移动结束的时候调用此代理方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    NSLog(@"结束移动");
    CZHColumnMenuModel *model;
    if (sourceIndexPath.section == 0) {
        model = self.objectiveArray[sourceIndexPath.item];
        [self.objectiveArray removeObjectAtIndex:sourceIndexPath.item];
    } else {
        model = self.itemArray[sourceIndexPath.item];
        [self.itemArray removeObjectAtIndex:sourceIndexPath.item];
    }

    if (destinationIndexPath.section == 0) {
        model.selected = YES;
        [self.objectiveArray insertObject:model atIndex:destinationIndexPath.item];
    } else if (destinationIndexPath.section == 1) {
        model.selected = NO;
        [self.itemArray insertObject:model atIndex:destinationIndexPath.item];
    }

    [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];

    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

#pragma mark - 刷新tag
- (void)refreshDelBtnsTag {
    for (CZHColumnViewCell *cell in self.collectionView.visibleCells) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        cell.closeButton.tag = indexPath.item;
    }
}

#pragma mark - 更新block数组
- (void)updateBlockArr {
    NSMutableArray *tempTagsArrM = [NSMutableArray array];
    NSMutableArray *tempOtherArrM = [NSMutableArray array];
    for (CZHColumnMenuModel *model in self.objectiveArray) {
        [tempTagsArrM addObject:model.title];
    }
    for (CZHColumnMenuModel *model in self.itemArray) {
        [tempOtherArrM addObject:model.title];
    }

    if ([self.delegate respondsToSelector:@selector(columnMenuObjectiveArray:itemsArray:)]) {
        [self.delegate columnMenuObjectiveArray:tempTagsArrM itemsArray:tempOtherArrM];
    }
    if (self.itemArray.count <= 0) {
        self.footerView.hidden = YES;
    } else {
        self.footerView.hidden = NO;
    }
}

#pragma mark - 导航栏右侧关闭按钮点击事件
- (void)navCloseBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavTitleStr:(NSString *)navTitleStr {
    _navTitle = navTitleStr;
    self.navTitleLabel.text = navTitleStr;
}

- (void)setNavBackgroundColor:(UIColor *)navBackgroundColor {
    _navBackgroundColor = navBackgroundColor;
    self.navView.backgroundColor = navBackgroundColor;
}

- (void)setNavTitleColor:(UIColor *)navTitleColor {
    _navTitleColor = navTitleColor;
    self.navTitleLabel.textColor = navTitleColor;
}

- (void)setNavRightImage:(UIImage *)navRightImage {
    _navRightImage = navRightImage;
    [self.navRightButton setImage:navRightImage forState:UIControlStateNormal];
}
@end
