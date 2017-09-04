//
//  AppDelegate.m
//  TKJD
//
//  Created by apple on 2017/1/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "signViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES) {
        
        
        self.window.rootViewController = [ZCYTabBarController new];
        
        [self.window makeKeyAndVisible];
        
    }else{
        
        signViewController * vc =[[signViewController alloc]init];
        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:vc];
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xFEFFFF)];
        
        self.window.rootViewController = nav;
        
        [self.window makeKeyAndVisible];
        
    }
    
    [self defaultsData];

    
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager]setUmSocialAppkey:@"57996898e0f55a4a03001feb"];
    
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    [self configUSharePlatforms];
    
    

    return YES;
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx5dcb3e20420d361f" appSecret:@"1e8a4a21a917ab19bca5635d59a48221" redirectURL:@"http://www.tkjidi.com"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105962988"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://www.tkjidi.com"];
    
//    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3156076585"  appSecret:@"45c85f15a7903235d4eec0dd2cb4467b" redirectURL:@"http://www.baidu.com/"];
    
   
}
-(void)defaultsData{
    
    if (![defaults boolForKey:@"defaultReply"]) {
        //机器人回复
        [defaults setBool:YES forKey:@"defaultReply"];
        
        NSString * text =@"http://588p.com/?r=s&kwd=,找，搜,{search_url}";
        [defaults setObject:text forKey:@"ReplyText"];
    }
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first"])
    {
        //首次登陆
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        
        //微信
        NSString * str =@"【淘宝秘券】{cvalue}元\n {title}\n【在售】{price}元\n【券后】{qhprice}元\n【淘口令】{pwd}\n【二合一链接】{short_url}\n{guid_content}";
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDefault"];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"defaultText"];
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        
        LRLog(@"1111");
    }
    return result;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TKJD"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
