//
//  HelpDetailesViewController.m
//  TKJD
//
//  Created by apple on 2017/3/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HelpDetailesViewController.h"

@interface HelpDetailesViewController ()


@property(nonatomic , retain)NSString * content;
@end

@implementation HelpDetailesViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = !tabbar.tabbar.hidden;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addNavView];
    [self requestData];
    
    NSLog(@"--------%@",self.idNum);
   
    
    
}
-(void)loadWebView{
    
    UIWebView * webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-64)];
    webView.backgroundColor=[UIColor whiteColor];
    [webView loadHTMLString:self.content baseURL:nil];
    [self.view addSubview:webView];

    
}
-(void)requestData{
    
    
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"news",@"id":weakSelf.idNum,@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign} successBlock:^(id returnData, int code, NSString *msg) {
        
        LRLog(@"%@",returnData[@"data"][@"title"]);
        //
        if (code==0) {
            
            weakSelf.content=returnData[@"data"][@"content"];
            
            
        }
        
        [weakSelf loadWebView];
        
    } failureBlock:^(NSError *error) {
        
        
        
        
    } showHUD:YES];
    

    
    
}
-(void)addNavView
{
    
    self.title=@"帮助详情";
    
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
    tabbar.tabbar.hidden = !tabbar.tabbar.hidden;
    
    
    [self.navigationController popToRootViewControllerAnimated:NO];
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
