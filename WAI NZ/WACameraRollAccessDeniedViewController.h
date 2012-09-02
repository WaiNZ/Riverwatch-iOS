//
//  WACameraRollAccessDeniedViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WACameraRollAccessDeniedViewController : UIViewController {
	IBOutlet UIBarButtonItem *cancelButton;
	NSString *reason;
	__unsafe_unretained IBOutlet UILabel *reasonLabel;
}

+ (id)controllerWithReason:(NSString *)reason;

- (id)initWithReason:(NSString *)reason;

@end
