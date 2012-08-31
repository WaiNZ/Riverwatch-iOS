//
//  UIActionSheet+Blocks.h
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Blocks)

typedef void (^UIActionSheetCallback)(NSInteger index);

- (id)initWithTitle:(NSString *)title
		   callback:(UIActionSheetCallback)callback
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
