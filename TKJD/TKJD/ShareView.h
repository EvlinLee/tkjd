//
//  ShareView.h
//  TKJD
//
//  Created by apple on 2017/3/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

-(void)shareViewBtn:(UIButton *)btn;

@end


@interface ShareView : UIView
@property(nonatomic , retain)NSMutableArray * imgAry;
@property(nonatomic , retain)NSMutableArray * titleAry;
@property(nonatomic , assign)id delegate;
@end
