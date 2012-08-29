//
//  UIAlertView+Blocks.h
//  WAI NZ
//
//  Created by Melby Ruarus on 29/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks)

- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
	  okButtonTitle:(NSString *)okButtonTitle
  cancelButtonTitle:(NSString *)cancelButtonTitle
	dismissCallback:(void (^)(NSInteger buttonIndex))dismissCallback;

@end
