//
//  ShopViewController.h
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CodeBlock)(NSInteger index);

@interface ShopViewController : UIViewController

@property(nonatomic,copy)CodeBlock block;
@end
