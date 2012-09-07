//
//  UIAlertView+Blocks.h
//  WAI NZ
//
//  Created by Melby Ruarus on 29/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Additions to UIAlertView to allow using blocks instead of a delegate for
 callbacks notifying of alert events.
 */
@interface UIAlertView (Blocks)

/**
 Initilize a UIAlertView with a title, message and button names, with a
 block for the dismiss callback function.
 
 For a description of when the dismissCallback is called see 
        -[UIAlertViewDelegate alertView:didDismissWithButtonIndex:] 
 as this is what triggers the call to this callback, the buttonIndex parameter
 is passed right through, so 1 will be the ok button index (rightmost) and 0 will
 be the cancel button index (leftmost).
 
 @param title the title of the alert to display
 @param message the message to display in the alert
 @param okButtonTitle the text to display in the default button (rightmost)
 @param cancelButtonTitle the text to display in the cancel button (leftmost)
 @param dismissCallback the block to call when the alert has been dismissed - see discussion
 */
- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
	  okButtonTitle:(NSString *)okButtonTitle
  cancelButtonTitle:(NSString *)cancelButtonTitle
	dismissCallback:(void (^)(NSInteger buttonIndex))dismissCallback;

@end
