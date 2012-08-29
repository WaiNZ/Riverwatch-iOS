//
//  WAAppDelegate.h
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The application delegate for WAI NZ. This class receives messages from the UIApplication
 object and is responsible for setting up the UI and responding to application level events
 
 There is only one instance of this class in the application. The instance of this class can
 be aquired by:
 
 		(WAAppDelegate *)[UIApplication sharedApplication].delegate
 
 */
@interface WAAppDelegate : UIResponder <UIApplicationDelegate>

/** The main application window */
@property (strong, nonatomic) UIWindow *window;

@end
