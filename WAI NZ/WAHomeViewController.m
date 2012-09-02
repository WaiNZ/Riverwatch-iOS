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
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "WACameraRollAccessDeniedViewController.h"

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
	void (^showPicker)() = ^{
		UIImagePickerController *cameraRollPicker = [[UIImagePickerController_Always alloc] init];
		
		cameraRollPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		cameraRollPicker.delegate = self;
		
		[self presentModalViewController: cameraRollPicker animated:YES];
	};
	
	if([UIDevice currentDevice].systemVersion.floatValue < 6.0) {
		// TODO: TEST!
		// Assets library required to access something from the camera roll
		// Assets library requires location access, so check before showing picker
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library enumerateGroupsWithTypes:ALAssetsGroupLibrary
							   usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
								   *stop = YES;
								   showPicker();
							   }
							 failureBlock:^(NSError *error) {
								 if([error.domain isEqualToString:ALAssetsLibraryErrorDomain]) {
									 switch(error.code) {
										 case ALAssetsLibraryAccessUserDeniedError: {
											 WACameraRollAccessDeniedViewController *controller = [WACameraRollAccessDeniedViewController controllerWithReason:@"Accessing the photo library requires access to your location, you can enable this in Location Services."];
											 [self presentModalViewController:controller animated:YES];
											 return;
										 }
										 case ALAssetsLibraryAccessGloballyDeniedError: {
											 WACameraRollAccessDeniedViewController *controller = [WACameraRollAccessDeniedViewController controllerWithReason:@"Accessing the photo library requires access to your location, you can enable this in Location Services."];
											 [self presentModalViewController:controller animated:YES];
											 return;
										 }
										 default: {
											 break;
										 }
									 }
								 }
								 
									// TODO: error, wansn't what we were expecting
							 }];
	}
	else {
		showPicker();
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// Create a submission photo - this is async
	[WASubmissionPhoto photoWithMediaPickingInfo:info
									 resultBlock:^(WASubmissionPhoto *photo) {
										 // Configure the submission with the photo
										 WASubmission *submission = [[WASubmission alloc] init];
										 submission.anonymous = YES;
										 submission.location = photo.location;
										 [submission addSubmissionPhoto:photo];
										 
										 // Show the overview screen
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
