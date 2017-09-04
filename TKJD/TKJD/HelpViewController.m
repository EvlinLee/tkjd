//
//  HelpViewController.m
//  TKJD
//
//  Created by apple on 2017/3/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpModel.h"
#import "HelpDetailesViewController.h"
@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , retain)NSMutableArray * dataAry;
@property(nonatomic , retain)UITableView * tableView;
@end
@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets=NO;

    self.title=@"使用帮助";
    
    self.dataAry=[[NSMutableArray alloc]init];
    
    
    
    [self requestData];
    self.tableView =[[UITableView  alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    
    HelpModel * model =self.dataAry[indexPath.row];
    cell.textLabel.text=model.title;
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LRLog(@"%d",indexPath.row);
    
    HelpModel * model =self.dataAry[indexPath.row];
    
    
    HelpDetailesViewController * vc =[[HelpDetailesViewController alloc]init];
    
    vc.idNum=model.idStr;
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}
-(void)requestData{
    
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    [MHNetworkManager getRequstWithURL:API_URL params:@{@"a":@"newsios",@"timestamp":time,@"nonce":[NSString md5To32bit:once],@"sign":sign} successBlock:^(id returnData, int code, NSString *msg) {
        
        LRLog(@"%@",returnData);
//
        if (code==0) {
            
           
            id ary =returnData[@"data"];
            for (NSDictionary * dic in ary) {
                
                HelpModel * model =[[HelpModel alloc]init];
                model.idStr=dic[@"id"];
                model.title=dic[@"title"];
                
                [self.dataAry addObject:model];
            }
            
            [self.tableView reloadData];
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
        
        
    } showHUD:YES];
    
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
