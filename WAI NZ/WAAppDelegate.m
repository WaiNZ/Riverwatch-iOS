//
//  WAAppDelegate.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAAppDelegate.h"

#import "WAHomeViewController.h"

@implementation WAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    WAHomeViewController *homeController = [[WAHomeViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeController];
	self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@synthesize window;
@end
