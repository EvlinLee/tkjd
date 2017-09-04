//
//  Shop+CoreDataProperties.h
//  TKJD
//
//  Created by apple on 2017/8/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "Shop+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Shop (CoreDataProperties)

+ (NSFetchRequest<Shop *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *class_name;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *goodid;
@property (nullable, nonatomic, copy) NSString *isChoose;
@property (nullable, nonatomic, copy) NSString *quanhou;
@property (nullable, nonatomic, copy) NSString *rate;
@property (nullable, nonatomic, copy) NSString *sales;
@property (nullable, nonatomic, copy) NSString *shoujia;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSString *thumb;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *tmall;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *url_shop;
@property (nullable, nonatomic, copy) NSString *urlContent;
@property (nullable, nonatomic, copy) NSString *yhLink;
@property (nullable, nonatomic, copy) NSString *yhPrice;
@property (nullable, nonatomic, copy) NSString *yhql;
@property (nullable, nonatomic, copy) NSString *yhqsy;
@property (nullable, nonatomic, copy) NSString *yj;
@property (nullable, nonatomic, copy) NSString *video_url;

@end

NS_ASSUME_NONNULL_END
