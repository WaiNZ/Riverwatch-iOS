//
//  IUNavigationBar+Animation.h
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//



/**
 Additions to UINavigationBar to help with animations
 */
@interface UINavigationBar (Animation)

/**
 The duration of a push pop animation for a navigation controller
 */
+ (NSTimeInterval)pushPopAnimationDuration;

/**
 Set the bar style of the navigation bar, optionally animated
 
 @param barStyle the UIBarStyle to set on the bar
 @param animated whether the status bar change should be animated
 */
- (void)setBarStyle:(UIBarStyle)barStyle animated:(BOOL)animated;

@end
