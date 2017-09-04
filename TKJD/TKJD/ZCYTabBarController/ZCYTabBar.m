//
//  ZCYTabBar.m
//  ZCYTabBar
//
//  Created by 张春雨 on 16/8/6.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "ZCYTabBar.h"
#import "OtherButton.h"
#define TabBarTag 199202
#define ZCYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ZCYTabBar()
@end

@implementation ZCYTabBar
-(instancetype)init{
    self = [super init];
    if (self) {

        _isCenter=NO;
    }
    return self;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    for (UITabBarItem * item in items) {
        
        OtherButton *btn = [OtherButton buttonWithType:UIButtonTypeCustom];
        //设置tag值
        btn.tag = self.subviews.count + TabBarTag;
        if (btn.tag==199204) {
            btn.bigTag=199204;
            self.bigButton=btn;
//            btn.backgroundColor=[UIColor orangeColor];
            
        }

        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;
        //设置文字
//          btn.titleLabel.font=[UIFont systemFontOfSize:11];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitleColor:ZCYColor(113, 109, 104) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xff307e) forState:UIControlStateSelected];
        
        
        
        
        btn.item = item;
        // 添加观察者
//        [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(btn)];

        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
//        [self.OtherButtons addObject:btn];
    }
    
}


#pragma mark - 外部设置索引，跳转页面
- (void)setSeletedIndex:(NSInteger)seletedIndex{
    _seletedIndex = seletedIndex;
    int n = [[self viewWithTag:TabBarTag + seletedIndex] isEqual:self.bigButton]?1:0;
    UIButton *button = [self viewWithTag:(TabBarTag + seletedIndex + n)];
    [self btnClick:button];
}


#pragma mark - 隐藏tabbar 执行弹出动画
-(void)setHidden:(BOOL)hidden{
//    if (hidden) {
//        __weak typeof (self)weakself = self;
//        [UIView animateWithDuration:0.2 animations:^{
//            weakself.layer.affineTransform = CGAffineTransformMakeTranslation(0, 100);
//        }completion:^(BOOL finished) {
//            [super setHidden:hidden];
//        }];
//    }
//    else{
    
    _isCenter=hidden;
        [super setHidden:hidden];
//        __weak typeof (self)weakself = self;
//        [UIView animateWithDuration:0.2 animations:^{
//            weakself.layer.affineTransform = CGAffineTransformIdentity;
//        }];
//    }
}


//#pragma mark - 控制器器按钮点击
- (void)btnClick:(UIButton *)button{
    
    LRLog(@"%d",button.tag);
    if (_isCenter==NO) {
        if (button.tag < TabBarTag)
            return;
        
        _selButton.selected = NO;
        button.selected = YES;
        _selButton = button;
        
        // 通知tabBarVc切换控制器
        if ([_delegate respondsToSelector:@selector(tabBar:didClickBtn:)]) {
            //        int n = button.tag > _bigButton.tag ? -1 : 0;
            //        _seletedIndex = button.tag - TabBarTag + n;
            [_delegate tabBar:self didClickBtn:button.tag - TabBarTag];
        }

    }
 
}

#pragma mark - 绘制按钮
- (void)layoutSubviews{
    [super layoutSubviews];

    int count = (int)self.subviews.count;
    CGFloat width = self.frame.size.width/count;
    CGFloat height = self.frame.size.height;
    if (width!=0 && height!=0) {
        
        int i = 0;
        for (UIButton * loop in self.subviews) {
   
            
            loop.frame = CGRectMake(i++ * width, 0, width, self.frame.size.height);
    
        }
    }
}
//
//#pragma mark - 处理中间凸出的按钮部分点击事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 这里宽度应该跟突出部分的宽度一样，减少点击反应区域
    CGFloat pointW = 43;
    CGFloat pointH = 61;
    CGFloat pointX = ([UIScreen mainScreen].bounds.size.width - pointW) / 2;
    CGFloat pointY = -12;
    CGRect rect = CGRectMake(pointX, pointY, pointW, pointH);
    if (CGRectContainsPoint(rect, point))
        return self.bigButton;
    return [super hitTest:point withEvent:event];
}
//
//-(NSMutableArray*)OtherButtons{
//    if(!_OtherButtons){
//        _OtherButtons = [NSMutableArray array];
//    }
//    return _OtherButtons;
//}

@end
