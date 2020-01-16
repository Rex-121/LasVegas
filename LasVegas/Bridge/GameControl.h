//
//  GameControl.h
//  LasVegas
//
//  Created by Tyrant on 2020/1/3.
//  Copyright © 2020 Tyrant. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameControl : NSObject

// 初始化
+ (void)genesis;


+ (void)start;


+ (void)end;


+ (void)appDidEnterBackground;

+ (void)appWillEnterForeground;

+ (void)destory;


+ (void)statusBarOrientationChanged;

@end



@interface GameControl (AppKit)

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (void)applicationDidBecomeActive:(UIApplication *)application;
+ (void)applicationWillResignActive:(UIApplication *)application;
+ (void)applicationDidEnterBackground:(UIApplication *)application;
+ (void)applicationWillEnterForeground:(UIApplication *)application;
+ (void)applicationWillTerminate:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
