//
//  itemCell.m
//  TKJD
//
//  Created by apple on 2017/3/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "itemCell.h"

@implementation itemCell{
    
    CGFloat pricewidth;
    
    CGFloat width;
    CGFloat font;
    CGFloat font1;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        
        if (IPHONE4||IPHONE5) {

            width=90;

        }else if (iPhone6Plus_6sPlus){
             width=100;
        
        }else if (iPhone6_6s){
  
            width=100;
            
        }else {
             width=90;
            
        }
        pricewidth=80;
        font=12;
        font1=11;
        
        UIView * line =[[UIView alloc]init];
        line.backgroundColor=UIColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:line];
        
        self.image =[[UIImageView alloc]init];
        [self.contentView addSubview:self.image];
        
        
        self.titleLab=[[UILabel alloc]init];
        self.titleLab.font=[UIFont systemFontOfSize:font];
        self.titleLab.textColor=UIColorFromRGB(0x444444);
        self.titleLab.numberOfLines=0;
        [self.contentView addSubview:self.titleLab];
        
        self.priceLab=[[UILabel alloc]init];
        self.priceLab.adjustsFontSizeToFitWidth=YES;
        self.priceLab.textAlignment=NSTextAlignmentRight;
        self.priceLab.textColor=UIColorFromRGB(0x666666);
        self.priceLab.font=[UIFont systemFontOfSize:font];
        [self.contentView addSubview:self.priceLab];
        
        self.salesLab=[[UILabel alloc]init];
        self.salesLab.textColor=UIColorFromRGB(0x666666);
        self.salesLab.adjustsFontSizeToFitWidth=YES;
        self.salesLab.textAlignment=NSTextAlignmentLeft;
        self.salesLab.font=[UIFont systemFontOfSize:font1];
        [self.contentView addSubview:self.salesLab];
        
       
        self.qhPriceLab=[[UILabel alloc]init];
        self.qhPriceLab.adjustsFontSizeToFitWidth=YES;
        self.qhPriceLab.font=[UIFont systemFontOfSize:font];
        self.qhPriceLab.textColor=UIColorFromRGB(0xff1750);
        [self.contentView addSubview:self.qhPriceLab];
        
        
        self.qPriceLab=[[UILabel alloc]init];
        self.qPriceLab.adjustsFontSizeToFitWidth=YES;
        self.qPriceLab.textColor=UIColorFromRGB(0x666666);
        self.qPriceLab.font=[UIFont systemFontOfSize:font1];
        [self.contentView addSubview:self.qPriceLab];
        
        
        self.numLab =[[UILabel alloc]init];
        self.numLab.textColor=UIColorFromRGB(0x666666);
        self.numLab.textAlignment=NSTextAlignmentRight;
        self.numLab.font=[UIFont systemFontOfSize:font1];
        self.numLab.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:self.numLab];
        

        self.progressView.backgroundColor=[UIColor blackColor];
        [self.contentView addSubview:self.progressView];
    
        
        
        self.commissionLab=[[UILabel alloc]init];
        self.commissionLab.adjustsFontSizeToFitWidth=YES;
        self.commissionLab.font=[UIFont systemFontOfSize:font];
        self.commissionLab.textAlignment=NSTextAlignmentCenter;
        self.commissionLab.textColor=UIColorFromRGB(0xff1750);
        [self.contentView addSubview:self.commissionLab];
        
        self.proportionLab=[[UILabel alloc]init];
//        self.proportionLab.text=@"比例:30.00%";
        self.proportionLab.adjustsFontSizeToFitWidth=YES; 
        self.proportionLab.font=[UIFont systemFontOfSize:font1];
        self.proportionLab.textColor=UIColorFromRGB(0xff1750);
        [self.contentView addSubview:self.proportionLab];
        
        
        self.shareBut=[UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBut.backgroundColor=UIColorFromRGB(0xff1750);
        [self.shareBut setTitle:@"收藏商品" forState:UIControlStateNormal];
        self.shareBut.layer.cornerRadius=5;
        self.shareBut.layer.masksToBounds=YES;
//        [self.shareBut setImage:[UIImage imageNamed:@"fx"] forState:UIControlStateNormal];
        self.shareBut.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.shareBut];
        
        
        
        self.buyBut=[UIButton buttonWithType:UIButtonTypeCustom];
        self.buyBut.backgroundColor=UIColorFromRGB(0x579AFC);
        [self.buyBut setTitle:@"商品详情" forState:UIControlStateNormal];
        self.buyBut.layer.cornerRadius=5;
        self.buyBut.layer.masksToBounds=YES;
        self.buyBut.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.buyBut];
        
        
        self.xImgView=[[UIImageView alloc]init];
        self.xImgView.image=[UIImage imageNamed:@"x"];
        [self.contentView addSubview:self.xImgView];
        
        
        self.image.sd_layout
        .topSpaceToView(self.contentView,2)
        .leftSpaceToView(self.contentView,2)
        .bottomSpaceToView(self.contentView,2)
        .widthIs(width);
        
        
        self.commissionLab.sd_layout
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .heightIs(15)
        .widthIs(60);
        
        
        
        self.shareBut.sd_layout
        .topSpaceToView(self.commissionLab,8)
        .rightSpaceToView(self.contentView,10)
        .heightIs(20)
        .widthIs(60);
        
        
        self.buyBut.sd_layout
        .topSpaceToView(self.shareBut,8)
        .rightSpaceToView(self.contentView,10)
        .heightIs(20)
        .widthIs(60);
        
        
        
        
        self.titleLab.sd_layout
        .topSpaceToView(self.contentView,5)
        .leftSpaceToView(self.image,5)
        .rightSpaceToView(self.shareBut,10)
        .heightIs(30);
        
        
        self.priceLab.sd_layout
        .rightEqualToView(self.titleLab)
        .topSpaceToView(self.titleLab,2)
        .widthIs(70)
        .heightIs(15);
        
        self.qhPriceLab.sd_layout
        .topSpaceToView(self.titleLab,2)
        .leftEqualToView(self.titleLab)
        .heightIs(15)
        .rightSpaceToView(self.priceLab,0);
        

        
        self.xImgView.sd_layout
        .topSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0)
        .widthIs(2)
        .rightSpaceToView(self.shareBut,5);
        
        
        line.sd_layout
        .bottomSpaceToView(self.contentView, 1)
        .leftSpaceToView(self.image, 5)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1);

        
    }
    
    return self;
}
-(void)setModel:(ShopModel *)model{
    
    self.qPriceLab.text=[NSString stringWithFormat:@"优惠券￥%d元",[model.yhPrice intValue]];
    
    self.salesLab.text=[NSString stringWithFormat:@"月销%@件",model.sales];
    
    CGSize size =[self.salesLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font1]}];
    
    
    if ([model.me isEqualToString:@""]) {
        NSString * numStr = [NSString stringWithFormat:@"发行量:%d张",[model.yhqsy intValue]+[model.yhql intValue]];
        
        NSUInteger numlength =[numStr length];
        NSMutableAttributedString * numAttributedStr = [[NSMutableAttributedString alloc]initWithString:numStr];
        [numAttributedStr addAttribute:NSForegroundColorAttributeName
         
                                 value:[UIColor redColor]
         
                                 range:NSMakeRange(4, numlength-5)];
        
        self.numLab.attributedText=numAttributedStr;
        
        
    }else{
        
        NSString * numStr = [NSString stringWithFormat:@"余%@张",model.yhqsy];
        
        NSUInteger numlength =[numStr length];
        NSMutableAttributedString * numAttributedStr = [[NSMutableAttributedString alloc]initWithString:numStr];
        [numAttributedStr addAttribute:NSForegroundColorAttributeName
         
                                 value:[UIColor redColor]
         
                                 range:NSMakeRange(1, numlength-2)];
        
        self.numLab.attributedText=numAttributedStr;
        
    }
    
    
    
    
    self.qPriceLab.sd_layout
    .topSpaceToView(self.qhPriceLab,2)
    .leftEqualToView(self.titleLab)
    .heightIs(15)
    .widthIs(150);
    
    
    self.salesLab.sd_layout
    .topSpaceToView(self.qPriceLab,2)
    .leftEqualToView(self.titleLab)
    .heightIs(15)
    .widthIs(size.width+2);
    
    self.numLab.sd_layout
    .topSpaceToView(self.qPriceLab,2)
    .rightEqualToView(self.titleLab)
    .leftSpaceToView(self.salesLab, 6)
    .heightIs(15);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
