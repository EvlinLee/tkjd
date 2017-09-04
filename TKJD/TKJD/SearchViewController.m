//
//  SearchViewController.m
//  TKJD
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SearchViewController.h"
#import "itemCell.h"
#import "ShopModel.h"
#import "SChainViewController.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    int page;
    NSString * account;
    NSArray * headings;
}
@property(nonatomic ,retain)UITableView * tableView;
@property(nonatomic , retain)NSMutableArray * dataAry;
@property(nonatomic,retain)NSMutableArray* heads;
@property(nonatomic , strong)NSString * order;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self addNavView];
    

    _dataAry=[[NSMutableArray alloc]init];
    _heads=[[NSMutableArray alloc]init];
    self.order=@"1";
    page=1;
    
    headings = @[@"最新",@"销量",@"佣金",@"优惠",@"价格"];
    
    for (int i =0 ; i<headings.count; i++) {
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        btn.tag=20+i;
        btn.frame=CGRectMake(WINDOWRECT_WIDTH/headings.count*i, 64, WINDOWRECT_WIDTH/headings.count, 40);
        [btn setTitle:headings[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.backgroundColor=UIColorFromRGB(0xf5f5f5);
        if (i==0) {
            [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(headingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.heads addObject:btn];
        
        [self.view addSubview:btn];
        
        
    }
    
    for (int i=0; i<4; i++) {
        
        UIView * line =[[UIView alloc]init];
        
        line.backgroundColor=UIColorFromRGB(0xd3d3d3);
        
        
        
        line.frame=CGRectMake(WINDOWRECT_WIDTH/headings.count*(i+1), 64, 1, 40);
        
        
        
        [self.view addSubview:line];
        
    }

    
    
    
    [self requestData];
    [self loadTableView];
    
}
-(void)headingBtnClick:(UIButton *)btn{

    self.order=[NSString stringWithFormat:@"%d",(int)btn.tag-19];
    
    page=1;
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];

    
    [self.dataAry removeAllObjects];
    

    [self requestData];
    

    [self.tableView reloadData];
    
    for (UIButton* btn in self.heads) {
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
    
    
    
    
}
-(void)loadTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 104, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-104) style:UITableViewStylePlain];
    //    self.tableView.backgroundColor=[UIColor orangeColor];
    [self.tableView registerClass:[itemCell class] forCellReuseIdentifier:@"choose"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    self.tableView.mj_footer = footer;
    
    
}
-(void)loadMoreData{
    
    page++;

    [self requestData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return _dataAry.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    itemCell * cell =[tableView dequeueReusableCellWithIdentifier:@"choose"];
    if (!cell) {
        cell =[[itemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choose"];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    ShopModel * model =_dataAry[indexPath.row];
    
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
    
    //    cell.proportionLab.text=[NSString stringWithFormat:@"比例:%@%%",model.rate];
    
    [cell.shareBut addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.buyBut addTarget:self action:@selector(buyButClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    ShopModel * model =_dataAry[indexPath.row];
//    DetailsViewController * vc =[[DetailsViewController alloc]init];
//    vc.urlStr=model.url_shop;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
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
#pragma mark---商品详情
-(void)buyButClick:(UIButton *)btn{
    
    
    itemCell * cell =(itemCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];
    ShopModel * model =self.dataAry[indexPath.row];
    
    DetailsViewController * vc =[[DetailsViewController alloc]init];
    vc.model=model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)requestData{
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];

    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"pro_list",@"cate_id":@"",@"order":weakSelf.order,@"kwd":weakSelf.text,@"page":@(page),@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign} successBlock:^(id returnData, int code, NSString *msg) {
        

        LRLog(@"%@",returnData);
        
        if (returnData[@"data"]!=nil) {

            NSArray * array =returnData[@"data"];

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
            
            if (_dataAry.count==0) {
                
                [self.view makeToast:@"没有该商品" duration:2 position:@"center"];
                
            }else{
                
            
                if (array.count!=0) {
                    
                    [weakSelf.tableView reloadData];

                    
                }else{
                    
                    [self.view makeToast:@"加载完毕" duration:2 position:@"center"];

                    
                }
                
                
            
            }
  
        }

        [weakSelf.tableView.mj_footer endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
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

-(void)addNavView
{
    
    self.title=@"搜索结果";
    
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
