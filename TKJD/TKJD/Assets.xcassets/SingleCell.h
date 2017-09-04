//
//  SingleCell.h
//  TKJD
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleCell : UITableViewCell
@property(nonatomic , strong)UILabel * titleLab;
@property(nonatomic , strong)UILabel * rateLab;

@property(nonatomic , strong)UILabel * textLab;
@property(nonatomic , retain)UITextView * textView;
@property(nonatomic , strong)UIButton * promoteBtn;
@end
