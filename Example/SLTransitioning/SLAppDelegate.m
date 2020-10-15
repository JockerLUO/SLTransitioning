//
//  SLAppDelegate.m
//  SLTransitioning
//
//  Created by Jocker Luo on 10/15/2020.
//  Copyright (c) 2020 Jocker Luo. All rights reserved.
//

#import "SLAppDelegate.h"
#import "SLTabBarController.h"

@implementation SLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    SLTabBarController *vc = [SLTabBarController new];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
