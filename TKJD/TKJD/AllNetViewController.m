//
//  AllNetViewController.m
//  HQ
//
//  Created by apple on 2017/7/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AllNetViewController.h"
#import "AllNetCell.h"
#import "CheckModel.h"
#import "ShopModel.h"
#import "NetChainViewController.h"
#import "SearchViewController.h"
@interface AllNetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    int page;
    int totalPage;
    int docsfound;
    
    NSString * _time;
    
    //    NSString *    item;
    NSString *    seller;
    UITextField * textfield;
    
    UITextField * bigText;
    
    UIButton * topBut;
    NSMutableArray * actAry;
    UITableView * _tableView;
    
    
    ShopModel * shop;
}
@property(nonatomic , strong)NSMutableArray * dataAry;

@end

@implementation AllNetViewController
-(NSMutableArray *)dataAry{
    
    if (!_dataAry) {
        _dataAry=[[NSMutableArray alloc]init];
        
    }
    
    return _dataAry;
}

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
    
    shop=[[ShopModel alloc]init];
    shop.class_name=@"其它";
    
    page=1;
    actAry=[NSMutableArray new];
    
    [self loadTableView];
   
    
   


}

-(UIButton *)searchButtonWithTitle:(NSString *)title{
    
    UIButton *  btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor=[UIColor orangeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    
    
    
    return btn;
    
}
-(void)addCheckView{
    
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, 200)];
    view.backgroundColor=UIColorFromRGB(0xededed);
    

    
    bigText=[[UITextField alloc]init];
    bigText.delegate=self;
    bigText.clearButtonMode=UITextFieldViewModeAlways;
    bigText.font=[UIFont systemFontOfSize:14];
   
    bigText.backgroundColor=[UIColor whiteColor];
    bigText.placeholder=@"搜索大额度商品优惠券查询";
    bigText.returnKeyType=UIReturnKeyDone;
    bigText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    bigText.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:bigText];
    [bigText becomeFirstResponder];
    
    
    
    textfield =[[UITextField alloc]init];
    textfield.delegate=self;
    textfield.clearButtonMode=UITextFieldViewModeAlways;
    textfield.font=[UIFont systemFontOfSize:14];
    textfield.backgroundColor=[UIColor whiteColor];
    //    textfield.text=self.text;
    textfield.placeholder=@"商品标题或全名称查询全网优惠券";
    textfield.returnKeyType=UIReturnKeyDone;
    textfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:textfield];
    
    
    UIButton * bigBtn =[self searchButtonWithTitle:@"查大额隐藏券"];
    bigBtn.backgroundColor=UIColorFromRGB(0xfb875d);
    [bigBtn addTarget:self action:@selector(bigBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * allBtn =[self searchButtonWithTitle:@"查全名称券"];
    allBtn.backgroundColor=UIColorFromRGB(0xf93c60);
    [allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubviews:@[bigBtn ,allBtn]];
    
    
    
    bigText.sd_layout
    .topSpaceToView(view, 10)
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .heightIs(40);
    
    bigBtn.sd_layout
    .topSpaceToView(bigText, 10)
    .centerXEqualToView(view)
    .widthIs(120)
    .heightIs(30);
    
    
    textfield.sd_layout
    .topSpaceToView(bigBtn, 10)
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .heightIs(40);
    
    allBtn.sd_layout
    .topSpaceToView(textfield, 10)
    .centerXEqualToView(view)
    .widthIs(100)
    .heightIs(30);
    
    
 
    
    _tableView.tableHeaderView=view;
    
    
}
-(void)bigBtnClick{
    
    if (bigText.text.length>0) {
        [bigText resignFirstResponder];
        SearchViewController * vc =[[SearchViewController alloc]init];
        vc.text=bigText.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self.view makeToast:@"请输入您要搜索的商品" duration:1 position:@"center"];
    }

    
}
-(void)allBtnClick{
    
    [self buttonRequest];
}
#pragma mark---表视图
-(void)loadTableView{
    
    
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor=UIColorFromRGB(0xededed);
        [_tableView registerClass:[AllNetCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
        
//        [self setupRefreshH];
        
         [self addCheckView];
        
        topBut=[[UIButton alloc]initWithFrame:CGRectMake(WINDOWRECT_WIDTH-55, WINDOWRECT_HEIGHT-104, 40, 40)];
        [topBut setImage:[UIImage imageNamed:@"fhdb"] forState:UIControlStateNormal];
        [topBut addTarget:self action:@selector(returnTop) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:topBut];
        
        
    }else{
        
        [_tableView reloadData];
    }
    
    
}
-(void)returnTop{
    
    
    [_tableView setContentOffset:CGPointMake(0, 0)animated:NO];
    
}
- (void)setupRefreshH
{
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooter)];
    
}
-(void)loadNewTopic{
    
    page=1;
    [self.dataAry removeAllObjects];
    [self requestDataWithItem:textfield.text];
    
}
-(void)loadFooter
{
    
    if (page < totalPage)
    {
        page ++;
        [self requestDataWithItem:textfield.text];
    }
    else
    {
        [self.view makeToast:@"全部加载完毕" duration:2 position:@"center"];
        [_tableView.mj_footer endRefreshing];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataAry.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view =[[UIView alloc]init];

    
    
    if (self.dataAry.count==0) {
        UIView * bgView =[[UIView alloc]init];
        bgView.backgroundColor=[UIColor whiteColor];
        [view addSubview:bgView];
        
        UIImageView * imageview =[[UIImageView alloc]init];
        imageview.image=[UIImage imageNamed:@"search_bg"];
        [bgView addSubview:imageview];
        
        bgView.sd_layout
        .topSpaceToView(view, 0)
        .leftSpaceToView(view, 10)
        .rightSpaceToView(view, 10)
        .bottomSpaceToView(view, 10);
        
        imageview.sd_layout
        .topSpaceToView(bgView, 10)
        .leftSpaceToView(bgView, 0)
        .rightSpaceToView(bgView, 0)
        .heightIs((WINDOWRECT_WIDTH-20)/0.51);

    }
    
    
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CheckModel * model =self.dataAry[indexPath.row];
    
    AllNetCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[AllNetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",model.imgStr]] placeholderImage:[UIImage imageNamed:@"jdz"]];
    
    cell.titleLab.text=model.title;
    
    NSString * order =[NSString stringWithFormat:@"原价:￥%.2f",[model.price floatValue]];
    NSUInteger orderlength=[order length];
    NSMutableAttributedString *orderAttributedStr = [[NSMutableAttributedString alloc] initWithString:order];
    [orderAttributedStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0),NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} range:NSMakeRange(3, orderlength-3)];
    
    cell.priceLab.attributedText=orderAttributedStr;
    
    NSString * qhStr =[NSString stringWithFormat:@"￥%.2f(券后价)",[model.price floatValue]-[model.yhPrice intValue]];
    
    NSUInteger length =[qhStr length];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:qhStr];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16]
     
                          range:NSMakeRange(0, length-5)];
    
    
    cell.qhLab.attributedText=AttributedStr;
    
    [cell.yhBut setTitle:[NSString stringWithFormat:@"￥%d",[model.yhPrice intValue]] forState:UIControlStateNormal];
    
    [cell.ledBut addTarget:self action:@selector(ledButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    if (self.dataAry.count>0) {
        
        return 10;

        
    }else{
        
        return (WINDOWRECT_WIDTH-20)/0.51+20;
 
    }
  

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPathP{
    
    return 150;
}
-(void)ledButtonClick:(UIButton *)btn{
    
    AllNetCell * cell =(AllNetCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[_tableView indexPathForCell:cell];
    CheckModel * model =self.dataAry[indexPath.row];
    
    
    shop.yhPrice  =   [NSString stringWithFormat:@"%@",model.yhPrice];
    shop.thumb    =   [NSString stringWithFormat:@"https:%@",model.imgStr];
    shop.sales    =   [NSString stringWithFormat:@"%@",model.sales];
    shop.title    =   model.title;
    shop.shoujia  =   [NSString stringWithFormat:@"%.2f",[model.price floatValue]];
    shop.quanhou  =   [NSString stringWithFormat:@"%.2f",[model.price floatValue]-[model.yhPrice floatValue]];
    shop.goodsId  =   [NSString stringWithFormat:@"%@",model.goodId];
    shop.url_shop =   model.shopUrl;
    shop.yhql     =   model.ledNum;
    shop.yhqsy    =   [NSString stringWithFormat:@"%@",model.leftNum];
    shop.guid_content=@"";

    
    if ([defaults objectForKey:@"mmNick"]==nil) {
        
        [self.view makeToast:@"请先登录阿里妈妈" duration:1 position:@"center"];
        
    }else{
        
        
        [self toChainWithModel:shop];

    }

    
}
-(void)toChainWithModel:(ShopModel *)model{

    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    NSString * user =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    NSString * url =[NSString stringWithFormat:@"http://api.tkjidi.com/index.php?m=App&a=locktaobao&timestamp=%@&nonce=%@&sign=%@",time,[NSString md5To32bit:once],sign];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:@{@"username":user,@"taobao_account":[defaults objectForKey:@"mmNick"]} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
        
        if ([returnData[@"status"] intValue]==200) {
            
            NetChainViewController * vc =[[NetChainViewController alloc]init];
            vc.model=model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            [weakSelf.view makeToast:returnData[@"msg"] duration:3 position:@"center"];
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
        
    } showHUD:NO];
    
   

}
#pragma mark---查询全网按钮事件
-(void)buttonRequest{
    
    //        if (isbtn==YES) {
    
    //            isbtn=NO;
    
    
    [textfield resignFirstResponder];
    
    _time =[ NSString stringWithFormat:@"%lld",[[Customer timeString] longLongValue]];
    
    if ([[textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0) {
        
        if ([textfield.text rangeOfString:@"http"].location!=NSNotFound) {
            
            [self.view makeToast:@"输入关键字搜索" duration:2 position:@"center"];
            
        }else{
            [self.dataAry removeAllObjects];
            
            [self requestDataWithItem:textfield.text];
            
        }
        
        
    }else{
        
        //            isbtn=YES;
        
        [self.view makeToast:@"请输入要搜索的商品" duration:2 position:@"center"];
        
    }
    
    
    //    }
    
}
-(void)requestDataWithItem:(NSString *)item{
    //时间戳
    NSString * time =[ NSString stringWithFormat:@"%lld",[[Customer timeString] longLongValue]];
    
    
    NSString * url =[NSString stringWithFormat:@"http://pub.alimama.com/items/search.json?&_t=%@&toPage=%d&dpyhq=1&perPageSize=20&shopTag=dpyhq&t=%@",_time,page,time];
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:url params:@{@"q":item} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
        
        
        if (returnData[@"data"][@"pageList"]!=[NSNull null]) {
            docsfound=[returnData[@"data"][@"head"][@"docsfound"]intValue];
            totalPage=[returnData[@"data"][@"head"][@"docsfound"]intValue]/20;
            id ary = returnData[@"data"][@"pageList"];
            for (NSDictionary * dic in ary) {
                CheckModel * model =[[CheckModel alloc]init];
                model.imgStr=dic[@"pictUrl"];
                
                //                NSArray * titleAry =[dic[@"title"] componentsSeparatedByString:@"<"];
                //                model.title =[NSString stringWithFormat:@"%@%@",[titleAry firstObject],[[[titleAry lastObject] componentsSeparatedByString:@">"] lastObject]];
                
                model.title=[[dic[@"title"] stringByReplacingOccurrencesOfString:@"<span class=H>" withString:@""] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                
                model.price=dic[@"zkPrice"];
                model.yhPrice=dic[@"couponAmount"];
                model.subtitle=dic[@"couponInfo"];
                model.goodId=dic[@"auctionId"];
                model.shopUrl=dic[@"auctionUrl"];
                model.ledNum=dic[@"couponTotalCount"];
                model.leftNum=dic[@"couponLeftCount"];
                model.sales=dic[@"biz30day"];
                
                if (dic[@"tkRate"]!=[NSNull null]) {
                    
                    model.pt=dic[@"tkRate"];
                    
                }
                
                
                if (dic[@"eventRate"]!=[NSNull null]) {
                    
                    model.gy=dic[@"eventRate"];
                    
                }
                
                
                if (dic[@"tkSpecialCampaignIdRateMap"]!=[NSNull null]) {
                    
                    NSDictionary * tkDic=dic[@"tkSpecialCampaignIdRateMap"];
                    NSArray * tkAry = tkDic.allValues;
                    model.dx = [tkAry valueForKeyPath:@"@max.floatValue"];
                    NSLog(@"定向>>>>>>>>%@",model.dx);
                    
                }else{
                    NSLog(@"======没有定向======");
                    
                }
                
                
                [weakSelf.dataAry addObject:model];
                
            }
            [weakSelf loadTableView];
            //            [_tableView reloadData];
            
            
        }else{
            
            [self.view makeToast:@"抱歉，没有找到相关商品！" duration:2 position:@"center"];
        }
        
        
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
        [_tableView reloadData];
        [self.view makeToast:@"网络拥堵，请稍后再试！" duration:2 position:@"center"];
        NSLog(@"%@",error);
        
    } showHUD:YES];
    
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
        
        
    }
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [self.view endEditing:YES];
    return YES;
    
}
-(void)addNavView{
    
    
    self.title=@"查全网券";
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bar;
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
    
}
-(void)backView
{
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
