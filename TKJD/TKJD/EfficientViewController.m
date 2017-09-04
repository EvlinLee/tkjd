//
//  EfficientViewController.m
//  TKJD
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "EfficientViewController.h"
#import "ChainModel.h"
#import "YBLabel.h"
#import "ShareView.h"
@interface EfficientViewController ()<UIScrollViewDelegate,UITextViewDelegate>{
    
    NSString * pwd;
    NSString * short_url;
    NSString * coupon_click_url;
    NSString * activityId;
    
    float mark;
    NSString * text;
    UIView * bgView;
//    YBLabel * textLab;
    UIImageView * headerImg;
    
    
     UITextView * textView;
    
}
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *lastBottomLine;
@property (nonatomic, strong) UIView *wrapperView;

@property(nonatomic , strong)NSString * pid;


@end

@implementation EfficientViewController
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    self.pid=[defaults objectForKey:@"pid"];
    
    if ([[defaults objectForKey:@"valid_time"] longLongValue]>[[Customer timeString] longLongValue]&&[defaults objectForKey:@"valid_time"]!=nil) {
        
        if ([[defaults objectForKey:@"expire_time"] longLongValue]>[[Customer timeString] longLongValue]) {
            
            if ([defaults objectForKey:@"pid"]!=nil) {
                
                [self requestApi];
            
            }else{
                
                PIDViewController * vc =[[PIDViewController alloc]init];
                vc.isCheck=YES;
                [self.navigationController pushViewController:vc animated:NO];
                
                //                [self.view makeToast:@"还没有设置推广位哦！" duration:2 position:@"center"];
            }

//            [self requestApi];
            
        }else{
            
            [self requestAccessToken];
            
        }
        
    }else{
        
        NSLog(@"1");
        
        GrantViewController * vc =[[GrantViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

   
}
-(void)uploadViewWithPwd:(NSString *)pwdStr URL:(NSString *)url{
    
    pwd=pwdStr;
    
    short_url=url;
    
    self.model.tmall=url;
    
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
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    tap.numberOfTapsRequired = 1;
    [self.wrapperView addGestureRecognizer:tap];

    
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
- (void)setupImageCell{
    
    headerImg =[[UIImageView alloc]init];
    [headerImg sd_setImageWithURL:[NSURL URLWithString:self.model.thumb] placeholderImage:[UIImage imageNamed:@"111"]];
    headerImg.tag=1000;
    headerImg.userInteractionEnabled=YES;
    
    
    UILabel * titleLab=[[UILabel alloc]init];
    titleLab.text=[NSString stringWithFormat:@"%@",self.model.title];
    titleLab.numberOfLines=0;
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textColor=UIColorFromRGB(0x666666);
    
    mark = ([self.model.quanhou floatValue]*[self.model.rate floatValue])/100;
   
    UILabel * rateLab =[[UILabel alloc]init];
    rateLab.font=[UIFont systemFontOfSize:12];
    rateLab.textColor=UIColorFromRGB(0x666666);
    
    NSString * rateStr =[NSString stringWithFormat:@"佣金比例:%.2f%%(￥%.2f)",[self.model.rate floatValue],mark];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:rateStr];
    NSRange range = [rateStr rangeOfString:@"("];

    
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16]
     
                          range:NSMakeRange(5, range.location-5)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:UIColorFromRGB(0xff5170)
     
                          range:NSMakeRange(5, range.location-5)];
    
    rateLab.attributedText=AttributedStr;
    
    CGSize rateSize =[rateLab.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }];
    
    
    
    UILabel * qhLab=[[UILabel alloc]init];
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
    priceLab.font=[UIFont systemFontOfSize:14];
    priceLab.textColor=UIColorFromRGB(0x666666);
    NSString * priceStr =[NSString stringWithFormat:@"￥%@",self.model.shoujia];
    NSUInteger pricelength = [priceStr length];
    NSMutableAttributedString * priceAttStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [priceAttStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0,pricelength)];
    
    priceLab.attributedText=priceAttStr;
    
    NSString *  num =  [NSString stringWithFormat:@"%d",[self.model.yhql intValue]+[self.model.yhqsy intValue]];
    
    UILabel * yhPriceLab=[[UILabel alloc]init];
    yhPriceLab.font=[UIFont systemFontOfSize:14];
    yhPriceLab.textColor=UIColorFromRGB(0x666666);
    
    
   
    NSString * syStr =[NSString stringWithFormat:@"%d元优惠券,发行量:%@张",[self.model.yhPrice intValue],num];
    NSRange syRang = [syStr rangeOfString:@","];
    NSUInteger sylength = [num length];
    NSMutableAttributedString * AttStr = [[NSMutableAttributedString alloc]initWithString:syStr];
    [AttStr addAttribute:NSForegroundColorAttributeName
         
                    value:UIColorFromRGB(0xff5170)
         
                    range:NSMakeRange(syRang.location+5,sylength)];
    
        
    yhPriceLab.attributedText=AttStr;
        
        
        
    
    
    
    
    
    UILabel * salesLab =[[UILabel alloc]init];
    salesLab.text=[NSString stringWithFormat:@"月销量%@",self.model.sales];
    salesLab.font=[UIFont systemFontOfSize:14];
    salesLab.textColor=UIColorFromRGB(0x666666);
    
    
    [self.wrapperView sd_addSubviews:@[headerImg,titleLab,rateLab,qhLab,salesLab,priceLab,yhPriceLab]];
    
    
    headerImg.sd_layout
    .leftSpaceToView(self.wrapperView, 0)
    .topSpaceToView(self.wrapperView, 0)
    .rightSpaceToView(self.wrapperView, 0)
    .heightIs(WINDOWRECT_WIDTH);
    
    
    titleLab.sd_layout
    .leftSpaceToView(self.wrapperView, 10)
    .topSpaceToView(headerImg, 5)
    .rightSpaceToView(self.wrapperView, 10)
    .autoHeightRatio(0);
    
    
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
    //    NSLog(@"%@",short_url);
    
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
            
            
            if (![self.model.guid_content isEqualToString:@""]) {
                
                NSString * content =[NSString stringWithFormat:@"【推荐语】%@",self.model.guid_content];
                text = [text stringByReplacingOccurrencesOfString:@"{guid_content}" withString:content];
                
            }else{
                
                text = [text stringByReplacingOccurrencesOfString:@"{guid_content}" withString:self.model.guid_content];
                
            }
            
            
        }
        
    }
    
    //    if (![self.model.video_url isEqualToString:@""]&&self.model.video_url.length>0) {
    //
    //        text=[NSString stringWithFormat:@"%@\n【视频连接】%@",text,self.model.video_url];
    //
    //    }
    
    NSLog(@"%@",text);
    
    [self addShopClick];
    
    bgView =[[UIView alloc]init];
    bgView.backgroundColor=UIColorFromRGB(0xf3f3f3);
    
    
    UILabel * titleLab =[[UILabel alloc]init];
    titleLab.text=@"复制这条口令，打开淘宝即可看见";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textColor=UIColorFromRGB(0x666666);
    
    
    textView =[[UITextView alloc]init];
    textView.layer.borderColor=UIColorFromRGB(0xfd355a).CGColor;
    textView.layer.borderWidth=1;
    textView.delegate=self;
    textView.backgroundColor=UIColorFromRGB(0xffe7eb);
    textView.font=[UIFont systemFontOfSize:14];
    textView.textColor=UIColorFromRGB(0x666666);
    textView.text=[NSString stringWithFormat:@"%@",text];
    
    CGSize size =[text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] }];
    
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
    [shareBtn setTitle:[NSString stringWithFormat:@"一键复制图文推广赚￥%.2f",mark] forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:UIColorFromRGB(0xF83A5E)];
    shareBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    shareBtn.layer.masksToBounds=YES;
    shareBtn.layer.cornerRadius=15;
    shareBtn.tag=21;
    [shareBtn addTarget:self action:@selector(ChainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgView sd_addSubviews:@[titleLab,textView,tsLab,copyBtn,shareBtn]];
    
    //    bgView.sd_equalWidthSubviews = @[titleLab,textLab,tsLab,copyBtn,shareBtn];
    
    titleLab.sd_layout
    .leftSpaceToView(bgView, 2)
    .topSpaceToView(bgView, 0)
    .rightSpaceToView(bgView, 2)
    .heightIs(30);
    
    textView.sd_layout
    .leftSpaceToView(bgView, 2)
    .topSpaceToView(titleLab, 5)
    .rightSpaceToView(bgView, 2)
    .heightIs(size.height+50);
    
    copyBtn.sd_layout
    .rightSpaceToView(bgView,0)
    .topSpaceToView(textView,2)
    .heightIs(30)
    .widthIs(120);
    
    tsLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(textView, 5)
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


#pragma mark--加入商品库
-(void)addShopClick{
    
    
    NSArray * students =[Shop MR_findByAttribute:@"goodid" withValue:self.model.goodsId];
    
    if (students.count==0) {
        
        NSLog(@"---------%@",text);
        
        Shop * shop =[Shop MR_createEntity];
        
        //        shop.video_url=self.model.video_url;
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
        shop.yj=[NSString stringWithFormat:@"佣金:%.2f",mark];
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
        [self.view makeToast:@"收藏成功" duration:2 position:@"center"];
        
    }else{
        
        [self.view makeToast:@"已加入商品库" duration:1 position:@"center"];
    }
    
}

-(void)ChainButtonClick:(UIButton *)btn{
    
    if (btn.tag==20) {
        
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        
        NSString *string = textView.text;
        
        [pab setString:string];
        
        if (pab == nil) {
            
            
            [self.view makeToast:@"复制失败" duration:2 position:@"center"];
            
        }else
        {
            [self.view makeToast:@"复制成功" duration:2 position:@"center"];
            
            
        }
        
        
    }else{
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        
        NSString *string = textView.text;
        
        [pab setString:string];
        
//        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.thumb]];
//        UIImage *imagerang = [UIImage imageWithData:data];
        
        UIImage *imagerang = [Customer createViewImage:self.model];
        
        NSArray *activityItems = @[imagerang];
        
        UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
        
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
            UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
            {
                if (completed)
                {
                    
                    [self.view makeToast:@"分享成功,去粘贴文案吧！" duration:2 position:@"center"];
                }
                else
                {
                    //                    LRLog(@"cancel");
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
#pragma mark ---高效API
-(void)requestApi{
    
    
    NSString  * url =[NSString stringWithFormat:@"http://wxapi.tkjidi.com/api/tkjidi/tkjidiApi"];
    __weak __typeof(self)weakSelf = self;
    
    AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager POST:url parameters:@{@"goods_id":weakSelf.model.goodsId,@"pid":weakSelf.pid,@"token":[defaults objectForKey:@"access_token"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LRLog(@"%@",operation.responseObject);
        if ([operation.responseObject[@"status_code"] integerValue]==200) {
            
            NSLog(@">>>%@",weakSelf.model.me);
            coupon_click_url =operation.responseObject[@"resp"][@"result"][@"data"][@"coupon_click_url"];
 
            weakSelf.model.rate=operation.responseObject[@"resp"][@"result"][@"data"][@"max_commission_rate"];
           
      
            
            if ([Customer TokenRefreshWithTime:[defaults objectForKey:@"expired_at"]]==NO) {
                
                
                [weakSelf requsetWithMerge];
                
                
            }else{
                
                [weakSelf requsetWithRefresh];
            }

            
        }else{
            
            NSLog(@"%@",operation.responseObject[@"message"]);
            
            [weakSelf.view makeToast:operation.responseObject[@"message"] duration:2 position:@"center"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"000>>>>>>>%@",operation.responseString);
        
        [weakSelf.view makeToast:@"数据错误，请稍后再试" duration:1 position:@"center"];
        
        
    }];
    
}

#pragma mark ---淘口令
-(void)requsetWithMerge{
    
    NSString  * url =[NSString stringWithFormat:@"http://newapi.tkjidi.com/api/convert/urlCode?token=%@",[defaults objectForKey:@"token"]];
    
    LRLog(@"%@",url);
    __weak __typeof(self)weakSelf = self;
    
    AFHTTPRequestOperationManager  *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager POST:url parameters:@{@"convert_type":@"taoCode",@"url":coupon_click_url,@"content":weakSelf.model.title} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        LRLog(@"%@",operation.responseObject);
        if ([operation.responseObject[@"status_code"] integerValue]==200) {
            
            
            pwd=operation.responseObject[@"data"];
            
            [weakSelf requsetWithChain];
            
        }else{
            
            
            if ([Customer TokenRefreshWithTime:[defaults objectForKey:@"expired_at"]]==NO) {
                
                
                [weakSelf.view makeToast:operation.responseObject[@"message"] duration:2 position:@"center"];

                
            }else{
                
                [self requsetWithRefresh];
            }
            
 

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"1111>>>>>>>%@",operation.responseString);
        if ([operation.responseObject[@"error"][@"status_code"] integerValue]==401) {
            
            [weakSelf requsetWithRefresh];
            
        }

    }];
    
    
}
#pragma mark ---转链
-(void)requsetWithChain{
    
    NSString  * url =[NSString stringWithFormat:@"http://newapi.tkjidi.com/api/convert/urlCode?token=%@",[defaults objectForKey:@"token"]];
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:@{@"convert_type":@"shortUrl",@"url":coupon_click_url} successBlock:^(id returnData, int code, NSString *msg) {
        LRLog(@"%@,%@",returnData,returnData[@"message"]);
        if ([returnData[@"status_code"] integerValue]==200) {
            
            NSArray * ary =returnData[@"data"];
            
            for (NSDictionary * dic in ary) {
                
                short_url=dic[@"content"];
            }
            
            [weakSelf uploadViewWithPwd:pwd URL:short_url];

        }
        
        
    } failureBlock:^(NSError *error) {
        
        [weakSelf.view makeToast:@"数据错误，请稍后再试" duration:1 position:@"center"];
        
    } showHUD:NO];
    
}


#pragma mark --- 刷新Token

-(void)requsetWithRefresh{
    
    NSString  * url =[NSString stringWithFormat:@"http://newapi.tkjidi.com/api/convert/urlCode?token=%@",[defaults objectForKey:@"token"]];
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:nil successBlock:^(id returnData, int code, NSString *msg) {
        NSLog(@">>>>%@",returnData);
        NSString * token =returnData[@"data"][@"token"];
        [defaults setObject:token forKey:@"token"];
        NSString * time  =returnData[@"data"][@"expired_at"];
        [defaults setObject:time forKey:@"expired_at"];
        
        [weakSelf requsetWithMerge];
        
    } failureBlock:^(NSError *error) {
        
        //        NSLog(@">>>>>>>%@",error);
        [weakSelf requestToken];
        
    } showHUD:NO];
    
}


-(void)requestAccessToken{
    
    [MHNetworkManager postReqeustWithURL:@"https://oauth.taobao.com/token" params:@{@"grant_type":@"refresh_token",@"client_id":@"23617975",@"client_secret":@"3f722bb9f2f90ef770da88d08b363f6b",@"refresh_token":[defaults objectForKey:@"access_token"]} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData);
        
        [defaults setObject:returnData[@"access_token"] forKey:@"access_token"];
        [defaults setObject:returnData[@"expire_time"] forKey:@"expire_time"];
        [defaults setObject:returnData[@"refresh_token"] forKey:@"refresh_token"];
        [defaults setObject:returnData[@"refresh_token_valid_time"] forKey:@"valid_time"];
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}

#pragma mark --- 获取Token
-(void)requestToken{
    //    13073123173   111111
    //    15555929107 123456789
    
    NSString  * url =[NSString stringWithFormat:@"http://newapi.tkjidi.com/api/user/access_token"];
    __weak __typeof(self)weakSelf = self;
    [MHNetworkManager postReqeustWithURL:url params:@{@"username":@"13073123173",@"password":@"111111"} successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"%@",returnData[@"data"]);
        if (returnData[@"data"][@"message"]!=NULL) {
            
            [weakSelf.view makeToast:returnData[@"data"][@"message"] duration:1 position:@"center"];
            
        }else{
            
            NSString * token =returnData[@"data"][@"token"];
            [defaults setObject:token forKey:@"token"];
            NSString * time  =returnData[@"data"][@"expired_at"];
            [defaults setObject:time forKey:@"expired_at"];
            
            [weakSelf requsetWithMerge];
            
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
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 由于scrollview在滚动时会不断调用layoutSubvies方法，这就会不断触发自动布局计算，而很多时候这种计算是不必要的，所以可以通过控制“sd_closeAotuLayout”属性来设置要不要触发自动布局计算
    self.wrapperView.sd_closeAotuLayout = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 由于scrollview在滚动时会不断调用layoutSubvies方法，这就会不断触发自动布局计算，而很多时候这种计算是不必要的，所以可以通过控制“sd_closeAotuLayout”属性来设置要不要触发自动布局计算
    self.wrapperView.sd_closeAotuLayout = NO;
}

#pragma mark-键盘出现隐藏事件
-(void)keyHiden:(NSNotification *)notification
{
    // 键盘动画时间
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
}
-(void)keyWillAppear:(NSNotification *)notification
{
    CGFloat offset = self.scroollView.contentSize.height - WINDOWRECT_HEIGHT;
    if (offset > 0)
    {
        [self.scroollView setContentOffset:CGPointMake(0, offset) animated:NO];
        
    }
    
    
    //获得通知中的info字典
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.frame = CGRectMake(0.0f, -(kbHeight-80), self.view.frame.size.width, self.view.frame.size.height);
        
    }];
    
    
}

-(void)addNavView
{
    self.title=@"推广详情";
    
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
-(void)doTapChange:(UITapGestureRecognizer *)sender{
    
    
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
