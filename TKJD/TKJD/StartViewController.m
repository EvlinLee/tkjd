//
//  StartViewController.m
//  TKJD
//
//  Created by apple on 2017/4/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "StartViewController.h"
#import "NameModel.h"
@interface StartViewController ()<UIScrollViewDelegate,UITextFieldDelegate>{
    
    UITextView  * textview;
    UITextField * qfText;
    UITextField * notQFText;
    
    BOOL isOK;
    
    NSTimer * timer;
    
    NSString * imgUrl;
    NSString * shopText;
    
    NSString * key;

    NSString * ToUserName;
    
    NSString * timeString;
    NSString * MediaId;
    NSMutableArray * dataAry;
    NSMutableArray * sentAry;
    
    int index;
    
    
    ShopModel * shopModel;

}
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *lastBottomLine;
@property (nonatomic, strong) UIView *wrapperView;
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColorFromRGB(0xEEEEEF)];
    
    dataAry = [[NSMutableArray alloc]init];
    sentAry =[[NSMutableArray alloc]init];
    
    [self addNavView];
    index=0;
    isOK=YES;
    
    [self requestWebwxsync];
    [self uploadView];
}
-(void)uploadView{
    
    self.wrapperView = [UIView new];
    self.wrapperView.backgroundColor=UIColorFromRGB(0xEEEEEF);
    [self.scroollView addSubview:self.wrapperView];
    [self.scroollView setupAutoContentSizeWithBottomView:self.wrapperView bottomMargin:0];
    
    [self setupContentCell];
    
    self.wrapperView.sd_layout.
    leftEqualToView(self.scroollView)
    .rightEqualToView(self.scroollView)
    .topEqualToView(self.scroollView);
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
- (UIButton *)buttonWithTitle:(NSString *)title bgColor:(UIColor *)bgColor sel:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [button setBackgroundColor:bgColor];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}
-(UITextField *)textFile{
    
    UITextField * textFile =[[UITextField alloc]init];
    textFile.font=[UIFont systemFontOfSize:14];
    textFile.backgroundColor=UIColorFromRGB(0xFDE8EC);
    textFile.layer.borderWidth=1;
    textFile.layer.borderColor=[UIColorFromRGB(0xdcdcdc)CGColor];
    textFile.delegate=self;
    
    return textFile;
   
}

- (void)setupContentCell{
    
    
    UIView * bgView =[[UIView alloc]init];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.borderColor=UIColorFromRGB(0xdcdcdc).CGColor;
    bgView.layer.borderWidth=1;
    
    
    UILabel * qfLab =[[UILabel alloc]init];
    qfLab.text=@"微信群发间隔                     秒";
    qfLab.textColor=UIColorFromRGB(0x444444);
    qfLab.font=[UIFont systemFontOfSize:16];
    qfLab.textAlignment=NSTextAlignmentLeft;

    
    UILabel * notLab =[[UILabel alloc]init];
    notLab.text=@"微信不同群发送间隔                    秒";
    notLab.textColor=UIColorFromRGB(0x444444);
    notLab.font=[UIFont systemFontOfSize:16];
    notLab.textAlignment=NSTextAlignmentLeft;

    
    qfText =[self textFile];
    qfText.text=[defaults objectForKey:@"qf"];
    
    notQFText =[self textFile];
    notQFText.text=[defaults objectForKey:@"not"];
    
    UILabel * txLab =[[UILabel alloc]init];
    txLab.text=@"（微信不同群发送间隔建议为10s; 微信群发间隔须大于微信不同群发送间隔乘以群个数）";
    txLab.numberOfLines=0;
    txLab.textColor=UIColorFromRGB(0x999999);
    txLab.font=[UIFont systemFontOfSize:12];

    
    UILabel * title =[[UILabel alloc]init];
    title.text=@"1.发送商品库商品和文案\n2.发送机器人配置的微信群\n3.不能返回主页面\n";
    title.textColor=UIColorFromRGB(0xff486c);
    title.font=[UIFont systemFontOfSize:16];
    [Customer changeLineSpaceForLabel:title WithSpace:2];
    
    UIButton * saveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存设置" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.backgroundColor=UIColorFromRGB(0xF83A5E);
    saveBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * sentBtn =[self buttonWithTitle:@"开始发送" bgColor:UIColorFromRGB(0xFB4A41) sel:@selector(WxSetButtonClick:)];
    sentBtn.tag=10;
    
    UIButton * continueBtn = [self buttonWithTitle:@"继续发送" bgColor:UIColorFromRGB(0xF83A5E) sel:@selector(WxSetButtonClick:)];
    continueBtn.tag=11;
    
    UIButton * endBtn =[self buttonWithTitle:@"暂停发送" bgColor:UIColorFromRGB(0x579AFC) sel:@selector(WxSetButtonClick:)];
    endBtn.tag=12;
    
    
    UILabel * lab =[[UILabel alloc]init];
    lab.text=@"当前状态：";
    lab.textColor=UIColorFromRGB(0x444444);
    lab.font=[UIFont systemFontOfSize:16];
    lab.textAlignment=NSTextAlignmentLeft;
    
    
    UIView * view  =[[UIView alloc]init];
    view.backgroundColor=UIColorFromRGB(0xFDE8EC);
    view.layer.borderWidth=1;
    view.layer.borderColor=[UIColorFromRGB(0xdcdcdc)CGColor];

    
    textview =[[UITextView alloc]init];
    textview.editable=NO;
    textview.font=[UIFont systemFontOfSize:14];
    textview.backgroundColor=UIColorFromRGB(0xFDE8EC);
//    textview.layer.borderWidth=1;
//    textview.layer.borderColor=[UIColorFromRGB(0xdcdcdc)CGColor];
    textview.layoutManager.allowsNonContiguousLayout = NO;
    
    [view addSubview:textview];
    
    [bgView addSubviews:@[qfLab,notLab,title,saveBtn,qfText,notQFText,txLab]];
    
    [self.wrapperView addSubviews:@[bgView,sentBtn,continueBtn,endBtn,lab,view]];
    
    bgView.sd_layout
    .topSpaceToView(self.wrapperView, 10)
    .leftSpaceToView(self.wrapperView, 10)
    .rightSpaceToView(self.wrapperView, 10)
    .heightIs(280);
    
    
    qfLab.sd_layout
    .topSpaceToView(bgView, 20)
    .leftSpaceToView(bgView, 10)
    .rightSpaceToView(bgView, 10)
    .heightIs(20);
    
    notLab.sd_layout
    .topSpaceToView(qfLab, 20)
    .leftSpaceToView(bgView, 10)
    .rightSpaceToView(bgView, 10)
    .heightIs(20);
    
    
    
    qfText.sd_layout
    .topSpaceToView(bgView, 16)
    .leftSpaceToView(bgView, 120)
    .widthIs(60)
    .heightIs(30);
    
    
    notQFText.sd_layout
    .topSpaceToView(qfLab, 16)
    .leftSpaceToView(bgView, 170)
    .widthIs(60)
    .heightIs(30);
    
    txLab.sd_layout
    .topSpaceToView(notLab, 20)
    .leftSpaceToView(bgView, 10)
    .rightSpaceToView(bgView, 10)
    .autoHeightRatio(0);
    
    title.sd_layout
    .topSpaceToView(txLab, 10)
    .leftSpaceToView(bgView, 10)
    .rightSpaceToView(bgView, 10)
    .autoHeightRatio(0);
    
    saveBtn.sd_layout
    .topSpaceToView(title, 10)
    .centerXEqualToView(bgView)
    .widthIs(200)
    .heightIs(40);
    
    sentBtn.sd_layout
    .topSpaceToView(bgView, 10)
    .leftSpaceToView(self.wrapperView, 10)
    .widthIs((WINDOWRECT_WIDTH-50)/3)
    .heightIs(40);
    
    continueBtn.sd_layout
    .topEqualToView(sentBtn)
    .leftSpaceToView(sentBtn, 10)
    .widthIs((WINDOWRECT_WIDTH-50)/3)
    .heightIs(40);
    
    endBtn.sd_layout
    .topEqualToView(continueBtn)
    .leftSpaceToView(continueBtn, 10)
    .widthIs((WINDOWRECT_WIDTH-50)/3)
    .heightIs(40);
    
    lab.sd_layout
    .topSpaceToView(sentBtn, 20)
    .leftSpaceToView(self.wrapperView, 10)
    .widthIs(200)
    .heightIs(20);
    
    
    view.sd_layout
    .topSpaceToView(lab, 10)
    .leftSpaceToView(self.wrapperView, 10)
    .rightSpaceToView(self.wrapperView, 10)
    .heightIs(120);
    
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(view.mas_top).offset(5);
        make.left.equalTo(view.mas_left).offset(5);
        make.right.equalTo(view.mas_right).offset(-5);
        make.bottom.equalTo(view.mas_bottom).offset(-5);
        
    }];

    
    self.lastBottomLine = [self addSeparatorLineBellowView:view margin:1];

    
}
-(void)saveBtnClick{
    
    if ([qfText.text length]!=0||[notQFText.text length]!=0) {
        
        [self.view endEditing:YES];
        
        [defaults setObject:qfText.text  forKey:@"qf"];
        [defaults setObject:notQFText.text forKey:@"not"];
        
        [self.view makeToast:@"保存成功" duration:2 position:@"center"];
    }else{
        
        
        [self.view makeToast:@"不能为空" duration:2 position:@"center"];
        
    }
    
   
    
    
    
}
-(void)WxSetButtonClick:(UIButton *)btn{
    
    if (btn.tag==10) {
        
        NSString * str =@"等待发送中...";
        [sentAry addObject:str];
        textview.text=[sentAry componentsJoinedByString:@"\n"];
        
        timer =  [NSTimer scheduledTimerWithTimeInterval:[qfText.text floatValue] target:self selector:@selector(requestWXData) userInfo:nil repeats:YES];
        
        NSLog(@"10");
        
        
        //        [self requestWXContact];
        
    }else if (btn.tag==11){
        
        NSString * str =@"-----继续发送-----";
        [sentAry addObject:str];
        
        textview.text=[sentAry componentsJoinedByString:@"\n"];
        
        
        
        //开启定时器
        [timer setFireDate:[NSDate distantPast]];
        
        
    }else{
        NSLog(@"%@",self.model.skey);
        

        NSString * str =@"-----暂停发送-----";
        [sentAry addObject:str];
        
        textview.text=[sentAry componentsJoinedByString:@"\n"];
        
        
        [timer setFireDate:[NSDate distantFuture]];
        
        
    }
    
}

-(void)requestWXData{
  
    if (self.shopAry.count==0) {
        NSArray * array1=[[[Shop MR_findAll] reverseObjectEnumerator]allObjects];
        dataAry=[NSMutableArray arrayWithArray:array1];
    }else{
        
        dataAry=self.shopAry;
    }
    
    static int i=0;

    if (i<dataAry.count) {
        
        Shop * shop =dataAry[i];
        
        shopText=shop.text;
        imgUrl=shop.thumb;
        
        shopModel=[Customer ModelWithShop:shop];
        
        NameModel * model =self.nameAry[index];
        
        NSString * str =[NSString stringWithFormat:@"商品:%@\n正发送群:%@，发送中...",shop.title,model.NickName];
        [sentAry addObject:str];
        
        textview.text=[sentAry componentsJoinedByString:@"\n"];
        
        
        
        ToUserName=model.UserName;
        
        [self requestMediaId];
        
        i++;
    }else{
        
        [timer invalidate];
        timer = nil;
        i=0;
//        
//        UIButton * btn =(UIButton *)[buttonContainer viewWithTag:10];
//        
//        [btn setTitle:@"开始" forState:UIControlStateNormal];
        
        NSString * str =@"-----商品已全部发送完毕-----";
        [sentAry addObject:str];
        textview.text=[sentAry componentsJoinedByString:@"\n"];
        
        [textview scrollRangeToVisible:NSMakeRange(textview.text.length, 1)];

        
        [self.view makeToast:@"发送完毕" duration:2 position:@"center"];
    }
    
    
    
}
-(void)wxTimeInterval{
    
    index++;
    NSLog(@"%lu",(unsigned long)self.nameAry.count);
    if (index>=self.nameAry.count) {
        
        index=0;
        
    }else{
        
        NameModel * model =self.nameAry[index];
        
        NSString * str =[NSString stringWithFormat:@"正发送群:%@，发送中...",model.NickName];
        [sentAry addObject:str];
        
        textview.text=[sentAry componentsJoinedByString:@"\n"];
        

        ToUserName=model.UserName;
        
        [self requestMediaId];
    }
 
}


#pragma mark---获取发送图片的MediaId
-(void)requestMediaId{
    
    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setPMSymbol:@"下午"];
    [formatter setAMSymbol:@"上午"];
    
    
    [formatter setDateFormat:@"YYYY/MM/dd aaah:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    //    NSLog(@"%@",DateTime);
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    
    NSMutableString *cookieString = [NSMutableString stringWithFormat:@""];
    
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    for (NSString *keyStr in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", keyStr, [cookieDic valueForKey:keyStr]];
        
        [cookieString appendString:appendString];
        
    }
    NSString * cookie = [cookieString substringToIndex:cookieString.length-1];
    NSString * webwx_data_ticket=[[cookie componentsSeparatedByString:@"webwx_data_ticket="] lastObject];
    
    
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"/Documents/%@.jpg", time];
    
    
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//    UIImage *imagerang = [UIImage imageWithData:data];
    
    UIImage * imagerang=[Customer createViewImage:shopModel];
    
    NSString *path_sandox = NSHomeDirectory();
    
    
    NSString *imagePath = [path_sandox stringByAppendingString:fileName];
    
    [UIImageJPEGRepresentation(imagerang, 1) writeToFile:imagePath atomically:YES];
    
    NSString * size =[NSString stringWithFormat:@"%lld",[self fileSizeAtPath:imagePath]];

    NSString * str =[NSString stringWithFormat:@"{\"UploadType\":2,\"BaseRequest\":{\"Uin\":%@,\"Sid\":\"%@\",\"Skey\":\"%@\",\"DeviceID\":\"e778022334380637\"},\"ClientMediaId\":%@,\"TotalLen\":%@,\"StartPos\":0,\"DataLen\":%@,\"MediaType\":4,\"FromUserName\":\"%@\",\"ToUserName\":\"%@\",\"FileMd5\":\"25402a2cdc7a121aa25611b26b8e9ad2\"}",self.model.uin,self.model.sid,self.model.skey,timeString,size,size,self.model.userName,ToUserName];
    
    
    NSDictionary * dic =@{@"id":@"WU_FILE_0",@"name":[imagePath lastPathComponent],@"type":@"image/jpeg",@"lastModifiedDate":DateTime,@"size":size,@"mediatype":@"pic",@"uploadmediarequest":str,@"webwx_data_ticket":webwx_data_ticket,@"pass_ticket":self.model.pass_ticket};
    

    NSString * url =[NSString stringWithFormat:@"https://file.wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxuploadmedia?f=json",[defaults objectForKey:@"wx"]];
       __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(imagerang, 1) name:@"filename" fileName:[imagePath lastPathComponent] mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
//        NSLog(@"%@",operation.responseString);
        
        NSDictionary * dic =[[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
        
        MediaId =dic[@"MediaId"];
        
        
        [weakSelf requestWXImage];
        
    
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
}
#pragma mark-----发送图片
-(void)requestWXImage{
    NSString * time =[NSString stringWithFormat:@"%@0630",timeString];
    
    NSDictionary * dic =@{@"BaseRequest":@{@"Uin":self.model.uin ,@"Sid":self.model.sid,@"Skey":self.model.skey,@"DeviceID":@"e207079374714885"},@"Msg":@{@"ClientMsgId":time,@"MediaId":MediaId,@"Content":@"",@"FromUserName":self.model.userName,@"LocalID":time,@"ToUserName":ToUserName,@"Type":@"3"},@"Scene":@"0"};
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    @"https://wx2.qq.com/cgi-bin/mmwebwx-bin/webwxsendmsgimg?fun=async&f=json"
    
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxsendmsgimg?fun=async&f=json",[defaults objectForKey:@"wx"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];

    [request setHTTPBody:[dic JSONData]];
       __weak __typeof(self)weakSelf = self;
    NSOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"--------%@",operation.responseString);
        
//        NSDictionary * dic =[[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
        
        
        
        [weakSelf performSelector:@selector(requestWXSendmsg) withObject:nil afterDelay:2];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [manager.operationQueue addOperation:operation];
    
    
}
#pragma mark ---发送消息
-(void)requestWXSendmsg{
    
    NSString * strRandom=@"e";
    
    for(int i=0; i<15; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    
    NSString * time =[NSString stringWithFormat:@"%@",timeString];
    
    for (int i=0; i<4; i++) {
        time=[time stringByAppendingFormat:@"%i",(arc4random() % 9)];
        
    }
    
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxsendmsg?lang=zh_CN&pass_ticket=%@",[defaults objectForKey:@"wx"],self.model.pass_ticket];
    
    NSDictionary * dic =@{@"BaseRequest":@{@"Uin":self.model.uin ,@"Sid":self.model.sid,@"Skey":self.model.skey,@"DeviceID":strRandom},@"Msg":@{@"ClientMsgId":time,@"Content":shopText,@"FromUserName":self.model.userName,@"LocalID":time,@"ToUserName":ToUserName,@"Type":@"1"},@"Scene":@"0"};
    
       __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];

    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];

    [request setHTTPBody:[dic JSONData]];
    
    NSOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Msg--------%@",operation.responseString);
        
        //        NSDictionary * dic =[[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
        NSString * str =@"发送完毕";
        [sentAry addObject:str];
        
        textview.text=[sentAry componentsJoinedByString:@"\n"];

        [textview scrollRangeToVisible:NSMakeRange(textview.text.length, 1)];
        
        [weakSelf performSelector:@selector(wxTimeInterval) withObject:nil afterDelay:[notQFText.text floatValue]];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [manager.operationQueue addOperation:operation];
    
}
-(void)sentWXMsgWithContent:(NSString *)content ToUserName:(NSString *)toUserName{
    
    NSString * strRandom=@"e";
    
    for(int i=0; i<15; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    
    NSString * time =[NSString stringWithFormat:@"%@",timeString];
    
    for (int i=0; i<4; i++) {
        time=[time stringByAppendingFormat:@"%i",(arc4random() % 9)];
        
    }
    
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxsendmsg?lang=zh_CN&pass_ticket=%@",[defaults objectForKey:@"wx"],self.model.pass_ticket];
    
    NSDictionary * dic =@{@"BaseRequest":@{@"Uin":self.model.uin ,@"Sid":self.model.sid,@"Skey":self.model.skey,@"DeviceID":strRandom},@"Msg":@{@"ClientMsgId":time,@"Content":content,@"FromUserName":self.model.userName,@"LocalID":time,@"ToUserName":toUserName,@"Type":@"1"},@"Scene":@"0"};
    
   
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    
    [request setHTTPBody:[dic JSONData]];
    
    NSOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Msg--------%@",operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [manager.operationQueue addOperation:operation];
    
}
-(void)requestWebwxsync{

    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxsync?sid=%@&skey=%@&lang=zh_CN&pass_ticket=%@",[defaults objectForKey:@"wx"],self.model.sid,self.model.skey,self.model.pass_ticket];
    
    NSDictionary * dic =    @{@"BaseRequest":@{@"Uin":self.model.uin,@"Sid":self.model.sid,@"Skey":self.model.skey,@"DeviceID":@"e200046210733551"},@"SyncKey":self.synckeyDic,@"rr":timeString};

    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
//    [request setValue:@"https://wx2.qq.com/?&lang=zh_CN" forHTTPHeaderField:@"Referer"];
//    [request setValue:@"https://wx2.qq.com" forHTTPHeaderField:@"Origin"];
    [request setHTTPBody:jsonData];

    NSOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSLog(@"synckey--------%@",operation.responseString);

//        [self.synckeyDic removeAllObjects];
        [weakSelf.model.listAry removeAllObjects];

        NSDictionary * dic =[[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];

        weakSelf.synckeyDic=dic[@"SyncKey"];

        NSLog(@"synckeyDic---%@",self.synckeyDic);

        id ary =dic[@"SyncKey"][@"List"];
        for (NSDictionary * listdic in  ary) {

            NSString * list =[NSString stringWithFormat:@"%@_%@",listdic[@"Key"],listdic[@"Val"]];

            [weakSelf.model.listAry addObject:list];

        }
//        "Content": "@42294de4f77269a84075151ecd67d4c0beb9e3fa2a8b1cbc1f12a4d73cd63f5c:<br/>找妹子",
        NSArray * MsgList =dic[@"AddMsgList"];
        if (MsgList.count>0 &&[defaults boolForKey:@"reply"]==YES) {
            
            NSDictionary * msgDic =MsgList[0];
            NSString * content =msgDic[@"Content"];
            NSString * toName =msgDic[@"FromUserName"];
            
            if ([content rangeOfString:@"<br/>"].location!=NSNotFound) {
                
                content=[[content componentsSeparatedByString:@"<br/>"] lastObject];
                
            }
            
            BOOL found =NO;
            for (NameModel * model in weakSelf.nameAry) {
                
                if ([model.UserName isEqualToString:toName]) {
                    
                    found=YES;
                }
                
            }

            NSString * text =[defaults objectForKey:@"ReplyText"];
            NSArray * array =[text componentsSeparatedByString:@","];
            NSArray * keyAry =[array[1] componentsSeparatedByString:@"，"];
            BOOL iskey = NO;
            for (NSString * str in keyAry) {
                
                if ([content rangeOfString:str].location!=NSNotFound&&[content hasPrefix:str]==YES) {
                    iskey=YES;
                    key=str;
                }
                
            }
            if (iskey==YES&&[toName rangeOfString:@"@@"].location!=NSNotFound&&found==YES) {
                
                NSLog(@">>>>>>%@<<<<<<<<,",key);
                
                NSString * kwd =[[[content componentsSeparatedByString:key] lastObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString * replyText = [array[2] stringByReplacingOccurrencesOfString:@"{search_url}" withString:[NSString stringWithFormat:@"%@%@",array[0],kwd]];
                
                [weakSelf sentWXMsgWithContent:replyText ToUserName:toName];
            
            }
    
        }
        

        [weakSelf upDate];
       

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"%@",error);

    }];

    [manager.operationQueue addOperation:operation];

}
#pragma mark---心跳包
-(void)upDate{
    
    static int i=0;
    NSString * strRandom=@"e";
    
    for(int i=0; i<15; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }

    timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    NSString * synckey=[self.model.listAry componentsJoinedByString:@"%7C"];
        NSLog(@"%@",synckey);
    NSString * url =[NSString stringWithFormat:@"https://webpush.wx%@.qq.com/cgi-bin/mmwebwx-bin/synccheck?r=%@&skey=%@&sid=%@&uin=%@&deviceid=%@&synckey=%@&_=%@",[defaults objectForKey:@"wx"],timeString,self.model.skey,self.model.sid,self.model.uin,strRandom,synckey,timeString];
    
    __weak __typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%d=========%@",i++,operation.responseString);
//        [defaults setObject:operation.responseString forKey:@"heart"];

        
        NSArray * ary =[[[operation.responseString componentsSeparatedByString:@"="] lastObject] componentsSeparatedByString:@","];
        NSString *  retcode =[[ary firstObject] componentsSeparatedByString:@"\""][1];
        if ([retcode intValue]==1101) {
            
            isOK=NO;
        }

        if (isOK==YES) {
        
           [weakSelf requestWebwxsync];
            
        }
      
//        if (isOK==YES) {
//
//            [self performSelector:@selector(upDate) withObject:nil afterDelay:25];
//
//        }
      
        
  
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
    
    
}
-(void)requestOUT{
    NSString * url =[NSString stringWithFormat:@"https://wx%@.qq.com/cgi-bin/mmwebwx-bin/webwxlogout?redirect=1&type=0&skey=%@",[defaults objectForKey:@"wx"],self.model.skey];
    NSDictionary * dic =@{@"sid":self.model.sid,@"uin":self.model.uin};

    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30" forHTTPHeaderField:@"User-Agent"];

    [request setHTTPBody:[dic JSONData]];
       __weak __typeof(self)weakSelf = self;
    NSOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Msg--------%@",operation.responseString);
        
        if ([operation.responseString rangeOfString:@"微信网页版"].location!=NSNotFound) {
            
            [weakSelf.view makeToast:@"成功退出微信" duration:2 position:@"center"];

            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [manager.operationQueue addOperation:operation];

    
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    
    return YES;
}
-(void)addNavView
{
    
    self.title=@"群发设置";
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backViewB) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bar;
    
    UIEdgeInsets img = backBtn.imageEdgeInsets;
    img.left = -20;
    [backBtn setImageEdgeInsets:img];
    
    
    UIButton * outButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
   [outButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(outWXButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:outButton];
    self.navigationItem.rightBarButtonItem = bar1;

    
}
-(void)outWXButton{
    [timer invalidate];
    timer=nil;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];//取消延迟操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upDate) object:nil];
    isOK=NO;
    
    [self requestOUT];
    
}
-(void)backViewB{
    
    [timer invalidate];
    timer=nil;
    
    ZCYTabBarController * tabbar = (ZCYTabBarController *)self.tabBarController;
    tabbar.tabbar.hidden = NO;
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
