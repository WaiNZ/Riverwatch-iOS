//
//  UIImageView+Layout.m
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "UIImageView+Layout.h"

@implementation UIImageView (Layout)

- (void)setAndFitToImage:(UIImage *)image {
	self.image = image;
	
	[self fitToImage];
}

- (void)fitToImage {
	// Start by filling superview
	CGRect newFrame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
	
	// Figure out the origin offset and new width/height using aspect fit
	if(self.image.size.width/self.image.size.height > newFrame.size.width/newFrame.size.height) {
		CGFloat newHeight = newFrame.size.width * (self.image.size.height/self.image.size.width);
		newFrame.origin.y = (newFrame.size.height - newHeight) / 2;
		newFrame.size.height = newHeight;
	}
	else {
		CGFloat newWidth = newFrame.size.height * (self.image.size.width/self.image.size.height);
		newFrame.origin.x = (newFrame.size.width - newWidth) / 2;
		newFrame.size.width = newWidth;
	}
	
	self.frame = newFrame;
}

@end
