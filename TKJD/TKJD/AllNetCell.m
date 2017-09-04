//
//  AllNetCell.m
//  TKJD
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AllNetCell.h"

@implementation AllNetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        self.imgView=[[UIImageView alloc]init];
        
        
        self.titleLab=[[UILabel alloc] init];
        self.titleLab.font=[UIFont systemFontOfSize:14];
        self.titleLab.textColor=UIColorFromRGB(0x333333);
        self.titleLab.textAlignment=NSTextAlignmentLeft;
        self.titleLab.numberOfLines=0;
        
        self.priceLab=[[UILabel alloc]init];
        self.priceLab.font=[UIFont systemFontOfSize:14];
        self.priceLab.textAlignment=NSTextAlignmentLeft;
        self.priceLab.textColor=UIColorFromRGB(0x666666);
        
        
        self.qhLab=[[UILabel alloc]init];
        self.qhLab.font=[UIFont systemFontOfSize:11];
        self.qhLab.textAlignment=NSTextAlignmentLeft;
        self.qhLab.textColor=UIColorFromRGB(0xff307e);
        self.qhLab.adjustsFontSizeToFitWidth=YES;
        
        
        self.yhBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.yhBut setImage:[UIImage imageNamed:@"q"] forState:UIControlStateNormal];
        self.yhBut.titleLabel.font=[UIFont systemFontOfSize:16];
        [self.yhBut setTitleColor:UIColorFromRGB(0xff307e) forState:UIControlStateNormal];
        
        self.ledBut =[UIButton new];
        [self.ledBut setTitle:@"立即领券" forState:UIControlStateNormal];
        [self.ledBut setTitleColor:UIColorFromRGB(0x0ff307e) forState:UIControlStateNormal];
        self.ledBut.layer.borderColor=UIColorFromRGB(0xff307e).CGColor;
        self.ledBut.layer.borderWidth=1;
        self.ledBut.layer.masksToBounds=YES;
        self.ledBut.layer.cornerRadius=2;
        self.ledBut.titleLabel.font =[UIFont systemFontOfSize:16];
        
        [self.contentView addSubviews:@[self.titleLab,self.priceLab,self.qhLab,self.yhBut,self.ledBut,self.imgView]];
        
        
        self.imgView.sd_layout
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 10)
        .widthIs(130);
        
        self.titleLab.sd_layout
        .leftSpaceToView(self.imgView,10)
        .topSpaceToView(self.contentView,5)
        .rightSpaceToView(self.contentView,20)
        .heightIs(40);
        
        self.priceLab.sd_layout
        .leftSpaceToView(self.imgView,10)
        .topSpaceToView(self.titleLab,10)
        .rightSpaceToView(self.contentView,20)
        .heightIs(20);
        
        
        self.yhBut.sd_layout
        .topSpaceToView(self.priceLab,5)
        .rightSpaceToView(self.contentView,10)
        .heightIs(20)
        .widthIs(70);
        
        self.qhLab.sd_layout
        .leftSpaceToView(self.imgView,10)
        .topSpaceToView(self.priceLab,5)
        .rightSpaceToView(self.yhBut,0)
        .heightIs(20);
        
        
        self.ledBut.sd_layout
        .topSpaceToView(self.qhLab,5)
        .rightSpaceToView(self.contentView,10)
        .heightIs(30)
        .leftSpaceToView(self.imgView, 10);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
