//
//  ZCYTabBar.h
//  ZCYTabBar
//
//  Created by 张春雨 on 16/8/6.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherButton.h"
//tabbar按钮点击通知协议
@class ZCYTabBar;
@protocol ZCYTabBarDelegate <NSObject>
@optional
- (void)tabBar:(ZCYTabBar *)tabBar didClickBtn:(NSInteger)index;
@end


@interface ZCYTabBar : UIView

// 点击代理人
@property (weak , nonatomic)id<ZCYTabBarDelegate> delegate;
// 控制器按钮属性(UITabBarItem)
@property (weak , nonatomic) NSArray *items;
// 中间按钮属性
//@property (weak , nonatomic)UITabBarItem *CenterButtonitem;


@property(assign , nonatomic)BOOL isCenter;

// 中间按钮
@property (weak, nonatomic) OtherButton *bigButton;
// 其他按钮
//@property (strong , nonatomic) NSMutableArray* OtherButtons;
// 选中按钮
@property (weak, nonatomic) UIButton *selButton;
// 选中的索引
@property (assign , nonatomic) NSInteger seletedIndex;
// 外部设置索引跳转页面
- (void)setSeletedIndex:(NSInteger)seletedIndex;
@end
