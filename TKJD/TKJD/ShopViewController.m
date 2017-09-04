//
//  ShopViewController.m
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopModel.h"
#import "ClassModel.h"
#import "itemCell.h"
#import "ClassView.h"
#import "PIDViewController.h"
#import "ChainViewController.h"
//#import "setViewController.h"
#import "PYSearchViewController.h"
#import "SearchViewController.h"

#import "loginViewController.h"
#import "CheckViewController.h"
#import "SChainViewController.h"
#import "SuperSViewController.h"

#import "HotViewController.h"
#import "BigViewController.h"
#import "CargoViewController.h"
#import "AllNetViewController.h"

@interface ShopViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    CGFloat font;
    
    NSMutableArray * dataAry;
    NSMutableArray * bannerAry;
    UIButton * topBut;
 
    MBProgressHUD * HUD;
    
    BOOL isSelected;
    BOOL isOK;
    
    NSArray * navTitle;

    NSString * account;
    
    NSString * kwd;
    
    
    NSString * versionCode;
    NSString * versionContent;
    
    
    int page;
    float height;
    float bannerHL;
    
    CGFloat threshild;
    CGFloat itrmPerPage;
    CGFloat currentPage;
  
}
@property(nonatomic , strong)NSString * order;
@property(nonatomic , strong)NSString * cate;
@property(nonatomic , retain)UITableView * tableView;

@property(nonatomic,retain)NSMutableArray* btns;
@property(nonatomic,retain)NSMutableArray* heads;
@property(nonatomic,strong)NSMutableArray* classAry;

@property(nonatomic,retain)UIView* navView;
@property(nonatomic,retain)UIView* bottomLine;
@property(nonatomic,retain)UIView* hearView;
@property(nonatomic,assign)CGFloat nav_x;
@property(nonatomic,retain)UIScrollView * navScroll;
@end

@implementation ShopViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = NO;

}
-(NSMutableArray *)classAry{
    
    if (!_classAry) {
        
        _classAry=[[NSMutableArray alloc]init];
        
    }
    
    return _classAry;
}
-(NSMutableArray *)heads{
    
    if (!_heads) {
        
        _heads=[[NSMutableArray alloc]init];
        
    }
    return _heads;
    
}
-(NSMutableArray *)btns{
    
    if (!_btns) {
        
        _btns=[[NSMutableArray alloc]init];
        
    }
    return _btns;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
   
    [self addNavView];
    
    if (IPHONE4||IPHONE5) {
        
     
        font=14;
        
    }else if (iPhone6Plus_6sPlus){
        
      
        font=16;
        
    }else if (iPhone6_6s){
        
        font=16;
       
    }else {
     
        font=14;
        
    }
    threshild=0.7;
    itrmPerPage=20;
    currentPage=0;
    
    dataAry=[[NSMutableArray alloc]init];


//    [self requestLoginTime];
    
    isOK=YES;
    page=1;
    self.order=@"1";
    kwd=@"";
    
    navTitle = @[@"最新",@"销量",@"佣金",@"优惠",@"价格"];


    [self requestBanner];

    [self loadTableView];

}

-(void)loadTableView{
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 102, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-142) style:UITableViewStylePlain];
    [self.tableView registerClass:[itemCell class] forCellReuseIdentifier:@"item"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
    topBut=[[UIButton alloc]initWithFrame:CGRectMake(WINDOWRECT_WIDTH-55, WINDOWRECT_HEIGHT-125, 40, 40)];
    [topBut setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    [topBut addTarget:self action:@selector(returnTop) forControlEvents:UIControlEventTouchUpInside];
    topBut.hidden=YES;
    [self.view addSubview:topBut];


    [self setupRefreshH];
}
//--------返回顶部----
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
  
    isSelected=YES;
    [self requestData];

}
-(void)loadFooter{
    
    page++;
    LRLog(@">>>>%d",page);
    [self requestData];

}
-(void)tableHeaderView{
    

    
    height =120*HL+47+70+87*HL;

    self.hearView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH,height)];
    
    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, 120*HL) imageURLStringsGroup:bannerAry];
    banner.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    banner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //    banner.delegate=self;
    [self.hearView addSubview:banner];
    
    
    UIView *bgView = [[UIView alloc]init];
    [self.hearView addSubview:bgView];
    
    NSMutableArray * temp =[NSMutableArray new];
    for (int i = 0; i < 4; i++)
    {
        
        NSString *str = nil;
        NSString *imgS = nil;
        
        switch (i)
        {
            case 0:
                str = @"8.8包邮";
                
                imgS = @"rm";
                
                break;
            case 1:
                str = @"看货";
                
                imgS = @"sp";
                
                
                break;
            case 2:
                str = @"大牌券";
                
                imgS = @"pp";
                
                break;
            case 3:
                str = @"查全网券";
                
                imgS = @"search";
                
                break;
                
            default:
                break;
                
        }
        
        UIButton * btn =[[UIButton alloc]init];
        btn.tag = i;
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgS] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtnH:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
        [bgView addSubview:btn];
        
        btn.sd_layout.autoHeightRatio(0.8);
        
        btn.imageView.sd_layout.widthRatioToView(btn,0.6).topSpaceToView(btn,0).centerXEqualToView(btn).heightRatioToView(btn,0.6);
        btn.titleLabel.sd_layout.topSpaceToView(btn.imageView,7).leftEqualToView(btn).rightEqualToView(btn).bottomSpaceToView(btn,3);
        
        
        [temp addObject:btn];
        
    }
    
    bgView.sd_layout.leftSpaceToView(self.hearView,0).rightSpaceToView(self.hearView,0).topSpaceToView(banner,4);
    
    [bgView setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:5 horizontalMargin:5 verticalEdgeInset:5 horizontalEdgeInset:5];
    
    
    
    UIView * line =[[UIView alloc]init];
    line.backgroundColor=[UIColor whiteColor];
    [self.hearView addSubview:line];
    
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hqzb"]];
    [self.hearView addSubview:image];
    
    
    _navView=[[UIView alloc]init];
    [self.hearView addSubview:_navView];
    
    
    UIView * line1 =[[UIView alloc]init];
    line1.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [self.hearView addSubview:line1];
    
    UIView * line2 =[[UIView alloc]init];
    line2.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [_navView addSubview:line2];
    
    line.sd_layout
    .topSpaceToView(bgView, 0)
    .leftSpaceToView(self.hearView, 0)
    .rightSpaceToView(self.hearView, 0)
    .heightIs(2);
    
    
    image.sd_layout
    .topSpaceToView(line,0)
    .centerXEqualToView(self.hearView)
    .widthIs(210)
    .heightIs(35);
    
    line1.sd_layout
    .topSpaceToView(image, 10)
    .leftSpaceToView(self.hearView, 0)
    .rightSpaceToView(self.hearView, 0)
    .heightIs(1);
    
    _navView.sd_layout
    .bottomSpaceToView(self.hearView,1)
    .leftSpaceToView(self.hearView,0)
    .rightSpaceToView(self.hearView,0)
    .heightIs(70);
    
    line2.sd_layout
    .topSpaceToView(_navView, 39)
    .leftSpaceToView(_navView, 0)
    .rightSpaceToView(_navView, 0)
    .heightIs(1);
    
    [self setHeadings:navTitle];
    
    [self.tableView setTableHeaderView:self.hearView];
    
    [self setMenuTitles:self.classAry];
 
    
    
    
}
-(void)setMenuTitles:(NSArray *)titles{
    
    _nav_x=10;

    
    _navScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, 38)];
    _navScroll.showsHorizontalScrollIndicator=NO;
    _navScroll.showsVerticalScrollIndicator=NO;
    _navScroll.scrollsToTop=NO;
    _navScroll.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_navScroll];
    
    
    UIView * line =[[UIView alloc]init];
    line.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:line];
    line.sd_layout
    .topSpaceToView(_navScroll, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(1);

    for (int i=0; i<titles.count; i++) {
        
        ClassModel * model =titles[i];
        
        NSString* title=model.classname;
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_nav_x, 5, size.width+10, 30);
//        btn.backgroundColor=[UIColor orangeColor];
        btn.tag=i;
        
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
            
            _bottomLine=[[UIView alloc] init];
            _bottomLine.center=CGPointMake(btn.centerX, btn.centerY+17);
            _bottomLine.bounds=CGRectMake(0, 0, size.width+4, 2);
            _bottomLine.backgroundColor=UIColorFromRGB(0xff1750);
            [_navScroll addSubview:_bottomLine];
            
        }
        
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(btnItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [self.btns addObject:btn];
        [btn setTitle:title forState:UIControlStateNormal];
        [_navScroll addSubview:btn];
        
        _nav_x=_nav_x+size.width+20;
        
    }
    _navScroll.contentSize=CGSizeMake(_nav_x, 0);
    
}
-(void)setHeadings:(NSArray *)headings{
    
    for (int i =0 ; i<headings.count; i++) {
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        btn.tag=20+i;
        btn.frame=CGRectMake(WINDOWRECT_WIDTH/headings.count*i, 40, WINDOWRECT_WIDTH/headings.count, 30);
        [btn setTitle:headings[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.backgroundColor=UIColorFromRGB(0xf5f5f5);
        if (i==0) {
            [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(headingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.heads addObject:btn];
        
        [_navView addSubview:btn];
        
        
    }
    
    for (int i=0; i<4; i++) {
        
        UIView * line =[[UIView alloc]init];
        
        line.backgroundColor=UIColorFromRGB(0xd3d3d3);
        
        line.frame=CGRectMake(WINDOWRECT_WIDTH/headings.count*(i+1), 40, 1, 30);
        
        [_navView addSubview:line];

    }

    
    NSArray * class =@[@"聚划算",@"淘抢购",@"天猫",@"运费险",@"金牌卖家"];
    UIView * classView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, 39)];
    classView.backgroundColor=[UIColor whiteColor];
    [_navView addSubview:classView];
    for (int i=0; i<class.count; i++) {
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        btn.frame=CGRectMake(WINDOWRECT_WIDTH/class.count*i, 0, WINDOWRECT_WIDTH/class.count, 39);
        [btn setTitle:class[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
//        btn.backgroundColor=UIColorFromRGB(0xf5f5f5);
        if (i==0) {
            [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
        }
        [classView addSubview:btn];
        [btn addTarget:self action:@selector(classButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    

    NSString * value =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSArray * valueAry = [value componentsSeparatedByString:@"."];
    NSArray * codeAry  = [versionCode componentsSeparatedByString:@"."];
    if (versionCode!=NULL) {
        if ([[codeAry lastObject] intValue]==0) {
            
            if(![versionCode isEqualToString:value]){
                
                
                [self setup];
            }

            
        }else{
            LRLog(@"%d--%d",[[codeAry lastObject] intValue],[[valueAry lastObject] intValue]);
            if ([[codeAry lastObject] intValue]>[[valueAry lastObject] intValue]) {
                
                [self setup];
            }
            
        }

    }
   
}

#pragma mark--版本更新
-(void)setup{
    
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"版本更新" message:versionContent preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alertVc dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertVc addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到AppStore，该App下载界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E6%B7%98%E5%AE%A2%E6%89%8B%E6%9C%BA%E7%BE%A4%E5%8F%91/id1208902638?mt=8"]];
    }];
    [alertVc addAction:action2];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
}


#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    itemCell * cell =[tableView dequeueReusableCellWithIdentifier:@"item"];
    if (!cell) {
        cell =[[itemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"item"];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    ShopModel * model =dataAry[indexPath.row];
    
    
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
     
                          value:[UIFont systemFontOfSize:font]
     
                          range:NSMakeRange(3, length-3)];
    
    cell.commissionLab.attributedText=AttributedStr;
    
    //    cell.proportionLab.text=[NSString stringWithFormat:@"比例:%@%%",model.rate];
    
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
#pragma mark---商品详情
-(void)buyButClick:(UIButton *)btn{
    

    itemCell * cell =(itemCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];
    ShopModel * model =dataAry[indexPath.row];
    
    
    
    DetailsViewController * vc =[[DetailsViewController alloc]init];
    vc.model=model;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark---推广详情
-(void)cellBtnClick:(UIButton *)btn{

    itemCell * cell =(itemCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];

    ShopModel * model = dataAry[indexPath.row];
   
    
    if ([defaults objectForKey:@"mmNick"]==nil) {
        
        PIDViewController * vc =[[PIDViewController alloc]init];
        vc.model=model;
        vc.isCheck=YES;
        [self.navigationController pushViewController:vc animated:NO];
   
    }else{
        
        [self requestBindingWith:model];
    }

}

#pragma mark ---分类

-(void)btnItemAction:(id)sender{
    
    UIButton* btn=(UIButton*)sender;
    if (self.block) {
        self.block(btn.tag);
    }
  
    ClassModel * model =self.classAry[btn.tag];

//    if (btn.tag==0) {
//        self.cate=@"";
//    }else{
    
        self.cate=model.idStr;
//    }
    
    page=1;
    
    isSelected=YES;


    
    [self moveInIndex:btn.tag];


    
}
-(void)classButtonClick:(UIButton *)btn{
    
    
    

}

-(void)moveInIndex:(NSInteger)index{
    

     [self.tableView setContentOffset:CGPointMake(0, height-71) animated:NO];
    
    for (UIButton* btn in self.btns) {
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    
    UIButton* btn=(UIButton*)self.btns[index];
    [btn setTitleColor:self.bottomLine.backgroundColor forState:UIControlStateNormal];

    
    
    [UIView animateWithDuration:0.4 animations:^{

        CGSize size =[btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.bottomLine.center=CGPointMake(btn.center.x, btn.center.y+17);
        self.bottomLine.bounds=CGRectMake(0, 0, size.width+4, 2);
        
        if (btn.center.x>_navScroll.bounds.size.width/2&&_navScroll.contentSize.width-_navScroll.bounds.size.width/2>btn.center.x) {
            
            _navScroll.contentOffset=CGPointMake(btn.center.x-_navScroll.bounds.size.width/2, 0);
            
        }else if(btn.center.x>_navScroll.contentSize.width-_navScroll.frame.size.width/2)
        {
            _navScroll.contentOffset=CGPointMake(_navScroll.contentSize.width-_navScroll.bounds.size.width, 0);
        }else
        {
            _navScroll.contentOffset=CGPointMake(0, 0);
        }
        
       
    }];
    
    
    
    [self requestData];
    

}


-(void)headingBtnClick:(UIButton *)btn{
    
    isSelected=YES;
    self.order=[NSString stringWithFormat:@"%d",(int)btn.tag-19];
    
    page=1;
    
    [self requestData];
    
    [self.tableView setContentOffset:CGPointMake(0, height-71) animated:NO];
    
    for (UIButton* btn in self.heads) {
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:UIColorFromRGB(0xff1750) forState:UIControlStateNormal];
    

    

}
#pragma mark---按钮事件
-(void)clickBtnH:(UIButton *)btn{
    
    
    switch (btn.tag) {
        case 0:{
            
            HotViewController * vc =[[HotViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:{
            
            CargoViewController * vc =[[CargoViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 2:{
            
            BigViewController * vc =[[BigViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:{
            
            SuperSViewController * vc =[[SuperSViewController alloc]init];
            vc.isTab=YES;
            [self.navigationController pushViewController:vc animated:YES];
            
      
            
        }
            break;
            
        default:
            break;
    }
 
}
#pragma mark---搜索
-(void)searchClick{
  
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索商品" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        
        LRLog(@"1111%@",searchText);
        
        SearchViewController * vc =[[SearchViewController alloc] init];
        
        vc.text=searchText;
        
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    
//    [self.navigationController pushViewController:searchViewController animated:YES];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
  
}
#pragma mark---数据
-(void)requestData{
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];

    NSLog(@"%@",self.cate);
    
      __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"pro_list",@"class_id":weakSelf.cate,@"order":weakSelf.order,@"kwd":kwd,@"page":@(page),@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign} successBlock:^(id returnData, int code, NSString *msg) {
        
        if (isSelected==YES) {
            
            [dataAry removeAllObjects];

            isSelected=NO;
        }

        LRLog(@"%@",returnData);
        if (returnData[@"data"]!=nil) {
            id array =returnData[@"data"];

            
            for (NSDictionary * dic in array ) {
                
                ShopModel * model =[[ShopModel alloc]initWithDictionary:dic];
                
//                NSLog(@"》》》》%@",model.class_name);

                BOOL bfound= NO;
                
                for (ShopModel * oldModel in dataAry) {
                    
                    
                    if ([model.goodsId isEqualToString:oldModel.goodsId]) {
                        
                        bfound = YES;
                        
                    }
                    
                }
                
                if (bfound ==NO) {
                    
                    [dataAry addObject:model];
                }

               
            }

            [weakSelf.tableView reloadData];


        }
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
    } showHUD:NO];
    
}
-(void)requestBanner{
    
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"banner1",@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign} successBlock:^(id returnData, int code, NSString *msg) {
        
      bannerAry=[[NSMutableArray alloc]init];

        LRLog(@"%@",returnData);
        
        if (code==0) {
            id ary =returnData[@"data"];
            for (NSDictionary * dic in ary) {
                
                NSString * content =dic[@"content"];
                
                LRLog(@"%@",content);
                
                [bannerAry addObject:content];
            }
            
            if ((NSNull *)returnData[@"dialog"]!=[NSNull null]) {
            
                versionCode=returnData[@"dialog"][@"versionCode"];
            
                versionContent=returnData[@"dialog"][@"versionContent"];

            }

        }
        
         LRLog(@"%@",versionCode);
        
        [weakSelf requestNavTitle];
        

        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
    } showHUD:NO];

}
-(void)requestNavTitle{
    
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:@"http://api.tkjidi.com/index.php?m=App" params:@{@"a":@"tkjidiClassIos",@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign,@"username":[defaults objectForKey:@"username"]} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
        if ([returnData[@"status"] intValue]==200) {
            
            id ary =returnData[@"data"];
            for (NSDictionary * dic in ary) {
                
                ClassModel * model =[[ClassModel alloc]initWithDictionary:dic];
                
                [weakSelf.classAry addObject:model];
            }
            
            [weakSelf tableHeaderView];
            
            ClassModel * model =[weakSelf.classAry firstObject];
            weakSelf.cate=model.idStr;
            
            [weakSelf requestData];
        }
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
    } showHUD:NO];
    
}
#pragma mark---绑定基地账号
-(void)requestBindingWith:(ShopModel *)model{

    LRLog(@"---------------------%@",model.url_shop);
    
    account=[defaults objectForKey:@"mmNick"];
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    NSString * user =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    NSString * url =[NSString stringWithFormat:@"http://api.tkjidi.com/index.php?m=App&a=locktaobao&timestamp=%@&nonce=%@&sign=%@",time,[NSString md5To32bit:once],sign];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:@{@"username":user,@"taobao_account":account} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
        isOK=YES;
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y>WINDOWRECT_HEIGHT) {
        topBut.hidden=NO;
    }else{
        topBut.hidden=YES;
    }
    
    if (scrollView.contentOffset.y>height-70) {
        
        _navView.frame=CGRectMake(0, 64, WINDOWRECT_WIDTH, 70);
        [self.view addSubview:_navView];
        
    }else{
        
        _navView.frame=CGRectMake(0, height-70, WINDOWRECT_WIDTH, 70);
        
        [self.hearView addSubview:_navView];
        
    }
    
    
    currentPage=page-1;
    
    CGFloat current =scrollView.contentOffset.y + scrollView.frame.size.height;
    
    CGFloat total   =2425+height+currentPage*2425;
    
    CGFloat ratio   =current/total;
    
    CGFloat needRead =itrmPerPage * threshild + currentPage * itrmPerPage;
    
    CGFloat totalItem =itrmPerPage*(currentPage+1);
    
    CGFloat newThreshold =needRead/totalItem;
    
    NSLog(@"%f---%f---%f---%f---%f---%f",current,total,ratio,needRead,totalItem,newThreshold);
    
    if (ratio>=newThreshold) {
 
        page++;
        NSLog(@"请求数据-%d",page);
        [self requestData];
    }

}
-(void)addNavView{
    
    self.title=@"淘客手机群发";
    
    UIButton *searchBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [searchBtn setImage:[UIImage imageNamed:@"ss"] forState:UIControlStateNormal];
    //    [backBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = bar;
    
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
