//
//  CheckViewController.m
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CheckViewController.h"
#import "CheckModel.h"
#import "ShopModel.h"

#import "ResultsCell.h"
#import "CheckCell.h"
#import "SingleCell.h"

#import "EfficientViewController.h"
@interface CheckViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
   
    
//    MBProgressHUD * HUD;
    
    NSString * _time;
    NSString *    shopUrl;

    NSString *    copyText;

    UITextView  * textview;
    UITextView  *  textView1;
    
    NSMutableArray * dataAry;//表数据

    
    UITableView * _tableView;

    
    UIView * headerView;
    UIView * bgView;
    
    CGFloat  dxMax;
    CGFloat  ptMax;
    CGFloat  gyMax;

    

    ShopModel * shop;

}

@end

@implementation CheckViewController
-(UIView *)lineView{
    
    UIView * view =[UIView new];
    view.backgroundColor=UIColorFromRGB(0xdcdcdc);
    
    return view;
}
- (void)viewWillAppear:(BOOL)animated{
    
      self.tabBarController.tabBar.hidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor=UIColorFromRGB(0xEEEEEF);
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"优惠券查询";
    shop=[[ShopModel alloc]init];
    dataAry=[[NSMutableArray alloc]init];
    
//    isbtn=YES;
//    isOK=NO;

    shop.class_name=@"其它";
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];

    [self addCheckView];
    
   
    
}
#pragma mark-----头部视图
-(void)addCheckView{
    
    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, 180)];

    [self.view addSubview:headerView];

    
    textview =[[UITextView alloc]init];
//    textView.scrollEnabled = NO;
    textview.tag=1000;
    textview.editable=YES;
    textview.delegate=self;
    textview.font=[UIFont systemFontOfSize:14];
    textview.backgroundColor=UIColorFromRGB(0xFDE8EC);
//    textView.text=@"https://item.taobao.com/item.htm?spm=a230r.1.14.235.s4hHWl&id=531941920487&ns=1&abbucket=19#detail";
    textview.layer.borderWidth=1;
    textview.layer.borderColor=[UIColorFromRGB(0xdcdcdc)CGColor];
    [headerView addSubview:textview];
    
    UILabel *label =[[UILabel alloc]init];
    label.text=@"Tips:搜索关键字查询商品，查看是否有优惠券。(复制商品标题，即可单独查券)";
    label.font=[UIFont fontWithName:@"Arial" size:12];
    label.textColor=UIColorFromRGB(0x999999);
    label.numberOfLines=0;
    [headerView addSubview:label];
    
    
    UIButton * copyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"一键粘贴" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    copyBtn.backgroundColor=UIColorFromRGB(0xFA574D);
    copyBtn.layer.cornerRadius=5;
    copyBtn.layer.masksToBounds=YES;
    [copyBtn addTarget:self action:@selector(copyToTextView:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:copyBtn];
    
    
    UIButton * button =[UIButton new];
    button.backgroundColor=UIColorFromRGB(0xFB4C6E);
    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    button.layer.cornerRadius=5;
    button.layer.masksToBounds=YES;
    [button addTarget:self action:@selector(buttonRequest) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    
    
    textview.sd_layout
    .rightSpaceToView(headerView,10)
    .leftSpaceToView(headerView, 10)
    .topSpaceToView(headerView, 10)
    .heightIs(90);
    
    label.sd_layout
    .rightSpaceToView(headerView,20)
    .leftSpaceToView(headerView,20)
    .topSpaceToView(textview,10)
    .autoHeightRatio(0);
    
    copyBtn.sd_layout
    .leftSpaceToView(headerView,10)
    .topSpaceToView(label,10)
    .heightIs(30)
    .widthIs((WINDOWRECT_WIDTH-40)/2);
    
    button.sd_layout
    .rightSpaceToView(headerView,10)
    .leftSpaceToView(copyBtn,20)
    .topSpaceToView(label,10)
    .heightIs(30);

   
}

#pragma mark---表视图
-(void)loadTableView{

    if (!bgView) {
        bgView =[[UIView alloc]init];
        
        [self.view addSubview:bgView];
        
        bgView.sd_layout
        .topSpaceToView(headerView,10)
        .leftSpaceToView(self.view,10)
        .rightSpaceToView(self.view,10)
        .bottomSpaceToView(self.view,60);
        
        
        
        UILabel * label =[[UILabel alloc]init];
        label.backgroundColor=[UIColor whiteColor];
        label.layer.borderColor=[UIColorFromRGB(0xdcdcdc)CGColor];
        label.layer.borderWidth=1;
        label.font=[UIFont fontWithName:@"Arial" size:16];
        label.textColor=UIColorFromRGB(0xF93961);
        label.text=@"查询结果";
        label.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        label.sd_layout
        .topSpaceToView(bgView,0)
        .leftSpaceToView(bgView,0)
        .rightSpaceToView(bgView,0)
        .heightIs(40);
        
        
        
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, WINDOWRECT_WIDTH-20, WINDOWRECT_HEIGHT-350) style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[ResultsCell class] forCellReuseIdentifier:@"results"];
        [_tableView registerClass:[CheckCell class] forCellReuseIdentifier:@"Check"];
        [_tableView registerClass:[SingleCell class] forCellReuseIdentifier:@"Single"];
        _tableView.backgroundColor=UIColorFromRGB(0xEEEEEF);
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [bgView addSubview:_tableView];
        

    }else{
        
        [_tableView reloadData];
        NSLog(@"11111");
    }
    
}
#pragma mark---tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataAry.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  
        
    ResultsCell * cell =[tableView dequeueReusableCellWithIdentifier:@"results"];
    
    if (!cell) {
        cell=[[ResultsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"results"];
            
    
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    CheckModel * model =dataAry[indexPath.row];
    ptMax=[model.pt floatValue];
    dxMax=[model.dx floatValue];
    gyMax=[model.gy floatValue];
    
    
    NSString * imgUrl =[NSString stringWithFormat:@"https:%@",model.imgStr];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@""]];
        
    cell.titleLab.text=model.title;
    
    NSString * qhStr =[NSString stringWithFormat:@"%.1f",[model.price floatValue]-[model.yhPrice floatValue]];
    cell.priceLab.text=[NSString stringWithFormat:@"原价:%@ 券后价:%@",model.price,qhStr];
    
    
    if (ptMax==YBMAX(ptMax, dxMax, gyMax)) {
        
        cell.jhLab.text=@"普通";
        model.rateStr=[NSString stringWithFormat:@"%.1f",ptMax];
        
    }else if (dxMax==YBMAX(ptMax, dxMax, gyMax)){
        
        cell.jhLab.text=@"定向";
        model.rateStr=[NSString stringWithFormat:@"%.1f",dxMax];

        
    }else{
        
        cell.jhLab.text=@"高佣";
        model.rateStr=[NSString stringWithFormat:@"%.1f",gyMax];

    }
    
    shop.yj =[NSString stringWithFormat:@"%.2f",[qhStr floatValue]*([model.rateStr floatValue]/100)];
    cell.rateLab.text=[NSString stringWithFormat:@"佣金比例:%@%% (%@)",model.rateStr,shop.yj];

    cell.subtitleLab.text=model.subtitle;
    
    [cell.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    return 120;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    LRLog(@"%ld",(long)indexPath.row);

}

#pragma mark---立即推广按钮事件
-(void)buttonClick:(UIButton *)but{
    
  
    
    CheckCell * cell =(CheckCell *)[[but superview]superview];
    NSIndexPath * indexPath =[_tableView indexPathForCell:cell];
    CheckModel * model =dataAry[indexPath.row];
    LRLog(@"%ld",(long)indexPath.row);
    
    shop.yhPrice = [NSString stringWithFormat:@"%@",model.yhPrice];
    shop.thumb   = [NSString stringWithFormat:@"https:%@",model.imgStr];
    shop.sales   = [NSString stringWithFormat:@"%@",model.sales];
    shop.title   = model.title;
    shop.shoujia = [NSString stringWithFormat:@"%@",model.price];
    shop.quanhou = [NSString stringWithFormat:@"%.1f",[model.price floatValue]-[model.yhPrice floatValue]];
    shop.goodsId = [NSString stringWithFormat:@"%@",model.goodId];
    shop.url_shop= model.shopUrl;
    shop.yhql    = model.ledNum;
    shop.yhqsy   = [NSString stringWithFormat:@"%@",model.leftNum];
    shop.guid_content=@"";

    if ([defaults objectForKey:@"mmNick"]==nil) {
        
         [self.view makeToast:@"请先登录阿里妈妈" duration:1 position:@"center"];
        
    }else{
        
        
        [self requestLoginWithModel:shop];
    }

  
}

#pragma mark---粘贴按钮事件
-(void)copyToTextView:(UIButton *)btn{

    if ([btn.titleLabel.text isEqualToString:@"重置"]) {
        
        [btn setTitle:@"一键粘贴" forState:UIControlStateNormal];
        
        textview.text=@"";
        
        
    }else{
        
        [btn setTitle:@"重置" forState:UIControlStateNormal];
        
        UIPasteboard * pd =[UIPasteboard generalPasteboard];
        textview.text=pd.string;
    }
    

}

#pragma mark---查询按钮事件
-(void)buttonRequest{

//    if (isbtn==YES) {
    
//        isbtn=NO;

        [dataAry removeAllObjects];
    
        [textview resignFirstResponder];
    
    _time =[ NSString stringWithFormat:@"%lld",[[Customer timeString] longLongValue]];

        if ([[textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0) {
            
            if ([textview.text rangeOfString:@"http"].location!=NSNotFound) {
                
                  [self.view makeToast:@"输入关键字搜索" duration:2 position:@"center"];
                
            }else{
                
                [self requestDataWithItem:textview.text];
            
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


    NSString * url =[NSString stringWithFormat:@"http://pub.alimama.com/items/search.json?&_t=%@&toPage=1&dpyhq=1&perPageSize=30&shopTag=yxjh,dpyhq&t=%@",_time,time];
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:url params:@{@"q":item} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
        if (returnData[@"data"][@"pageList"]!=[NSNull null]) {
            id ary = returnData[@"data"][@"pageList"];
            for (NSDictionary * dic in ary) {
                CheckModel * model =[[CheckModel alloc]init];
                model.imgStr=dic[@"pictUrl"];
                
                NSArray * titleAry =[dic[@"title"] componentsSeparatedByString:@"<"];
                model.title =[NSString stringWithFormat:@"%@%@",[titleAry firstObject],[[[titleAry lastObject] componentsSeparatedByString:@">"] lastObject]];
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
                
                
                [dataAry addObject:model];
                
            }
            
            [weakSelf loadTableView];
            

        }else{
            
            [self.view makeToast:@"抱歉，没有找到相关商品！" duration:2 position:@"center"];
        }
        
    } failureBlock:^(NSError *error) {
       
        [_tableView reloadData];
         [self.view makeToast:@"网络拥堵，请稍后再试！" duration:2 position:@"center"];
        NSLog(@"%@",error);
        
    } showHUD:YES];
    
}
#pragma mark---判断是否绑定
-(void)requestLoginWithModel:(ShopModel *)model{
    
   
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    NSString * user =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    NSString * url =[NSString stringWithFormat:@"http://api.tkjidi.com/index.php?m=App&a=locktaobao&timestamp=%@&nonce=%@&sign=%@",time,[NSString md5To32bit:once],sign];
    
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:@{@"username":user,@"taobao_account":[defaults objectForKey:@"mmNick"]} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);

        if ([returnData[@"status"] intValue]==200) {
            
            EfficientViewController * vc =[[EfficientViewController alloc]init];
            vc.model=model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            [weakSelf.view makeToast:returnData[@"msg"] duration:3 position:@"center"];
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
        
    } showHUD:NO];

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
- (void)textViewBeginEditing:(NSNotification *)noti
{
    textView1=noti.object;

}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIBarButtonItem *done =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] ;
    self.navigationItem.rightBarButtonItem = done;
    

}
- (void)showKeyboard:(NSNotification *)noti
{
//        textView=noti.object;
//    LRLog(@"%d",textview.tag);
    if (textView1.tag!=1000) {
        self.view.transform = CGAffineTransformIdentity;
        CGRect tfRect = [bgView.superview convertRect:bgView.frame toView:self.view];
        NSValue *value = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
        CGRect keyBoardF = [value CGRectValue];
        CGFloat animationTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
        CGFloat _editMaxY = CGRectGetMaxY(tfRect);
        CGFloat _keyBoardMinY = CGRectGetMinY(keyBoardF);
        if (_keyBoardMinY < _editMaxY) {
            CGFloat moveDistance = _editMaxY - _keyBoardMinY;
            [UIView animateWithDuration:animationTime animations:^{
                self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -moveDistance);
            }];
        }

    }
  
}
- (void)hideKeyboard:(NSNotification *)noti
{
//    [textview becomeFirstResponder];
    self.view.transform = CGAffineTransformIdentity;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
//     [textview becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;

}

- (void)leaveEditMode {
 
//    [textview becomeFirstResponder];
    [self.view endEditing:YES];
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
