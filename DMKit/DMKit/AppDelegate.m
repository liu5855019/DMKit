//
//  AppDelegate.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 17/8/30.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "AppDelegate.h"
#import "RootVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DMExceptionTool start];
    
    DMLog(@"app在%d状态下启动",application.applicationState);
    
    RootVC *vc = [RootVC new];
    
    BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = navc;
    
    [self.window makeKeyAndVisible];
    
    DMLog(@"app 启动完成");
    
    return YES;
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


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
