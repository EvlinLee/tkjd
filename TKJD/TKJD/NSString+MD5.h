//
//  NSString+MD5.h
//  JDZ
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (MD5)
+ (NSString *)md5To32bit:(NSString *)str;
+ (NSString*)sha1:(NSString *)sha;
@end
