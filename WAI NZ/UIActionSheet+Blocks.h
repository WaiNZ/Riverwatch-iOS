//
//  UIActionSheet+Blocks.h
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Additions to UIActionSheet to allow for using UIActionSheet with
 blocks.
 */
@interface UIActionSheet (Blocks)

typedef void (^UIActionSheetCallback)(NSInteger index);

/**
 Initalize a UIActionSheet with a block callback instead of using
 a normal delegate.
 
 The callback called is equivelent to the delegate method
 -actionSheet:didDismissWithButtonIndex: with the button index passed
 in as the first parameter.
 
 @param title the text to be displyed in the top of the UIActionSheet
 @param callback the block to be called when the sheet has been dismissed
 @param cancelButtonTitle the title for the cancel button
 @param destructiveButtonTitle the title for the destructive button (red)
 @param otherButtonTitles the titles for the other buttons
 @param ... more buttons titles
 */
- (id)initWithTitle:(NSString *)title
		   callback:(UIActionSheetCallback)callback
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
