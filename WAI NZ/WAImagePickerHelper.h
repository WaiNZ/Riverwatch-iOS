//
//  WAImagePickerHelper.h
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A helper class for displaying a image picker and checking for permissions and prompting the
 user if needed. This class abstracts checks for different iOS versions and displays relevant
 errors when permission is denied or the camera library cannot be accessed.
 */
@interface WAImagePickerHelper : NSObject

/**
 Present a UIImagePickerController with the specified delegate, checking for various
 possible error conditions for different versions of iOS and displaying appropriate
 messages
 
 @param controller the view controller to display the picker in
 @param delegate the delegate to set on the UIImagePickerController
 */
+ (void)showImagePickerForCameraRollInController:(UIViewController *)controller
							  withPickerDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate;

@end
