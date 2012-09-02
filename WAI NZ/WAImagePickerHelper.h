//
//  WAImagePickerHelper.h
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAImagePickerHelper : NSObject

+ (void)showImagePickerForCameraRollInController:(UIViewController *)controller withPickerDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate;

@end
