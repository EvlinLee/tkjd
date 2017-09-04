//
//  ClassView.h
//  TKJD
//
//  Created by apple on 2017/1/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassViewDelegate <NSObject>

-(void)clickWithRow:(NSInteger)row button:(UIButton *)btn;

@end
@interface ClassView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * titleAry;
@property (nonatomic, assign) BOOL  isData;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, weak)id<ClassViewDelegate>delegate;
@end
