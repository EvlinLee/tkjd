//
//  NotPreCell.h
//  TKJD
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotPreCell : UITableViewCell{
    
    float height;
}
@property(nonatomic , retain)UIImageView * image;


@property(nonatomic , retain)UILabel * titleLab;
@property(nonatomic , retain)UILabel * priceLab;
@property(nonatomic , retain)UILabel * qhPriceLab;
@property(nonatomic , retain)UILabel * qPriceLab;
@property(nonatomic , retain)UILabel * commissionLab;
@property(nonatomic , retain)UILabel * proportionLab;

@property(nonatomic , retain)UILabel * salesLab;

@property(nonatomic , retain)UIButton * shareBut;
@property(nonatomic , strong)ShopModel * model;
@end
