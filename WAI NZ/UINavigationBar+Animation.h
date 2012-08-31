//
//  IUNavigationBar+Animation.h
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//



@interface UINavigationBar (Animation)

+ (NSTimeInterval)pushPopAnimationDuration;
- (void)setBarStyle:(UIBarStyle)barStyle animated:(BOOL)animated;

@end
