//
//  YBLabel.m
//  TKJD
//
//  Created by apple on 2017/3/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YBLabel.h"

@implementation YBLabel

-(void)drawTextInRect:(CGRect)rect{
    
    CGRect frame = CGRectMake(rect.origin.x + 2, rect.origin.y + 2, rect.size.width-4, rect.size.height-2);
    [super drawTextInRect:frame];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
