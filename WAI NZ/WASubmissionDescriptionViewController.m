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

- (id)initWithSubmission:(WASubmission *)_submission {
    self = [super init];
    if (self) {
        // Custom initialization
        submission = _submission;
		self.navigationItem.title = @"Description";
        descriptionText.text=submission.descriptionText;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end
