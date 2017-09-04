//
//  ClassView.m
//  TKJD
//
//  Created by apple on 2017/1/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ClassView.h"

@implementation ClassView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self loadClassView];
    }
    return self;
}

-(void)loadClassView{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    UITableView * tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self addSubview:tableView];
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }

    cell.textLabel.text=self.titleAry[indexPath.row];
    
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickWithRow:button:)])
    {
        [self.delegate clickWithRow:indexPath.row button:self.btn];
    }

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
