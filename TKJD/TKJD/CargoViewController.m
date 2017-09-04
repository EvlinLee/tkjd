//
//  CargoViewController.m
//  HQ
//
//  Created by apple on 2017/7/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CargoViewController.h"
#import "itemCell.h"
#import "ShopModel.h"
@interface CargoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    NSString * account;
    UIView * lineView;
    NSString * order;
    UIView * navView;
    UIView * HeaderView;
    
    UIButton * topBut;
    
    int page;
}
@property(nonatomic , retain)UITableView * tableView;
@property(nonatomic , strong)NSMutableArray * dataAry;
@property(nonatomic , strong)NSMutableArray * heads;

@end

@implementation CargoViewController
-(NSMutableArray *)dataAry{
    
    if (!_dataAry) {
        
        _dataAry=[[NSMutableArray alloc]init];
        
    }
    
    return _dataAry;
}
-(NSMutableArray *)heads{
    
    if (!_heads) {
        
        _heads=[[NSMutableArray alloc]init];
        
    }
    
    return _heads;
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
    page=1;
    order=@"1";
    [self requestData];
    
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-64) style:UITableViewStylePlain];
    [self.tableView registerClass:[itemCell class] forCellReuseIdentifier:@"shop"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:[self tableViewHeader]];

    topBut=[[UIButton alloc]initWithFrame:CGRectMake(WINDOWRECT_WIDTH-55, WINDOWRECT_HEIGHT-100, 40, 40)];
    [topBut setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    [topBut addTarget:self action:@selector(returnTop) forControlEvents:UIControlEventTouchUpInside];
    topBut.hidden=YES;
    [self.view addSubview:topBut];

    
    [self setupRefreshH];
}
-(void)returnTop{
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
}
- (void)setupRefreshH
{
    
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooter)];
    
}
-(void)loadNewTopic{
    
    page=1;
    [self.dataAry removeAllObjects];
    [self requestData];
    
}
-(void)loadFooter{
    
    page++;
    LRLog(@">>>>%d",page);
    [self requestData];
    
}

-(UIView *)tableViewHeader{
    
    HeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, WINDOWRECT_WIDTH/3.4+40)];
    
    UIImageView * imageView =[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"cargo"];
    [HeaderView addSubview:imageView];
    
    
    NSArray *ary =[[NSArray alloc]initWithObjects:@"最新",@"销量",@"比例",@"优惠",@"价格",nil];
    
    navView=[[UIView alloc]init];
    navView.backgroundColor=[UIColor whiteColor];
    [HeaderView addSubview:navView];
    
    lineView =[[UIView alloc]init];
    lineView.backgroundColor=UIColorFromRGB(0xff1750);
    [navView addSubview:lineView];
    
    for (int i = 0 ; i < ary.count; i++) {
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        btn.tag=20+i;
        btn.frame=CGRectMake(WINDOWRECT_WIDTH/ary.count*i, 0, WINDOWRECT_WIDTH/ary.count, 39);
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
            lineView.center=CGPointMake(btn.center.x, btn.center.y+18);
            lineView.bounds=CGRectMake(0, 0, WINDOWRECT_WIDTH/ary.count, 1);
            
        }
        [btn addTarget:self action:@selector(headsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.heads addObject:btn];
        
        [navView addSubview:btn];
        
        
    }
    
    
    imageView.sd_layout
    .topSpaceToView(HeaderView, 0)
    .leftSpaceToView(HeaderView, 0)
    .rightSpaceToView(HeaderView, 0)
    .heightIs(WINDOWRECT_WIDTH/3.4);
    
    navView.sd_layout
    .topSpaceToView(imageView, 0)
    .leftSpaceToView(HeaderView, 0)
    .rightSpaceToView(HeaderView, 0)
    .heightIs(40);
    
    
    
    return HeaderView;
}
#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    itemCell * cell =[tableView dequeueReusableCellWithIdentifier:@"shop"];
    if (!cell) {
        cell =[[itemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shop"];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    ShopModel * model =self.dataAry[indexPath.row];
    
    cell.model=model;
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@""]];
    
    cell.titleLab.text=[NSString stringWithFormat:@"%@",model.title];
    
    
    
    NSString * priceStr =[NSString stringWithFormat:@"%@元",model.shoujia];
    NSUInteger pricelength=[priceStr length];
    
    NSMutableAttributedString *priceAttributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    
    [priceAttributedStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, pricelength)];
    cell.priceLab.attributedText=priceAttributedStr;

    cell.qhPriceLab.text=[NSString stringWithFormat:@"券后￥%@元",model.quanhou];

    NSString * yj =[NSString stringWithFormat:@"佣金￥%@",model.yj];

    
    NSUInteger length =[yj length];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:yj];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:14]
     
                          range:NSMakeRange(3, length-3)];
    
    cell.commissionLab.attributedText=AttributedStr;
    
    [cell.shareBut addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.buyBut addTarget:self action:@selector(buyButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IPHONE4||IPHONE5) {
        return 90;
        
    }else{
        
        return 100;
    }

}
-(void)cellBtnClick:(UIButton *)btn{
    
    itemCell * cell =(itemCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];
    
    ShopModel * model = self.dataAry[indexPath.row];
    
    if ([defaults objectForKey:@"mmNick"]==nil) {
        
        PIDViewController * vc =[[PIDViewController alloc]init];
        vc.model=model;
        vc.isCheck=YES;
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        
        [self requestBindingWith:model];
    }
    
    
    
    
}
#pragma mark---商品详情
-(void)buyButClick:(UIButton *)btn{
    
    
    itemCell * cell =(itemCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];
    ShopModel * model =self.dataAry[indexPath.row];
    
    DetailsViewController * vc =[[DetailsViewController alloc]init];
    vc.model=model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)headsBtnClick:(UIButton *)btn{
    
    [self.dataAry removeAllObjects];
    
    order=[NSString stringWithFormat:@"%d",(int)btn.tag-19];
    
    for (UIButton* btn in self.heads) {
        
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        
    }
    [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
    lineView.center=CGPointMake(btn.center.x, btn.center.y+18);
    lineView.bounds=CGRectMake(0, 0, WINDOWRECT_WIDTH/5, 1);
    
    [self requestData];
    
    
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
            
            SChainViewController * vc =[[SChainViewController alloc]init];
            vc.model=model;
            //            vc.isTabBar=YES;
            [weakSelf.navigationController pushViewController:vc animated:NO];
            
            
        }else{
            
            [weakSelf.view makeToast:returnData[@"msg"] duration:3 position:@"center"];
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
        
    } showHUD:NO];
    
}

#pragma mark---数据
-(void)requestData{
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    NSLog(@"%@",order);
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"agentslist",@"page":@(page),@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign,@"order":order,@"per":@"20",@"type":@"2"} successBlock:^(id returnData, int code, NSString *msg) {
        
                LRLog(@"%@",returnData[@"data"]);
        if ([returnData[@"status"] intValue]==200) {
            id array =returnData[@"data"];
            
            for (NSDictionary * dic in array ) {
                
                ShopModel * model =[[ShopModel alloc]initWithDictionary:dic];
                
                BOOL bfound= NO;
                
                for (ShopModel * oldModel in weakSelf.dataAry) {
                    
                    
                    if ([model.goodsId isEqualToString:oldModel.goodsId]) {
                        
                        bfound = YES;
                        
                    }
                    
                }
                
                if (bfound ==NO) {
                    
                    [weakSelf.dataAry addObject:model];
                }

                
            }
            
            [weakSelf.tableView reloadData];
            
        }else{
            
            [weakSelf.view makeToast:returnData[@"msg"] duration:1 position:@"center"];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
    } showHUD:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y>WINDOWRECT_WIDTH/3.4) {
        
        navView.frame=CGRectMake(0, 64, WINDOWRECT_WIDTH, 40);
        [self.view addSubview:navView];
        
    }else{
        navView.frame=CGRectMake(0, WINDOWRECT_WIDTH/3.4, WINDOWRECT_WIDTH, 40);
        [HeaderView addSubview:navView];
        
    }
    
    if (scrollView.contentOffset.y>WINDOWRECT_HEIGHT) {
        topBut.hidden=NO;
    }else{
        topBut.hidden=YES;
    }

    
}

-(void)addNavView
{
    
    self.title=@"看货";
    
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
