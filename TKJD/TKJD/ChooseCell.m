//
//  ChooseCell.m
//  TKJD
//
//  Created by apple on 2017/2/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell{
    UIView * hLine1;
    UIView * hLine2;
    UIView * hLine3;
 UIView * hLine4;

    
    UIView * sLine1;
    UIView * sLine2;
    UIView * sLine3;


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
        
//        self.rateLab=[[UILabel alloc]init];
//        //        self.proportionLab.text=@"比例:30.00%";
//        self.rateLab.adjustsFontSizeToFitWidth=YES;
//        self.rateLab.font=[UIFont systemFontOfSize:12];
//        self.rateLab.textColor=UIColorFromRGB(0xF83A5E);
//        [self.contentView addSubview:self.rateLab];


        
        self.seleBut =[UIButton buttonWithType:UIButtonTypeCustom];
        self.seleBut.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.seleBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.seleBut setTitle:@"立即分享" forState:UIControlStateNormal];
//        self.seleBut.backgroundColor=UIColorFromRGB(0xF83A5E);
        self.seleBut.layer.masksToBounds=YES;
        self.seleBut.layer.cornerRadius=5;
        
        
        self.buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.buyBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.buyBtn.layer.masksToBounds=YES;
        self.buyBtn.layer.cornerRadius=5;
        self.buyBtn.backgroundColor=UIColorFromRGB(0x579AFC);
        [self.buyBtn setTitle:@"领券购买" forState:UIControlStateNormal];
        
        
        self.xImgView=[[UIImageView alloc]init];
        self.xImgView.image=[UIImage imageNamed:@"x"];
        
        
//        self.tmallImg=[[UIImageView alloc]init];
        
        
        self.qLab=[[UILabel alloc]init];

        
        self.byLab =[[UILabel alloc]init];
        self.byLab.layer.borderWidth=1;
        self.byLab.layer.borderColor=UIColorFromRGB(0xF83A5E).CGColor;
        self.byLab.textColor=UIColorFromRGB(0xF83A5E);
        self.byLab.textAlignment=NSTextAlignmentCenter;
        self.byLab.font=[UIFont systemFontOfSize:10];
        self.byLab.text=@"包邮";
        
        
        
        
        hLine4=[self lineView];

        
        [self.contentView sd_addSubviews:@[self.imgView,self.title,self.priceLab,self.salesLab,self.qhLab,self.yjLab,self.seleBut,hLine4,self.xImgView,self.qLab,self.byLab,self.buyBtn]];
        
        self.imgView.sd_layout
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,2)
        .bottomSpaceToView(self.contentView,0)
        .widthIs(100);
        
        
        self.yjLab.sd_layout
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,5)
        .heightIs(15)
        .widthIs(60);
        
        
//        self.rateLab.sd_layout
//        .topSpaceToView(self.yjLab,0)
//        .rightSpaceToView(self.contentView,5)
//        .heightIs(15)
//        .widthIs(60);
        
        self.seleBut.sd_layout
        .topSpaceToView(self.yjLab,10)
        .rightSpaceToView(self.contentView,6)
        .heightIs(20)
        .widthIs(60);
        
        self.buyBtn.sd_layout
        .topSpaceToView(self.seleBut,10)
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
        
//        self.tmallImg.sd_layout
//        .topSpaceToView(self.qhLab,0)
//        .leftEqualToView(self.title)
//        .heightIs(10)
//        .widthIs(10);
        

        self.byLab.sd_layout
        .topSpaceToView(self.qhLab,0)
        .leftSpaceToView(self.imgView,5)
        .heightIs(12)
        .widthIs(25);
        
        
        hLine4.sd_layout
        .bottomSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .heightIs(1);
   
        
    }
    return self;
}

-(void)labelWithText:(NSString *)text{
    
    
    self.qLab.text=[NSString stringWithFormat:@"%d元券",[text intValue]];
    self.qLab.font=[UIFont systemFontOfSize:10];
    self.qLab.layer.borderColor=UIColorFromRGB(0xF83A5E).CGColor;
    self.qLab.layer.borderWidth=1;
    self.qLab.textColor=UIColorFromRGB(0xF83A5E);
    self.qLab.textAlignment=NSTextAlignmentCenter;
    
    CGSize qhSize =[self.qLab.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:10] }];
    
    self.qLab.sd_layout
    .topSpaceToView(self.qhLab,0)
    .leftSpaceToView(self.byLab,2)
    .heightIs(12)
    .widthIs(qhSize.width+4);
    
    
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
