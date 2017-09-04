//
//  ShopModel.h
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
-(id)initWithDictionary:(NSDictionary *)dic;

@property(nonatomic , strong)NSString * goodsId;
@property(nonatomic , strong)NSString * title;
@property(nonatomic , strong)NSString * url_shop;
@property(nonatomic , strong)NSString * shoujia;
@property(nonatomic , strong)NSString * quanhou;
@property(nonatomic , strong)NSString * yhPrice;
@property(nonatomic , strong)NSString * yhLink;
@property(nonatomic , strong)NSString * yhqsy;
@property(nonatomic , strong)NSString * yhql;
@property(nonatomic , strong)NSString * rate;
@property(nonatomic , strong)NSString * sales;
@property(nonatomic , strong)NSString * class_name;
@property(nonatomic , strong)NSString * thumb;
@property(nonatomic , strong)NSString * type;
@property(nonatomic , strong)NSString * yj;
@property(nonatomic , strong)NSString * guid_content;

@property(nonatomic , strong)NSString * tmall;

@property(nonatomic , strong)NSString * video;
@property(nonatomic , strong)NSString * video_url;
@property(nonatomic , strong)NSString * me;

@property(nonatomic , assign)float progress;

@end
