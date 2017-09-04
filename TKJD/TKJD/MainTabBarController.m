//
//  MainTabBarController.m
//  sunhome
//
//  Created by wanghuaiyou on 16/3/16.
//  Copyright © 2016年 wanghuaiyou. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "ShopViewController.h"
#import "ChainViewController.h"
#import "CheckViewController.h"
#import "ChooseViewController.h"


@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
   
    // 首页
    ShopViewController  * shop = [ShopViewController new];
    [self addChildVc:shop title:@"商品库" image:@"shop" selectedImage:@""];
    
    // 监控
    ChainViewController * chain = [ChainViewController new];
    [self addChildVc:chain title:@"自动转链" image:@"zl" selectedImage:@""];
    
    // 资讯
    CheckViewController * check = [CheckViewController new];
    [self addChildVc:check title:@"查优惠券" image:@"cha" selectedImage:@""];
    
    // 发现
    ChooseViewController * choose = [ChooseViewController new];
    [self addChildVc:choose title:@"已选商品" image:@"yx" selectedImage:@""];
    
       
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title;
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
//    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
//    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    childVc.view.backgroundColor = [UIColor greenColor];
//    self.tabBar.tintColor= UIColorFromRGB(0xff307e);

    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    //  包装 一个导航控制器
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}





@end
