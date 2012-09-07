//
//  UIImageView+Layout.h
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This interface extends the UIImageView to resize correctly within the superview
 */
@interface UIImageView (Layout)

/**
 This method sets the image that this image view displays
 and resizes the view so that it aspect fits inside the
 superview.
 
 @param image the image to set and use for the size to resize to
 */
- (void)setAndFitToImage:(UIImage *)image;

/**
 Resize the view so that it aspect fits inside the superview.
 */
- (void)fitToImage;

@end
