//
//  SingleCell.m
//  TKJD
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SingleCell.h"

@implementation SingleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        
        self.titleLab=[[UILabel alloc]init];
        //         self.priceLab.text=@"¥20";
        self.titleLab.textColor=UIColorFromRGB(0x666666);
        self.titleLab.numberOfLines=0;
        self.titleLab.font=[UIFont systemFontOfSize:14];
        self.titleLab.textAlignment=NSTextAlignmentCenter;
        self.titleLab.text=@"没内部券，硬买吧亲。";

        
        self.rateLab=[UILabel new];
        //        self.makeLab.text=@"赚:¥15.5";
        self.rateLab.font=[UIFont systemFontOfSize:14];
        self.rateLab.textColor=UIColorFromRGB(0xF83A5E);
        self.rateLab.textAlignment=NSTextAlignmentCenter;
        
        
//        self.textLab=[[UILabel alloc]init];
//        self.textLab.textColor=UIColorFromRGB(0x666666);
//        self.textLab.numberOfLines=0;
//        self.textLab.font=[UIFont systemFontOfSize:14];
//        self.textLab.layer.borderWidth=1;
//        self.textLab.layer.borderColor=UIColorFromRGB(0xF83A5E).CGColor;
//        self.textLab.backgroundColor=UIColorFromRGB(0xFDE8EC);


        self.textView =[[UITextView alloc]init];
        self.textView.textColor=UIColorFromRGB(0x666666);
        self.textView.editable=YES;
        self.textView.font=[UIFont systemFontOfSize:14];
        self.textView.backgroundColor=UIColorFromRGB(0xFDE8EC);
        self.textView.layer.borderWidth=1;
        self.textView.layer.borderColor=[UIColorFromRGB(0xdcdcdc)CGColor];

        
        
        self.promoteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.promoteBtn.layer.masksToBounds=YES;
        self.promoteBtn.layer.cornerRadius=10;
        [self.promoteBtn setTitle:@"单品分享" forState:UIControlStateNormal];
        [self.promoteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.promoteBtn setBackgroundColor:UIColorFromRGB(0xF83A5E)];
        self.promoteBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        
        
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
        
        
        [self.contentView addSubviews:@[self.titleLab,self.promoteBtn,self.textView,self.rateLab]];
        
        
        
        self.titleLab.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        
        self.rateLab.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.titleLab,5)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        
        self.textView.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.rateLab,5)
        .rightSpaceToView(self.contentView,10)
        .heightIs(80);
        
        self.promoteBtn.sd_layout
        .topSpaceToView(self.textView,5)
        .centerXEqualToView(self.titleLab)
        .widthIs(80)
        .heightIs(25);
        

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
