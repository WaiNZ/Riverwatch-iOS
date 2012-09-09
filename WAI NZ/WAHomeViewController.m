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
#import "WACameraRollAccessDeniedViewController.h"
#import "WAImagePickerHelper.h"

@interface WAHomeViewController ()

@end

@implementation WAHomeViewController

#pragma mark - Init/Dealloc
///-----------------------------------------------------------------------------
/// @name Initilization
///-----------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"WAI NZ";
    }
    return self;
}

#pragma mark - View lifecycle
///-----------------------------------------------------------------------------
/// @name View lifecycle
///-----------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
	mainTableView.tableHeaderView = headerView;
	mainTableView.tableFooterView = footerView;
}

- (void)viewDidUnload {
	mainTableView = nil;
	headerView = nil;
	footerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
///-----------------------------------------------------------------------------
/// @name UITableViewDataSource/UITableViewDelegate
///-----------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = @"Take a photo";
			break;
		case 1:
			cell.textLabel.text = @"Choose an existing photo";
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0) {
		UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
		// TODO: check if the camera is available
		
		photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		photoPicker.delegate = self;
		
		[self presentModalViewController:photoPicker animated:YES];
	}
	else if(indexPath.section == 1) {
		[WAImagePickerHelper showImagePickerForCameraRollInController:self
												   withPickerDelegate:self];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
///-----------------------------------------------------------------------------
/// @name UIImagePickerControllerDelegate
///-----------------------------------------------------------------------------

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
