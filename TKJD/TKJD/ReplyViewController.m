//
//  ReplyViewController.m
//  TKJD
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ReplyViewController.h"

@interface ReplyViewController ()<UITextViewDelegate>{
    
    CGFloat kbHeight;
    double duration;
    UITextField * urlText;
    UITextField * keyText;
    
    UITextView * textview;
    NSString *  reply;
}
@property(nonatomic , strong)NSMutableArray * dataAry;

@end

@implementation ReplyViewController
-(NSMutableArray *)dataAry{
    
    if (!_dataAry) {
        
        _dataAry=[[NSMutableArray alloc]init];
        
    }
    return _dataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    [self addNavView];
    
    if ([defaults boolForKey:@"defaultReply"]==YES) {
        
        [self.dataAry addObjectsFromArray:@[@"http://588p.com/?r=s&kwd=",@"找，搜",@"{search_url}"]];
        
    }else{
        
        NSArray * ary =[[defaults objectForKey:@"ReplyText"] componentsSeparatedByString:@","];
        [self.dataAry addObjectsFromArray:ary];
        
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    [self setup];
    
}
-(UITextField *)textField{
    
    UITextField * textField =[[UITextField alloc]init];
    textField.backgroundColor=UIColorFromRGB(0xFDE8EC);
    textField.layer.borderWidth=1;
    textField.layer.borderColor=UIColorFromRGB(0xFB4C6E).CGColor;
    textField.textColor=UIColorFromRGB(0x555555);
    textField.font=[UIFont systemFontOfSize:14];
    textField.clearButtonMode=UITextFieldViewModeAlways;
    
    return textField;
}
-(UILabel *)LabelWithText:(NSString *)text{
    
    UILabel * label=[[UILabel alloc]init];
    label.textColor=UIColorFromRGB(0x666666);
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:14];
    label.text=text;
    
    return label;
    
}
-(void)setup{
    
    UILabel * urlLab =[self LabelWithText:@"搜索地址:"];
    
    urlText = [self textField];
    urlText.text=self.dataAry[0];
    
    UILabel * keyLab =[self LabelWithText:@"搜索关键词:"];
    
    keyText = [self textField];
    keyText.text=self.dataAry[1];
    
    
    UILabel * textLab =[self LabelWithText:@"发送文案:"];
    
    textview =[[UITextView alloc]init];
    textview.layer.borderColor=UIColorFromRGB(0xFB4C6E).CGColor;
    textview.layer.borderWidth=1;
    textview.delegate=self;
    textview.textColor=UIColorFromRGB(0x555555);
    textview.font=[UIFont systemFontOfSize:14];
    textview.backgroundColor=UIColorFromRGB(0xFDE8EC);
    textview.text=self.dataAry[2];

    [self.view addSubviews:@[urlLab,urlText,keyLab,keyText,textLab,textview]];
    
    
    UIButton * saveBtn =[[UIButton alloc]init];
    saveBtn.tag=10;
    saveBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    saveBtn.layer.masksToBounds=YES;
    saveBtn.layer.cornerRadius=5;
    [saveBtn setTitle:@"保存文本" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:UIColorFromRGB(0xFA574D)];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
    UIButton * defaultBtn =[[UIButton alloc]init];
    defaultBtn.tag=20;
    defaultBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    defaultBtn.layer.masksToBounds=YES;
    defaultBtn.layer.cornerRadius=5;
    [defaultBtn setTitle:@"恢复默认" forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [defaultBtn setBackgroundColor:UIColorFromRGB(0xFB4C6E)];
    [defaultBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:defaultBtn];

    UILabel * lab =[[UILabel alloc]init];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=[UIFont systemFontOfSize:14];
    lab.textColor=UIColorFromRGB(0xFB4C6E);
    lab.text=@"Tips:点击下方名称可添加到文案";
    [self.view addSubview:lab];

    UIButton * btn =[[UIButton alloc]init];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setTitle:@"{search_url} 搜索链接" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
    urlLab.sd_layout
    .topSpaceToView(self.view, 74)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(20);
    
    urlText.sd_layout
    .topSpaceToView(urlLab, 4)
    .leftEqualToView(urlLab)
    .rightEqualToView(urlLab)
    .heightIs(30);
    
    keyLab.sd_layout
    .topSpaceToView(urlText, 4)
    .leftEqualToView(urlLab)
    .rightEqualToView(urlLab)
    .heightIs(20);
    
    keyText.sd_layout
    .topSpaceToView(keyLab, 4)
    .leftEqualToView(keyLab)
    .rightEqualToView(keyLab)
    .heightIs(30);
    
    textLab.sd_layout
    .topSpaceToView(keyText, 4)
    .leftEqualToView(urlLab)
    .rightEqualToView(urlLab)
    .heightIs(20);
    
    textview.sd_layout
    .topSpaceToView(textLab, 4)
    .leftEqualToView(textLab)
    .rightEqualToView(textLab)
    .heightIs(100);
    
    
    saveBtn.sd_layout
    .topSpaceToView(textview,20)
    .leftSpaceToView(self.view,10)
    .heightIs(35)
    .widthIs((WINDOWRECT_WIDTH-30)/2);
    
    
    defaultBtn.sd_layout
    .topEqualToView(saveBtn)
    .leftSpaceToView(saveBtn,10)
    .heightIs(35)
    .widthIs((WINDOWRECT_WIDTH-30)/2);
    
    lab.sd_layout
    .topSpaceToView(saveBtn,10)
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,10)
    .autoHeightRatio(0);

    btn.sd_layout
    .topSpaceToView(lab, 10)
    .leftSpaceToView(self.view, 10)
    .widthIs(200)
    .heightIs(20);
    
}
-(void)btnClick:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    NSString * str =[NSString stringWithFormat:@"%@{search_url}",textview.text];
    
    textview.text=str;

    
}
-(void)saveBtnClick:(UIButton *)button{
    
 
    [self.view endEditing:YES];
    
    if (button.tag==10) {
       
        NSString * text =[NSString stringWithFormat:@"%@,%@,%@",urlText.text,keyText.text,textview.text];
        
        [defaults setBool:NO forKey:@"defaultReply"];
        [defaults setObject:text forKey:@"ReplyText"];
        [self.view makeToast:@"保存成功" duration:1 position:@"center"];
        
        
    }else{
        
        
        [defaults setBool:YES forKey:@"defaultReply"];
     
        urlText.text=@"http://588p.com/?r=s&kwd=";
        keyText.text=@"找，搜";
        textview.text=@"{search_url}";
       
        NSString * text =[NSString stringWithFormat:@"%@,%@,%@",urlText.text,keyText.text,textview.text];
        [defaults setObject:text forKey:@"ReplyText"];
        
    }
}
#pragma mark-键盘出现隐藏事件
-(void)keyHiden:(NSNotification *)notification
{
    // 键盘动画时间
    double dura = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:dura animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
}
-(void)keyWillAppear:(NSNotification *)notification
{

    kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    

}
-(void)textViewDidBeginEditing:(UITextView *)textView{

    CGFloat Y = WINDOWRECT_HEIGHT-kbHeight-textview.origin.y-150-64;
    
    if (Y<0) {
        
      
        [UIView animateWithDuration:duration animations:^{
            
            self.view.frame = CGRectMake(0.0f, Y, self.view.frame.size.width, self.view.frame.size.height);
            
        }];
        
    }

    
}
-(void)addNavView
{
    
    self.title=@"自动回复设置";
    
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
    
    
    [self.navigationController popViewControllerAnimated:NO];
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
