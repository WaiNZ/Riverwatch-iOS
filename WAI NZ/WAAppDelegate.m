//
//  WAAppDelegate.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAAppDelegate.h"

#import "WAHomeViewController.h"

#import <RestKit/RestKit.h>
#import "WASubmission.h"

@implementation WAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Restkit setup
	[RKObjectManager setSharedManager:[RKObjectManager managerWithBaseURLString:kRootURL]];
	[RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
	[[RKObjectManager sharedManager].router routeClass:[WASubmission class] toResourcePath:kResourceSubmitPath forMethod:RKRequestMethodPOST];
	[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[[WASubmission objectMapping] inverseMapping] forClass:[WASubmission class]];
	
	
	// Normal setup
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
