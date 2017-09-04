//
//  loginViewController.m
//  TKJD
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController ()

@property(nonatomic , retain)UIWebView * webView;
@end

@implementation loginViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = YES;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self addNavView];

    [self requestHTMLContent];
    
    

    
}
-(void)loadWebView{
    
    self.webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT)];
    
    self.webView.backgroundColor=[UIColor whiteColor];
//    [self.webView loadHTMLString:self.content baseURL:nil];
    
    NSDictionary *dictionary = @{@"UserAgent":@"Dalvik/2.1.0 (Linux; U; Android 7.1.2; Pixel XL Build/NJH47B)/zhe;4.5.2;Pixel XL;Android;7.1.2;106523"};
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

    
    NSURLRequest * req =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://vip.tkjidi.com/index.php?m=user&a=register"]];
    [self.webView loadRequest:req];
    self.webView.scrollView.bounces=NO;
    self.webView.backgroundColor=[UIColor whiteColor];
   

    
    [self.view addSubview:self.webView];
    
}
-(void)loadWebViewHTML{
   
    self.webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-64)];
    
    self.webView.backgroundColor=[UIColor whiteColor];
    
    [self.webView loadHTMLString:self.content baseURL:nil];
    
    
    [self.view addSubview:self.webView];
    
}
-(void)requestHTMLContent{
    
    
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"newsios",@"id":self.idStr,@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign} successBlock:^(id returnData, int code, NSString *msg) {
        
        LRLog(@"%@",returnData);
        //
        if ([returnData[@"status"] intValue]==200) {
            
             weakSelf.content=returnData[@"data"][@"content"];
        
            if([returnData[@"data"][@"title"] isEqualToString:@"注册帮助"]){
                
                [weakSelf loadWebView];
            }else{
                
                [weakSelf loadWebViewHTML];
            }
        
            
        }
        
        
        
        
    } failureBlock:^(NSError *error) {
        
        
        
        
    } showHUD:YES];
    
    
    
    
}
-(void)addNavView
{
  
   
    
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
    [self.navigationController popViewControllerAnimated:YES];
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
