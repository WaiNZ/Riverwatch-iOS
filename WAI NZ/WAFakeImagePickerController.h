//
//  WAFakeImagePickerController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#if TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

@interface WAFakeImagePickerController : UIViewController {
	UIImage *image;
}

@property (nonatomic) UIImagePickerControllerSourceType sourceType;
@property (nonatomic, unsafe_unretained) id<UIImagePickerControllerDelegate> delegate;
@end

#endif