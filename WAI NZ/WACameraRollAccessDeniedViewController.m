//
//  WACameraRollAccessDeniedViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WACameraRollAccessDeniedViewController.h"

#import "WAStyleHelper.h"

@interface WACameraRollAccessDeniedViewController ()

@end

@implementation WACameraRollAccessDeniedViewController

+ (id)controllerWithReason:(NSString *)reason {
	WACameraRollAccessDeniedViewController *controller = [[self alloc] initWithReason:reason];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	return nav;
}

- (id)initWithReason:(NSString *)_reason {
	self = [self init];
	if(self) {
		reason = _reason;
	}
	return self;
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
	reasonLabel.text = reason;
	[WAStyleHelper topAlignLabel:reasonLabel];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)viewDidUnload {
	cancelButton = nil;
	reasonLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
