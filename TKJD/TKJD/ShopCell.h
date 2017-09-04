//
//  ShopCell.h
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UITableViewCell
@property(nonatomic , strong)UIImageView * imgView;
@property(nonatomic , strong)UILabel * title;
@property(nonatomic , strong)UILabel * qhLab;
@property(nonatomic , strong)UILabel * rateLab;
@property(nonatomic , strong)UILabel * yjLab;
@property(nonatomic , retain)UILabel * priceLab;
@property(nonatomic , retain)UILabel * salesLab;

@property(nonatomic , strong)UIButton * seleBut;


@property(nonatomic , retain)UIImageView * xImgView;
@property(nonatomic , retain)UIImageView * tmallImg;


@end
