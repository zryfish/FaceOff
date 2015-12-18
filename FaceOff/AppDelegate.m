//
//  AppDelegate.m
//  FaceOff
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "AppDelegate.h"
#import "OpenShareHeader.h"
#import "FileUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)moveAvatarsToDocumentsDirectory {
    NSString * directoryPath = [[NSBundle mainBundle] bundlePath];
    NSDirectoryEnumerator * enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    NSString * filePath;
    while ((filePath = [enumerator nextObject]) != nil) {
        NSString * extension = [[filePath pathExtension] lowercaseString];
        
        if ([extension isEqualToString:@"jpg"]
            || [extension isEqualToString:@"jpeg"]) {
            
            NSString * fullPath = [directoryPath stringByAppendingPathComponent:filePath];
            NSData * data = [NSData dataWithContentsOfFile:fullPath];
            [FileUtils writeFileAtDocumentsDirectoryWithName:filePath withData:data];
            
            NSLog(@"%@", fullPath);
            assert([FileUtils isFileExistsAtDocumentsDirectory:filePath] == YES);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[UMSocialData setAppKey:@"5663ac82e0f55a2b04005460"];
    [OpenShare connectQQWithAppId:@"1105006004"];
    [OpenShare connectWeixinWithAppId:@"wx38765146033eb513"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HasLanuchedOnce"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLanuchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLanuchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"First time lanuch");
        [self moveAvatarsToDocumentsDirectory];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
