//
//  ChooseCell.h
//  TKJD
//
//  Created by apple on 2017/2/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCell : UITableViewCell
@property(nonatomic , strong)UIImageView * imgView;
@property(nonatomic , strong)UILabel * title;
@property(nonatomic , strong)UILabel * qhLab;
//@property(nonatomic , strong)UILabel * yhqLab;
@property(nonatomic , strong)UILabel * rateLab;
@property(nonatomic , strong)UILabel * yjLab;
//@property(nonatomic , strong)UILabel * contentLab;

@property(nonatomic , strong)UIButton * seleBut;
@property(nonatomic , strong)UIButton * buyBtn;

@property(nonatomic , retain)UILabel * priceLab;
@property(nonatomic , retain)UILabel * salesLab;
@property(nonatomic , retain)UIImageView * xImgView;
@property(nonatomic , retain)UIImageView * tmallImg;
@property(nonatomic , retain)UILabel * qLab;
@property(nonatomic , retain)UILabel * byLab;



-(void)labelWithText:(NSString *)text;
@end
