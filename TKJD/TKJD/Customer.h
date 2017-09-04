//
//  Customer.h
//  JDZ
//
//  Created by apple on 16/7/22.
//  Copyright (c) 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "ShopModel.h"  
@interface Customer : NSObject

+(NSString *)initWithTime:(NSString *)time nonce1:(NSString *)once;
//签名
+(NSString *)initWithTime:(NSString *)time nonce:(NSString *)once;
//随机字符串
+(NSString *)once;
//获取时间戳
+(NSString *)timeString;

+ (UIImage *)cutImage:(UIImage*)image rect:(CGRect)rect;


+ (NSString *)encodeParameter:(NSString *)originalPara;
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;


+ (BOOL)TokenRefreshWithTime:(NSString *)expiredTime;

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;


//view转image
+ (UIImage *)createViewImage:(ShopModel *)model;

+(ShopModel *)ModelWithShop:(Shop *)shop;

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
+ (CIImage *)createQRForString:(NSString *)qrString;

@end
