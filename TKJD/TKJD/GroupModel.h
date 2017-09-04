//
//  GroupModel.h
//  TKJD
//
//  Created by apple on 2017/4/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GroupModel : NSObject
@property(nonatomic , retain)NSString * skey;
@property(nonatomic , retain)NSString * sid;
@property(nonatomic , retain)NSString * uin;
@property(nonatomic , retain)NSString * pass_ticket;
@property(nonatomic , retain)NSString * userName;
@property(nonatomic , retain)NSMutableArray * listAry;


@end
