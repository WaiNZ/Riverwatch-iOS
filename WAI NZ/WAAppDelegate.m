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
#import "WPTouchStatusGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

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
	UIGestureRecognizer *gr = [[WPTouchStatusGestureRecognizer alloc] initWithTarget:self action:@selector(screenTouch:)];
	[self.window addGestureRecognizer:gr];
	gr.delegate = self;
	gr.cancelsTouchesInView = NO;
	gr.delaysTouchesBegan = NO;
    WAHomeViewController *homeController = [[WAHomeViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeController];
	navController.navigationBar.tintColor = [WAStyleHelper waiDarkBlueColor];
	self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)screenTouch:(UIPanGestureRecognizer *)recog {
	switch (recog.state) {
		case UIGestureRecognizerStateBegan:
			[touchView removeFromSuperview];
			touchView = [[UIView alloc] init];
			touchView.frame = CGRectMake(0, 0, 40, 40);
			touchView.layer.cornerRadius = 20;
			touchView.layer.borderWidth = 1;
			touchView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.8].CGColor;
			touchView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
			touchView.center = [recog locationInView:self.window];
			[self.window addSubview:touchView];
			break;
		case UIGestureRecognizerStateChanged:
			touchView.center = [recog locationInView:self.window];
			break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
		case UIGestureRecognizerStateEnded:
			[touchView removeFromSuperview];
			touchView = nil;
		default:
			break;
	}
}

- (void)configureRestKitWithBaseURL:(NSString *)url {
	[RKObjectManager setSharedManager:[RKObjectManager managerWithBaseURLString:url]];
	[RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
	[[RKObjectManager sharedManager].router routeClass:[WASubmission class] toResourcePath:kResourceSubmitPath forMethod:RKRequestMethodPOST];
	[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[[WASubmission objectMapping] inverseMapping] forClass:[WASubmission class]];
	[[RKObjectManager sharedManager].mappingProvider setObjectMapping:[WASubmissionResponse objectMapping] forResourcePathPattern:kResourceSubmitPath];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

@synthesize window;
@end
