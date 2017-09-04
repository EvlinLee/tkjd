//
//  itemCell.h
//  TKJD
//
//  Created by apple on 2017/3/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface itemCell : UITableViewCell

@property(nonatomic , retain)UIImageView * image;
@property(nonatomic , retain)UIImageView * xImgView;
@property(nonatomic , retain)UIImageView * tmallImg;

@property(nonatomic , retain)UILabel * titleLab;
@property(nonatomic , retain)UILabel * priceLab;
@property(nonatomic , retain)UILabel * salesLab;
@property(nonatomic , retain)UILabel * qhPriceLab;
@property(nonatomic , retain)UILabel * qPriceLab;
@property(nonatomic , retain)UILabel * numLab;
@property(nonatomic , retain)UILabel * commissionLab;
@property(nonatomic , retain)UILabel * proportionLab;

@property(nonatomic , retain)UIProgressView * progressView;

@property(nonatomic , retain)UIButton * shareBut;
@property(nonatomic , retain)UIButton * buyBut;

@property(nonatomic , strong)ShopModel * model;

@end
