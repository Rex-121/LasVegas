//
//  GameControl.m
//  LasVegas
//
//  Created by Tyrant on 2020/1/3.
//  Copyright © 2020 Tyrant. All rights reserved.
//

#import "GameControl.h"

#import <UIKit/UIKit.h>

#import "cocos2d.h"

#import "AppDelegate.h"

#import "SDKWrapper.h"

using namespace cocos2d;

@implementation GameControl

Application* app = nullptr;

+ (void)genesis {
 
    float scale = [[UIScreen mainScreen] scale];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    app = new AppDelegate(bounds.size.width * scale, bounds.size.height * scale);

    
}


+ (void)statusBarOrientationChanged {
    float scale = [[UIScreen mainScreen] scale];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    float width = bounds.size.width * scale;
    float height = bounds.size.height * scale;
    app->updateViewSize(width, height);
}


+ (void)start {
    app->start();
}

+ (void)appDidEnterBackground {
    app->applicationDidEnterBackground();
}

+ (void)appWillEnterForeground {
    app->applicationWillEnterForeground();
}

+ (void)destory {
    
    
    delete app;
    
    app = nil;
    
}
@end


@implementation GameControl (AppKit)

+ (void)application:(id)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SDKWrapper getInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

+ (void)applicationDidBecomeActive:(UIApplication *)application {
    [[SDKWrapper getInstance] applicationDidBecomeActive:application];
}

+ (void)applicationWillResignActive:(UIApplication *)application {
    [[SDKWrapper getInstance] applicationWillResignActive:application];
}

+ (void)applicationDidEnterBackground:(UIApplication *)application {
    [[SDKWrapper getInstance] applicationDidEnterBackground:application];
    
    [GameControl appDidEnterBackground];
}

+ (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[SDKWrapper getInstance] applicationWillEnterForeground:application];
    
    
    [GameControl appWillEnterForeground];
}

+ (void)applicationWillTerminate:(UIApplication *)application {
    
    [[SDKWrapper getInstance] applicationWillTerminate:application];
    
    [GameControl destory];
}


@end




