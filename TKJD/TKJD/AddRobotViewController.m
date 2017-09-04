//
//  AddRobotViewController.m
//  TKJD
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddRobotViewController.h"
#import "RobotViewController.h"
#import "ReplyViewController.h"
@interface AddRobotViewController ()

@end

@implementation AddRobotViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColorFromRGB(0xEEEEEF)];
    
    [self addNavView];
    
    
    
    
    
    UIButton * chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    if ([defaults boolForKey:@"reply"]==YES) {
        
        [chooseBtn setImage:[UIImage imageNamed:@"rbxz"] forState:UIControlStateNormal];
      
        
    }else{

        [chooseBtn setImage:[UIImage imageNamed:@"rb"] forState:UIControlStateNormal];
 
    }

    [chooseBtn setTitle:@" 搜索商品自动回复" forState:UIControlStateNormal];
    [chooseBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    chooseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton * createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn setTitle:@"创建机器人" forState:UIControlStateNormal];
    createBtn.titleLabel.font=[UIFont systemFontOfSize:16 weight:1];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.backgroundColor=UIColorFromRGB(0xF83A5E);
    [createBtn addTarget:self action:@selector(cerateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel * txLab=[[UILabel alloc]init];
    txLab.font=[UIFont systemFontOfSize:18 weight:2];
    txLab.textAlignment=NSTextAlignmentLeft;
    txLab.text=@"重要提示:";
    txLab.textColor=UIColorFromRGB(0xff307e);
    
    
    UILabel * title =[[UILabel alloc]init];
    title.text=@"1.扫码所使用的微信账号已成为机器人账号，在服务期间不能再电脑上登录微信，且不能再手机版微信登出，否则服务掉线。\n2.为保证机器人长期稳定在线，强烈建议您使用微信小号创建机器人并管理群。\n3.机器人人所有功能异常，都可以采用手动掉线，然后重新登录的方式尝试解决。\n4.机器人掉线期间，机器人无法为微群工作，请机器人重新登录\n微信群发为后台群发，不影响手机前台操作。（顺序发送商品库商品）\n\n\n";
    title.textColor=UIColorFromRGB(0x444444);
    title.font=[UIFont systemFontOfSize:14];
    [Customer changeLineSpaceForLabel:title WithSpace:4];
    
    [self.view addSubviews:@[createBtn,txLab,title,chooseBtn]];
    
    
    chooseBtn.sd_layout
    .topSpaceToView(self.view, 94)
    .centerXEqualToView(self.view)
    .widthIs(140)
    .heightIs(20);
    
    createBtn.sd_layout
    .topSpaceToView(chooseBtn, 15)
    .centerXEqualToView(self.view)
    .widthIs(200)
    .heightIs(40);
    
    
    txLab.sd_layout
    .topSpaceToView(createBtn, 20)
    .leftSpaceToView(self.view, 20)
    .widthIs(200)
    .heightIs(20);
    
    title.sd_layout
    .topSpaceToView(txLab, 10)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .autoHeightRatio(0);
    
    
}
-(void)cerateBtn:(UIButton *)btn{
    
    RobotViewController * vc =[[RobotViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(void)chooseBtnClick:(UIButton *)btn{
    
    if (![defaults boolForKey:@"reply"]) {
        [btn setImage:[UIImage imageNamed:@"rbxz"] forState:UIControlStateNormal];
        [defaults setBool:YES forKey:@"reply"];

        
    }else{
        
      
        [btn setImage:[UIImage imageNamed:@"rb"] forState:UIControlStateNormal];
        [defaults setBool:NO forKey:@"reply"];

    }
    
    
    
}
-(void)addNavView
{
    
    self.title=@"微信群发";
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backViewB) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bar;
    
    UIEdgeInsets img = backBtn.imageEdgeInsets;
    img.left = -20;
    [backBtn setImageEdgeInsets:img];
    
    
    UIButton * szBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    szBtn.frame=CGRectMake(0, 0, 20, 20);
    [szBtn setBackgroundImage:[UIImage imageNamed:@"jqr-sz"] forState:UIControlStateNormal];
    [szBtn addTarget:self action:@selector(szBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * bar1 =[[UIBarButtonItem alloc]initWithCustomView:szBtn];
    self.navigationItem.rightBarButtonItem=bar1;
    
    
    
}
-(void)szBtnClick{
    
    ReplyViewController * vc =[[ReplyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)backViewB{
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = NO;
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
