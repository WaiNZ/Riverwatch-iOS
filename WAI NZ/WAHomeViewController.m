//
//  WAHomeViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAHomeViewController.h"

#import "WASubmissionOverviewViewController.h"
#import "WASubmission.h"

@interface WAHomeViewController ()

@end

@implementation WAHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"WAI NZ";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    // TODO: check if the camera is available
    
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	photoPicker.delegate = self;
    
    [self presentModalViewController:photoPicker animated:YES];
}

- (IBAction)choosePhoto:(id)sender {
	// TODO: check for < 6.0 and notify user that location services are required if not enabled
    UIImagePickerController *cameraRollPicker = [[UIImagePickerController_Always alloc] init];
    
    cameraRollPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    cameraRollPicker.delegate = self;
    
    [self presentModalViewController: cameraRollPicker animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[WASubmissionPhoto photoWithMediaPickingInfo:info
									 resultBlock:^(WASubmissionPhoto *photo) {
										 WASubmission *submission = [[WASubmission alloc] init];
										 submission.descriptionText = @"I saw Old McDonald's cow crapping in the river ";
										 submission.email = @"syzygy@dt.net.nz";
										 submission.anonymous = NO;
										 submission.location = photo.location;
										 [submission addSubmissionPhoto:photo];
										 
										 WASubmissionOverviewViewController *controller = [[WASubmissionOverviewViewController alloc] initWithSubmission:submission];
										 [self.navigationController pushViewController:controller animated:NO];
										 
										 [picker dismissModalViewControllerAnimated:YES];
									 }
									failureBlock:^(NSError *error) {
										// TODO: error;
										
										[picker dismissModalViewControllerAnimated:YES];
									}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

@end
