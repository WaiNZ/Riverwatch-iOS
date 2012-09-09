//
//  WAStyleHelper.h
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/2012.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A class with static methods to provide help with styles
 */
@interface WAStyleHelper : NSObject

///-----------------------------------------------------------------------------
/// @name Aligning views
///-----------------------------------------------------------------------------

/**
 Resize a UILabel so that the text is top aligned.
 
 This method returns the amount that the label has been resized
 by, this is positive if the view has been expended, and negative
 if it has been shrunk. For this reason this value can be used
 to shift the views below the label by just adding it to the
 frame.origin.y.
 
 @param label the label to top align the text in.
 @return the amount that the label has been resized by
 */
+ (CGFloat)topAlignLabel:(UILabel *)label;

/**
 Resize a UILabel so that the text is bottom aligned.
 
 This method returns the amount that the label has been resized
 by, this is positive if the view has been expended, and negative
 if it has been shrunk. For this reason this value can be used
 to shift the views below the label by just adding it to the
 frame.origin.y.
 
 @param label the label to bottom align the text in.
 @return the amount that the label has been resized by
 */
+ (CGFloat)bottomAlignLabel:(UILabel *)label;

///-----------------------------------------------------------------------------
/// @name Colors
///-----------------------------------------------------------------------------

/**
 This returns the correct color to assign to the table header text
 
 @return the UIColor used for table header text
 */
+ (UIColor *)tableViewHeaderTextColor;

/**
 Returns the dark blue color that is used for the application
 
 @return the UIColor used throughtout the application for WAI NZ
 */
+ (UIColor *)waiDarkBlueColor;

@end
