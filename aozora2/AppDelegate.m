//
//  AppDelegate.m
//  aozora2
//
//  Created by 羽野 真悟 on 13/04/24.
//  Copyright (c) 2013年 羽野 真悟. All rights reserved.
//

#import "AppDelegate.h"
#import "SecondViewController.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"644872599"]; // アプリを追加したときに与えられる9桁の数字(Apple ID)
    [Appirater setDebug: NO]; // デバッグモードの設定。YESにするとアプリを起動するたびに表示される。(デフォルト:NO)
    [Appirater appLaunched:YES]; // Appiraterの起動
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SecondViewController *secondViewController=[[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
    self.navigationController=[[UINavigationController alloc]initWithRootViewController:secondViewController];

    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
        [Appirater appEnteredForeground:YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
