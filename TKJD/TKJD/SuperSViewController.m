//
//  SuperSViewController.m
//  TKJD
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperSViewController.h"
#import "SuperCell.h"
#import "NotPreCell.h"
#import "NetViewController.h"
#import "UIImage+Draw.h"
@interface SuperSViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>{
    
    int num;
    int page;
    
    NSString * account;
    
    UIView * view;
    UITableView * _tableView;
    UITextField * textfield;
    UIImageView * imageView;
    
    UIView * bgView;
    
    float height;
}
@property(nonatomic , strong)NSMutableArray * dataAry, * titleAry, * btns;
@property(nonatomic , strong)UIScrollView * scrollView , * bigScrollView;

@property(nonatomic , strong)NSString * order;
@end

@implementation SuperSViewController
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
        
        _titleAry=[[NSMutableArray alloc]initWithObjects:@"最新",@"销量",@"佣金",@"优惠",@"价格", nil];
    }
    
    return _titleAry;
}
-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView =[[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator=NO;
        
     

        
        UIImageView * imageview =[[UIImageView alloc]init];
        imageview.image=[UIImage imageNamed:@"s_bg"];
        [_scrollView addSubview:imageview];
        
        
        imageview.sd_layout
        .topSpaceToView(_scrollView, 0)
        .leftSpaceToView(_scrollView, 0)
        .rightSpaceToView(_scrollView, 0)
        .heightIs((WINDOWRECT_WIDTH-20)/0.43);
        
        _scrollView.contentSize=CGSizeMake(0, (WINDOWRECT_WIDTH-20)/0.43);
        
    }
    
    return _scrollView;
}
-(UIScrollView *)bigScrollView{
    
    if (!_bigScrollView) {
        
        _bigScrollView =[[UIScrollView alloc]init];
        _bigScrollView.showsVerticalScrollIndicator=NO;
        _bigScrollView.showsHorizontalScrollIndicator=NO;
        _bigScrollView.pagingEnabled=YES;
        _bigScrollView.delegate=self;
        _bigScrollView.tag=2000;
        [self.view addSubview:_bigScrollView];
        
        _bigScrollView.sd_layout
        .topSpaceToView(self.view, 204)
        .leftSpaceToView(self.view,10)
        .rightSpaceToView(self.view,10)
        .bottomSpaceToView(self.view,10+height);
        
        
        self.bigScrollView.contentSize=CGSizeMake(2*(WINDOWRECT_WIDTH-20), 0);
    }
    
    return _bigScrollView;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.isTab==YES) {
        
        ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
        tabbar.tabbar.hidden = YES;
        
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=UIColorFromRGB(0xf9f9f9);
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self addNavView];
    
    self.order=@"1";
    page=1;
    num=0;
 
    if (self.isTab==YES) {
        
        
        height=0;
        
    }else{
        
        height=40;
        
    }
    
    [self addCheckView];

    [self.view addSubview:self.scrollView];

    
    self.scrollView.sd_layout
    .topSpaceToView(self.view, 204)
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .bottomSpaceToView(self.view,10+height);
    
}
-(UIButton *)searchButtonWithTitle:(NSString *)title{
    
    UIButton *  btn =[UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.backgroundColor=[UIColor orangeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:16];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    
    
    
    return btn;
    
}
-(void)addCheckView{
    
    
    view =[[UIView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, 140)];
    view.backgroundColor=UIColorFromRGB(0xf9f9f9);
    [self.view addSubview:view];
    
    
    UIView * textview= [[UIView alloc]init];
    textview.layer.borderColor=UIColorFromRGB(0xfa8853).CGColor;
    textview.layer.borderWidth=1;
    textview.backgroundColor=[UIColor whiteColor];
    textview.layer.masksToBounds=YES;
    textview.layer.cornerRadius=15;
    [view addSubview:textview];
    
    imageView =[[UIImageView alloc]init];
    [view addSubview:imageView];

    
    textfield =[[UITextField alloc]init];
    textfield.delegate=self;
    textfield.clearButtonMode=UITextFieldViewModeAlways;
    textfield.font=[UIFont systemFontOfSize:14];
    textfield.backgroundColor=[UIColor whiteColor];
    //    textfield.text=self.text;
    textfield.placeholder=@"商品标题或全名称查询全网优惠券";
    textfield.returnKeyType=UIReturnKeyDone;
//    textfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
//    textfield.leftViewMode = UITextFieldViewModeAlways;
    [textview addSubview:textfield];
    
    
    UIButton * bigBtn =[self searchButtonWithTitle:@"独家大额券"];
    bigBtn.backgroundColor=UIColorFromRGB(0xff4d36);
    bigBtn.tag=10;
    [bigBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * allBtn =[self searchButtonWithTitle:@"全网券查询"];
    allBtn.backgroundColor=UIColorFromRGB(0xfa8853);
    allBtn.tag=20;
    [allBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * seachBtn =[self searchButtonWithTitle:@"搜索"];
    seachBtn.backgroundColor=UIColorFromRGB(0xfa8853);
    seachBtn.tag=30;
    [seachBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubviews:@[bigBtn ,allBtn,textview,seachBtn]];
    
    textview.sd_layout
    .topSpaceToView(view, 20)
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 80)
    .heightIs(40);
    
    
    textfield.sd_layout
    .topSpaceToView(textview, 0)
    .leftSpaceToView(textview, 20)
    .rightSpaceToView(textview, 10)
    .heightIs(40);
    
    
    seachBtn.sd_layout
    .topSpaceToView(view, 20)
    .leftSpaceToView(textview, 10)
    .rightSpaceToView(view, 20)
    .heightIs(40);
    
    bigBtn.sd_layout
    .topSpaceToView(textview, 20)
    .leftSpaceToView(view,10)
    .widthIs((WINDOWRECT_WIDTH-40)/2)
    .heightIs(35);
   
    allBtn.sd_layout
    .topSpaceToView(textview, 20)
    .rightSpaceToView(view,10)
    .widthIs((WINDOWRECT_WIDTH-40)/2)
    .heightIs(35);
   
}
-(void)loadNetView{
    
    NetViewController * vc =[[NetViewController alloc]init];
  
    vc.height=height;
    
    vc.text=textfield.text;

    vc.view.frame=CGRectMake(WINDOWRECT_WIDTH-20, 0, WINDOWRECT_WIDTH-20, WINDOWRECT_HEIGHT-214-height);
    
    [self addChildViewController:vc];
    
    
    [self.bigScrollView addSubview:vc.view];

//    self.bigScrollView.contentSize=CGSizeMake(2*(WINDOWRECT_WIDTH-20), 0);
    
    
    
}
-(void)loadTableView{
    
    if (!bgView) {
       
        bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH-20, WINDOWRECT_HEIGHT-214-height)];
        [self.bigScrollView addSubview:bgView];
        
      

        UIView * navView =[[UIView alloc]init];
        navView.backgroundColor=[UIColor whiteColor];
        navView.layer.borderWidth=1;
        navView.layer.borderColor=UIColorFromRGB(0xdcdcdc).CGColor;
        [bgView addSubview:navView];
        
        for (int i=0; i<5; i++) {
            
            UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.titleAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            if (i==0) {
                
                [btn setTitleColor:UIColorFromRGB(0xff4e36) forState:UIControlStateNormal];
                
            }
            btn.tag=i+100;
            [btn addTarget: self action:@selector(NavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            btn.frame=CGRectMake((WINDOWRECT_WIDTH-20)/5*i, 0, (WINDOWRECT_WIDTH-20)/5, 40);
            [navView addSubview:btn];
            [self.btns addObject:btn];
            
        }
        
        navView.sd_layout
        .topSpaceToView(bgView, 0)
        .leftSpaceToView(bgView, 0)
        .rightSpaceToView(bgView, 0)
        .heightIs(40);
        
        
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, WINDOWRECT_WIDTH-20, bgView.height-42) style:UITableViewStyleGrouped];
        _tableView.backgroundColor=UIColorFromRGB(0xf9f9f9);
        [_tableView registerClass:[SuperCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[NotPreCell class] forCellReuseIdentifier:@"pre"];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [bgView addSubview:_tableView];
       
       
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        
        
        
    }else{
        
        [_tableView reloadData];
        NSLog(@"11111");
    }

}
-(void)loadMoreData{
    
    page++;
    
    [self requestData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataAry.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopModel * model =self.dataAry[indexPath.row];
    
    if ([model.yhPrice isEqualToString:@""]||(NSNull *)model.yhPrice==[NSNull null]) {
        
        NotPreCell * cell =[tableView dequeueReusableCellWithIdentifier:@"pre"];
        if (!cell) {
            
            cell=[[NotPreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pre"];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.model=model;
        
        [cell.shareBut addTarget:self action:@selector(NotPreCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else{
        
        SuperCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[SuperCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
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
-(void)NavBtnClick:(UIButton *)btn{
    
    
    for (UIButton * button in self.btns) {
        
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:UIColorFromRGB(0xff4e36) forState:UIControlStateNormal];
    
    self.order=[NSString stringWithFormat:@"%d",(int)btn.tag-99];
    
    page=1;
    
    [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    
    
    
    [self requestData];
    
 
}

-(void)BtnClick:(UIButton *)btn{
    if (textfield.text==nil||textfield.text.length==0) {
        
        [self.view makeToast:@"搜索的商品名称不能为空" duration:1 position:@"center"];
        
        
    }else{
        
        [self.view endEditing:YES];
        [self.scrollView removeFromSuperview];

        if (num==0) {
            
            [self loadNetView];
            
        }else{
            
            NetViewController * vc =self.childViewControllers[0];

            [vc searchDataWithText:textfield.text];
        }
        num++;
        
        page=1;
        [self.dataAry removeAllObjects];
        [self requestData];
        
        
        if (btn.tag==10) {
            
            UIImage  * image =[UIImage triangleImageWithSize:CGSizeMake(15, 5) tintColor:UIColorFromRGB(0xff4d36)];
            imageView.image=image;
            imageView.center=CGPointMake(btn.center.x, btn.center.y+20);
            imageView.bounds=CGRectMake(0, 0, 15, 5);
            
            [self.bigScrollView setContentOffset:CGPointMake(0, 0)];
            
            
        }else if (btn.tag==20){

            
            UIImage  * image =[UIImage triangleImageWithSize:CGSizeMake(15, 5) tintColor:UIColorFromRGB(0xfa8853)];
            imageView.image=image;
            imageView.center=CGPointMake(btn.center.x, btn.center.y+20);
            imageView.bounds=CGRectMake(0, 0, 15, 5);
            
            [self.bigScrollView setContentOffset:CGPointMake(WINDOWRECT_WIDTH-20, 0)];
            
        }else{

            
            UIImage  * image =[UIImage triangleImageWithSize:CGSizeMake(15, 5) tintColor:UIColorFromRGB(0xff4d36)];
            imageView.image=image;
            
            UIButton * button =(UIButton *)[view viewWithTag:10];
            
            imageView.center=CGPointMake(button.center.x, button.center.y+20);
            imageView.bounds=CGRectMake(0, 0, 15, 5);
           
            [self.bigScrollView setContentOffset:CGPointMake(0, 0)];

            
        }

    }
    
}
-(void)requestData{
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"pro_list",@"cate_id":@"",@"order":self.order,@"kwd":textfield.text,@"page":@(page),@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign} successBlock:^(id returnData, int code, NSString *msg) {
        
        
        LRLog(@"%@",returnData);
        
        if (returnData[@"data"]!=nil) {
            
            if(page==1){
                
                [weakSelf.dataAry removeAllObjects];

            }
            
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
            
            if (weakSelf.dataAry.count==0) {
                
                [weakSelf.view makeToast:@"没有该商品" duration:2 position:@"center"];
                
            }else{
                
                
                if (array.count!=0) {
                    
                    [weakSelf loadTableView];
                    
                    
                }else{
                    
                    [weakSelf.view makeToast:@"加载完毕" duration:2 position:@"center"];
                    
                    
                }
                
                
                
            }
            
        }
        
     [_tableView.mj_footer endRefreshing];
        
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

        
    int index =scrollView.contentOffset.x/(WINDOWRECT_WIDTH-20);
    
    NSLog(@"%d",index);
    
    if (scrollView.tag==2000) {
        if (index==0) {
            
            UIButton *button =(UIButton *)[view viewWithTag:10];
            
            UIImage  * image =[UIImage triangleImageWithSize:CGSizeMake(15, 5) tintColor:UIColorFromRGB(0xff4d36)];
            imageView.image=image;
            imageView.center=CGPointMake(button.center.x, button.center.y+20);
            imageView.bounds=CGRectMake(0, 0, 15, 5);

        }else{
            
            UIButton *button =(UIButton *)[view viewWithTag:20];
            
            UIImage  * image =[UIImage triangleImageWithSize:CGSizeMake(15, 5) tintColor:UIColorFromRGB(0xfa8853)];
            imageView.image=image;
            imageView.center=CGPointMake(button.center.x, button.center.y+20);
            imageView.bounds=CGRectMake(0, 0, 15, 5);
        }

    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}
-(void)addNavView{
    
    
    self.title=@"超级搜";
    if (self.isTab==YES) {
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = bar;
        backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
    }

    
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
