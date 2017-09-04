//
//  ChainViewController.h
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface ChainViewController : UIViewController
@property(nonatomic , assign)BOOL isTabBar;
@property(nonatomic , strong)ShopModel * model;
@end
