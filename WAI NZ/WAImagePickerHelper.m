//
//  WAImagePickerHelper.m
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAImagePickerHelper.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "WACameraRollAccessDeniedViewController.h"

@implementation WAImagePickerHelper

+ (void)showImagePickerForCameraRollInController:(UIViewController *)controller withPickerDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate {
	void (^showPicker)() = ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
		UIImagePickerController *cameraRollPicker = [[UIImagePickerController_Always alloc] init];
#pragma clang diagnostic pop
		
		cameraRollPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		cameraRollPicker.delegate = delegate;
		
		[controller presentModalViewController: cameraRollPicker animated:YES];
	};
	
	if([UIDevice currentDevice].systemVersion.floatValue < 6.0) {
		// TODO: TEST!
		// Assets library required to access something from the camera roll
		// Assets library requires location access, so check before showing picker
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library enumerateGroupsWithTypes:ALAssetsGroupLibrary
							   usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
								   *stop = YES;
								   showPicker();
							   }
							 failureBlock:^(NSError *error) {
								 if([error.domain isEqualToString:ALAssetsLibraryErrorDomain]) {
									 switch(error.code) {
										 case ALAssetsLibraryAccessUserDeniedError: {
											 WACameraRollAccessDeniedViewController *denyController = [WACameraRollAccessDeniedViewController controllerWithReason:@"Accessing the photo library requires access to your location, you can enable this in Location Services."];
											 [controller presentModalViewController:denyController animated:YES];
											 return;
										 }
										 case ALAssetsLibraryAccessGloballyDeniedError: {
											 WACameraRollAccessDeniedViewController *denyController = [WACameraRollAccessDeniedViewController controllerWithReason:@"Accessing the photo library requires access to your location, you can enable this in Location Services."];
											 [controller presentModalViewController:denyController animated:YES];
											 return;
										 }
										 default: {
											 break;
										 }
									 }
								 }
								 
								 // TODO: error, wansn't what we were expecting
							 }];
	}
	else {
		showPicker();
	}
}
@end
