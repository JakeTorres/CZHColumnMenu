//
//  ViewController.m
//  CZHColumnMenu
//
//  Created by JakeTorres on 2021/2/3.
//

#import "ViewController.h"
#import "CZHColumnViewController.h"

#import "UIView+CZH.h"
#import "CZHConfig.h"

@interface ViewController ()<ColumnMenuDelegate>

/// 管理类
@property (nonatomic, strong) CZHColumnViewController *columnManager;
@end

@implementation ViewController

+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:[UIColor blackColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

+ (void)load {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"黑头搜索";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    NSArray *array = @[@"仿腾讯风格",@"仿风格头条"];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.backgroundColor = kRandomColor;
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.centerX = self.view.width * 0.5 - 50;
        button.width = 100;
        button.height = 40;
        button.y = i * 40 + 20 * (i + 1);
        button.layer.cornerRadius = 4.f;
        button.layer.masksToBounds = YES;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)sender {
    NSMutableArray *objectvie = [NSMutableArray arrayWithObjects:@"要闻",@"视频",@"娱乐",@"军事",@"新时代",@"独家",@"广东",@"社会",@"图文",@"段子",@"搞笑视频", nil];
    NSMutableArray *items = [NSMutableArray arrayWithObjects:@"八卦",@"搞笑",@"短视频",@"图文段子",@"极限第一人", nil];

    if (sender.tag == 0) {
        CZHColumnViewController *menuManager = [CZHColumnViewController columnMenuWithObjectiveArray:objectvie itemsArray:items type:ColumnMenuTypeTencent delegate:self];
        [self showViewController:menuManager sender:nil];
    } else if (sender.tag == 1) {
        CZHColumnViewController *menuManager = [CZHColumnViewController columnMenuWithObjectiveArray:objectvie itemsArray:items type:ColumnMenuTypeTouTiao delegate:self];
        [self showViewController:menuManager sender:nil];
    }
}

#pragma mark - JMColumnMenuDelegate
- (void)columnMenuObjectiveArray:(NSMutableArray *)objective itemsArray:(NSMutableArray *)items {
    NSLog(@"选择数组---%@",objective);
    NSLog(@"未选择数组%@",items);
}

- (void)columnMenuDidSelectedTitle:(NSString *)title index:(NSInteger)index {
    NSLog(@"点击的标题---%@  对应的index---%zd",title, index);
}

@end
