//
//  WAFakeImagePickerController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#if TARGET_IPHONE_SIMULATOR

#import "WAFakeImagePickerController.h"

#import "WASimulatorData.h"

@protocol WAFakeImagePickerControllerDelegate
@optional
- (void)imagePickerController:(WAFakeImagePickerController *)controller didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;
- (void)imagePickerController:(WAFakeImagePickerController *)controller didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(WAFakeImagePickerController *)controller;
@end

@implementation WAFakeImagePickerController

- (id)init {
	self = [super init];
	
	if(self) {
		image = [UIImage imageWithData:[NSData dataWithBytes:kWACowData length:sizeof(kWACowData)]];
	}
	
	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view.window.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view.opaque = YES;
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	cancelButton.frame = CGRectMake(8, 8, self.view.bounds.size.width/2-16, 44);
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cancelButton];
	
	UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	selectButton.frame = CGRectMake(8+self.view.bounds.size.width/2, 8, self.view.bounds.size.width/2-16, 44);
	[selectButton setTitle:@"Use photo" forState:UIControlStateNormal];
	[selectButton addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:selectButton];
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44+16, self.view.frame.size.width, self.view.frame.size.height-(44+16))];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.image = image;
	[self.view addSubview:imageView];
}

- (void)cancel {
	if(delegate) {
		if([delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
			[(id<WAFakeImagePickerControllerDelegate>)delegate imagePickerControllerDidCancel:self];
		}
	}
	else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)select {
	if(delegate) {
		if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
			[(id<WAFakeImagePickerControllerDelegate>)delegate imagePickerController:self didFinishPickingMediaWithInfo:@{UIImagePickerControllerOriginalImage: image}];
		}
		else if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImage:editingInfo:)]) {
			[(id<WAFakeImagePickerControllerDelegate>)delegate imagePickerController:self didFinishPickingImage:image editingInfo:nil];
		}
	}
	else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark - Properties

@synthesize sourceType;
@synthesize delegate;
@end

#endif