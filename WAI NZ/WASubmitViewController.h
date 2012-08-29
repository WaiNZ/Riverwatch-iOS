//
//  WASubmitViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This controller manages the uploading of a submission to WAI NZ
 * and presents a user interface to monitor the progress and report on any errors.
 *
 * When the submission is complete this controller will pop the
 * entire navigation stack.
 */
@interface WASubmitViewController : UIViewController {
    
    __unsafe_unretained IBOutlet UILabel *successfulStatusMessage;
    __unsafe_unretained IBOutlet UILabel *inProgressStatusMessage;
    __unsafe_unretained IBOutlet UIButton *retryButton;
    __unsafe_unretained IBOutlet UIProgressView *progressBar;
    __unsafe_unretained IBOutlet UILabel *unsuccessfulStatusMessage;
    
    IBOutlet UIBarButtonItem *doneButton;
    //views
    
    IBOutlet UIView *unsuccessfulView;
    IBOutlet UIView *successfulView;
    IBOutlet UIView *inProgressView;

}
- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)retryButtonPressed:(id)sender;
@end
