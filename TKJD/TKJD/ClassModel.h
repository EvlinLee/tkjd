//
//  ClassModel.h
//  TKJD
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
@property(nonatomic , strong)NSString * classname;
@property(nonatomic , strong)NSString * idStr;
-(id)initWithDictionary:(NSDictionary *)dic;
@end
