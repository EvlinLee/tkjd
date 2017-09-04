//
//  ShopModel.m
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
-(id)initWithDictionary:(NSDictionary *)dic{
    
    self=[super init];
    
    if (self) {
        
        
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
        for (NSString *key in dic.allKeys) {
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                //                NSLog(@"%@---%@",[dic objectForKey:key],key);
                [mutableDic setValue:@"" forKey:key];
            }else{
                
                [mutableDic setObject:[dic objectForKey:key] forKey:key];
            }
        }
        
        self.video_url=mutableDic[@"video_url"];
        self.goodsId=mutableDic[@"goods_id"];
        self.title=mutableDic[@"buss_name"];
        self.url_shop=mutableDic[@"url_shop"];
        self.shoujia=mutableDic[@"price_shoujia"];
        self.quanhou=mutableDic[@"price_juanhou"];
        self.yhPrice=mutableDic[@"youhuiquan_price"];
        self.yhLink=mutableDic[@"youhuiquan_link"];
        self.yhqsy=mutableDic[@"youhuiquan_num_shengyu"];
        self.yhql=mutableDic[@"youhuiquan_num_ling"];
        self.rate=mutableDic[@"commission_rate"];
        self.sales=mutableDic[@"sales"];
        self.tmall=mutableDic[@"tmall"];
        self.video=mutableDic[@"video"];
        self.me=mutableDic[@"me"];

        self.thumb=mutableDic[@"thumb"];
        self.type=mutableDic[@"commission_type"];

        
        if ([self.thumb rangeOfString:@"http"].location==NSNotFound) {
            
            self.thumb=[NSString stringWithFormat:@"http:%@",self.thumb];
        }
        
        
        if (mutableDic[@"classname"]==[NSNull null]) {
            self.class_name=@"";
        }else{
            self.class_name=mutableDic[@"classname"];
        }
        
        
        if (dic[@"guid_content"]==[NSNull null]) {
            self.guid_content=@"";
        }else{
            self.guid_content=mutableDic[@"guid_content"];
        }
        
        
        if (dic[@"sales"]==[NSNull null]) {
            
            self.sales=@"0";
        }else{
            
            self.sales=mutableDic[@"sales"];
        }
        
        
        //        self.progress=[self.yhqsy floatValue]/([self.yhqsy floatValue]+[self.yhql floatValue]);
        
//        if ([defaults objectForKey:@"rate"]!=NULL) {
//            NSString * rates =[defaults objectForKey:@"rate"];
//            float a =([self.quanhou floatValue]*[self.rate floatValue])/100*[rates floatValue];
//            NSNumber *num = [NSNumber numberWithFloat:a];
//            
//            self.yj=[NSString stringWithFormat:@"%.2f",round([num floatValue]*100)/100];
//            
//            
//        }else{
        
            self.yj=[NSString stringWithFormat:@"%.2f",([self.quanhou floatValue]*[self.rate floatValue])/100];
            
//        }
        
        
    }
    
    return self;
}

@end
