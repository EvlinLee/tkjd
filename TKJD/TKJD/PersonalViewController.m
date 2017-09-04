//
//  PersonalViewController.m
//  TKJD
//
//  Created by apple on 2017/3/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PersonalViewController.h"
#import "textViewController.h"
#import "signViewController.h"
#import "PIDViewController.h"
#import "TGWViewController.h"
#import "SuffixViewController.h"

#import "GrantViewController.h"
@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString * pwd;
    UIView * view;
}
@property(nonatomic , retain)UITableView * tableView;
@end

@implementation PersonalViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [view removeFromSuperview];
    
    [self tableViewHeaderView];
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"个人中心";
    [self requestLoginTime];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-108) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    [self tableViewHeaderView];
    
}
-(void)tableViewHeaderView{
    
    view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, 170)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    
    NSString * urlStr =[NSString stringWithFormat:@"http:%@",[defaults objectForKey:@"avatar"]];

    UIImageView * txImgView =[[UIImageView alloc]init];
//    txImgView.image=[UIImage imageNamed:@"tx"];
    txImgView.layer.masksToBounds=YES;
    txImgView.layer.cornerRadius=45;
    [txImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"tx"]];
    [view addSubview:txImgView];
    
    UIImageView * sjImgView =[[UIImageView alloc]init];
    sjImgView.image=[UIImage imageNamed:@"sj"];
    [view addSubview:sjImgView];
    
    UILabel * nameLab =[[UILabel alloc]init];
    nameLab.textAlignment=NSTextAlignmentRight;
    nameLab.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    [view addSubview:nameLab];
   
    
    UILabel * dateLab =[[UILabel alloc]init];
    dateLab.textAlignment=NSTextAlignmentLeft;
    dateLab.adjustsFontSizeToFitWidth=YES;
    NSString * time =[[NSUserDefaults standardUserDefaults]objectForKey:@"time"];
    NSString * dateStr =[NSString stringWithFormat:@"会员剩余:%d天",[time intValue]];
    
    NSUInteger length = [dateStr length];
    NSMutableAttributedString * dateAttStr = [[NSMutableAttributedString alloc]initWithString:dateStr];
    [dateAttStr addAttribute:NSForegroundColorAttributeName
     
                     value:[UIColor redColor]
     
                     range:NSMakeRange(5, length-6)];

    
    dateLab.attributedText=dateAttStr;
    [view addSubview:dateLab];
    
    
    
    UILabel * grantLab =[[UILabel alloc]init];
    grantLab.textAlignment=NSTextAlignmentCenter;
    grantLab.adjustsFontSizeToFitWidth=YES;
    grantLab.textColor=UIColorFromRGB(0x666666);
    NSString * str =[Customer timeWithTimeIntervalString:[defaults objectForKey:@"valid_time"]];
    grantLab.text=[NSString stringWithFormat:@"授权过期时间：%@",str];
    grantLab.font=[UIFont systemFontOfSize:14];
    [view addSubview:grantLab];
    
    
    
    UIView * line =[[UIView alloc]init];
    line.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [view addSubview:line];
    
    
    txImgView.sd_layout
    .topSpaceToView(view,10)
    .centerXEqualToView(view)
    .heightIs(90)
    .widthIs(90);
    
    sjImgView.sd_layout
    .topSpaceToView(txImgView,10)
    .centerXEqualToView(view)
    .heightIs(20)
    .widthIs(20);
    
    nameLab.sd_layout
    .topEqualToView(sjImgView)
    .rightSpaceToView(sjImgView,5)
    .heightIs(20)
    .leftSpaceToView(view,20);
    
    
    dateLab.sd_layout
    .topEqualToView(sjImgView)
    .leftSpaceToView(sjImgView,5)
    .heightIs(20)
    .rightSpaceToView(view,30);
    
    
    grantLab.sd_layout
    .topSpaceToView(sjImgView, 4)
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .heightIs(20);
    
    
    line.sd_layout
    .bottomSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .leftSpaceToView(view,0)
    .heightIs(1);
    
    [self.tableView setTableHeaderView:view];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        
        return 4;
        
    }else{
        
        return 1;
    }

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section==0) {

        if (indexPath.row==0) {
            
            cell.imageView.image=[UIImage imageNamed:@"aldl"];
            cell.textLabel.text=@"阿里妈妈账号登录";

        
        }else if(indexPath.row==1) {
            
            cell.imageView.image=[UIImage imageNamed:@"tgw"];
            cell.textLabel.text=@"设置默认推广位";
            
        }else if(indexPath.row==2){
            
            cell.imageView.image=[UIImage imageNamed:@"xbt"];
            cell.textLabel.text=@"设置小标题";
            
        }else{
             cell.imageView.image=[UIImage imageNamed:@"grzx1"];
            cell.textLabel.text=@"用户授权";
        }
       
    }else if (indexPath.section==1){
        
        cell.imageView.image=[UIImage imageNamed:@"mb"];
        cell.textLabel.text=@"转链输出模板";
        
    }else if (indexPath.section==2){
        
        cell.imageView.image=[UIImage imageNamed:@"clean"];
        cell.textLabel.text=@"清除全部数据";
        
    }else{
        
        cell.imageView.image=[UIImage imageNamed:@"quit"];
        cell.textLabel.text=@"退出账号";
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            
            PIDViewController * vc =[[PIDViewController alloc]init];
            vc.isCheck=YES;
            [self.navigationController pushViewController:vc animated:YES];
        
        }else if (indexPath.row==1){
            
            TGWViewController * vc =[[TGWViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if (indexPath.row==2){
            
            SuffixViewController * vc =[[SuffixViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

            
        }else{
            
            GrantViewController * vc =[[GrantViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        
            
        }
        
    }else if (indexPath.section==1){
        
        textViewController * vc =[[textViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

        
        
    }else if (indexPath.section==2){
        
        NSArray * shopAry = [Shop MR_findAll];
        
        for (Shop * shop in shopAry) {
            
            [shop MR_deleteEntity];
            
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];

        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            [self.view makeToast:@"已全部清除" duration:2 position:@"center"];
        }];
     
    }else if(indexPath.section==3){
        
        [defaults removeObjectForKey:@"valid_time"];
        [defaults removeObjectForKey:@"mmNick"];
        [defaults removeObjectForKey:@"cookie"];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"login"];
        
        [defaults synchronize];
        
        UIWindow * window =[[[UIApplication sharedApplication]delegate]window];
        signViewController * vc =[[signViewController alloc]init];
        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:vc];
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xFEFFFF)];
        
        [window setRootViewController:nav];
        [window makeKeyWindow];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}
-(void)requestLoginTime{
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    NSString * user =[defaults objectForKey:@"username"];
    if ([defaults objectForKey:@"pwd"]==nil) {
        
        pwd=@"";
        
    }else{
    
        pwd=[defaults objectForKey:@"pwd"];
    
    }
    
    
    NSString * url =[NSString stringWithFormat:@"http://api.tkjidi.com/index.php?m=App&a=isuser&timestamp=%@&nonce=%@&sign=%@",time,[NSString md5To32bit:once],sign];

    [MHNetworkManager postReqeustWithURL:url params:@{@"username":user,@"pwd":pwd} successBlock:^(id returnData, int code, NSString *msg) {
        
        LRLog(@"%@",msg);
        if ([returnData[@"status"] intValue]==200) {
            
            [defaults setObject:returnData[@"data"] forKey:@"time"];
            
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
