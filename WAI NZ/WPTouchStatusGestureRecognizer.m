//
//  WPTouchStatusGestureRecognizer.m
//  WalletPoC
//
//  Created by Melby Ruarus on 20/08/12.
//  Copyright (c) 2012 Alphero. All rights reserved.
//

#import "WPTouchStatusGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface WPTouchStatusGestureRecognizer ()
@property (nonatomic, assign) BOOL touchDown;
@end

@implementation WPTouchStatusGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.touchDown = YES;
	self.state = UIGestureRecognizerStateBegan;
//	for(UITouch *touch in touches) {
//		[self ignoreTouch:touch forEvent:event];
//	}
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.touchDown = NO;
	self.state = UIGestureRecognizerStateEnded;
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.touchDown = NO;
	self.state = UIGestureRecognizerStateCancelled;
	[super touchesCancelled:touches withEvent:event];
}

@synthesize touchDown;
@end
