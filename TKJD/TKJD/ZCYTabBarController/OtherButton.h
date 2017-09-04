//
//  Button.h
//  ZCYTabBar
//
//  Created by 张春雨 on 16/8/6.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherButton : UIButton
//模型数据
@property (weak , nonatomic) UITabBarItem *item;
@property(nonatomic , assign)int bigTag;
@end
