//
//  ResultsCell.m
//  TKJD
//
//  Created by apple on 2017/3/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ResultsCell.h"

@implementation ResultsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        
//        self.backgroundColor=[UIColor orangeColor];
        
        self.imgView=[[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
        
        self.titleLab=[[UILabel alloc]init];
        self.titleLab.font=[UIFont systemFontOfSize:14];
        self.titleLab.numberOfLines=0;
        self.titleLab.textColor=UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.titleLab];
        
        
        self.priceLab=[[UILabel alloc]init];
        self.priceLab.font=[UIFont systemFontOfSize:12];
        self.priceLab.textColor=UIColorFromRGB(0x666666);
        [self.contentView addSubview:self.priceLab];
    
        self.rateLab=[[UILabel alloc]init];
        self.rateLab.font=[UIFont systemFontOfSize:12];
        self.rateLab.textColor=UIColorFromRGB(0x666666);
        [self.contentView addSubview:self.rateLab];
        
        self.jhLab=[[UILabel alloc]init];
        self.jhLab.font=[UIFont systemFontOfSize:12];
        self.jhLab.textColor=UIColorFromRGB(0x666666);
        [self.contentView addSubview:self.jhLab];
        
        self.subtitleLab=[[UILabel alloc]init];
        self.subtitleLab.font=[UIFont systemFontOfSize:12];
        self.subtitleLab.textColor=UIColorFromRGB(0x666666);
        [self.contentView addSubview:self.subtitleLab];
        
        
        self.button =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:@"立即推广" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.titleLabel.font=[UIFont systemFontOfSize:14];
        self.button.backgroundColor=UIColorFromRGB(0xF83A5E);
        self.button.layer.masksToBounds=YES;
        self.button.layer.cornerRadius=5;
        [self.contentView addSubview:self.button];
        
        
        
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
        .heightIs(1);

        line3.sd_layout
        .rightSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0)
        .heightIs(0.5);

        
        self.imgView.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthIs(100);
        
        self.titleLab.sd_layout
        .topEqualToView(self.imgView)
        .leftSpaceToView(self.imgView,10)
        .rightSpaceToView(self.contentView,10)
        .heightIs(40);
        
        self.priceLab.sd_layout
        .topSpaceToView(self.titleLab,0)
        .leftEqualToView(self.titleLab)
        .rightEqualToView(self.titleLab)
        .heightIs(20);
        
        self.rateLab.sd_layout
        .topSpaceToView(self.priceLab,0)
        .leftEqualToView(self.titleLab)
        .rightEqualToView(self.titleLab)
        .heightIs(20);
        
        
        self.jhLab.sd_layout
        .topSpaceToView(self.titleLab,10)
        .rightEqualToView(self.titleLab)
        .widthIs(30)
        .heightIs(20);
        
        self.subtitleLab.sd_layout
        .topSpaceToView(self.rateLab, 0)
        .leftEqualToView(self.titleLab)
        .rightEqualToView(self.titleLab)
        .heightIs(20);
        
        
//        self.salesLab.sd_layout
//        .topSpaceToView(self.priceLab,0)
//        .leftEqualToView(self.titleLab)
//        .rightEqualToView(self.titleLab)
//        .heightIs(20);
//    
        
        self.button.sd_layout
        .topSpaceToView(self.jhLab,10)
        .rightSpaceToView(self.contentView,10)
        .widthIs(70)
        .heightIs(20);
        
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
