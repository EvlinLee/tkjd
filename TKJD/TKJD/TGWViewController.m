//
//  TGWViewController.m
//  TKJD
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TGWViewController.h"
#import "PIDModel.h"
@interface TGWViewController ()<UIScrollViewDelegate>{
    
    
    NSMutableArray * dataAry;
}
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *lastBottomLine;
@property (nonatomic, strong) UIView *wrapperView;
@property (nonatomic, strong) NSMutableArray * btns;
@end

@implementation TGWViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = !tabbar.tabbar.hidden;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.title=@"设置推广位";
    [self addNavView];
    dataAry=[[NSMutableArray alloc]init];
//    dataAry=[[NSMutableArray alloc]initWithObjects:@"扣扣",@"爱分享",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",@"微信",nil];
    
    [self requestPID];

//    [self uploadView];
    
    
  
}

-(void)uploadView{
    
    self.wrapperView = [UIView new];
    self.wrapperView.backgroundColor=UIColorFromRGB(0xEEEEEF);
    [self.scroollView addSubview:self.wrapperView];
    [self.scroollView setupAutoContentSizeWithBottomView:self.wrapperView bottomMargin:0];

    [self loadTGWView];
    
    self.wrapperView.sd_layout.
    leftEqualToView(self.scroollView)
    .rightEqualToView(self.scroollView)
    .topSpaceToView(self.scroollView,0);
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
-(void)loadTGWView{
    
    _btns=[[NSMutableArray alloc]init];
    
    NSString * urlStr =[NSString stringWithFormat:@"http:%@",[defaults objectForKey:@"avatar"]];
    
    UIImageView * txImgView =[[UIImageView alloc]init];
    [txImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"tx"]];
    txImgView.layer.masksToBounds=YES;
    txImgView.layer.cornerRadius=45;
//    [self.wrapperView addSubview:txImgView];
    
    
    UILabel * nameLab =[[UILabel alloc]init];
    nameLab.text=[NSString stringWithFormat:@"用户名:%@",[defaults objectForKey:@"mmNick"]];
    nameLab.textAlignment=NSTextAlignmentCenter;
    nameLab.font=[UIFont systemFontOfSize:16];
    
    
    UILabel * idLab=[[UILabel alloc]init];
    idLab.text=[NSString stringWithFormat:@"ID:%@",[defaults objectForKey:@"memberid"]];
    idLab.font=[UIFont systemFontOfSize:14];
    idLab.textAlignment=NSTextAlignmentCenter;
    idLab.textColor=UIColorFromRGB(0x333333);
    
    
    
    
    UIView * view =[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    
    
    UILabel * lab =[[UILabel alloc]init];
    lab.text=@"请选择导购推广位";
    lab.font=[UIFont systemFontOfSize:16];
    lab.textColor=[UIColor blueColor];
    lab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:lab];
    
    UIView * line =[[UIView alloc]init];
    line.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [view addSubview:line];
    
    for (int i=0;i<dataAry.count ; i++) {
        
        PIDModel * model =dataAry[i];
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [btn setTitle:model.name forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:18];
        btn.tag=i;
        if ([model.pid isEqualToString:[defaults objectForKey:@"pid"]]) {
            
            [btn setImage:[UIImage imageNamed:@"g"] forState:UIControlStateNormal];
            
        }else{
            
            [btn setImage:[UIImage imageNamed:@"y"] forState:UIControlStateNormal];

        }
        
        
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(TGWButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(10, 40+(30*i), WINDOWRECT_WIDTH-60, 30);
        
        [_btns addObject:btn];
        [view addSubview:btn];
    }
    
    [self.wrapperView sd_addSubviews:@[txImgView,nameLab,idLab,view]];

    
    txImgView.sd_layout
    .topSpaceToView(self.wrapperView,70)
    .centerXEqualToView(self.wrapperView)
    .heightIs(90)
    .widthIs(90);
    
    
    nameLab.sd_layout
    .topSpaceToView(txImgView,10)
    .centerXEqualToView(txImgView)
    .heightIs(20)
    .widthIs(WINDOWRECT_WIDTH);
    
    
    idLab.sd_layout
    .topSpaceToView(nameLab,0)
    .centerXEqualToView(nameLab)
    .heightIs(20)
    .widthIs(WINDOWRECT_WIDTH);
    
    
    lab.sd_layout
    .topSpaceToView(view,0)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs(40);
    
    
    line.sd_layout
    .topSpaceToView(lab,0)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs(1);
    
    
  
    
    view.sd_layout
    .topSpaceToView(idLab,10)
    .leftSpaceToView(self.wrapperView,10)
    .rightSpaceToView(self.wrapperView,10)
    .heightIs(40+(30*dataAry.count));
   

    
    self.lastBottomLine = [self addSeparatorLineBellowView:view margin:10];
}
-(void)TGWButtonClick:(UIButton *)btn{
    
    for (UIButton* btn in self.btns) {
        [btn setImage:[UIImage imageNamed:@"y"] forState:UIControlStateNormal];
    }
    
    UIButton * button=(UIButton*)self.btns[btn.tag];
    [button setImage:[UIImage imageNamed:@"g"] forState:UIControlStateNormal];
    
    PIDModel * model =dataAry[btn.tag];
    
    [defaults setObject:model.pid forKey:@"pid"];
    
}
-(void)requestPID{
    
    NSString * cookieStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"];
    
    __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
    //        operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operationManager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"cookie"];
    [operationManager GET:@"http://pub.alimama.com/common/adzone/adzoneManage.json?&tab=3&toPage=1&perPageSize=40&gcid=8"  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LRLog(@">>>>>>>%@",operation.responseString);
        
        if ((NSNull *)operation.responseObject[@"data"][@"pagelist"]!=[NSNull null]) {
            
            
            id ary =operation.responseObject[@"data"][@"pagelist"];
            for (NSDictionary * dic in ary) {
                
                if ([dic[@"tag"] intValue]==29) {
                    PIDModel * model =[[PIDModel alloc]init];
                    
                    model.name=dic[@"name"];
                    model.pid=dic[@"adzonePid"];
                    
                    [dataAry addObject:model];
                }
            }
       
            [weakSelf uploadView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        
        LRLog(@"%@",[error localizedDescription]);
        [self.view makeToast:@"请登录阿里妈妈" duration:2 position:@"center"];

        
        
    }];
    
    
    
}
-(void)addNavView
{
    
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
