//
//  MainNavigationController.m
//  sunhome
//
//  Created by wanghuaiyou on 16/3/16.
//  Copyright © 2016年 wanghuaiyou. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // 去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    // 图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
    
    // 背景颜色
    self.navigationBar.barTintColor=[UIColor whiteColor];
    
    // 文字颜色 title
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]}];
    
    // 返回字的颜色 left right
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    
}




@end
