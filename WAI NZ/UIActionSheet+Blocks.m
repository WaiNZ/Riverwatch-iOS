//
//  UIActionSheet+Blocks.m
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "UIActionSheet+Blocks.h"

#import <objc/runtime.h>

@interface __UIActionSheet_Block_Delegate : NSObject <UIActionSheetDelegate> {
@public
	UIActionSheetCallback callback;
}
@end
@implementation __UIActionSheet_Block_Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(callback) {
		callback(buttonIndex);
	}
}
@end

@implementation UIActionSheet (Blocks)

- (id)initWithTitle:(NSString *)title
		   callback:(UIActionSheetCallback)callback
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
	__UIActionSheet_Block_Delegate *delegate = [[__UIActionSheet_Block_Delegate alloc] init];
	delegate->callback = callback;
	
	self = [self initWithTitle:title
					  delegate:delegate
			 cancelButtonTitle:nil
		destructiveButtonTitle:nil
			 otherButtonTitles:nil];
	
	if(self) {
		static char key;
		objc_setAssociatedObject(self, &key, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		
		va_list args;
		va_start(args, otherButtonTitles);
		NSString  *otherButtonTitle;
		for (otherButtonTitle = otherButtonTitles; otherButtonTitle != nil; otherButtonTitle = va_arg(args, NSString *)) { // we assume that all arguments are objects
			[self addButtonWithTitle:otherButtonTitle];
		}
		va_end(args);
		
		self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
	}
	
	// TODO: Implemenet destructiveButtonTitle
	
	return self;
}

@end
