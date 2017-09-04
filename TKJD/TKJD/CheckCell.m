//
//  CheckCell.m
//  JDZ
//
//  Created by apple on 2017/1/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CheckCell.h"

@implementation CheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        self.imgView=[[UIImageView alloc]init];
        self.imgView.image=[UIImage imageNamed:@"bgCell"];
        
        
        self.priceLab=[[UILabel alloc]init];
//         self.priceLab.text=@"¥20";
        self.priceLab.textColor=[UIColor whiteColor];
        self.priceLab.numberOfLines=0;
        self.priceLab.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.priceLab.textAlignment=NSTextAlignmentCenter;

        
        UILabel * lab =[[UILabel alloc]init];
        lab.font=[UIFont systemFontOfSize:16];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.textColor=[UIColor whiteColor];
        lab.text=@"优惠券";
        
        self.proportionLab=[UILabel new];
//        self.proportionLab.text=@"佣金比例:30.0%";
        self.proportionLab.font=[UIFont systemFontOfSize:13];
        self.proportionLab.textColor=UIColorFromRGB(0x333333);
        self.proportionLab.textAlignment=NSTextAlignmentLeft;

        
//        self.qhLab=[UILabel new];
        
//        self.qhLab.text=@"券后:¥48.5";
//        self.qhLab.font=[UIFont systemFontOfSize:12];
//        self.qhLab.textColor=UIColorFromRGB(0x333333);
//        self.qhLab.textAlignment=NSTextAlignmentLeft;
        
        

        self.availableLab=[UILabel new];
//        self.availableLab.text=@"满60可用";
        self.availableLab.font=[UIFont systemFontOfSize:12];
        self.availableLab.textColor=UIColorFromRGB(0x333333);
        self.availableLab.textAlignment=NSTextAlignmentLeft;


        
        self.makeLab=[UILabel new];
//        self.makeLab.text=@"赚:¥15.5";
        self.makeLab.adjustsFontSizeToFitWidth=YES;
        self.makeLab.font=[UIFont systemFontOfSize:12];
        self.makeLab.textColor=UIColorFromRGB(0xF83A5E);
        self.makeLab.textAlignment=NSTextAlignmentCenter;
  

        
      
        self.promoteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.promoteBtn.layer.masksToBounds=YES;
        self.promoteBtn.layer.cornerRadius=10;
        [self.promoteBtn setTitle:@"一键分享" forState:UIControlStateNormal];
        [self.promoteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.promoteBtn setBackgroundColor:UIColorFromRGB(0xF83A5E)];
        self.promoteBtn.titleLabel.font =[UIFont systemFontOfSize:12];
        
        
        UIView * line =[[UIView alloc]init];
        line.backgroundColor=UIColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:line];
        
        UIView * line1=[[UIView alloc]init];
        line1.backgroundColor=UIColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:line1];
        
        UIView * line2=[[UIView alloc]init];
        line2.backgroundColor=UIColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:line2];
        
        UIView * line3=[[UIView alloc]init];
        line3.backgroundColor=UIColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:line3];
        
        
        line.sd_layout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0)
        .widthIs(1);
        
        line1.sd_layout
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0)
        .widthIs(1);
        
        line2.sd_layout
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .heightIs(0.5);
        
        line3.sd_layout
        .rightSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0)
        .heightIs(1);

        
        [self.contentView addSubviews:@[self.imgView,self.priceLab,self.proportionLab,self.makeLab,self.promoteBtn,self.availableLab,lab]];
        
        
        
        self.imgView.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthIs(100);
        
        
        self.priceLab.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,20)
        .autoHeightRatio(0)
        .widthIs(100);
        
        lab.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.priceLab,0)
        .autoHeightRatio(0)
        .widthIs(100);

        self.proportionLab.sd_layout
        .leftSpaceToView(self.imgView,10)
        .topSpaceToView(self.contentView,20)
        .widthIs((WINDOWRECT_WIDTH-20)/2)
        .heightIs(20);

//        self.qhLab.sd_layout
//        .leftSpaceToView(self.imgView,10)
//        .topSpaceToView(self.proportionLab,0)
//        .rightSpaceToView(self.contentView,70)
//        .heightIs(20);

        self.availableLab.sd_layout
        .leftSpaceToView(self.imgView,10)
        .topSpaceToView(self.proportionLab,5)
        .rightSpaceToView(self.contentView,70)
        .heightIs(20);
//
        self.makeLab.sd_layout
        .topSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,10)
        .heightIs(20)
        .widthIs(60);
//
        self.promoteBtn.sd_layout
        .topSpaceToView(self.makeLab,5)
        .rightSpaceToView(self.contentView,10)
        .heightIs(20)
        .widthIs(60);

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
