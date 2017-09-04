//
//  ShopCell.m
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopCell.h"

@implementation ShopCell{
    
     UIView * hLine;
    
 }

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView=[UIImageView new];
        
        
        self.title=[UILabel new];
        self.title.font=[UIFont systemFontOfSize:12];
        self.title.textColor=UIColorFromRGB(0x666666);
        self.title.numberOfLines=0;
        
        
        self.priceLab=[[UILabel alloc]init];
        //        self.priceLab.text=@"在售价:452元";
        //        self.priceLab.backgroundColor=[UIColor orangeColor];
        self.priceLab.textColor=UIColorFromRGB(0x666666);
        self.priceLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.priceLab];
        
        self.salesLab=[[UILabel alloc]init];
        //         self.salesLab.text=@"月销2991件";
        self.salesLab.textColor=UIColorFromRGB(0x666666);
        self.salesLab.textAlignment=NSTextAlignmentRight;
        self.salesLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.salesLab];
        
        self.qhLab=[[UILabel alloc]init];
        //         self.qhPriceLab.text=@"券后价:25元";
        self.qhLab.font=[UIFont systemFontOfSize:12];
        self.qhLab.textColor=UIColorFromRGB(0xF83A5E);
        [self.contentView addSubview:self.qhLab];
        
        self.yjLab=[[UILabel alloc]init];
        //        self.commissionLab.text=@"佣金:7.50";
        self.yjLab.adjustsFontSizeToFitWidth=YES;
        self.yjLab.font=[UIFont systemFontOfSize:12];
        self.yjLab.textColor=UIColorFromRGB(0xF83A5E);
        [self.contentView addSubview:self.yjLab];
        
        self.rateLab=[[UILabel alloc]init];
        //        self.proportionLab.text=@"比例:30.00%";
        self.rateLab.adjustsFontSizeToFitWidth=YES;
        self.rateLab.font=[UIFont systemFontOfSize:12];
        self.rateLab.textColor=UIColorFromRGB(0xF83A5E);
        [self.contentView addSubview:self.rateLab];
        
        
        
        self.seleBut =[UIButton buttonWithType:UIButtonTypeCustom];
        self.seleBut.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.seleBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [self.seleBut setTitle:@"立即分享" forState:UIControlStateNormal];
        //        self.seleBut.backgroundColor=UIColorFromRGB(0xF83A5E);
        
        self.seleBut.layer.masksToBounds=YES;
        self.seleBut.layer.cornerRadius=8;
        
        
        self.xImgView=[[UIImageView alloc]init];
        self.xImgView.image=[UIImage imageNamed:@"x"];
        
        

        
        hLine=[self lineView];
        
        
        [self.contentView sd_addSubviews:@[self.imgView,self.title,self.priceLab,self.salesLab,self.qhLab,self.yjLab,self.rateLab,self.seleBut,hLine,self.xImgView]];
        
        self.imgView.sd_layout
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,2)
        .bottomSpaceToView(self.contentView,0)
        .widthIs(100);
        
        
        self.yjLab.sd_layout
        .topSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,5)
        .heightIs(15)
        .widthIs(60);
        
        
        self.rateLab.sd_layout
        .topSpaceToView(self.yjLab,0)
        .rightSpaceToView(self.contentView,5)
        .heightIs(15)
        .widthIs(60);
        
        self.seleBut.sd_layout
        .topSpaceToView(self.rateLab,5)
        .rightSpaceToView(self.contentView,6)
        .heightIs(20)
        .widthIs(60);
        
        self.xImgView.sd_layout
        .topSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0)
        .widthIs(2)
        .rightSpaceToView(self.yjLab,10);
        
        self.title.sd_layout
        .topSpaceToView(self.contentView,5)
        .leftSpaceToView(self.imgView,5)
        .rightSpaceToView(self.xImgView,10)
        .heightIs(30);
        
        
        self.salesLab.sd_layout
        .rightEqualToView(self.title)
        .topSpaceToView(self.title,0)
        .widthIs(70)
        .heightIs(15);
        
        self.priceLab.sd_layout
        .topSpaceToView(self.title,0)
        .leftEqualToView(self.title)
        .heightIs(15)
        .rightSpaceToView(self.salesLab,0);
        
        
        self.qhLab.sd_layout
        .topSpaceToView(self.priceLab,0)
        .leftEqualToView(self.title)
        .rightSpaceToView(self.xImgView,0)
        .heightIs(20);
        

        

        
        
        hLine.sd_layout
        .bottomSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .heightIs(1);
        
        
    }

    return self;
}

- (UILabel *)labWithbgColor:(UIColor *)bgColor font:(CGFloat)font
{
    UILabel * lab =[UILabel new];
    lab.font=[UIFont systemFontOfSize:font];
    lab.textColor=bgColor;
    lab.textAlignment=NSTextAlignmentCenter;
    
    return lab;
}
-(UIView *)lineView{
    
    UIView * view =[UIView new];
    view.backgroundColor=UIColorFromRGB(0xdcdcdc);
    
    return view;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
