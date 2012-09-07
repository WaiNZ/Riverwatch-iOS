//
//  WASubmissionTagEditorViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WASubmission.h"

/**
 The interface for the view to edit the tags for the submission, eg Cow, Runoff or Pollution
 */
@interface WASubmissionTagEditorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	WASubmission *submission;
}

/**
 Initilize this WASubmissionDescriptionViewController with the specified
 submission.
 
 @param _submission the submission to edit the tags on
 */
- (id)initWithSubmission:(WASubmission *)_submission;

@end
