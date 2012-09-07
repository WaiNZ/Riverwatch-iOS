//
//  WACameraRollAccessDeniedViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A UIViewController to show that access to the Camera Roll has been denied
 */
@interface WACameraRollAccessDeniedViewController : UIViewController {
	IBOutlet UIBarButtonItem *cancelButton;
	NSString *reason;
	__unsafe_unretained IBOutlet UILabel *reasonLabel;
}

 /**
 initializer for WACameraRollAccessDeniedViewController, taking an NSString with the reason the access was denied, returns inside a NavigationViewController 
 @param reason reason the access was denied, to be shown on screen.
 */
+ (id)controllerWithReason:(NSString *)reason;

/**
 initializer for WACameraRollAccessDeniedViewController, taking an NSString with the reason the access was denied
 @param reason reason the access was denied, to be shown on screen.
 */
- (id)initWithReason:(NSString *)reason;

@end
