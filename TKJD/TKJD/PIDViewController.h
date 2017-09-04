//
//  PIDViewController.h
//  TKJD
//
//  Created by apple on 2017/1/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface PIDViewController : UIViewController
@property(nonatomic , strong)ShopModel * model;
@property(nonatomic , assign)BOOL isCheck;
@end
