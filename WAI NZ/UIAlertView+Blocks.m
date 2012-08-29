//
//  UIAlertView+Blocks.m
//  WAI NZ
//
//  Created by Melby Ruarus on 29/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "UIAlertView+Blocks.h"

#import <objc/runtime.h>

@interface __WAUIAlertViewBlockDelegate : NSObject <UIAlertViewDelegate> {
@public
	void (^callback)(NSInteger buttonIndex);
}
@end

@implementation __WAUIAlertViewBlockDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	callback(buttonIndex);
}
@end

@implementation UIAlertView (Blocks)

- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
	  okButtonTitle:(NSString *)okButtonTitle
  cancelButtonTitle:(NSString *)cancelButtonTitle
	dismissCallback:(void (^)(NSInteger buttonIndex))dismissCallback {
	
	__WAUIAlertViewBlockDelegate *delegate = [[__WAUIAlertViewBlockDelegate alloc] init];
	delegate->callback = dismissCallback;
	
	self = [self initWithTitle:title
					   message:message
					  delegate:delegate
			 cancelButtonTitle:cancelButtonTitle
			 otherButtonTitles:okButtonTitle, nil];
	
	if(self) {
		static const char blockDelegateKey;
		objc_setAssociatedObject(self, &blockDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN);
	}
	
	return self;
}

@end
