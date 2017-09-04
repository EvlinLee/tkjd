//
//  GrantViewController.m
//  TKJD
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GrantViewController.h"

@interface GrantViewController ()<UIWebViewDelegate>{
    
    
    NSString * code;
    
}

@end

@implementation GrantViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self addNavView];
    
    UIWebView * webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-64)];
    webView.delegate=self;

    
    NSURL * url =[NSURL URLWithString:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=23617975&redirect_uri=www.tkjidi.com&state=1212&view=wap"];
    
    NSURLRequest * req =[[NSURLRequest alloc]initWithURL:url];
    
    [webView loadRequest:req];
    
    [self.view addSubview:webView];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    NSLog(@"%@",request.URL.absoluteString);
    
    if ([request.URL.absoluteString rangeOfString:@"code="].location!=NSNotFound) {
        
         code =[[[[request.URL.absoluteString componentsSeparatedByString:@"code="] lastObject] componentsSeparatedByString:@"&"] firstObject];
       
        NSLog(@"%@",code);

        [self requestToken];
        
        NSURL * url =[NSURL URLWithString:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=23617975&redirect_uri=www.tkjidi.com&state=1212&view=wap"];
        
        NSURLRequest * req =[[NSURLRequest alloc]initWithURL:url];
        
        [webView loadRequest:req];
        
    }
    
    return YES;
}
-(void)requestToken{
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:@"https://oauth.taobao.com/token" params:@{@"code":code,@"grant_type":@"authorization_code",@"client_id":@"23617975",@"client_secret":@"3f722bb9f2f90ef770da88d08b363f6b",@"redirect_uri":@"www.tkjidi.com"} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
        
        [defaults setObject:returnData[@"access_token"] forKey:@"access_token"];
        [defaults setObject:returnData[@"expire_time"] forKey:@"expire_time"];
        [defaults setObject:returnData[@"refresh_token"] forKey:@"refresh_token"];
        [defaults setObject:returnData[@"refresh_token_valid_time"] forKey:@"valid_time"];
        
        [defaults synchronize];
        
        
        [weakSelf backViewB];
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}
-(void)addNavView
{
    
    self.title=@"用户授权";
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backViewB) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bar;
    
    UIEdgeInsets img = backBtn.imageEdgeInsets;
    img.left = -20;
    [backBtn setImageEdgeInsets:img];
    
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
