//
//  WASubmitViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmitViewController.h"

@interface WASubmitViewController ()

@end

@implementation WASubmitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Uploading...";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    inProgressStatusMessage.text = @"Uploading...";
    self.navigationItem.hidesBackButton = YES;

    
    
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.view == inProgressView) {
        prog = 0.01;
        pass = rand() % 100;
        [self sendSubmission];
    }
}

static float prog = 0.01;
static int pass = 0.01;


- (void) sendSubmission {
    prog += 0.01;
    progressBar.progress = prog;
    if (pass > 30 || prog*100 <= 100-pass) {
        if (prog <= 1)[self performSelector:@selector(sendSubmission) withObject:nil afterDelay:0.01];
        else {
            self.view = successfulView;
            self.navigationItem.title = @"Done!";
            self.navigationItem.rightBarButtonItem = doneButton;
        }
    }
    else {
        if (prog <= (1-pass))[self performSelector:@selector(sendSubmission) withObject:nil afterDelay:0.01];
        else {
            self.view = unsuccessfulView;
            self.navigationItem.title = @"Oh dear...";
            self.navigationItem.hidesBackButton = NO;

        }
    }
    
}

- (void)viewDidUnload {
    progressBar = nil;
    retryButton = nil;
    successfulStatusMessage = nil;
    inProgressStatusMessage = nil;
    unsuccessfulStatusMessage = nil;
    unsuccessfulView = nil;
    successfulView = nil;
    inProgressView = nil;
    doneButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)retryButtonPressed:(id)sender {
    prog = 0.01;
    pass = rand() % 100;
    self.view = inProgressView;
    self.navigationItem.hidesBackButton = YES;
    [self sendSubmission];
}
@end
