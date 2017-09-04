//
//  ShareView.m
//  TKJD
//
//  Created by apple on 2017/3/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView




-(instancetype)init{
    self = [super init];
    if (self) {
        
//        _imgAry=[[NSMutableArray alloc]initWithObjects:@"QQ",@"wx", nil];
//         _titleAry=[[NSMutableArray alloc]initWithObjects:@"QQ",@"微信好友", nil];
        
//        self.backgroundColor=[UIColor blackColor];
//        self.alpha=0.1;
        
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT)];
        view.backgroundColor=[UIColor blackColor];
        view.alpha=0.4;
        [self addSubview:view];
        
        
        UIView * btView =[[UIView alloc]init];
        btView.backgroundColor=UIColorFromRGB(0xF2F3F4);
        [self addSubview:btView];
        
        NSMutableArray * temp1 =[NSMutableArray new];
        for (int i=0; i<self.imgAry.count; i++) {
            
            UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:self.imgAry[i]] forState:UIControlStateNormal];
            [btn setTitle:self.titleAry[i] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:UIColorFromRGB(0x5c5c5c) forState:UIControlStateNormal];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i+10;
            [btView addSubview:btn];
            
            btn.sd_layout.autoHeightRatio(1.5);
            
            btn.imageView.sd_layout.widthRatioToView(btn,1.0).topSpaceToView(btn,0).centerXEqualToView(btn).heightRatioToView(btn,0.5);
            btn.titleLabel.sd_layout.topSpaceToView(btn.imageView,0).leftEqualToView(btn.imageView).rightEqualToView(btn.imageView).bottomSpaceToView(btn,5);
            
            
            [temp1 addObject:btn];

        }
        btView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,0);
        
        [btView setupAutoWidthFlowItems:[temp1 copy] withPerRowItemsCount:5 verticalMargin:5 horizontalMargin:5 verticalEdgeInset:10 horizontalEdgeInset:10];
        
        
    }
    return self;
}
-(void)btnClick:(UIButton *)btn{
    
    if ([_delegate respondsToSelector:@selector(shareViewBtn:)]) {

    
        [_delegate shareViewBtn:btn];
        
    }
    
    
}
-(NSMutableArray *)imgAry{
    
    if (!_imgAry) {
        
        _imgAry=[[NSMutableArray alloc]initWithObjects:@"QQ",@"wx", nil];
        
    }
    
    return _imgAry;
    
}
-(NSMutableArray *)titleAry{
    
    if (!_titleAry) {
        
        _titleAry=[[NSMutableArray alloc]initWithObjects:@"QQ",@"微信好友", nil];
        
    }
    
    return _titleAry;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
