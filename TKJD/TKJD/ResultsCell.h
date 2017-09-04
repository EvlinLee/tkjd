//
//  ResultsCell.h
//  TKJD
//
//  Created by apple on 2017/3/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsCell : UITableViewCell
@property(nonatomic , retain)UIImageView * imgView;
@property(nonatomic , retain)UILabel * titleLab;
@property(nonatomic , retain)UILabel * priceLab;
@property(nonatomic , retain)UILabel * rateLab;
@property(nonatomic , retain)UILabel * jhLab;
@property(nonatomic , retain)UILabel * subtitleLab;

@property(nonatomic , retain)UIButton * button;
@end
