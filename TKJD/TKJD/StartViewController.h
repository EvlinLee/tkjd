//
//  StartViewController.h
//  TKJD
//
//  Created by apple on 2017/4/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
@interface StartViewController : UIViewController
@property(nonatomic , retain)GroupModel * model;
@property(nonatomic , retain)NSMutableArray * nameAry;
@property(nonatomic , retain)NSMutableDictionary * synckeyDic;
@property(nonatomic , strong)NSMutableArray * shopAry;
@end
