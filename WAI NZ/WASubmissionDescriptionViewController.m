//
//  WASubmissionDescriptionViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionDescriptionViewController.h"
#import "WASubmission.h"

@interface WASubmissionDescriptionViewController ()

@end

@implementation WASubmissionDescriptionViewController

#pragma mark - Init/Dealloc
///-----------------------------------------------------------------------------
/// @name Init/Dealloc
///-----------------------------------------------------------------------------

- (id)initWithSubmission:(WASubmission *)_submission {
    self = [super init];
    if (self) {
        // Custom initialization
        submission = _submission;
		self.navigationItem.title = @"Description";

    }
    return self;
}

#pragma mark - View lifecycle
///-----------------------------------------------------------------------------
/// @name View lifecycle
///-----------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    descriptionText.text=submission.descriptionText;

}

- (void)viewWillAppear:(BOOL)animated {
    [descriptionText becomeFirstResponder];
	
	// Register for keyboard up/down
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    submission.descriptionText = descriptionText.text;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
    descriptionText = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - keyboard
///-----------------------------------------------------------------------------
/// @name Keyboard notifications
///-----------------------------------------------------------------------------

- (void)keyboardDidShow:(NSNotification *)notif {
    originalDescriptionTextFrame = descriptionText.frame;
    
    // TODO: support other rotations
    CGFloat keyboardSlideDuration = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:keyboardSlideDuration
                     animations:^{
                         CGRect frame = descriptionText.frame;
                         frame.size.height -= keyboardFrame.size.height;
                         descriptionText.frame = frame;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notif {
    CGFloat keyboardSlideDuration = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:keyboardSlideDuration
                     animations:^{
                         descriptionText.frame = originalDescriptionTextFrame;
                     }];
}

@end
