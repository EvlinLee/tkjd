//
//  Shop+CoreDataProperties.m
//  TKJD
//
//  Created by apple on 2017/8/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "Shop+CoreDataProperties.h"

@implementation Shop (CoreDataProperties)

+ (NSFetchRequest<Shop *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Shop"];
}

@dynamic class_name;
@dynamic content;
@dynamic goodid;
@dynamic isChoose;
@dynamic quanhou;
@dynamic rate;
@dynamic sales;
@dynamic shoujia;
@dynamic text;
@dynamic thumb;
@dynamic title;
@dynamic tmall;
@dynamic type;
@dynamic url_shop;
@dynamic urlContent;
@dynamic yhLink;
@dynamic yhPrice;
@dynamic yhql;
@dynamic yhqsy;
@dynamic yj;
@dynamic video_url;

@end
