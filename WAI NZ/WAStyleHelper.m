//
//  WAStyleHelper.m
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/2012.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAStyleHelper.h"

@implementation WAStyleHelper

+ (CGFloat)topAlignLabel:(UILabel *)label {
    CGSize size = label.bounds.size;
    size.height = CGFLOAT_MAX;
    
    CGSize textSize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:label.lineBreakMode];
    CGFloat diff = textSize.height - label.frame.size.height;
    CGRect frame = label.frame;
    frame.size.height = textSize.height;
    label.frame = frame;
    return diff;
}

+ (UIColor *)tableViewHeaderTextColor {
	CGColorSpaceRef device = CGColorSpaceCreateDeviceRGB();
	CGColorRef color = CGColorCreate(device, (CGFloat[]){0.298039, 0.337255, 0.423529,1});
	CGColorSpaceRelease(device);
	UIColor *uicolor = [[UIColor alloc] initWithCGColor:color];
	CGColorRelease(color);
	return uicolor;
}

@end
