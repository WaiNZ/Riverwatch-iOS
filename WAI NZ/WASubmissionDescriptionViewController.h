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
 * This controller provides the text editing screen for the description field of a submission.
 */
@interface WASubmissionDescriptionViewController : UIViewController{
    
    WASubmission *submission;
    __unsafe_unretained IBOutlet UITextView *descriptionText;

    
}
- (id)initWithSubmission:(WASubmission *)_submission;


@end
