//
//  PIDViewController.m
//  TKJD
//
//  Created by apple on 2017/1/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PIDViewController.h"
#import "PIDModel.h"

@interface PIDViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    UIWebView * webview;
    UIScrollView * bgScroll;

    
    NSString * cookieStr;
    NSString * account;
    
    UIView * bgView;
    
    NSMutableArray * dataAry;
    
    NSString * pidStr;

}
@end

@implementation PIDViewController

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
    
    dataAry=[[NSMutableArray alloc]init];
    

    
    [self addPIDView];
   
   
    
}
- (UIButton *)buttonWithTitle:(NSString *)title bgColor:(UIColor *)bgColor sel:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.numberOfLines=0;
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button setTitleColor:bgColor forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xff307e) forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.borderWidth=1;
    button.layer.borderColor=UIColorFromRGB(0xdcdcdc).CGColor;
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
 
}
- (UILabel *)labWithbgColor:(UIColor *)bgColor font:(CGFloat)font
{
    UILabel * lab =[UILabel new];
    lab.font=[UIFont systemFontOfSize:font];
    lab.textColor=bgColor;
    lab.numberOfLines=0;
    
    return lab;
}
-(void)addPIDView{
    
    bgScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT)];
    [self.view addSubview:bgScroll];

    
    UIButton * refreshBtn =[self buttonWithTitle:@"出现错误页面请点击我" bgColor:UIColorFromRGB(0x333333) sel:@selector(buttonClick:)];
    refreshBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    refreshBtn.frame=CGRectMake(10, 74, WINDOWRECT_WIDTH-20, 40);
    refreshBtn.tag=20;
    [bgScroll addSubview:refreshBtn];
    
    
    UILabel * label1=[self labWithbgColor:UIColorFromRGB(0x333333) font:14];
    label1.text=@"1.这里请填写淘宝联盟（阿里妈妈）账号和密码！";
    [bgScroll addSubview:label1];


    webview =[[UIWebView alloc]init];
    webview.scrollView.scrollEnabled=YES;

    NSDictionary *dictionary = @{@"UserAgent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"};
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

    webview.delegate=self;
    webview.scrollView.delegate=self;
    NSURL * url =[NSURL URLWithString:@"https://login.taobao.com/member/login.jhtml?style=mini&from=alimama&redirectURL=http%3A%2F%2Flogin.taobao.com%2Fmember%2Ftaobaoke%2Flogin.htm%3Fis_login%3d1&full_redirect=true&disableQuickLogin=true"];
    NSURLRequest * req =[[NSURLRequest alloc]initWithURL:url];
    
    [webview loadRequest:req];
    webview.backgroundColor=[UIColor whiteColor];
    [bgScroll addSubview:webview];


    
    label1.sd_layout
    .leftSpaceToView(bgScroll,10)
    .rightSpaceToView(bgScroll,10)
    .topSpaceToView(refreshBtn,10)
    .autoHeightRatio(0);
    

    
    webview.sd_layout
    .topSpaceToView(label1,10)
    .leftSpaceToView(bgScroll,0)
    .rightSpaceToView(bgScroll,0)
    .heightIs(WINDOWRECT_HEIGHT);
    
    if (IPHONE4) {
         bgScroll.contentSize=CGSizeMake(0, WINDOWRECT_HEIGHT+120);
        
    }else{
        
         bgScroll.contentSize=CGSizeMake(0, WINDOWRECT_HEIGHT+150);
    }
   
}

-(void)loadPickerView{
    


    
    [[NSUserDefaults standardUserDefaults]setObject:cookieStr forKey:@"cookie"];
    
    UIColor *color = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:249/255.0 alpha:1];
    bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT)];
    //    _bgview.backgroundColor=[UIColor blackColor];
    //    _bgview.alpha=0.5;
    [self.view addSubview:bgView];
    
    // UIPickerView 选择器
    
    UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, WINDOWRECT_HEIGHT-200, WINDOWRECT_WIDTH, 200)];
    pickerView.backgroundColor = color;
    pickerView.dataSource = self;
    pickerView.delegate =self;
    [bgView addSubview:pickerView];
    
    
    UIButton * ensureBtn=[[UIButton alloc]init];
    ensureBtn.tag=2;
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(pickerViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:ensureBtn];
    
    
    [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(pickerView.mas_top).offset(2);
        make.right.offset(-5);
        make.width.offset(50);
        make.height.offset(50);
        
    }];
    
  
}
// 设置picker有几个区域
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // 通过返回值设置picker的区域个数
    return 1;
}
// 设置pickerView每个区有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //    NSLog(@">>>>%lu",(unsigned long)self.shareAry.count);
    return dataAry.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *myView = nil;
    
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, 30)];
    
    
    myView.textAlignment =NSTextAlignmentCenter;
    
   
    PIDModel * model =dataAry[row];

//    NSLog(@"%@",model.name);
    
    myView.text = model.name;

    myView.font = [UIFont systemFontOfSize:16];         //用label来设置字体大小
    
    
    myView.backgroundColor = [UIColor clearColor];
    
    
    return myView;
    
}
// 选择某一行之后会调用这个方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"%ld",(long)row);

    
    PIDModel * model =dataAry[row];
   
   
    pidStr=model.pid;
    
}
-(void)pickerViewButton:(UIButton *)but{
    

//    [self requestToken];
   
    
    if (pidStr==nil) {
        
        PIDModel * model=dataAry[0];
    
        pidStr=model.pid;
    }
     NSLog(@"%@",pidStr);
    
    [[NSUserDefaults standardUserDefaults]setObject:pidStr forKey:@"pid"];

    [bgView removeFromSuperview];
    
    [self loginData];
  
}
-(void)buttonClick:(UIButton *)button{

    NSURLRequest * req =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://login.taobao.com/member/login.jhtml?style=mini&from=alimama&redirectURL=http%3A%2F%2Flogin.taobao.com%2Fmember%2Ftaobaoke%2Flogin.htm%3Fis_login%3d1&full_redirect=true&disableQuickLogin=true"]];
    
    [webview loadRequest:req];

}
#pragma mark--获取登录cookie
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    
//    NSLog(@"shouldStartLoadWithRequest %@",request.URL.absoluteString);
//
//    if (![request.URL.absoluteString hasPrefix:@"https://login.m.taobao.com/login.htm?_input_charset=utf-8"]){
//        
//        NSLog(@"111");
//
//
//    }else{

        NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
        NSMutableString *cookieString = [NSMutableString stringWithFormat:@""];
        NSHTTPCookieStorage *httpCookiesStorage =  [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies = [httpCookiesStorage cookiesForURL:request.URL];
        for (NSHTTPCookie *cookie in cookies) {
//                    NSLog(@"cookie===》》%@",cookie);
            [cookieDic setObject:cookie.value forKey:cookie.name];
        }
        for (NSString *key in cookieDic) {
            NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
            [cookieString appendString:appendString];
        
//            NSLog(@"%@",cookieString);
           
        }
        if ([cookieString rangeOfString:@"v=0"].location!=NSNotFound&&[cookieString rangeOfString:@"_l_g_="].location!=NSNotFound) {
//            NSLog(@"--------%@",cookieString);
             [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
            [[NSUserDefaults standardUserDefaults]setObject:cookieString forKey:@"cookie2"];
            
            
        }
        
        if ([cookieString rangeOfString:@"cookie31"].location!=NSNotFound &&[cookieString rangeOfString:@"cookie32"].location!=NSNotFound ) {
            
//            NSLog(@"2222222");
            [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
            cookieStr=cookieString;
           
            
            __weak __typeof(self)weakSelf = self;
            NSString * url =@"http://pub.alimama.com/common/getUnionPubContextInfo.json";
            AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
            [operationManager.requestSerializer setValue:cookieString forHTTPHeaderField:@"cookie"];
            [operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                LRLog(@"%@",operation.responseString);
                
                account = operation.responseObject[@"data"][@"mmNick"];
//                if ([nick rangeOfString:@"@alimama"].location!=NSNotFound) {
//                    
//                    account =[[nick componentsSeparatedByString:@"@"] firstObject];
//                    
//                }else{
//                    
//                    account=nick;
//                }
                
                [defaults setObject:account forKey:@"mmNick"];
                [defaults setObject:operation.responseObject[@"data"][@"memberid"] forKey:@"memberid"];
                [defaults setObject:operation.responseObject[@"data"][@"avatar"] forKey:@"avatar"];
                
                
               [weakSelf requestPID];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        }
        
//    }

    return YES;
}


-(void)requestPID{
    
        __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"cookie"];
    [operationManager GET:@"http://pub.alimama.com/common/adzone/adzoneManage.json?&tab=3&toPage=1&perPageSize=40&gcid=8"  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@">>>>>>>%@",operation.responseString);
        
        if ((NSNull *)operation.responseObject[@"data"][@"pagelist"]!=[NSNull null]) {
            
            [dataAry removeAllObjects];
            id ary =operation.responseObject[@"data"][@"pagelist"];
            for (NSDictionary * dic in ary) {
              
                if ([dic[@"tag"] intValue]==29) {
                    PIDModel * model =[[PIDModel alloc]init];

                    model.name=dic[@"name"];
                    model.pid=dic[@"adzonePid"];
                    
                    [dataAry addObject:model]; 
                }
            }
            [weakSelf loadPickerView];
            
        }else{
            
            NSURLRequest * req =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://login.taobao.com/member/login.jhtml?style=mini&from=alimama&redirectURL=http%3A%2F%2Flogin.taobao.com%2Fmember%2Ftaobaoke%2Flogin.htm%3Fis_login%3d1&full_redirect=true&disableQuickLogin=true"]];
            [webview loadRequest:req];
            
            [weakSelf.view makeToast:@"还没有PID" duration:2 position:@"center"];

            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        
        NSLog(@"%@",[error localizedDescription]);
       
        NSURLRequest * req =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://login.taobao.com/member/login.jhtml?style=mini&from=alimama&redirectURL=http%3A%2F%2Flogin.taobao.com%2Fmember%2Ftaobaoke%2Flogin.htm%3Fis_login%3d1&full_redirect=true&disableQuickLogin=true"]];
        [webview loadRequest:req];
 
        [weakSelf.view makeToast:@"还没有PID" duration:2 position:@"center"];

        
    }];

    
    
}



-(void)loginData{
    
    
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = !tabbar.tabbar.hidden;

    
    if (self.isCheck==YES) {
       
        [self.navigationController popViewControllerAnimated:YES];

   
    }else{
        
        SChainViewController * vc =[[SChainViewController alloc]init];
        vc.model=self.model;
        [self.navigationController pushViewController:vc animated:YES];
        
//        [[NSUserDefaults standardUserDefaults]setObject:cookieStr forKey:@"cookie"];

    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    NSLog(@"%f",scrollView.contentOffset.y);
    if (IPHONE5) {
        if (scrollView.contentOffset.y>0) {
            
            [bgScroll setContentOffset:CGPointMake(0, scrollView.contentOffset.y+40) animated:NO];
            
        }else{
            
            [bgScroll setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
        }

    }else if (IPHONE4){
        if (scrollView.contentOffset.y>=0) {
            
            [bgScroll setContentOffset:CGPointMake(0, scrollView.contentOffset.y+150) animated:NO];
            
        }else{
            
            [bgScroll setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
        }

        
    }
    
}
-(void)addNavView
{

    self.title=@"登录";
    
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
