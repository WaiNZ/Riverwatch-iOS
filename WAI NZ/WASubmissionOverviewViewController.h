//
//  WASubmissionOverviewViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 15/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WASubmission;

/**
 This controller displays the overview of a submission, and must be initilized
 using the -initWithSubmission: constructor.
 
 The kinds of data this controller displays about a submission are:
 
 - The photos
 - The location the event was noted at
 - The time the submission was made
 - A description of the submission
 - The tags on this submission
 - Which email address should be used to send to the council
 - Whether this email address should be submitted to the council if specified
 
 Of these the all but the time the submission was made can be edited by the
 user.
 */
@interface WASubmissionOverviewViewController : UITableViewController <UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate> {
	__unsafe_unretained IBOutlet UITableView *mainTableView;
	IBOutlet UITableViewCell *emailCell;
	IBOutlet UITextField *emailField;
	IBOutlet UISwitch *slider;
	IBOutlet UIView *topView;
	WASubmission *submission;
    __unsafe_unretained IBOutlet UIScrollView *photoScrollView;
	IBOutlet UIView *addPhotoView;
}

/**
 Initilize a WASubmissionOverviewViewController with the specified submission
 
 @param _submission the submission to display in this controller
 */
- (id)initWithSubmission:(WASubmission *)_submission;

@end
