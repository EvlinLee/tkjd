//
//  GroupViewController.h
//  TKJD
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
@interface GroupViewController : UIViewController
@property(nonatomic ,retain)GroupModel * model;
@property(nonatomic ,retain)NSMutableDictionary * keyDic;
@property(nonatomic , strong)NSMutableArray * shopAry;
@end
