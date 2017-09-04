//
//  setViewController.m
//  TKJD
//
//  Created by apple on 2017/2/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "setViewController.h"
#import "textViewController.h"
#import "signViewController.h"
@interface setViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField * textFiled1;
    UITextField * textFiled2;

    UIView * headerView;
    
    NSMutableArray * dataAry;
    
}
@property(nonatomic , strong)UITableView * tableView;

@end

@implementation setViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self addNavView];
    
    dataAry=[[NSMutableArray alloc]initWithObjects:@"转链输出摸板设置",@"清除已选商品", nil];
    
    [self loadTableView];
    [self addfooterView];
}
- (UILabel *)labWithbgColor:(UIColor *)bgColor font:(CGFloat)font
{
    UILabel * lab =[UILabel new];
    lab.font=[UIFont systemFontOfSize:font];
    lab.textColor=bgColor;
    lab.numberOfLines=0;
    
    return lab;
}
-(void)addfooterView{
    
//    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, 130)];
//    headerView.backgroundColor=[UIColor whiteColor];
//   
//    
//    UILabel * label3 =[self labWithbgColor:UIColorFromRGB(0x333333) font:16];
//    label3.text=@"三段PID:";
//    [headerView addSubview:label3];
//    
//    textFiled1 =[[UITextField alloc]init];
//    textFiled1.delegate=self;
//    textFiled1.layer.borderColor=UIColorFromRGB(0xdcdcdc).CGColor;
//    textFiled1.clearButtonMode=UITextFieldViewModeWhileEditing;
//    textFiled1.layer.borderWidth=1;
//    textFiled1.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"sPID"];
//    [headerView addSubview:textFiled1];
//    
//    
//    UILabel * label4 =[self labWithbgColor:UIColorFromRGB(0x333333) font:16];
//    label4.text=@"鹊桥PID:";
//    [headerView addSubview:label4];
//    
//    
//    
//    textFiled2 =[[UITextField alloc]init];
//    textFiled2.delegate=self;
//    textFiled2.layer.borderColor=UIColorFromRGB(0xdcdcdc).CGColor;
//    textFiled2.layer.borderWidth=1;
//    textFiled2.clearButtonMode=UITextFieldViewModeWhileEditing;
//    textFiled2.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"qPID"];
//    [headerView addSubview:textFiled2];
//   
//    
//    label3.sd_layout
//    .leftSpaceToView(headerView,10)
//    .topSpaceToView(headerView,20)
//    .heightIs(20)
//    .widthIs(70);
//    
//    textFiled1.sd_layout
//    .topSpaceToView(headerView,10)
//    .leftSpaceToView(label3,0)
//    .rightSpaceToView(headerView,10)
//    .heightIs(40);
//    
//    label4.sd_layout
//    .leftEqualToView(label3)
//    .topSpaceToView(label3,30)
//    .heightIs(20)
//    .widthIs(70);
//    
//    textFiled2.sd_layout
//    .topSpaceToView(textFiled1,10)
//    .leftSpaceToView(label3,0)
//    .rightSpaceToView(headerView,10)
//    .heightIs(40);
//
//    [self.tableView setTableHeaderView:headerView];
    
    
    UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, 60)];
//    footerView.backgroundColor=[UIColor whiteColor];
    
    UIButton * exitBtn =[[UIButton alloc]init];
    exitBtn.backgroundColor=UIColorFromRGB(0xff307e);
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:exitBtn];
    
    exitBtn.sd_layout
    .leftSpaceToView(footerView,30)
    .rightSpaceToView(footerView,30)
    .topSpaceToView(footerView,20)
    .heightIs(40);
    
    [self.tableView setTableFooterView:footerView];
    
}
-(void)loadTableView{
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-64) style:UITableViewStyleGrouped];
    //    _tableView.backgroundColor=[UIColor orangeColor];
     self.tableView.delegate=self;
     self.tableView.dataSource=self;
    [self.view addSubview: self.tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    cell.textLabel.text=dataAry[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        NSLog(@"111");
        
        textViewController * vc =[[textViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if(indexPath.row==1){
        
        NSLog(@"222");
        
        NSArray * shop =[Shop MR_findAll];
        for (int i=0; i<shop.count; i++) {
            
            Shop * temp =shop[i];
            [temp MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
  
        
        }
        
    }else{
//        NSError * error=nil;
        
//         NSString *path_sandox = NSHomeDirectory();
//        NSLog(@"%@",path_sandox);
//        if([[NSFileManager defaultManager] fileExistsAtPath:path_sandox])//如果存在临时文件的配置文件
//        {
//            [[NSFileManager defaultManager]  removeItemAtPath:path_sandox error:&error];
//        }
//        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)addNavView
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"设置";
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = title;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backViewB) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bar;
    
    UIEdgeInsets img = backBtn.imageEdgeInsets;
    img.left = -20;
    [backBtn setImageEdgeInsets:img];
    
    
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:save];
    self.navigationItem.rightBarButtonItem = bar1;
    
}
-(void)saveButton{
    
   
    if (textFiled1.text.length==0||textFiled1.text.length==0) {
        
        //            NSLog(@"不能为空");
        [self.view makeToast:@"请输入PID并保存" duration:1 position:@"center"];
        
    }else{

        [[NSUserDefaults standardUserDefaults]setObject:textFiled1.text forKey:@"sPID"];
        [[NSUserDefaults standardUserDefaults]setObject:textFiled2.text forKey:@"qPID"];
        [self.view makeToast:@"保存成功" duration:1 position:@"center"];
        
    }
 
    [self.view endEditing:YES];
}
-(void)exitBtnClick{
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"login"];
    
    UIWindow * window =[[[UIApplication sharedApplication]delegate]window];
    signViewController * vc =[[signViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:vc];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xff307e)];

    [window setRootViewController:nav];
    [window makeKeyWindow];

}
-(void)backViewB{
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
