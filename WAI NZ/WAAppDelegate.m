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
#import "WASubmissionResponse.h"
#import "WAStyleHelper.h"
#import "NSString+UUID.h"

#define UUID_USER_DEFAULTS_KEY @"App_UUID"

@implementation WAAppDelegate

+ (NSString *)uuid {
	return [[NSUserDefaults standardUserDefaults] objectForKey:UUID_USER_DEFAULTS_KEY];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// UUID setup
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:UUID_USER_DEFAULTS_KEY] == nil) {
        [defaults setObject:[NSString uuid] forKey:UUID_USER_DEFAULTS_KEY];
        [defaults synchronize];
    }
	
	// Restkit setup
	[self configureRestKitWithBaseURL:kRootURL];
	
#if DEBUG
	RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
#endif
		
	// Normal setup
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    WAHomeViewController *homeController = [[WAHomeViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeController];
	navController.navigationBar.tintColor = [WAStyleHelper waiDarkBlueColor];
	self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)configureRestKitWithBaseURL:(NSString *)url {
	[RKObjectManager setSharedManager:[RKObjectManager managerWithBaseURLString:url]];
	[RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
	[[RKObjectManager sharedManager].router routeClass:[WASubmission class] toResourcePath:kResourceSubmitPath forMethod:RKRequestMethodPOST];
	[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[[WASubmission objectMapping] inverseMapping] forClass:[WASubmission class]];
	[[RKObjectManager sharedManager].mappingProvider setObjectMapping:[WASubmissionResponse objectMapping] forResourcePathPattern:kResourceSubmitPath];
}

@synthesize window;
@end
