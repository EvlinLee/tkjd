//
//  GroupCell.m
//  TKJD
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

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
        
        
        
        
        self.imgView.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10)
        .heightIs(20)
        .widthIs(20);
        
        self.titleLab.sd_layout
        .topEqualToView(self.contentView)
        .leftSpaceToView(self.imgView,10)
        .rightSpaceToView(self.contentView,10)
        .heightIs(40);
        
             
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
