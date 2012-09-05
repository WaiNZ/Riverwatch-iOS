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

+ (UIColor *)tableViewHeaderTextColor;

@end
