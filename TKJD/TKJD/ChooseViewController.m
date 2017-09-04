//
//  ChooseViewController.m
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseCell.h"
#import "ClassView.h"
#import "AddRobotViewController.h"
#import "ClassModel.h"
@interface ChooseViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray * dataAry;
    NSMutableArray * selectArray;
    
//    ClassView * view;
    
    BOOL isSelected;
    NSArray * titles;
    
//    NSArray * class;

    NSString * items;
    NSMutableArray * itmeAry;
    
    
    UIView * bottomLine;
}
@property(nonatomic,strong)NSMutableArray* deleteAry;
@property(nonatomic,strong)NSMutableArray* classAry;
@property(nonatomic , strong)UITableView * tableView;
@property(nonatomic,assign)CGFloat nav_x;
@property(nonatomic,retain)NSMutableArray* btns;
@property(nonatomic,retain)UIScrollView * navScroll;
//@property(nonatomic, retain)UIButton * selectAllBtn;
@end

@implementation ChooseViewController
-(NSMutableArray *)classAry{
    
    if (!_classAry) {
        
        _classAry=[[NSMutableArray alloc]init];
        
    }
    
    return _classAry;
}
-(NSMutableArray *)deleteAry{
    
    
    if (!_deleteAry) {
        _deleteAry=[[NSMutableArray alloc]init];
        
    }
    return _deleteAry;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    NSLog(@"1111111111111");
    [self RefreshData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xEEEEEF);
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.title=@"我的商品库";
    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [releaseButton setImage:[UIImage imageNamed:@"jqr"] forState:UIControlStateNormal];
    releaseButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [releaseButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    
    isSelected=YES;
    selectArray=[[NSMutableArray alloc]init];
    itmeAry=[[NSMutableArray alloc]init];
    dataAry=[[NSMutableArray alloc]init];
//    class = @[@"全部",@"服饰鞋包",@"美容护理",@"食品保健",@"家居用品",@"母婴",@"3C数码",@"车品配件",@"运动户外",@"珠宝配饰",@"医药健康",@"生活用品",@"玩乐收藏",@"书籍音像",@"其它"];

    [self requestNavTitle];
    

    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 105, WINDOWRECT_WIDTH, WINDOWRECT_HEIGHT-222) style:UITableViewStylePlain];
    //    self.tableView.backgroundColor=[UIColor orangeColor];
    [self.tableView registerClass:[ChooseCell class] forCellReuseIdentifier:@"choose"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];

}


-(void)RefreshData{
    
    
    NSArray * array1=[[[Shop MR_findAll] reverseObjectEnumerator]allObjects];
    dataAry=[NSMutableArray arrayWithArray:array1];
    [self.tableView reloadData];

}

-(void)loadClassButton{
    
    _nav_x=10;
    
    _btns=[NSMutableArray new];

    
    _navScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WINDOWRECT_WIDTH, 40)];
    _navScroll.showsHorizontalScrollIndicator=NO;
    _navScroll.showsVerticalScrollIndicator=NO;
    _navScroll.scrollsToTop=NO;
    _navScroll.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_navScroll];
    
    UIView * line =[[UIView alloc]initWithFrame:CGRectMake(0, 104, WINDOWRECT_WIDTH, 1)];
    line.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:line];
    

    
    for (int i=0; i<self.classAry.count; i++) {
        ClassModel * model =self.classAry[i];
        NSString* title=model.classname;
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        //        _itemWidth=size.width;
        
        //        NSLog(@"%f",_itemWidth);
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_nav_x, 0, size.width+10, 40);
        btn.tag=i;
        
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:UIColorFromRGB(0xff307e) forState:UIControlStateNormal];
            
            bottomLine=[[UIView alloc] init];
            bottomLine.center=CGPointMake(btn.centerX, btn.centerY+14);
            bottomLine.bounds=CGRectMake(0, 0, size.width+4, 2);
            bottomLine.backgroundColor=UIColorFromRGB(0xff307e);
            [_navScroll addSubview:bottomLine];
            
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
    

    
    UIView * deleView =[[UIView alloc]init];
    deleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:deleView];
    
    UIView * line1=[[UIView alloc]init];
    line1.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [deleView addSubview:line1];
    
    UIView * line2=[[UIView alloc]init];
    line2.backgroundColor=UIColorFromRGB(0xdcdcdc);
    [deleView addSubview:line2];
    
    
    NSArray * btnAry =@[@"选择删除",@"全部删除",@"清空过期"];
    for (int i = 0; i<btnAry.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnAry[i] forState:UIControlStateNormal];
        btn.tag=10+i;
        if (btn.tag==10) {
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        }else if(btn.tag==11){
            
            btn.backgroundColor=UIColorFromRGB(0x579AFC);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            btn.backgroundColor=UIColorFromRGB(0xFB4A41);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        }
       
        btn.frame=CGRectMake(WINDOWRECT_WIDTH/3*i, 1 , WINDOWRECT_WIDTH/3, 40);
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        [deleView addSubview:btn];
    }
    
    
    
    line1.sd_layout
    .topSpaceToView(deleView,0)
    .leftSpaceToView(deleView,0)
    .rightSpaceToView(deleView,0)
    .heightIs(1);
    
    
    line2.sd_layout
    .bottomSpaceToView(deleView,0)
    .leftSpaceToView(deleView,0)
    .rightSpaceToView(deleView,0)
    .heightIs(1);
    
    deleView.sd_layout
    .bottomSpaceToView(self.view,75)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(42);
    
    
    
   
    
}
-(void)btnItemAction:(id)sender{
    
    UIButton* btn=(UIButton*)sender;
    
    [self moveInIndex:btn.tag];
    
    [dataAry removeAllObjects];
    
    ClassModel * model =self.classAry[btn.tag];
    
    if ([model.classname isEqualToString:@"全部"]) {
        
        NSMutableArray * array =[[NSMutableArray alloc]initWithArray:[Shop MR_findAll]];
        
        NSArray * array1=[[array reverseObjectEnumerator]allObjects];
        
        dataAry=[NSMutableArray arrayWithArray:array1];
        
        [self.tableView reloadData];
        
    }else{

        NSArray * students =[Shop MR_findByAttribute:@"class_name" withValue:model.classname];
        
        dataAry=[NSMutableArray arrayWithArray:students];
        
        [self.tableView reloadData];
        
        
    }

    
}


-(void)moveInIndex:(NSInteger)index{
    
    
    for (UIButton* btn in self.btns) {
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    
    UIButton* btn=(UIButton*)self.btns[index];
    [btn setTitleColor:bottomLine.backgroundColor forState:UIControlStateNormal];
    
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        CGSize size =[btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        bottomLine.center=CGPointMake(btn.center.x, btn.center.y+14);
        bottomLine.bounds=CGRectMake(0, 0, size.width+4, 2);
        
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
  
}



//-(void)editAction{
//    
//    NSArray * shopAry = [Shop MR_findAll];
//    
//    for (int i=0; i<shopAry.count; i++) {
//        Shop * shop =shopAry[i];
//        [shop MR_deleteEntity];
//        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
//    }
//
//}
-(void)buttonClick:(UIButton * )btn{
    if (btn.tag==11) {
        
        NSArray * shopAry = [Shop MR_findAll];
        
        for (Shop * shop in shopAry) {
            
            [shop MR_deleteEntity];
            
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
        [dataAry removeAllObjects];
        
        [self.tableView reloadData];
        
    }else{
        
        BOOL flag = _tableView.editing;
        
        if (flag) {
            
            
            [selectArray removeAllObjects];
            
            _tableView.editing = NO;
            btn.selected = NO;
            
        }else
        {
            
            
            //开始选择行
            [selectArray removeAllObjects];
            isSelected=NO;
            _tableView.editing = YES;
            btn.selected = YES;
            
        }
        
    }

}
- (void)selectAllBtnClick:(UIButton *)button {
    
    BOOL flag = _tableView.editing;
    
    if (flag) {
        //删除的操作
        //得到删除的商品索引
        //        NSMutableArray *indexArray = [NSMutableArray array];
        //        for (Shop * shop in dataAry) {
        //            NSInteger num = [dataAry indexOfObject:shop];
        //
        //            NSIndexPath *path = [NSIndexPath indexPathForRow:num inSection:0];
        //            [indexArray addObject:path];
        //        }
        //        LRLog(@"%d",selectArray.count);
        for (Shop * shop in self.deleteAry) {
            
            [shop MR_deleteEntity];
            
            
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
        //修改数据模型
        [dataAry removeObjectsInArray:self.deleteAry];
        [self.deleteAry removeAllObjects];
        
        
        //        NSArray * array1=[[[Shop MR_findAll] reverseObjectEnumerator]allObjects];
        //        dataAry=[NSMutableArray arrayWithArray:array1];
        
        
        //刷新
        [_tableView reloadData];
        
        _tableView.editing = NO;
        button.selected = NO;
    }else
    {
        //开始选择行
        [self.deleteAry removeAllObjects];
        isSelected=YES;
        _tableView.editing = YES;
        button.selected = YES;
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.tableView.editing)
    {
        //当表视图处于没有未编辑状态时选择多选删除
        return UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert;
    }
    else
    {
        //当表视图处于没有未编辑状态时选择左滑删除
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_tableView.editing){
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
//        Shop * shop = [dataAry objectAtIndex:indexPath.row];
//        DetailsViewController * vc =[[DetailsViewController alloc]init];
//        vc.urlStr = shop.url_shop;
//        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        
    }else{
        Shop * shop = [dataAry objectAtIndex:indexPath.row];
        
        if (isSelected==YES) {
            if (![self.deleteAry containsObject:shop]) {
                [self.deleteAry addObject:shop];
            }
            
        }else{
            
            if (![selectArray containsObject:shop]) {
                [selectArray addObject:shop];
            }
            
        }
        
        
    }

}

#pragma mark 取消选中行
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_tableView.editing)
        return;
    
    Shop * shop = [dataAry objectAtIndex:indexPath.row];
    if (isSelected==YES) {
        if ([self.deleteAry containsObject:shop]) {
            [self.deleteAry removeObject:shop];
        }
        
    }else{
        
        if ([selectArray containsObject:shop]) {
            [selectArray removeObject:shop];
        }
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%lu",(unsigned long)dataAry.count);
    
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Shop * shop =dataAry[indexPath.row];
 
    ChooseCell  * cell =[tableView dequeueReusableCellWithIdentifier:@"choose"];
    if (!cell) {
        cell=[[ChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choose"];
//        cell.showsReorderControl=YES;
        
    }

       cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:shop.thumb] placeholderImage:[UIImage imageNamed:@"111"]];
    cell.title.text=shop.title;
    
    cell.priceLab.text=[NSString stringWithFormat:@"%@元",shop.shoujia];
    
    cell.salesLab.text=[NSString stringWithFormat:@"月销量%@",shop.sales];
    
    cell.qhLab.text=[NSString stringWithFormat:@"券后价:%@元",shop.quanhou];

    cell.rateLab.text=[NSString stringWithFormat:@"比例:%@%%",shop.rate];

    [cell labelWithText:shop.yhPrice];

//    if ([shop.tmall isEqualToString:@"1"]) {
//        
//        cell.tmallImg.image=[UIImage imageNamed:@"tm"];
//        
//    }else{
//     
//        cell.tmallImg.image=[UIImage imageNamed:@"tb"];
//    }
    
    NSUInteger length =[shop.yj length];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:shop.yj];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16]
     
                          range:NSMakeRange(3, length-3)];

    
    
    cell.yjLab.attributedText=AttributedStr;

    
//    [cell.moreBut addTarget:self action:@selector(CopyTextBtn:) forControlEvents:UIControlEventTouchUpInside];

//    if ([shop.isChoose isEqualToString:@"1"]) {
//        
//        [cell.seleBut setBackgroundColor:[UIColor grayColor]];
//        
//        [cell.seleBut setTitle:@"已过期" forState:UIControlStateNormal];
//    }else{
    
        
        [cell.seleBut setBackgroundColor:UIColorFromRGB(0xF83A5E)];
        
        [cell.seleBut setTitle:@"分享一下" forState:UIControlStateNormal];
        
        [cell.seleBut addTarget:self action:@selector(PromoteButton:) forControlEvents:UIControlEventTouchUpInside];

//    }

    [cell.buyBtn addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    return cell;
}

-(void)buyButtonClick:(UIButton *)btn{
    
    ChooseCell * cell = (ChooseCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];
    Shop * shop = dataAry[indexPath.row];
    DetailsViewController * vc =[[DetailsViewController alloc]init];
    vc.urlStr = shop.urlContent;
    [self.navigationController pushViewController:vc animated:YES];

    
    
}
//表删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        Shop * shop =dataAry[indexPath.row];
        [dataAry removeObjectAtIndex:indexPath.row];
        NSArray * students =[Shop MR_findByAttribute:@"goodid" withValue:shop.goodid];
        for (Shop * tmp in students) {
            [tmp MR_deleteEntity];
        }
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
        
        
        // 删除一行或者多行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSArray * array1=[[[Shop MR_findAll] reverseObjectEnumerator]allObjects];
        dataAry=[NSMutableArray arrayWithArray:array1];
        
        
        [self.tableView reloadData];

       
    
    
    
    }else if(editingStyle == (UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert)){
        
        
    }
    
    
    
   
}


//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//     Shop * shop =dataAry[indexPath.row];
//    CGSize size =[shop.content boundingRectWithSize:CGSizeMake(WINDOWRECT_WIDTH-8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil].size;

    return 98;
}
-(void)CopyTextBtn:(UIButton *)btn {
    
    ChooseCell * cell = (ChooseCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];
    Shop * shop = dataAry[indexPath.row];
   
    
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    NSString *string = shop.text;
    
    [pab setString:string];
    

    
    if (pab == nil) {
        
        
        [self.view makeToast:@"复制失败" duration:2 position:@"center"];
        
    }else
    {
        [self.view makeToast:@"复制成功" duration:2 position:@"center"];
        
        
    }

}
-(void)PromoteButton:(UIButton *)btn {
    ChooseCell * cell = (ChooseCell *)[[btn superview]superview];
    NSIndexPath * indexPath =[self.tableView indexPathForCell:cell];
    Shop * shop = dataAry[indexPath.row];
    LRLog(@"%@---%@",   shop.text,shop.thumb);
    ShopModel * model =[Customer ModelWithShop:shop];

    
//    if (![shop.isChoose isEqualToString:@"1"]) {
    
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        
        NSString *string = shop.text;
        
        [pab setString:string];
        
    
    UIImage * imagerang=[Customer createViewImage:model];
    
    NSArray *activityItems = @[imagerang];
    

        UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        //
        //    //尽量不显示其他分享的选项内容
        ////
        activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
        
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
            UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
            {
                LRLog(@"activityType :%@", activityType);
                if (completed)
                {
                    LRLog(@"completed");
                    
                    [self.view makeToast:@"分享成功,去粘贴文案吧！" duration:2 position:@"center"];
                }
                else
                {
                    LRLog(@"cancel");
                }
                
            };
            
            // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
            activityViewController.completionWithItemsHandler = myBlock;
        }
        
        
        
        if (activityViewController) {
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
        

        
//    }
    
}
-(void)setButtonClick:(UIButton *)btn {

    AddRobotViewController * vc =[[AddRobotViewController alloc]init];
     vc.shopAry=selectArray;
    [self.navigationController pushViewController:vc animated:YES];

    
    
}
-(void)requestDataWithitemid:(NSString *)itmeid{
    NSString * once =[Customer once];
    NSString * time=[Customer timeString];
    NSString * sign = [Customer initWithTime:time nonce:once];
    
    NSString * api =[NSString stringWithFormat:@"http://api.tkjidi.com/index.php?m=App&a=invalid&timestamp=%@&nonce=%@&sign=%@",time,[NSString md5To32bit:once],sign];

//    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:api params:@{@"taobaoid":itmeid} successBlock:^(id returnData, int code, NSString *msg) {
        
//        id ary = returnData[@"data"];
        LRLog(@"%@--%@",returnData[@"data"],msg);
        if ([returnData[@"status"] intValue]==200&&returnData[@"data"]!=[NSNull null]) {
            
            id ary =returnData[@"data"];
            
            for (NSString * str in ary) {
               
                NSArray * students =[Shop MR_findByAttribute:@"goodid" withValue:str];
                for (Shop * tmp in students) {
                    
                    tmp.isChoose=@"1";//代表过期
                
                }
                
            }
           
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];

        }
        NSArray * array1=[[[Shop MR_findAll] reverseObjectEnumerator]allObjects];
        dataAry=[NSMutableArray arrayWithArray:array1];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        LRLog(@"%@",error);
        
    } showHUD:YES];
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
         
            [weakSelf loadClassButton];
        }
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
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
