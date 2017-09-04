//
//  NetViewController.m
//  TKJD
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NetViewController.h"
#import "SuperCell.h"
#import "NotPreCell.h"
#import "NetChainViewController.h"
@interface NetViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    int page;
    int totalPage;

    int docsfound;
    
    CGFloat  pt;
    CGFloat  gy;
    CGFloat  dx;
    
    
    NSString * queryType;
    NSString * sortType;
    NSString * shopTag;
    NSString * dpyhq;
    NSString * b2c;
    NSString * tb_token;

    
    NSString * account;
    
}
@property(nonatomic , strong)NSMutableArray * dataAry;
@property(nonatomic , strong)NSMutableArray * titleAry,* btns;
@property(nonatomic , strong)UITableView * tableView;
@end

@implementation NetViewController
-(NSMutableArray *)dataAry{
    
    if (!_dataAry) {
        _dataAry=[[NSMutableArray alloc]init];
        
    }
    
    return _dataAry;
}
-(NSMutableArray *)btns{
    
    if (!_btns) {
        _btns=[[NSMutableArray alloc]init];
        
    }
    
    return _btns;
}
-(NSMutableArray *)titleAry{
    
    if (!_titleAry) {
        
        _titleAry=[[NSMutableArray alloc]initWithObjects:@"综合排序",@"月销量",@"天猫",@"有券商品", nil];
    }
    
    return _titleAry;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, WINDOWRECT_WIDTH-20, WINDOWRECT_HEIGHT-254-self.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=UIColorFromRGB(0xf9f9f9);
    [self.tableView registerClass:[SuperCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NotPreCell class] forCellReuseIdentifier:@"pre"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
   
 
    queryType=@"0";
    sortType=@"";
    shopTag=@"";
    dpyhq=@"";
    
    tb_token=@"test";
    b2c=@"";
    
    page=1;
    

    [self requestDataWithItem:self.text];
    
    [self setup];

    
    
}
-(void)loadMoreData{
    
    page++;
    
    [self requestDataWithItem:self.text];
    
}
-(void)searchDataWithText:(NSString *)text{
    
    page=1;
    
    self.text=text;
 
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    [self requestDataWithItem:text];
    
}
-(void)setup{
    
    
    UIView * navView =[[UIView alloc]init];
    navView.backgroundColor=[UIColor whiteColor];
    navView.layer.borderWidth=1;
    navView.layer.borderColor=UIColorFromRGB(0xdcdcdc).CGColor;
    [self.view addSubview:navView];
    
    for (int i=0; i<4; i++) {
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.titleAry[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        if (i==0) {
            
            [btn setTitleColor:UIColorFromRGB(0xff4e36) forState:UIControlStateNormal];
        }
        btn.tag=100+i;
        [btn addTarget:self action:@selector(NavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.frame=CGRectMake((WINDOWRECT_WIDTH-20)/4*i, 0, (WINDOWRECT_WIDTH-20)/4, 40);
        [navView addSubview:btn];
        [self.btns addObject:btn];
    }
    
    navView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .widthIs(WINDOWRECT_WIDTH-20)
    .heightIs(40);
    
    


    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     NSLog(@"1111---%lu",(unsigned long)self.dataAry.count);
    
    return self.dataAry.count;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"1111---%lu",(unsigned long)self.dataAry.count);
    
    ShopModel * model =self.dataAry[indexPath.row];
    
    if ([model.yhPrice intValue]==0||(NSNull *)model.yhPrice==[NSNull null]) {
        
        NotPreCell * cell =[tableView dequeueReusableCellWithIdentifier:@"pre"];
        if (!cell) {
            
            cell=[[NotPreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pre"];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        cell.model=model;
        
         [cell.shareBut addTarget:self action:@selector(NotPreCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    
    }else{
        
        SuperCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
           
            cell=[[SuperCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        cell.model=model;
        
         [cell.shareBut addTarget:self action:@selector(SuperCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPathP{
    
    if (IPHONE5||IPHONE4) {
        
        return 130;
    }else{
        
        return 150;
    }
}
-(void)SuperCellButtonClick:(UIButton *)button{
    
    SuperCell * cell =(SuperCell *)[[button superview]superview];
    NSIndexPath * indexPath =[_tableView indexPathForCell:cell];
    ShopModel * model = _dataAry[indexPath.row];
    
    
    if ([defaults objectForKey:@"mmNick"]==nil) {
        
        PIDViewController * vc =[[PIDViewController alloc]init];
        vc.model=model;
        vc.isCheck=YES;
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        
        [self requestBindingWith:model];
    }
    
}
-(void)NotPreCellButtonClick:(UIButton *)button{
    NotPreCell * cell =(NotPreCell *)[[button superview]superview];
    NSIndexPath * indexPath =[_tableView indexPathForCell:cell];
    ShopModel * model = _dataAry[indexPath.row];
    
    if ([defaults objectForKey:@"mmNick"]==nil) {
        
        PIDViewController * vc =[[PIDViewController alloc]init];
        vc.model=model;
        vc.isCheck=YES;
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        
        [self requestBindingWith:model];
    }
    
    
}

-(void)NavButtonClick:(UIButton *)btn{
    NSLog(@"%@",self.text);
    
    for (UIButton * button in self.btns) {
        
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    [btn setTitleColor:UIColorFromRGB(0xff4e36) forState:UIControlStateNormal];
    
    page=1;
    
    if (btn.tag==100) {
       
        queryType=@"0";
        sortType=@"";
        shopTag=@"";
        dpyhq=@"";
        tb_token=@"test";
        b2c=@"";

    }else if(btn.tag==101){
  
        queryType=@"0";
        sortType=@"9";
        shopTag=@"";
        dpyhq=@"";
        tb_token=@"test";
        b2c=@"";
        
    }else if(btn.tag==102){
   
        queryType=@"";
        sortType=@"";
        dpyhq=@"";
        
        shopTag=@"b2c";
        tb_token=@"HsIDeOmdhuq";
        b2c=@"1";
        
    }else if(btn.tag==103){
        queryType=@"0";
        sortType=@"";
        shopTag=@"dpyhq";
        dpyhq=@"1";
        tb_token=@"test";
        b2c=@"";
        
    }
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    
    [self requestDataWithItem:self.text];
    
    
    
}
 -(void)requestDataWithItem:(NSString *)item{
 
    //时间戳
    NSString * time =[ NSString stringWithFormat:@"%lld",[[Customer timeString] longLongValue]];
    
    
    NSString * url =[NSString stringWithFormat:@"http://pub.alimama.com/items/search.json?&_t=%@&perPageSize=20&t=%@",time,time];
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:url params:@{@"q":item,@"toPage":@(page),@"dpyhq":dpyhq,@"shopTag":shopTag,@"queryType":queryType,@"sortType":sortType,@"b2c":b2c,@"_tb_token_":tb_token} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
     
        if (returnData[@"data"]!=[NSNull null]) {
            if (returnData[@"data"][@"pageList"]!=[NSNull null]) {
                
                if(page==1){
                    
                    [weakSelf.dataAry removeAllObjects];
                    
                }
                docsfound=[returnData[@"data"][@"head"][@"docsfound"]intValue];
                totalPage=[returnData[@"data"][@"head"][@"docsfound"]intValue]/20;
                id ary = returnData[@"data"][@"pageList"];
                for (NSDictionary * dic in ary) {
                    ShopModel * model =[[ShopModel alloc]init];
                    model.thumb=[NSString stringWithFormat:@"http:%@",dic[@"pictUrl"]];
                    
                    model.title=[[dic[@"title"] stringByReplacingOccurrencesOfString:@"<span class=H>" withString:@""] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                    NSString * price =dic[@"zkPrice"];
                    model.shoujia= [NSString stringWithFormat:@"%.2f",[price floatValue]];
                    model.yhPrice= [NSString stringWithFormat:@"%@",dic[@"couponAmount"]];
                    model.quanhou= [NSString stringWithFormat:@"%.2f",[model.shoujia floatValue]-[model.yhPrice floatValue]];
                    model.goodsId= [NSString stringWithFormat:@"%@",dic[@"auctionId"]];
                    model.url_shop=[NSString stringWithFormat:@"%@",dic[@"auctionUrl"]];
                    model.yhql=    [NSString stringWithFormat:@"%@",dic[@"couponTotalCount"]];
                    model.yhqsy=   [NSString stringWithFormat:@"%@",dic[@"couponLeftCount"]];
                    model.sales=   [NSString stringWithFormat:@"%@",dic[@"biz30day"]];
                    model.guid_content=@"";
                    
                    if (dic[@"tkRate"]!=[NSNull null]) {
                        
                        pt=[dic[@"tkRate"] floatValue];
                        
                    }else{
                        pt=0;
                    }
                    
                    
                    if (dic[@"eventRate"]!=[NSNull null]) {
                        
                        gy=[dic[@"eventRate"] floatValue];
                        
                        
                    }else{
                        
                        gy=0;
                    }
                    
                    
                    if (dic[@"tkSpecialCampaignIdRateMap"]!=[NSNull null]) {
                        
                        NSDictionary * tkDic=dic[@"tkSpecialCampaignIdRateMap"];
                        NSArray * tkAry = tkDic.allValues;
                        dx = [[tkAry valueForKeyPath:@"@max.floatValue"] floatValue];
                        //                    NSLog(@"定向>>>>>>>>%@",model.dx);
                        
                    }else{
                        dx=0;
                        NSLog(@"======没有定向======");
                        
                    }
                    NSLog(@"%.2f--%.2f---%.2f",dx,pt,gy);
                    model.rate=[NSString stringWithFormat:@"%.2f",YBMAX(dx, pt, gy)];
                    model.yj=[NSString stringWithFormat:@"%.2f",[model.quanhou floatValue]*[model.rate floatValue]/100];
                    
                    [weakSelf.dataAry addObject:model];
                    
                }

                
                [weakSelf.tableView reloadData];
                
            }

        }
     
         [weakSelf.tableView.mj_footer endRefreshing];

        
    } failureBlock:^(NSError *error) {
        
        [_tableView reloadData];
//        [self.view makeToast:@"网络拥堵，请稍后再试！" duration:2 position:@"center"];
        NSLog(@"%@",error);
        
    } showHUD:YES];
    
}
#pragma mark---绑定基地账号
-(void)requestBindingWith:(ShopModel *)model{
    
    LRLog(@"---------------------%@",model.url_shop);
    
    account=[defaults objectForKey:@"nick"];
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    NSString * user =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    NSString * url =[NSString stringWithFormat:@"http://api.tkjidi.com/index.php?m=App&a=locktaobao&timestamp=%@&nonce=%@&sign=%@",time,[NSString md5To32bit:once],sign];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:@{@"username":user,@"taobao_account":account} successBlock:^(id returnData, int code, NSString *msg) {
        
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
