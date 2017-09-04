//
//  NetViewController.h
//  TKJD
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetViewController : UIViewController
@property(nonatomic , strong)NSString * text;
@property(nonatomic , assign)float height;

-(void)searchDataWithText:(NSString *)text;
@end
