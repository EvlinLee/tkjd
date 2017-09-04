//
//  DetailsViewController.m
//  TKJD
//
//  Created by apple on 2017/3/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()<UIWebViewDelegate>{
    
    

    NSString * urls;
}

@end

@implementation DetailsViewController
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
    if (self.urlStr.length>0) {
        
        [self loadWebViewWithUrl:self.urlStr];

        
    }else{
       
        [self requsetWithMerge];
        
    }

    
    
}
//二合一
-(void)requsetWithMerge{
    
//    NSString * activityId =[[[[self.model.yhLink componentsSeparatedByString:@"activity_id="] lastObject] componentsSeparatedByString:@";"] firstObject];
//    
//    
//    //    https://uland.taobao.com/cp/coupon?activityId=%@&itemId=%@&dx=1
//    
//    
//    NSString * url =[NSString stringWithFormat:@"https://uland.taobao.com/coupon/edetail?activityId=%@&itemId=%@&dx=1",activityId,self.model.goodsId];
//    LRLog(@"%@",url);
    
    [self loadWebViewWithUrl:self.model.url_shop];
  
}

-(void)loadWebViewWithUrl:(NSString *)urlStr{
    
    UIWebView * webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-64)];
    webView.backgroundColor=[UIColor whiteColor];
    webView.delegate=self;
    [self.view addSubview:webView];
    
    NSLog(@"%@",self.urlStr);
    
    NSURL* url = [NSURL URLWithString:urlStr];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
        LRLog(@"shouldStartLoadWithRequest %@",request.URL.absoluteString);
    
    if ([request.URL.absoluteString rangeOfString:@"about:blank"].location!=NSNotFound) {
        
        return YES;
        
    }
    
    
    return YES;
}
-(void)addNavView
{
    
    self.title=@"商品详情";
    
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

    [self.navigationController popViewControllerAnimated:NO];
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
