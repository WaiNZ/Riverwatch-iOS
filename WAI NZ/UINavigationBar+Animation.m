//
//  IUNavigationBar+Animation.m
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "UINavigationBar+Animation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (Animation)

+ (NSTimeInterval)pushPopAnimationDuration {
	return 0.368f;
}

- (void)setBarStyle:(UIBarStyle)barStyle animated:(BOOL)animated {
	// From http://stackoverflow.com/questions/645232/transitioning-uinavigationbar-colors
	
    if (animated && self.barStyle != barStyle) {
        CATransition *transition = [CATransition animation];
        transition.duration = [UINavigationBar pushPopAnimationDuration];
        transition.timingFunction = [CAMediaTimingFunction
									 functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.layer addAnimation:transition forKey:nil];
    }
	
    [self setBarStyle:barStyle];
}

@end
