//
//  ChainViewController.m
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChainViewController.h"
#import "ChainModel.h"
#import "YBLabel.h"
#import "ShareView.h"
@interface ChainViewController ()<UIScrollViewDelegate>{
    
    NSMutableArray * numAry;
    NSMutableArray * modelAry;
    
    NSString * CampaignID;
    NSString * ShopKeeperID;
    
    CGFloat  dxMax;
    CGFloat  ptMax;
    CGFloat  gyMax;
    
    dispatch_group_t serviceGroup;
    
    NSArray * titleAry;

    NSString * pwd;
    NSString * short_url;
    NSString * text;
    NSString * urls;
    NSString * channel;
    
    YBLabel * textLab;
    
//    UIImageView * imageView;
    
    
    float mark;
    float height;
    
    UIView * bgView;
    
    ShareView * shareView;

}
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *lastBottomLine;
@property (nonatomic, strong) UIView *wrapperView;

@property(nonatomic , strong)NSString * dx;
@property(nonatomic , strong)NSString * pid;
@property(nonatomic , strong)NSString * name;
@end

@implementation ChainViewController

- (void)viewWillAppear:(BOOL)animated{
    
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
    self.title=@"推广详情";
    numAry=[[NSMutableArray alloc]init];
    modelAry=[[NSMutableArray alloc]init];

//    LRLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]);
    
    serviceGroup = dispatch_group_create();

    [self requestWithHigh];

    [self requestWithOrdinary];
   
        
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        
        self.pid=[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"];
        
        
        LRLog(@">>>>>>%@",self.pid);
        
        
        if (ptMax==YBMAX(ptMax, dxMax, gyMax)) {
                
            self.dx=@"1";
       
            channel=@"";
            self.model.rate=[NSString stringWithFormat:@"%.1f",ptMax];
            self.name=@"通用";
            [self requsetWithMerge];
                
        }else if (dxMax==YBMAX(ptMax, dxMax, gyMax)){
                
            self.dx=@"1";
            self.model.rate=[NSString stringWithFormat:@"%.1f",dxMax];
            self.name=@"定向";
            channel=@"";
            [self requestWithDingxiang];
                
        }else{
            channel=@"&channel=tk_qqhd";
            self.dx=@"3";
            self.name=@"高佣";
            self.model.rate=[NSString stringWithFormat:@"%.1f",gyMax];
            [self requsetWithMerge];
        }
            
    });
    
}
-(void)uploadViewWithPwd:(NSString *)pwdStr URL:(NSString *)url{
    
    pwd=pwdStr;
    
    short_url=url;
    
    self.model.quanhou=[NSString stringWithFormat:@"%.1f",[self.model.shoujia floatValue]-[self.model.yhPrice floatValue]];
 
    mark = [self.model.quanhou floatValue]*([self.model.rate floatValue]/100);
    //    NSLog(@"%@",short_url);
    
    self.wrapperView = [UIView new];
    self.wrapperView.backgroundColor=[UIColor whiteColor];
    [self.scroollView addSubview:self.wrapperView];
    [self.scroollView setupAutoContentSizeWithBottomView:self.wrapperView bottomMargin:0];
    
    [self setupImageCell];

    [self setupLableCell];
    
    self.wrapperView.sd_layout.
    leftEqualToView(self.scroollView)
    .rightEqualToView(self.scroollView)
    .topSpaceToView(self.scroollView,64);
    [self.wrapperView setupAutoHeightWithBottomView:self.lastBottomLine bottomMargin:0];

}
- (UIScrollView *)scroollView
{
    if (!_scroollView) {
        _scroollView = [UIScrollView new];
        _scroollView.backgroundColor=UIColorFromRGB(0xF2F3F4);
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
    line.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self.wrapperView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.wrapperView, 0)
    .rightSpaceToView(self.wrapperView, 0)
    .heightIs(10)
    .topSpaceToView(view, margin);
    
    return line;
}

- (UIButton *)buttonWithTitle:(NSString *)title bgColor:(UIColor *)bgColor sel:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button setTitleColor:bgColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}



- (void)setupImageCell
{
    if (IPHONE4||IPHONE5) {
        
        height=300;
        
    }else if (iPhone6Plus_6sPlus){
        
        
        height=400;
        
    }else{
        
     
        height=350;
        
    }

    
    
    UIImageView * headerImg =[[UIImageView alloc]init];
//    headerImg.clipsToBounds=YES;
//    headerImg.contentMode=UIViewContentModeScaleAspectFill;
    
    [headerImg sd_setImageWithURL:[NSURL URLWithString:self.model.thumb] placeholderImage:[UIImage imageNamed:@"111"]];
    
    
    UILabel * titleLab=[[UILabel alloc]init];
    titleLab.text=[NSString stringWithFormat:@"%@",self.model.title];
    titleLab.numberOfLines=0;
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textColor=UIColorFromRGB(0x666666);
    
    
//    UIImageView * tmallImg =[[UIImageView alloc]init];
//    if ([self.model.tmall isEqualToString:@"1"]) {
//        
//        tmallImg.image=[UIImage imageNamed:@"tm"];
//        
//    }else{
//        
//        tmallImg.image=[UIImage imageNamed:@"tb"];
//        
//    }
    
 
    
    UILabel * rateLab =[[UILabel alloc]init];
    rateLab.font=[UIFont systemFontOfSize:12];
    rateLab.textColor=UIColorFromRGB(0x666666);
    
    NSString * rateStr =[NSString stringWithFormat:@"佣金比例:%@%%(￥%.1f)",self.model.rate,mark];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:rateStr];
        NSRange range = [rateStr rangeOfString:@"("];
    
//       LRLog(@"%d",range.location);
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16]
     
                          range:NSMakeRange(5, range.location-5)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:UIColorFromRGB(0xff5170)
     
                          range:NSMakeRange(5, range.location-5)];
   
    rateLab.attributedText=AttributedStr;
    
    CGSize rateSize =[rateLab.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }];
    
 
    
    UILabel * qhLab=[[UILabel alloc]init];
//    qhLab.text=[NSString stringWithFormat:@"券后￥%@",self.model.quanhou];
    qhLab.font=[UIFont systemFontOfSize:14];
    qhLab.textColor=UIColorFromRGB(0x666666);
    
    NSString * qhStr =[NSString stringWithFormat:@"券后￥%@",self.model.quanhou];
    NSUInteger length = [qhStr length];
    NSMutableAttributedString * qhAttStr = [[NSMutableAttributedString alloc]initWithString:qhStr];
    [qhAttStr addAttribute:NSForegroundColorAttributeName
     
                          value:UIColorFromRGB(0xff5170)
     
                          range:NSMakeRange(2, length-2)];

    qhLab.attributedText=qhAttStr;
    CGSize qhSize =[qhLab.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    
    
    UILabel * priceLab=[[UILabel alloc]init];
//    priceLab.text=[NSString stringWithFormat:@"￥%@",self.model.shoujia];
    priceLab.font=[UIFont systemFontOfSize:14];
    priceLab.textColor=UIColorFromRGB(0x666666);
    NSString * priceStr =[NSString stringWithFormat:@"￥%@",self.model.shoujia];
    NSUInteger pricelength = [priceStr length];
    NSMutableAttributedString * priceAttStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [priceAttStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0,pricelength)];
    
    priceLab.attributedText=priceAttStr;

    
   
    
    int num =  [self.model.yhql intValue]+[self.model.yhqsy intValue];
    
    UILabel * yhPriceLab=[[UILabel alloc]init];
//    yhPriceLab.text=[NSString stringWithFormat:@"%@元优惠券,剩余数量%@/%d",self.model.yhPrice,self.model.yhqsy,num];
    yhPriceLab.font=[UIFont systemFontOfSize:14];
    yhPriceLab.textColor=UIColorFromRGB(0x666666);

    NSLog(@"%@",self.model.yhqsy);
    NSString * syStr =[NSString stringWithFormat:@"%@元优惠券,剩余数量%@/%d",self.model.yhPrice,self.model.yhqsy,num];
    NSRange syRang = [syStr rangeOfString:@","];
    NSUInteger sylength = [self.model.yhqsy length];
    NSMutableAttributedString * AttStr = [[NSMutableAttributedString alloc]initWithString:syStr];
    [AttStr addAttribute:NSForegroundColorAttributeName
     
                     value:UIColorFromRGB(0xff5170)
     
                     range:NSMakeRange(syRang.location+5,sylength)];


    yhPriceLab.attributedText=AttStr;

    
//    UILabel * kucunLab =[[UILabel alloc]init];
//    kucunLab.text=[NSString stringWithFormat:@"剩余数量%@",self.model.yhqsy];
//    kucunLab.font=[UIFont systemFontOfSize:14];
//    kucunLab.textColor=UIColorFromRGB(0x333333);
    

    UILabel * salesLab =[[UILabel alloc]init];
    salesLab.text=[NSString stringWithFormat:@"月销量%@",self.model.sales];
    salesLab.font=[UIFont systemFontOfSize:14];
    salesLab.textColor=UIColorFromRGB(0x666666);

    UIButton * tyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    tyBtn.backgroundColor=UIColorFromRGB(0xFB5949);
    [tyBtn setTitle:self.name forState:UIControlStateNormal];
    [tyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tyBtn.layer.masksToBounds=YES;
    tyBtn.layer.cornerRadius=10;
    tyBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    
    UILabel * lab =[[UILabel alloc]init];
    lab.text=@"已生效";
    lab.textColor=UIColorFromRGB(0xF83A5E);
    lab.font=[UIFont systemFontOfSize:12];
    
    
//    UIButton * addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    addBtn.backgroundColor=UIColorFromRGB(0xF83A5E);
//    addBtn.titleLabel.font=[UIFont systemFontOfSize:12];
//    addBtn.titleLabel.numberOfLines=0;
//    addBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [addBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
//    [addBtn setTitle:@"加入\n商品库" forState:UIControlStateNormal];
//    addBtn.layer.masksToBounds=YES;
//    addBtn.layer.cornerRadius=24;
//    [addBtn setTitle:@"详情" forState:UIControlStateNormal];
//    addBtn.imageEdgeInsets=UIEdgeInsetsMake(-20, 0, 0, -25);
//    addBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -20, -20, 0);
//    [addBtn setImage:[UIImage imageNamed:@"xq"] forState:UIControlStateNormal];
//    [addBtn addTarget:self action:@selector(shopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.wrapperView sd_addSubviews:@[headerImg,titleLab,rateLab,qhLab,salesLab,priceLab,yhPriceLab,tyBtn,lab]];
    
    headerImg.sd_layout
    .leftSpaceToView(self.wrapperView, 0)
    .topSpaceToView(self.wrapperView, 0)
    .rightSpaceToView(self.wrapperView, 0)
    .heightIs(height);
    
//    addBtn.sd_layout
//    .rightSpaceToView(self.wrapperView,5)
//    .topSpaceToView(headerImg, 5)
//    .widthIs(50)
//    .heightIs(50);
    
    titleLab.sd_layout
    .leftSpaceToView(self.wrapperView, 10)
    .topSpaceToView(headerImg, 5)
    .rightSpaceToView(self.wrapperView, 10)
    .autoHeightRatio(0);
    
    
//    tmallImg.sd_layout
//    .leftSpaceToView(self.wrapperView,10)
//    .topSpaceToView(headerImg,8)
//    .widthIs(10)
//    .heightIs(10);
    
    
    rateLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(titleLab, 2)
    .heightIs(20)
    .widthIs(rateSize.width+20);

    
    qhLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(rateLab, 2)
    .heightIs(20)
    .widthIs(qhSize.width);
    
    
    priceLab.sd_layout
    .leftSpaceToView(qhLab,10)
    .topSpaceToView(rateLab, 2)
    .heightIs(20)
    .rightSpaceToView(self.wrapperView, 70);
    
    
    yhPriceLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(qhLab, 2)
    .rightSpaceToView(self.wrapperView, 70)
    .autoHeightRatio(0);

    
    salesLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(yhPriceLab, 5)
    .rightSpaceToView(self.wrapperView, 70)
    .autoHeightRatio(0);
    
    tyBtn.sd_layout
    .leftSpaceToView(rateLab,0)
    .topSpaceToView(titleLab, 3)
    .widthIs(40)
    .heightIs(20);
    
    lab.sd_layout
    .leftSpaceToView(tyBtn,2)
    .topSpaceToView(titleLab, 3)
    .widthIs(40)
    .heightIs(20);
    

    
    self.lastBottomLine = [self addSeparatorLineBellowView:salesLab margin:10];
}

- (void)setupLableCell{
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isDefault"]==YES) {
        
        text =[[NSUserDefaults standardUserDefaults]objectForKey:@"defaultText"];
    }else{
        
        text =[[NSUserDefaults standardUserDefaults]objectForKey:@"text"];
    }
    
    NSString * suffix =[defaults objectForKey:@"suffix"];
    
    if ([suffix length]>0) {
        
        text=[NSString stringWithFormat:@"%@\n%@",text,suffix];
        
    }

    LRLog(@"111>>>>%@",self.model.yhPrice);
    for (int i = 0; i<7; i++) {
        
        if ([text rangeOfString:@"{cvalue}"].location!=NSNotFound) {
            
            text = [text stringByReplacingOccurrencesOfString:@"{cvalue}" withString:self.model.yhPrice];
         
            
            
        }else if ([text rangeOfString:@"{title}"].location!=NSNotFound){
            
            text = [text stringByReplacingOccurrencesOfString:@"{title}" withString:self.model.title];
            
        }else if ([text rangeOfString:@"{price}"].location!=NSNotFound){
            
            text = [text stringByReplacingOccurrencesOfString:@"{price}" withString:self.model.shoujia];
            
        }else if ([text rangeOfString:@"{qhprice}"].location!=NSNotFound){
            
            text = [text stringByReplacingOccurrencesOfString:@"{qhprice}" withString:self.model.quanhou];
            
        }else if ([text rangeOfString:@"{pwd}"].location!=NSNotFound){
            
            text = [text stringByReplacingOccurrencesOfString:@"{pwd}" withString:pwd];
            
        }else if ([text rangeOfString:@"{short_url}"].location!=NSNotFound){
            
            text = [text stringByReplacingOccurrencesOfString:@"{short_url}" withString:short_url];
            
        }else if ([text rangeOfString:@"{guid_content}"].location!=NSNotFound){
            
            LRLog(@"【推荐语】%@",self.model.guid_content);
            
            if (![self.model.guid_content isEqualToString:@""]) {
                
                NSString * content =[NSString stringWithFormat:@"【推荐语】%@",self.model.guid_content];
                text = [text stringByReplacingOccurrencesOfString:@"{guid_content}" withString:content];
                
            }else{
                
                text = [text stringByReplacingOccurrencesOfString:@"{guid_content}" withString:self.model.guid_content];
                
            }
            
            
        }
        
    }

    
//    [self addShopClick];
    
    bgView =[[UIView alloc]init];
    bgView.backgroundColor=UIColorFromRGB(0xf3f3f3);
   

    UILabel * titleLab =[[UILabel alloc]init];
    titleLab.text=@"复制这条口令，打开淘宝即可看见";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textColor=UIColorFromRGB(0x666666);
    
    
    textLab =[[YBLabel alloc]init];
    textLab.font=[UIFont systemFontOfSize:14];
//    textLab.adjustsFontSizeToFitWidth=YES;
    textLab.numberOfLines=0;
    textLab.textColor=UIColorFromRGB(0x666666);
    textLab.layer.borderColor=UIColorFromRGB(0xfd355a).CGColor;
    textLab.layer.borderWidth=1;
    textLab.backgroundColor=UIColorFromRGB(0xffe7eb);
    textLab.text=[NSString stringWithFormat:@"%@",text];
    
    UILabel * tsLab =[[UILabel alloc]init];
    tsLab.text=@"Tips:请不要更改{}之间的文字哦~";
    tsLab.font=[UIFont systemFontOfSize:12];
    tsLab.textColor=UIColorFromRGB(0x666666);
    
    UIButton * copyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [copyBtn setImage:[UIImage imageNamed:@"fz"] forState:UIControlStateNormal];
    [copyBtn setTitle:@" 仅复制分享文案" forState:UIControlStateNormal];
    [copyBtn setTitleColor:UIColorFromRGB(0xF83A5E) forState:UIControlStateNormal];
    copyBtn.tag=20;
    [copyBtn addTarget:self action:@selector(ChainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton * shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn setTitle:[NSString stringWithFormat:@"一键复制图文分享赚￥%.2f",mark] forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:UIColorFromRGB(0xF83A5E)];
    shareBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    shareBtn.layer.masksToBounds=YES;
    shareBtn.layer.cornerRadius=15;
    shareBtn.tag=21;
    [shareBtn addTarget:self action:@selector(ChainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgView sd_addSubviews:@[titleLab,textLab,tsLab,copyBtn,shareBtn]];
    
//    bgView.sd_equalWidthSubviews = @[titleLab,textLab,tsLab,copyBtn,shareBtn];
    
    titleLab.sd_layout
    .leftSpaceToView(bgView, 2)
    .topSpaceToView(bgView, 0)
    .rightSpaceToView(bgView, 2)
    .heightIs(30);
    
    textLab.sd_layout
    .leftSpaceToView(bgView, 2)
    .topSpaceToView(titleLab, 5)
    .rightSpaceToView(bgView, 2)
    .autoHeightRatio(0);
    
    copyBtn.sd_layout
    .rightSpaceToView(bgView,0)
    .topSpaceToView(textLab,2)
    .heightIs(30)
    .widthIs(120);
    
    tsLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(textLab, 5)
    .heightIs(20)
    .rightSpaceToView(copyBtn, 10);
    

    shareBtn.sd_layout
    .leftSpaceToView(bgView,10)
    .rightSpaceToView(bgView,10)
    .topSpaceToView(tsLab,20)
    .heightIs(40);
    

    
    [self.wrapperView sd_addSubviews:@[bgView]];
    
    bgView.sd_layout
    .leftSpaceToView(self.wrapperView,0)
    .rightSpaceToView(self.wrapperView,0)
    .topSpaceToView(self.lastBottomLine,0);
    
     [bgView setupAutoHeightWithBottomView:shareBtn bottomMargin:0];
    
    self.lastBottomLine = [self addSeparatorLineBellowView:bgView margin:0];
    
}
-(void)shopButtonClick{
    
    DetailsViewController * vc =[[DetailsViewController alloc]init];
    vc.urlStr=self.model.url_shop;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--加入商品库
-(void)addShopClick{

    NSArray * students =[Shop MR_findByAttribute:@"goodid" withValue:self.model.goodsId];
    
    if (students.count==0) {
    
        LRLog(@"---------%@",text);
        
        Shop * shop =[Shop MR_createEntity];
        
        shop.goodid=self.model.goodsId;
        shop.title=self.model.title;
        shop.url_shop=self.model.url_shop;
        shop.shoujia=self.model.shoujia;
        shop.quanhou=self.model.quanhou;
        shop.yhLink=self.model.yhLink;
        shop.yhPrice=self.model.yhPrice;
        shop.content=self.model.guid_content;
        shop.thumb =self.model.thumb;
        shop.rate =self.model.rate;
        shop.class_name=self.model.class_name;
        shop.sales=self.model.sales;
        shop.tmall=self.model.tmall;
        shop.urlContent=short_url;
        shop.text=text;
        shop.yj=[NSString stringWithFormat:@"佣金:%.2f",([self.model.quanhou floatValue]*[self.model.rate floatValue])/100];

        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
         [self.view makeToast:@"收藏成功" duration:2 position:@"center"];
        
    }else{
        
         [self.view makeToast:@"已加入商品库" duration:1 position:@"center"];
    }
  
}

-(void)ChainButtonClick:(UIButton *)btn{
    
    if (btn.tag==20) {
        
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        
        NSString *string = textLab.text;
        
        [pab setString:string];

        if (pab == nil) {
        
        
            [self.view makeToast:@"复制失败" duration:2 position:@"center"];
            
        }else
        {
            [self.view makeToast:@"复制成功" duration:2 position:@"center"];

            
        }
        
        
    }else{
     
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        
        NSString *string = textLab.text;
        
        [pab setString:string];
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.thumb]];
        UIImage *imagerang = [UIImage imageWithData:data];
        
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
        
        
    }
}

//查高佣或定向
-(void)requestWithHigh{

    NSLog(@"%@",self.model.url_shop);
    dispatch_group_enter(serviceGroup);
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:@"http://pub.alimama.com/items/channel/qqhd.json?" params:@{@"q":weakSelf.model.url_shop,@"channel":@"qqhd",@"perPageSize":@"40"} successBlock:^(id returnData, int code, NSString *msg) {
        
        LRLog(@"------%@",returnData);
        
        if (returnData[@"data"]!=[NSNull null]) {
        
            id dic = returnData[@"data"][@"head"];
            NSString  * status =dic[@"status"];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"OK"]) {
                id listDic = returnData[@"data"][@"pageList"][0];
                
                gyMax=[listDic[@"eventRate"] floatValue];
                
                self.model.yhPrice=[NSString stringWithFormat:@"%@",listDic[@"couponAmount"]];
//                self.model.rate=[NSString stringWithFormat:@"%@",listDic[@"tkRate"]];
                self.model.shoujia=[NSString stringWithFormat:@"%.1f",[listDic[@"zkPrice"] floatValue]];


    
                NSLog(@"高佣>>>>>>>%@",listDic[@"eventRate"]);
                if (listDic[@"tkSpecialCampaignIdRateMap"]!=[NSNull null]) {
                    
                    NSDictionary * tkDic=listDic[@"tkSpecialCampaignIdRateMap"];
                    NSArray * tkAry = tkDic.allValues;
                    dxMax = [[tkAry valueForKeyPath:@"@max.floatValue"] floatValue];
                    
                    NSLog(@"定向>>>>>>>>%f",dxMax);
                }else{
                    NSLog(@"======没有定向======");
                }

            }else{
                
                NSLog(@"======没有高佣======");
            }
            
        }

        dispatch_group_leave(serviceGroup);
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
    } showHUD:YES];
}
//查普通佣金或定向
-(void)requestWithOrdinary{
     dispatch_group_enter(serviceGroup);
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager getRequstWithURL:@"http://pub.alimama.com/items/search.json?" params:@{@"q":weakSelf.model.url_shop,@"perPageSize":@"40"} successBlock:^(id returnData, int code, NSString *msg) {
        
        LRLog(@"------%@",returnData);
        
        if (returnData[@"data"]!=[NSNull null]) {
            id dic = returnData[@"data"][@"head"];
            NSString  * status =dic[@"status"];
            if ([status isEqualToString:@"OK"]) {
                id listDic = returnData[@"data"][@"pageList"][0];
                NSLog(@"普通>>>>>>>%@",listDic[@"tkRate"]);
                ptMax=[listDic[@"tkRate"] floatValue];
               
                LRLog(@"%@",listDic[@"couponAmount"]);
                //商品信心获取
                self.model.yhPrice=[NSString stringWithFormat:@"%@",listDic[@"couponAmount"]];
//                self.model.rate=[NSString stringWithFormat:@"%@",listDic[@"tkRate"]];
                self.model.shoujia=[NSString stringWithFormat:@"%.1f",[listDic[@"zkPrice"] floatValue]];

                    LRLog(@"%@", self.model.yhPrice);
                
                if (listDic[@"tkSpecialCampaignIdRateMap"]!=[NSNull null]) {
                    
                    NSDictionary * tkDic=listDic[@"tkSpecialCampaignIdRateMap"];
                    NSArray * tkAry = tkDic.allValues;
                    dxMax = [[tkAry valueForKeyPath:@"@max.floatValue"] floatValue];
                    NSLog(@"定向>>>>>>>>%f",dxMax);
                    
                }else{
                    NSLog(@"======没有定向======");
                    
                }
                
            }
          
        }
        dispatch_group_leave(serviceGroup);

        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error---\n%@",error);
        
    } showHUD:YES];
}
//获取定向最高
-(void)requestWithDingxiang{
    
    NSLog(@"%@",self.model.goodsId);
    NSString * cookie =[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"];
    NSString * url =[NSString stringWithFormat:@"http://pub.alimama.com/pubauc/getCommonCampaignByItemId.json?itemId=%@&t=%@",self.model.goodsId,[Customer timeString]];
    AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager.requestSerializer setValue:cookie forHTTPHeaderField:@"cookie"];
        __weak __typeof(self)weakSelf = self;
    [operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
               LRLog(@">>>>>>>%@",operation.responseString);
        id ary =operation.responseObject[@"data"];
        for (NSDictionary * dic in ary) {
            
            [numAry addObject:dic[@"commissionRate"]];
            
            ChainModel * model =[[ChainModel alloc]init];
            model.commissionRate = dic[@"commissionRate"];
            model.CampaignID = dic[@"CampaignID"];
            model.ShopKeeperID = dic[@"ShopKeeperID"];
            model.CampaignName = dic[@"CampaignName"];
            [modelAry addObject:model];
        }
        [weakSelf requestWithToapplyfor];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"cookie 失效");
        
        PIDViewController * vc =[[PIDViewController alloc]init];
        vc.isCheck=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}
//申请定向
-(void)requestWithToapplyfor{
    
    CGFloat maxValue = [[numAry valueForKeyPath:@"@max.floatValue"] floatValue];
    
    for (ChainModel * model in modelAry) {
        
        if ([model.commissionRate floatValue]==maxValue) {
            CampaignID=model.CampaignID;
            ShopKeeperID=model.ShopKeeperID;
        }
        
    }
   
    NSString * cookie =[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"];
    NSString * token =[[[[cookie componentsSeparatedByString:@"_tb_token_="] lastObject] componentsSeparatedByString:@";"] firstObject];
    
    
    AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager.requestSerializer setValue:cookie forHTTPHeaderField:@"cookie"];
            __weak __typeof(self)weakSelf = self;
    [operationManager POST:@"http://pub.alimama.com/pubauc/applyForCommonCampaign.json" parameters:@{@"campId":CampaignID,@"keeperid":ShopKeeperID,@"applyreason":@"111111",@"t":[Customer timeString],@"_tb_token_":token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
//        NSLog(@">>>>>>>%@",operation.responseString);
        NSString * message =operation.responseObject[@"info"][@"message"];
        if ((NSNull *)message==[NSNull null]||[message rangeOfString:@"已经在申请该计划或您已经申请过该掌柜计划"].location!=NSNotFound) {
            [weakSelf requsetWithMerge];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

//二合一
-(void)requsetWithMerge{
   
//    NSString * activityId =[[[[self.model.yhLink componentsSeparatedByString:@"activity_id="] lastObject] componentsSeparatedByString:@";"] firstObject];
//
//    
////    https://uland.taobao.com/cp/coupon?activityId=%@&itemId=%@&dx=1
//    
//
//    NSString * url =[NSString stringWithFormat:@"https://uland.taobao.com/coupon/edetail?activityId=%@&itemId=%@&dx=%@",activityId,self.model.goodsId,self.dx];
//    __weak __typeof(self)weakSelf = self;
//
//    [MHNetworkManager getRequstWithURL:@"https://api.weibo.com/2/short_url/shorten.json?source=1681459862" params:@{@"url_long":url} successBlock:^(id returnData, int code, NSString *msg) {
//        
//        
//        NSLog(@"%@",returnData);
//        id ary =returnData[@"urls"];
//        for (NSDictionary * dic in ary) {
//            
//            
//            urls =dic[@"url_short"];
//        
//            
//        }
//        
//        [weakSelf uploadViewWithPwd:@"" URL:urls];
//        
//    } failureBlock:^(NSError *error) {
//        
//        
//        
//    } showHUD:NO];
//    
//    
//    
//    
    
    
    
    
    
    
    
  
    NSString * cookie =[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"];
    NSString * token =[[[[cookie componentsSeparatedByString:@"_tb_token_="] lastObject] componentsSeparatedByString:@";"] firstObject];
   
    
    NSArray * ary =[self.pid componentsSeparatedByString:@"_"];
    NSString * adzoneid =[ary lastObject];
    NSString * siteid   =ary[ary.count-2];
    
    //时间戳
    NSString * time =[ NSString stringWithFormat:@"%lld",[[Customer timeString] longLongValue]];

    
    //请求的链接
    NSString * reqUrl = [NSString stringWithFormat:@"http://pub.alimama.com/common/code/getAuctionCode.json?auctionid=%@&adzoneid=%@&siteid=%@&scenes=%@&t=%@&_tb_token_=%@%@",self.model.goodsId,adzoneid,siteid,self.dx,time,token,channel];
    NSLog(@"%@",reqUrl);
    
    NSString * cookiesStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"];
    __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
    //设置cookie
    
    [operationManager.requestSerializer setValue:cookiesStr forHTTPHeaderField:@"cookie"];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operationManager GET:reqUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LRLog(@">>>>>>>%@",operation.responseString);
        NSString * jsonStr =[[[[operation.responseString componentsSeparatedByString:@"("] lastObject] componentsSeparatedByString:@")"] firstObject];
        
        NSDictionary * dic = [self dictionaryWithJsonString:jsonStr];
        
        if(dic[@"data"]!=[NSNull null]){
            NSString * taoToken=dic[@"data"][@"couponLinkTaoToken"];
            if (taoToken.length>0) {
                
                [weakSelf uploadViewWithPwd:dic[@"data"][@"couponLinkTaoToken"] URL:dic[@"data"][@"couponShortLinkUrl"]];
                
            }else{
                
                [self.view makeToast:@"没有优惠券" duration:3 position:@"center"];
            }

        }else{
            
            [self.view  makeToast:dic[@"info"][@"message"] duration:2 position:@"center"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        
        NSLog(@"%@",[error localizedDescription]);
        
    }];

    
    
    
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
    tabbar.tabbar.hidden = NO;
    
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)keyboardWillShowNotification:(NSNotification *)note
{
    
    [self.view endEditing:YES];
    // code
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
