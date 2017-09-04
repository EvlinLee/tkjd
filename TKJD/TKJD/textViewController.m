//
//  textViewController.m
//  TKJD
//
//  Created by 杨波 on 17/2/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "textViewController.h"

@interface textViewController ()<UITextViewDelegate>{
    
    
    UITextView * textView;
}

@end

@implementation textViewController

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
    
    self.title=@"转链模板设置";
    
    self.titleAry=[[NSMutableArray alloc]initWithObjects:@"{title}商品标题",@"{cvalue}优惠券面值",@"{price}在售价",@"{qhprice}券后价格",@"{pwd}淘口令",@"{short_url}二合一链接",@"{guid_content}推荐语", nil];
    
    self.textAry=[[NSMutableArray alloc]initWithObjects:@"{title}",@"{cvalue}",@"{price}",@"{qhprice}",@"{pwd}",@"{short_url}",@"{guid_content}", nil];
    
    [self addNavView];
    [self loadTextView];
    
}
-(void)loadTextView{
    
//    UITextField * textFile =[[UITextField alloc]init];
//    textFile.layer.borderColor=UIColorFromRGB(0xff307e).CGColor;
//    textFile.layer.borderWidth=1;
//    
//    [self.view addSubview:textFile];
    
    
    textView =[[UITextView alloc]init];
    textView.layer.borderColor=UIColorFromRGB(0xFB4C6E).CGColor;
    textView.layer.borderWidth=1;
    textView.delegate=self;
    textView.backgroundColor=UIColorFromRGB(0xFDE8EC);


    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isDefault"]==YES) {
        
        textView.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"defaultText"];

    }else{
        
         textView.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"text"];
    }
   
    
    [self.view addSubview:textView];
    
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
    [defaultBtn setTitle:@"恢复默认文本" forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [defaultBtn setBackgroundColor:UIColorFromRGB(0xFB4C6E)];
    [defaultBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:defaultBtn];

    


    UILabel * lab =[[UILabel alloc]init];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=[UIFont systemFontOfSize:14];
    lab.textColor=UIColorFromRGB(0xFB4C6E);
    lab.text=@"Tips:点击下方名称可更改模板";
    [self.view addSubview:lab];
    
    
    for (int i=0;i<self.titleAry.count; i++) {
        
//        LRLog(@"%d",self.titleAry.count);
        
        UIButton * btn =[[UIButton alloc]init];
        btn.tag=i;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [btn setTitle:self.titleAry[i] forState:UIControlStateNormal];
//        btn.titleLabel.textAlignment=NSTextAlignmentRight;
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame=CGRectMake(10, 320+(20*i), 200, 20);
        
        [self.view addSubview:btn];
        
    }
    
    
    textView.sd_layout
    .topSpaceToView(self.view,74)
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(150);
    
    
    saveBtn.sd_layout
    .topSpaceToView(textView,20)
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


    
}
-(void)saveBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    if (btn.tag==10) {
        
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isDefault"];
        [[NSUserDefaults standardUserDefaults]setObject:textView.text forKey:@"text"];
        [self.view makeToast:@"保存成功" duration:2 position:@"center"];
        
    }else{
        textView.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"defaultText"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isDefault"];
    }
 
}
-(void)btnClick:(UIButton *)btn{
    
    
    NSString * str =[NSString stringWithFormat:@"%@%@",textView.text,self.textAry[btn.tag]];
    
    textView.text=str;
   
//    [[NSUserDefaults standardUserDefaults]setObject:textView.text forKey:@"text"];

    LRLog(@"%@",str);
    
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
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIBarButtonItem *done =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] ;
    self.navigationItem.rightBarButtonItem = done;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)leaveEditMode {
    
    [textView resignFirstResponder];
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
