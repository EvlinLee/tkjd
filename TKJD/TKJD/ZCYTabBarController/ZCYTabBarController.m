//
//  ZCYTabBarController.m
//  ZCYTabBar
//
//  Created by 张春雨 on 16/8/6.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "ZCYTabBarController.h"
#import "ShopViewController.h"
#import "HelpViewController.h"
#import "CheckViewController.h"
#import "ChooseViewController.h"
#import "PersonalViewController.h"
#import "MainNavigationController.h"
#import "SuperSViewController.h"
@interface ZCYTabBarController ()<ZCYTabBarDelegate>
//保存所有控制器对应按钮的属性
@property (strong , nonatomic) NSMutableArray *items;
//保存中间按钮对应按钮的属性
@property (strong , nonatomic)UITabBarItem *CenterButtonitem;
@end

@implementation ZCYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ShopViewController * shop =[[ShopViewController alloc]init];
    [self addOneChildController:shop title:@"好券直播" imageName:@"zb" selectedImageName:@"zb1"];
    
    HelpViewController * help =[[HelpViewController alloc]init];
    [self addOneChildController:help title:@"使用帮助" imageName:@"help" selectedImageName:@"help1"];
    
 
//    CheckViewController * check =[[CheckViewController alloc]init];
    SuperSViewController * check=[[SuperSViewController alloc]init];
    [self addCenterButtonTitle:@"" image:@"cq" selectedImage:@"cq"];
    [self addOneChildController:check title:@"" imageName:@"cq" selectedImageName:@"cq1"];
    
    ChooseViewController * choose =[[ChooseViewController alloc]init];
    [self addOneChildController:choose title:@"我的商品库" imageName:@"wdspk" selectedImageName:@"wdspk1"];
    
    PersonalViewController * personal =[[PersonalViewController alloc]init];
    [self addOneChildController:personal title:@"个人中心" imageName:@"grzx" selectedImageName:@"grzx1"];
    
    
    
    
    
}

#pragma mark - 初始化
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载自定义tabbar
    [self.view addSubview:self.tabbar];
    
    //干掉系统tabBar
    self.tabBar.hidden = YES;
    [self.tabBar removeFromSuperview];
    
    for (UIView *loop in self.tabBar.subviews) {
        if (![loop isKindOfClass:[ZCYTabBar class]]) {
            [loop removeFromSuperview];
        }
    }
}

#pragma mark - 设置中间凸出按钮
- (void)addCenterButtonTitle:(NSString *)Title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    if (!_CenterButtonitem) {
        //设置按钮属性
        UITabBarItem * TabBarItem = [[UITabBarItem alloc]initWithTitle:Title image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:selectedImage]];
        //记录按钮对应内容
        _CenterButtonitem = TabBarItem;
    }
}


#pragma mark - 设置子控制器按钮
- (void)addOneChildController:(UIViewController *)Controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    // 设置标题
    Controller.tabBarItem.title = title;
    // 设置图标
    Controller.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 不要渲染
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Controller.tabBarItem.selectedImage = selectedImage;
   
    // 记录所有控制器对应按钮的内容
    [self.items addObject:Controller.tabBarItem];
    
     MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:Controller];
    
    // 添加为tabbar控制器的子控制器
    [self addChildViewController:nav];
    
    
    
}

#pragma mark - tabBar上按钮的点击切换控制器 Delegate方法
- (void)tabBar:(ZCYTabBar *)tabBar didClickBtn:(NSInteger)index{
    [super setSelectedIndex:index];
}

#pragma mark - 懒加载
- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (ZCYTabBar *)tabbar{
    if (!_tabbar) {
        // 初始化tabBar
        _tabbar = [[ZCYTabBar alloc]init];
        _tabbar.delegate = self;
        _tabbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ZCYTabBar.bundle/tab_background"]];
        
        //保存tabbar的属性
        _tabbar.items = self.items;
        
        _tabbar.frame = self.tabBar.frame;
        
        //默认选中0
        [_tabbar setSeletedIndex:0];
    }
    return _tabbar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
