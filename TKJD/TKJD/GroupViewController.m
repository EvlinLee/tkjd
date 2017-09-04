//
//  GroupViewController.m
//  TKJD
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupCell.h"
#import "NameModel.h"
#import "StartViewController.h"
@interface GroupViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    
    MBProgressHUD * HUD;
    NSTimer * timer;
    NSString *timeString;

    UITextField * textFiled;
    NSMutableArray * dataAry;
    NSMutableArray * resultsAry;
    NSMutableArray * nameAry;
    
    NSMutableArray * sentAry;
    
    
//    BOOL  isOK;
    
    
}
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *lastBottomLine;
@property (nonatomic, strong) UIView *wrapperView;
@property (nonatomic, retain) UITableView * tableView;
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColorFromRGB(0xEEEEEF)];
    
    [self addNavView];
    
    dataAry =[[NSMutableArray alloc]init];
    resultsAry=[[NSMutableArray alloc]init];
    nameAry=[[NSMutableArray alloc]init];
    sentAry=[[NSMutableArray alloc]init];
    
//    isOK=YES;
    
//    ary =[[NSArray alloc]initWithObjects:@"wqeq",@"qqw",@"11www",@"222www",@"33ssss",@"33aaa", nil];
//    [dataAry addObjectsFromArray:ary];
    
//    [self upDate];
    timer =  [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(upDate) userInfo:nil repeats:YES];

      NSLog(@"%@",[defaults objectForKey:@"wx"]);
    
    [self uploadView];
    
    [self requestWXContact];
    
    
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
    
    
    UILabel * lab =[[UILabel alloc]init];
    lab.text=@"已成功创建机器人，扫码微信号已成为机器人账号。恭喜您已完成机器人初始化管理的群：";
    lab.textColor=UIColorFromRGB(0xff486c);
    lab.font=[UIFont systemFontOfSize:14];
    
    
    textFiled =[[UITextField alloc]init];
    textFiled.layer.borderColor=UIColorFromRGB(0xdcdcdc).CGColor;
    textFiled.layer.borderWidth=1;
    textFiled.delegate=self;
    textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    textFiled.placeholder=@"请输入群名称";
    textFiled.backgroundColor=[UIColor whiteColor];
    
    UIButton * searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"ss"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [textFiled addSubview:searchBtn];
    
    
    UIButton * refreshBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font=[UIFont systemFontOfSize:14 weight:2];
    refreshBtn.backgroundColor=UIColorFromRGB(0xFB4A41);
    [refreshBtn addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 120, WINDOWRECT_WIDTH-20, 200) style:UITableViewStylePlain];
    [_tableView registerClass:[GroupCell class] forCellReuseIdentifier:@"group"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=UIColorFromRGB(0xEEEEEF);
    
    
    
    
    UIButton * qdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qdBtn setTitle:@"确定" forState:UIControlStateNormal];
    qdBtn.titleLabel.font=[UIFont systemFontOfSize:14 weight:2];
    [qdBtn setBackgroundColor:UIColorFromRGB(0xF83A5E)];
    [qdBtn addTarget:self action:@selector(qdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * title =[[UILabel alloc]init];
    title.text=@"没找到想要添加的群？\n1.请点击刷新按钮。\n2.请确保创建机器人的微信号在需要添加的群内。\n3.请在需要添加的群内任意发布一条消息。\n\n\n";
    title.textColor=UIColorFromRGB(0x444444);
    title.font =[UIFont systemFontOfSize:14];
    [Customer changeLineSpaceForLabel:title WithSpace:4];
    
    
    
    [self.wrapperView addSubviews:@[lab,textFiled,refreshBtn,_tableView,qdBtn,title,searchBtn]];

    lab.sd_layout
    .topSpaceToView(self.wrapperView, 20)
    .leftSpaceToView(self.wrapperView, 10)
    .rightSpaceToView(self.wrapperView, 10)
    .autoHeightRatio(0);
    
    
    textFiled.sd_layout
    .topSpaceToView(lab, 10)
    .leftSpaceToView(self.wrapperView, 10)
    .rightSpaceToView(self.wrapperView, 80)
    .heightIs(45);
    
//    tableView.sd_layout
//    .topSpaceToView(textFiled, 20)
//    .leftSpaceToView(self.wrapperView, 10)
//    .rightSpaceToView(self.wrapperView, 10)
//    .heightIs(300);
    
    refreshBtn.sd_layout
    .topSpaceToView(lab, 10)
    .leftSpaceToView(textFiled, 10)
    .widthIs(45)
    .heightIs(45);
    
    
    
    qdBtn.sd_layout
    .topSpaceToView(_tableView, 10)
    .centerXEqualToView(self.wrapperView)
    .widthIs(200)
    .heightIs(40);
    
    title.sd_layout
    .topSpaceToView(qdBtn, 20)
    .leftSpaceToView(self.wrapperView, 10)
    .rightSpaceToView(self.wrapperView, 10)
    .autoHeightRatio(0);
    
    
//    searchBtn.sd_layout
//    .topSpaceToView(textFiled, 10)
//    .rightSpaceToView(textFiled, 10)
//    .widthIs(25)
//    .heightIs(25);
    
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textFiled.mas_top).offset(10);
        make.right.equalTo(textFiled.mas_right).offset(-10);
        make.width.offset(25);
        make.height.offset(25);
        
    }];
    
    self.lastBottomLine = [self addSeparatorLineBellowView:title margin:1];

  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%lu",(unsigned long)dataAry.count);
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupCell *cell =[[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"group"];
    if (!cell) {
        
        cell =[[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"group"];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=UIColorFromRGB(0xEEEEEF);
    
    NameModel *model =dataAry[indexPath.row];
    if (model.isChoose==NO) {
        
        cell.imgView.image=[UIImage imageNamed:@"y"];
    
    }else{
        
        cell.imgView.image=[UIImage imageNamed:@"g"];
    }

    cell.titleLab.text=model.NickName;
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NameModel * model =dataAry[indexPath.row];
    
    if (model.isChoose==NO) {
        
        model.isChoose=YES;
        
        cell.imgView.image=[UIImage imageNamed:@"g"];
        
        [sentAry addObject:model];
        
    }else{
        
        model.isChoose=NO;
        
        cell.imgView.image=[UIImage imageNamed:@"y"];
   
        [sentAry removeObject:model];
    }
    
}
-(void)qdButtonClick:(UIButton *)btn {
    
//    [timer setFireDate:[NSDate distantFuture]];
    
    [timer invalidate];
    timer=nil;
    
    
    NSLog(@"%@",sentAry);
    if (sentAry.count==0) {
        
        [self.view makeToast:@"请选择要发送的群" duration:2 position:@"center"];
   
    }else{
        StartViewController * vc =[[StartViewController alloc]init];
        vc.model=self.model;
        vc.nameAry=sentAry;
        vc.synckeyDic=self.keyDic;
        vc.shopAry=self.shopAry;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    
}
-(void)refreshData{
    
  
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.labelText=@"正在加载..";
    //    HUD.mode=MBProgressHUDModeCustomView;
    HUD.taskInProgress=YES;
    [HUD show:YES];
    [self.view addSubview:HUD];

    [self requestWXContact];
}
-(void)searchBtnClick{
    
    NSLog(@"111===%@",textFiled.text);
    
    [dataAry removeAllObjects];
    
    if ([textFiled.text length]!=0&&textFiled.text!=nil) {
        
        [resultsAry removeAllObjects];
        for (NameModel * model in nameAry)
        {
        
            if ([model.NickName rangeOfString:textFiled.text].location != NSNotFound)
            {
              
                [resultsAry addObject:model];
           
            }
        
        
        }

        [dataAry addObjectsFromArray:resultsAry];
        [_tableView reloadData];
        
    }else{
        
        
        [dataAry addObjectsFromArray:nameAry];
        [_tableView reloadData];
    }
    
}
#pragma mark ---获取列表
-(void)requestWXContact{
    
//    @"https://wx2.qq.com/cgi-bin/mmwebwx-bin/webwxgetcontact"
    
  
    [dataAry removeAllObjects];
    [nameAry removeAllObjects];
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxgetcontact",[defaults objectForKey:@"wx"]];
//    NSLog(@"%@",self.model.pass_ticket);
    
    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [manager GET:url parameters:@{@"lang":@"zh_CN",@"pass_ticket":self.model.pass_ticket,@"r":timeString,@"seq":@"0",@"skey":self.model.skey} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD removeFromSuperview];
        
        LRLog(@"群===========%@",operation.responseString);
        
        NSDictionary * objDic =[[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
        
        NSLog(@"===========%@",objDic[@"BaseResponse"][@"Ret"]);

        NSString * code =objDic[@"BaseResponse"][@"Ret"];
        
        if ([code intValue]==0) {
        
            id array =objDic[@"MemberList"];
            
            for (NSDictionary * dic in array) {
                
                if ([dic[@"UserName"] rangeOfString:@"@@"].location!=NSNotFound) {
                    NSLog(@"%@",dic[@"UserName"]);
                    NameModel * model =[[NameModel alloc]init];
                    
                    model.UserName=dic[@"UserName"];
                    model.NickName=dic[@"NickName"];
                    model.isChoose=NO;
                    [nameAry addObject:model];
                    
                    
                }
                
            }
           
        
            NSLog(@"%lu",(unsigned long)nameAry.count);
            [dataAry addObjectsFromArray:nameAry];
            [_tableView reloadData];
            
            
        }else{
        
            NSLog(@"获取列表错误----");
        
        }
        
 
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@",error);
        
        
        
    }];
    
}

#pragma mark---心跳包
-(void)upDate{
    
    static int i=0;
    
    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    
    NSString * synckey=[self.model.listAry componentsJoinedByString:@"%7C"];
    
    NSString * url =[NSString stringWithFormat:@"https://webpush.wx%@.qq.com/cgi-bin/mmwebwx-bin/synccheck?r=%@&skey=%@&sid=%@&uin=%@&deviceid=e059428368796601&synckey=%@&_=%@",[defaults objectForKey:@"wx"],timeString,self.model.skey,self.model.sid,self.model.uin,synckey,timeString];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"https://wx2.qq.com/?&lang=zh_CN" forHTTPHeaderField:@"Referer"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
  
        NSLog(@"%d---%@",i++,operation.responseString);
        
        if ([operation.responseString rangeOfString:@"1101"].location!=NSNotFound) {
            
            [self.view makeToast:@"掉线，请重新登录" duration:2 position:@"center"];
            [timer timeInterval];
            timer=nil;
            
            
        }else{
            
            if ([operation.responseString rangeOfString:@"7"].location!=NSNotFound) {
                [self.view makeToast:@"掉线，请重新登录" duration:2 position:@"center"];
                [timer timeInterval];
                timer=nil;
                
            }else{

//                [self upDate];

                
//                [self performSelector:@selector(upDate) withObject:nil afterDelay:25];

            }
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self searchBtnClick];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    
    [textFiled resignFirstResponder];
    
    
    return YES;
    
}
-(void)addNavView
{
    
    self.title=@"获取微信群";
    
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
    
//    [timer setFireDate:[NSDate distantFuture]];
    
    [timer invalidate];
    timer=nil;
    
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
