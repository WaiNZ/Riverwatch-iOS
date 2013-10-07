//
//  WAFakeImagePickerController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

@compatibility_alias UIImagePickerController_Always UIImagePickerController;

#if TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

/**
 A class that mimics UIImagePickerController for use in the simulator.
 This class is not currently a full copy of UIImagePickerController so certain
 methods and properties do not exist.
 
 Use of this class should be automatic, as when WAFakeImagePickerController.h
 is imported all instances of UIImagePickerController will become instances of
 WAFakeImagePickerController.
 */
@interface WAFakeImagePickerController : UIViewController {
	UIImage *image;
}

/** The source type for the picker, ignored */
@property (nonatomic) UIImagePickerControllerSourceType sourceType;
/** The delegate, notified when a photo is picked or the picker cancels */
@property (nonatomic, unsafe_unretained) id<UIImagePickerControllerDelegate> delegate;
@end

#if !NO_WAFakeImagePickerController
	#define UIImagePickerController WAFakeImagePickerController
#endif

#endif