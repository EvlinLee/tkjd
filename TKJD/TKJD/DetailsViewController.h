//
//  DetailsViewController.h
//  TKJD
//
//  Created by apple on 2017/3/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface DetailsViewController : UIViewController
@property(nonatomic , retain)NSString * urlStr;
@property(nonatomic , retain)ShopModel * model;
@end
