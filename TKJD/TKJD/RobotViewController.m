//
//  RobotViewController.m
//  TKJD
//
//  Created by apple on 2017/4/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RobotViewController.h"
#import "GroupViewController.h"
#import "GroupModel.h"
@interface RobotViewController ()<UIScrollViewDelegate>{
//    NSString * skey;
//    NSString * sid;
//    NSString * uin;
//    NSString * pass_ticket;
    NSString *timeString;
    NSString * uuid;
    NSString * redirect_uri;
    
    MBProgressHUD * HUD;
    NSString * userName;
    NSMutableDictionary * synckeyDic;
//    NSMutableArray * listAry;
    
    GroupModel * model;
    UIImageView * imgView;

}
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *lastBottomLine;
@property (nonatomic, strong) UIView *wrapperView;
@end

@implementation RobotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColorFromRGB(0xEEEEEF)];
//    listAry=[[NSMutableArray alloc]init];
    model=[[GroupModel alloc]init];
//    model.listAry=[[NSMutableArray alloc]init];
    
    [defaults setObject:@"2" forKey:@"wx"];
    
    [self addNavView];
    
    [self uploadView];
    
    [self requestWithUUID];
    
}
-(void)uploadView{
    
    self.wrapperView = [UIView new];
    self.wrapperView.backgroundColor=UIColorFromRGB(0xEEEEEF);
    [self.scroollView addSubview:self.wrapperView];
    [self.scroollView setupAutoContentSizeWithBottomView:self.wrapperView bottomMargin:0];

    [self setupContentCell];

    self.wrapperView.sd_layout.
    leftEqualToView(self.scroollView)
    .rightEqualToView(self.scroollView)
    .topEqualToView(self.scroollView);
    [self.wrapperView setupAutoHeightWithBottomView:self.lastBottomLine bottomMargin:0];
}
- (UIScrollView *)scroollView
{
    if (!_scroollView) {
        _scroollView = [UIScrollView new];
        _scroollView.backgroundColor=UIColorFromRGB(0xEEEEEF);
        _scroollView.delegate = self;
        _scroollView.showsVerticalScrollIndicator=NO;
        [self.view addSubview:_scroollView];
        
        _scroollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    return _scroollView;
}
- (UIView *)addSeparatorLineBellowView:(UIView *)view margin:(CGFloat)margin
{
    UIView *line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0xEEEEEF);
    [self.wrapperView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.wrapperView, 0)
    .rightSpaceToView(self.wrapperView, 0)
    .heightIs(10)
    .topSpaceToView(view, margin);
    
    return line;
}
- (void)setupContentCell{
    
    UILabel * lab1 =[[UILabel alloc]init];
    lab1.text=@"请使用微信扫一扫扫描下方二维码并点击登录，完成机器人创建。";
    lab1.font=[UIFont systemFontOfSize:14];
    lab1.textColor=UIColorFromRGB(0x444444);
    
    
    imgView =[[UIImageView alloc]init];
    
    
    UIButton * refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font=[UIFont systemFontOfSize:16 weight:2];
    refreshBtn.backgroundColor=UIColorFromRGB(0xF83A5E);
    [refreshBtn addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * view =[[UIView alloc]init];
    view.backgroundColor=UIColorFromRGB(0xEEEEEF);
    view.layer.borderWidth=1;
    view.layer.borderColor=UIColorFromRGB(0xff486c).CGColor;
    
    
    NSString * str =@"提示：二维码可能过期，请点击刷新重新扫码。如果尝试多次登录不上，请登录web微信检察是否可以正常登录。";
    UILabel * lab2 =[[UILabel alloc]init];
    lab2.textColor=UIColorFromRGB(0xff486c);
    lab2.text=str;
    lab2.font=[UIFont systemFontOfSize:14];
    [view addSubview:lab2];
    CGSize size =[str boundingRectWithSize:CGSizeMake(WINDOWRECT_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil].size;

    
    UILabel * lab3 =[[UILabel alloc]init];
    lab3.textColor=UIColorFromRGB(0xff486c);
    lab3.text=@"不支持微信内截图/长按识别！";
    lab3.textAlignment=NSTextAlignmentCenter;
    lab3.font=[UIFont systemFontOfSize:16];
    
    UILabel * lab4 =[[UILabel alloc]init];
    lab4.font=[UIFont systemFontOfSize:14];
    lab4.textColor=UIColorFromRGB(0x444444);
    lab4.text=@"若无法完成二维码扫描，请联系客服，重要提示：\n1.请身边好友拿手机拍摄二维码（或截图传到电脑）\n2.打开手机微信扫描好友拍摄的二维码，点击确认登录。\n3.返回界面，添加群，完成机器人创建。\n\n\n";
    [Customer changeLineSpaceForLabel:lab4 WithSpace:4];
    
    
    
    [self.wrapperView addSubviews:@[lab1,lab3,lab4,imgView,refreshBtn,view]];
    
    
    lab1.sd_layout
    .topSpaceToView(self.wrapperView, 30)
    .leftSpaceToView(self.wrapperView, 10)
    .rightSpaceToView(self.wrapperView, 10)
    .autoHeightRatio(0);
    
    
    imgView.sd_layout
    .topSpaceToView(lab1, 10)
    .centerXEqualToView(self.wrapperView)
    .widthIs(200)
    .heightIs(200);
    
    
    refreshBtn.sd_layout
    .topSpaceToView(imgView, 10)
    .centerXEqualToView(imgView)
    .widthIs(200)
    .heightIs(40);
    
    
    view.sd_layout
    .topSpaceToView(refreshBtn, 20)
    .leftEqualToView(lab1)
    .rightEqualToView(lab1)
    .heightIs(size.height+40);
    
    lab3.sd_layout
    .topSpaceToView(view, 20)
    .leftEqualToView(lab1)
    .rightEqualToView(lab1)
    .heightIs(20);
    
    
    lab4.sd_layout
    .topSpaceToView(lab3, 10)
    .leftEqualToView(lab1)
    .rightEqualToView(lab1)
    .autoHeightRatio(0);
    
    
    lab2.sd_layout
    .topSpaceToView(view, 10)
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .autoHeightRatio(0);
    
    

     self.lastBottomLine = [self addSeparatorLineBellowView:lab4 margin:1];
    
}

-(void)refreshButtonClick:(UIButton *)btn{
   
    [self requestWithUUID];
    
    
}
#pragma mark--- 获取UUID
-(void)requestWithUUID{
    
    
    
    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    
    NSString * uri =[NSString stringWithFormat:@"%@/cgi-bin/mmwebwx-bin/webwxnewloginpage",[defaults objectForKey:@"wx"]];
    
    
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager GET:@"https://login.weixin.qq.com/jslogin" parameters:@{@"appid":@"wx782c26e4c19acffb",@"redirect_uri":uri,@"fun":@"new",@"lang":@"zh_CN",@"_":timeString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        uuid =[[[operation.responseString componentsSeparatedByString:@"window.QRLogin.uuid = "] lastObject] componentsSeparatedByString:@"\""][1];
        
        [self loadImage];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}
#pragma 加载二维码
-(void)loadImage{
    
    
    if (!imgView) {
        
        
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://login.weixin.qq.com/qrcode/%@",uuid]] placeholderImage:[UIImage imageNamed:@""]];
        
        
    }else{
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://login.weixin.qq.com/qrcode/%@",uuid]] placeholderImage:[UIImage imageNamed:@""]];
        
    }
    
    
    
    [self requestLogin];
    
}
#pragma mark ----微信登录
-(void)requestLogin{
    
    NSInteger a =[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    
    
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager GET:@"https://login.wx2.qq.com/cgi-bin/mmwebwx-bin/login" parameters:@{@"loginicon":@"true",@"uuid":uuid,@"tip":@"1",@"r":@(-a),@"_":timeString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if ([operation.responseString rangeOfString:@"408"].location!=NSNotFound) {
            NSLog(@"登录-----------------------%@",operation.responseString);
//            [self requestWithUUID];
            
            [self performSelector:@selector(requestLogin) withObject:nil afterDelay:5];

            
        }else if ([operation.responseString rangeOfString:@"201"].location!=NSNotFound){
            
            [self performSelector:@selector(requestLogin) withObject:nil afterDelay:2];
            
            
        }else if ([operation.responseString rangeOfString:@"200"].location!=NSNotFound){
            NSLog(@"登录-----------------------%@",operation.responseString);
            redirect_uri=[[[operation.responseString componentsSeparatedByString:@"window.redirect_uri="] lastObject] componentsSeparatedByString:@"\""][1];
            
            [self requestLoginParameter];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark ---登陆后获得参数
-(void)requestLoginParameter{
    
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager GET:redirect_uri parameters:@{@"fun":@"new",@"version":@"v2"} success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",operation.responseString);
        
        model.skey=[[[[operation.responseString componentsSeparatedByString:@"</skey>"] firstObject] componentsSeparatedByString:@"<skey>"] lastObject];
        
    
        model.sid=[[[[operation.responseString componentsSeparatedByString:@"</wxsid>"] firstObject] componentsSeparatedByString:@"<wxsid>"] lastObject];
        
        model.uin=[[[[operation.responseString componentsSeparatedByString:@"</wxuin>"] firstObject] componentsSeparatedByString:@"<wxuin>"] lastObject];
        
        model.pass_ticket=[[[[operation.responseString componentsSeparatedByString:@"</pass_ticket>"] firstObject] componentsSeparatedByString:@"<pass_ticket>"] lastObject];
        
        
        [self requestWXInit];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark ---微信初始化（获取自己的信息）
-(void)requestWXInit{
    
    
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxinit?r=-1532859035&lang=zh_CN&pass_ticket=%@",[defaults objectForKey:@"wx"],model.pass_ticket];
    
    NSDictionary * dic =@{@"BaseRequest":@{@"Uin":model.uin,@"Sid":model.sid,@"Skey":model.skey,@"DeviceID":@"e207079374714885"}};
    
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
//    [request setValue:@"https://wx.qq.com/?&lang=zh_CN" forHTTPHeaderField:@"Referer"];
//    [request setValue:@"https://wx.qq.com" forHTTPHeaderField:@"Origin"];
    [request setHTTPBody:jsonData];
    
    NSOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                        NSLog(@"synckeyDic--------%@",operation.responseString);
        
        [model.listAry removeAllObjects];
        
        NSDictionary * dic =[[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
        
        model.userName =dic[@"User"][@"UserName"];
        
        synckeyDic=dic[@"SyncKey"];
        
        NSLog(@"synckeyDic===%@",synckeyDic);
        
        id ary =dic[@"SyncKey"][@"List"];
        
        for (NSDictionary * listdic in  ary) {
            
            NSString * list =[NSString stringWithFormat:@"%@_%@",listdic[@"Key"],listdic[@"Val"]];
            
            [model.listAry addObject:list];
            
        }
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=@"正在加载..";
        //    HUD.mode=MBProgressHUDModeCustomView;
        HUD.taskInProgress=YES;
        [HUD show:YES];
        [self.view addSubview:HUD];
        
        [self requestWebwxsync];
//        [self upDate];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [manager.operationQueue addOperation:operation];
    
    
}
-(void)requestWebwxsync{
    
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxsync?sid=%@&skey=%@&lang=zh_CN&pass_ticket=%@",[defaults objectForKey:@"wx"],model.sid,model.skey,model.pass_ticket];
    
    NSDictionary * dic =@{@"BaseRequest":@{@"Uin":model.uin,@"Sid":model.sid,@"Skey":model.skey,@"DeviceID":@"e200046210733551"},@"SyncKey":synckeyDic,@"rr":timeString};
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
       __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"https://wx2.qq.com/?&lang=zh_CN" forHTTPHeaderField:@"Referer"];
    [request setValue:@"https://wx2.qq.com" forHTTPHeaderField:@"Origin"];
    [request setHTTPBody:jsonData];
    
    NSOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                NSLog(@"--------%@",operation.responseString);
        
        //        [synckeyDic removeAllObjects];
        [model.listAry removeAllObjects];
        
        NSDictionary * dic =[[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
        
        synckeyDic=dic[@"SyncKey"];
        
        NSLog(@"222");
        
        id ary =dic[@"SyncKey"][@"List"];
        for (NSDictionary * listdic in  ary) {
            
            NSString * list =[NSString stringWithFormat:@"%@_%@",listdic[@"Key"],listdic[@"Val"]];
            
            [model.listAry addObject:list];
            
        }
        
        [weakSelf upDate];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [manager.operationQueue addOperation:operation];
    
}

#pragma mark---心跳包
-(void)upDate{
    
    static int i=0;
    
    NSLog(@"%@",[defaults objectForKey:@"wx"] );
    
    NSString * synckey=[model.listAry componentsJoinedByString:@"%7C"];

    NSString * url =[NSString stringWithFormat:@"https://webpush.wx%@.qq.com/cgi-bin/mmwebwx-bin/synccheck?r=%@&skey=%@&sid=%@&uin=%@&deviceid=e059428368796601&synckey=%@&_=%@",[defaults objectForKey:@"wx"],timeString,model.skey,model.sid,model.uin,synckey,timeString];
       __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"https://wx.qq.com/?&lang=zh_CN" forHTTPHeaderField:@"Referer"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD removeFromSuperview];
        NSLog(@"%d---%@",i++,operation.responseString);
        
        if ([operation.responseString rangeOfString:@"1101"].location!=NSNotFound) {

            static int a= 0;
            if (a<2) {
 
                [weakSelf performSelector:@selector(requestLogin) withObject:nil afterDelay:2];

                a++;

            }else{
                a=0;
                [weakSelf.view makeToast:@"登录失败，请刷新扫描" duration:2 position:@"center"];
                
            }
        
        }else if ([operation.responseString rangeOfString:@"1100"].location!=NSNotFound){
            
            static int i= 0;
            if (i<2) {

                [defaults setObject:@"" forKey:@"wx"];
                [weakSelf requestLogin];

                i++;

            }else{
                i=0;
                [weakSelf.view makeToast:@"登录失败，请刷新扫描" duration:2 position:@"center"];
                
            }

            
            
        }else{
            
            if ([operation.responseString rangeOfString:@"7"].location!=NSNotFound) {
                [weakSelf.view makeToast:@"登录失败，请刷新扫描" duration:2 position:@"center"];
                [weakSelf requestLogin];
                
            }else{
//                static int b= 0;
//                if (b==0) {
//                    
//                    [self.view makeToast:@"登录成功" duration:2 position:@"center"];
//                }
                
//                [self upDate];
//                [self performSelector:@selector(upDate) withObject:nil afterDelay:25];
                
                GroupViewController * vc =[[GroupViewController alloc]init];
                vc.model=model;
                vc.keyDic=synckeyDic;
                vc.shopAry=weakSelf.shopAry;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
//                b++;
            }
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
    
    
}
-(void)addNavView
{
    
    self.title=@"微信登录";
    
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
