//
//  NameModel.h
//  TKJD
//
//  Created by apple on 2017/4/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameModel : NSObject
@property(nonatomic , retain)NSString * UserName;
@property(nonatomic , retain)NSString * NickName;
@property(nonatomic , assign)BOOL  isChoose;
@end
