//
//  ZCYTabBarController.h
//  ZCYTabBar
//
//  Created by 张春雨 on 16/8/6.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCYTabBar.h"

@interface ZCYTabBarController : UITabBarController

//tabbar
@property (nonatomic, strong) ZCYTabBar *tabbar;

//设置中间凸出按钮
- (void)addCenterButtonTitle:(NSString *)Title
                       image:(NSString *)image
               selectedImage:(NSString *)selectedImage;

//设置子控制器按钮
- (void)addOneChildController:(UIViewController *)Controller
                        title:(NSString *)title
                    imageName:(NSString *)imageName
            selectedImageName:(NSString *)selectedImageName;
@end
