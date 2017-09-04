//
//  signViewController.m
//  TKJD
//
//  Created by 杨波 on 17/2/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "signViewController.h"
#import "MainTabBarController.h"
#import "loginViewController.h"
@interface signViewController ()<UITextFieldDelegate>{
    
    
    
    UITextField * textFiled1;
    UITextField * textFiled2;

}

@end

@implementation signViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"登录";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = title;

    
    textFiled1 =[[UITextField alloc]init];
    textFiled1.delegate=self;
    textFiled1.clearButtonMode=UITextFieldViewModeWhileEditing;
    textFiled1.backgroundColor=UIColorFromRGB(0xDFE0E1);
    textFiled1.placeholder=@"请输入您的11位手机号码";
    textFiled1.font=[UIFont systemFontOfSize:14];
    textFiled1.layer.masksToBounds=YES;
    textFiled1.layer.cornerRadius=5;
    [self.view addSubview:textFiled1];
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    UIImageView *accIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 16, 25)];
    accIcon.image = [UIImage imageNamed:@"sjh"];
    [view addSubview:accIcon];
    textFiled1.leftView = view;
    textFiled1.leftViewMode = UITextFieldViewModeAlways;
    

    
    
    
    textFiled2 =[[UITextField alloc]init];
    textFiled2.delegate=self;
    textFiled2.secureTextEntry=YES;
    textFiled2.placeholder=@"请输入密码";
    textFiled2.font=[UIFont systemFontOfSize:14];
    textFiled2.clearButtonMode=UITextFieldViewModeWhileEditing;
    textFiled2.backgroundColor=UIColorFromRGB(0xDFE0E1);
    textFiled2.layer.masksToBounds=YES;
    textFiled2.layer.cornerRadius=5;
    [self.view addSubview:textFiled2];
    
    
    UIView * passView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    
    
    UIImageView *passIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 25)];
    passIcon.image = [UIImage imageNamed:@"mm"];
    [passView addSubview:passIcon];
    
    textFiled2.leftView = passView;
    textFiled2.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton * sginBtn =[[UIButton alloc]init];
    sginBtn.backgroundColor=UIColorFromRGB(0x579AFC);
    [sginBtn setTitle:@"登录" forState:UIControlStateNormal];
    sginBtn.layer.masksToBounds=YES;
    sginBtn.layer.cornerRadius=5;
    [sginBtn addTarget:self action:@selector(sginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sginBtn];
    
   

    UIButton * helpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [helpBtn setTitle:@"注册帮助" forState:UIControlStateNormal];
    [helpBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    helpBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpBtn];
    
    
    textFiled1.sd_layout
    .topSpaceToView(self.view,74)
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(40);
    
    
    textFiled2.sd_layout
    .topSpaceToView(textFiled1,10)
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(40);
    
    
    sginBtn.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(textFiled2,15)
    .heightIs(40);
    
    
    helpBtn.sd_layout
    .bottomSpaceToView(self.view,10)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(20);

}
- (UILabel *)labWithbgColor:(UIColor *)bgColor font:(CGFloat)font
{
    UILabel * lab =[UILabel new];
    lab.font=[UIFont systemFontOfSize:font];
    lab.textColor=bgColor;
    lab.numberOfLines=0;
    
    return lab;
}

-(void)sginBtnClick{
    
//    [self requestToken];
    [self requestData];
    

    
}
-(void)helpBtnClick{
    

    loginViewController * vc =[[loginViewController alloc]init];

    vc.title=@"注册帮助";
    vc.idStr=@"47";
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(void)registerButton{
    

    loginViewController * vc =[[loginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)requestData{
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    NSString * url =[NSString stringWithFormat:@"http://api.tkjidi.com/index.php?m=App&a=isuser&timestamp=%@&nonce=%@&sign=%@",time,[NSString md5To32bit:once],sign];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:@{@"username":textFiled1.text,@"pwd":textFiled2.text} successBlock:^(id returnData, int code, NSString *msg) {
    
        LRLog(@"%@",msg);
        if ([returnData[@"status"] intValue]==200) {
            [defaults setBool:YES forKey:@"login"];
            [defaults setObject:textFiled1.text forKey:@"username"];
            [defaults setObject:returnData[@"data"] forKey:@"time"];
            [defaults setObject:textFiled2.text forKey:@"pwd"];
            
            UIWindow * window =[[[UIApplication sharedApplication]delegate]window];
            [window setRootViewController:[ZCYTabBarController new]];
            [window makeKeyWindow];

            
        }else{
            
            [weakSelf.view makeToast:returnData[@"msg"] duration:2 position:@"center"];
        }
        
    } failureBlock:^(NSError *error) {
        
        
        
    } showHUD:YES];
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
