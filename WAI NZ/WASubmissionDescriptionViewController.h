//
//  WASubmissionDescriptionViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WASubmission;

/**
 This controller provides the text editing screen for the description
 field of a submission.
 
 This controller must be initilized using the -initWithSubmission:
 constructor.
 */
@interface WASubmissionDescriptionViewController : UIViewController{
    WASubmission *submission;
    __unsafe_unretained IBOutlet UITextView *descriptionText;
    CGRect originalDescriptionTextFrame;

    
}

/**
 Initilize this WASubmissionDescriptionViewController with the specified
 submission.
 
 @param _submission the submission to edit the description on
 */
- (id)initWithSubmission:(WASubmission *)_submission;

@end
