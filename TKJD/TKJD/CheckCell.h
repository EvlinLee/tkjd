//
//  CheckCell.h
//  JDZ
//
//  Created by apple on 2017/1/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckCell : UITableViewCell
@property(nonatomic , strong)UIImageView * imgView;
@property(nonatomic , strong)UILabel * priceLab;
@property(nonatomic , strong)UILabel * proportionLab;
@property(nonatomic , strong)UILabel * qhLab;
@property(nonatomic , strong)UILabel * availableLab;
@property(nonatomic , strong)UILabel * makeLab;


@property(nonatomic , strong)UIButton * promoteBtn;

@end
