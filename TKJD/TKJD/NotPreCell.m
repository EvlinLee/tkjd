//
//  NotPreCell.m
//  TKJD
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NotPreCell.h"

@implementation NotPreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UIView *)lineView{
    UIView * line =[[UIView alloc]init];
    line.backgroundColor=UIColorFromRGB(0xdcdcdc);
    
    return line;
    
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIView * line1 =[self lineView];
        UIView * line2 =[self lineView];
        UIView * line3 =[self lineView];
        
        [self.contentView addSubviews:@[line1,line2,line3]];
        
        line1.sd_layout
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .widthIs(1)
        .leftSpaceToView(self.contentView, 1);
        
        line2.sd_layout
        .topSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .widthIs(1);
        
        line3.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1)
        .bottomSpaceToView(self.contentView, 0);
        
        
 
        
        
        self.image =[[UIImageView alloc]init];
        [self.contentView addSubview:self.image];
        
        
        self.titleLab=[[UILabel alloc]init];
        self.titleLab.font=[UIFont systemFontOfSize:12];
        self.titleLab.textColor=UIColorFromRGB(0x555555);
        self.titleLab.numberOfLines=0;
        [self.contentView addSubview:self.titleLab];
        
        self.priceLab=[[UILabel alloc]init];
        self.priceLab.adjustsFontSizeToFitWidth=YES;
        self.priceLab.textAlignment=NSTextAlignmentLeft;
        self.priceLab.textColor=UIColorFromRGB(0xff4e36);
        self.priceLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.priceLab];
        
        
        
        self.qhPriceLab=[[UILabel alloc]init];
        self.qhPriceLab.adjustsFontSizeToFitWidth=YES;
        self.qhPriceLab.font=[UIFont systemFontOfSize:14];
        self.qhPriceLab.textColor=UIColorFromRGB(0xff4e36);
        self.qhPriceLab.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.qhPriceLab];
        
        
        self.qPriceLab=[[UILabel alloc]init];
        self.qPriceLab.adjustsFontSizeToFitWidth=YES;
        self.qPriceLab.textColor=UIColorFromRGB(0x555555);
        self.qPriceLab.font=[UIFont systemFontOfSize:12];
        self.qPriceLab.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.qPriceLab];

        self.salesLab=[[UILabel alloc]init];
        self.salesLab.adjustsFontSizeToFitWidth=YES;
        self.salesLab.textColor=UIColorFromRGB(0x555555);
        self.salesLab.font=[UIFont systemFontOfSize:12];
        self.salesLab.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.salesLab];

        
        self.commissionLab=[[UILabel alloc]init];
        self.commissionLab.adjustsFontSizeToFitWidth=YES;
        self.commissionLab.font=[UIFont systemFontOfSize:12];
        self.commissionLab.textAlignment=NSTextAlignmentLeft;
        self.commissionLab.textColor=UIColorFromRGB(0xff4e36);
        [self.contentView addSubview:self.commissionLab];
        
        
        self.proportionLab=[[UILabel alloc]init];
        self.proportionLab.adjustsFontSizeToFitWidth=YES;
        self.proportionLab.font=[UIFont systemFontOfSize:12];
        self.proportionLab.textAlignment=NSTextAlignmentLeft;
        self.proportionLab.textColor=UIColorFromRGB(0xff4e36);
        [self.contentView addSubview:self.proportionLab];
        
        
        
        self.shareBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBut setTitle:@"立即推广" forState:UIControlStateNormal];
        [self.shareBut setTitleColor:UIColorFromRGB(0xff4e36) forState:UIControlStateNormal];
        self.shareBut.titleLabel.font=[UIFont systemFontOfSize:14];
        self.shareBut.layer.borderColor=UIColorFromRGB(0xff4e36).CGColor;
        self.shareBut.layer.borderWidth=1;
        [self.contentView addSubview:self.shareBut];
        
        
        if (IPHONE4||IPHONE5) {
            
            self.image.sd_layout
            .topSpaceToView(self.contentView,10)
            .leftSpaceToView(self.contentView,2)
            .bottomSpaceToView(self.contentView,10)
            .widthIs(110);
            
            self.titleLab.sd_layout
            .topSpaceToView(self.contentView,10)
            .leftSpaceToView(self.image,5)
            .rightSpaceToView(self.contentView,10)
            .heightIs(30);
            
            
            self.commissionLab.sd_layout
            .topSpaceToView(self.titleLab,20)
            .leftEqualToView(self.titleLab)
            .heightIs(20)
            .widthIs(60);
            
            
            self.proportionLab.sd_layout
            .topSpaceToView(self.titleLab, 20)
            .leftSpaceToView(self.commissionLab, 2)
            .heightIs(20)
            .widthIs(60);
            
            self.salesLab.sd_layout
            .topSpaceToView(self.titleLab,0)
            .rightSpaceToView(self.contentView, 10)
            .heightIs(20)
            .widthIs(75);

            
        }else{
            
            self.image.sd_layout
            .topSpaceToView(self.contentView,10)
            .leftSpaceToView(self.contentView,2)
            .bottomSpaceToView(self.contentView,10)
            .widthIs(130);
            
            self.titleLab.sd_layout
            .topSpaceToView(self.contentView,10)
            .leftSpaceToView(self.image,5)
            .rightSpaceToView(self.contentView,10)
            .heightIs(40);
            
            
            self.commissionLab.sd_layout
            .topSpaceToView(self.titleLab,28)
            .leftEqualToView(self.titleLab)
            .heightIs(20)
            .widthIs(60);
            
            
            self.proportionLab.sd_layout
            .topSpaceToView(self.titleLab, 28)
            .leftSpaceToView(self.commissionLab, 2)
            .heightIs(20)
            .widthIs(60);
            
            self.salesLab.sd_layout
            .topSpaceToView(self.titleLab,4)
            .rightSpaceToView(self.contentView, 10)
            .heightIs(20)
            .widthIs(75);

            
        }
      
        
    }
    
    return self;
}
-(void)setModel:(ShopModel *)model{
    
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    self.titleLab.text=model.title;
    
    self.commissionLab.text=[NSString stringWithFormat:@"佣金 %.2f",[model.yj floatValue]];
    
    self.proportionLab.text=[NSString stringWithFormat:@"比例 %.1f%%",[model.rate floatValue]];
    
    
    self.salesLab.text=[NSString stringWithFormat:@"销量 %@",model.sales];

 
        
    self.qPriceLab.text=@"暂无优惠券";
        
        
    NSString * price =[NSString stringWithFormat:@"价格:￥%.2f",[model.shoujia floatValue]];
        
    NSUInteger length =[price length];
        
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:price];
    [AttributedStr addAttribute:NSFontAttributeName
         
                            value:[UIFont systemFontOfSize:14]
         
                            range:NSMakeRange(3, length-3)];
    
    self.priceLab.attributedText=AttributedStr;
        
    
    if (IPHONE4||IPHONE5) {
        self.priceLab.sd_layout
        .topSpaceToView(self.titleLab, 0)
        .leftSpaceToView(self.image, 5)
        .rightSpaceToView(self.salesLab, 20)
        .heightIs(20);
        
        
        
        self.shareBut.sd_layout
        .bottomSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.image, 5)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(30);
        
        
        self.qPriceLab.sd_layout
        .topSpaceToView(self.titleLab,20)
        .rightEqualToView(self.titleLab)
        .heightIs(20)
        .widthIs(48);

    }else{
       
        self.priceLab.sd_layout
        .topSpaceToView(self.titleLab, 4)
        .leftSpaceToView(self.image, 5)
        .rightSpaceToView(self.salesLab, 20)
        .heightIs(20);
        
        
        
        self.shareBut.sd_layout
        .bottomSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.image, 5)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(30);
        
        
        self.qPriceLab.sd_layout
        .topSpaceToView(self.titleLab,28)
        .rightEqualToView(self.titleLab)
        .heightIs(22)
        .widthIs(70);

    }
   
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
