//
//  SuffixViewController.m
//  TKJD
//
//  Created by apple on 2017/4/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuffixViewController.h"

@interface SuffixViewController ()<UITextViewDelegate>

@property(nonatomic , retain)UITextView * textView;
@end

@implementation SuffixViewController
-(void)viewWillAppear:(BOOL)animated{
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
    
    _textView =[[UITextView alloc]init];
    _textView.layer.borderColor=UIColorFromRGB(0xFB4C6E).CGColor;
    _textView.layer.borderWidth=1;
    _textView.delegate=self;
    _textView.backgroundColor=UIColorFromRGB(0xFDE8EC);
    _textView.text= [defaults objectForKey:@"suffix"];
    [self.view addSubview:_textView];
    
    
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保 存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=UIColorFromRGB(0xF83A5E);
    btn.titleLabel.font=[UIFont systemFontOfSize:16 weight:1];
    [self.view addSubview:btn];
    
    _textView.sd_layout
    .topSpaceToView(self.view, 74)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(200);
    
    btn.sd_layout
    .topSpaceToView(_textView, 20)
    .centerXEqualToView(self.view)
    .widthIs(200)
    .heightIs(30);
    
    
    
    
    
    
}
-(void)saveBtnClick:(UIButton *)btn{
    
    [_textView resignFirstResponder];

    [defaults setObject:_textView.text forKey:@"suffix"];

    [self.view makeToast:@"保存成功" duration:2 position:@"center"];
    
}
-(void)addNavView
{
    
    self.title=@"小标题";
    
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
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIBarButtonItem *done =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] ;
    self.navigationItem.rightBarButtonItem = done;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)leaveEditMode {
    
    [_textView resignFirstResponder];
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
