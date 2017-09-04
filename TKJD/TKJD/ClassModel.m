//
//  ClassModel.m
//  TKJD
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
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
        
        self.classname=mutableDic[@"classname"];
        self.idStr=mutableDic[@"id"];
        
    }
    
    return self;
}

@end
