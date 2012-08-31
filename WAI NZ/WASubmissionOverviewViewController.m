//
//  WASubmissionOverviewViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 15/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionOverviewViewController.h"
#import "WASubmissionDescriptionViewController.h"
#import "WASubmitViewController.h"
#import "WASubmission.h"
#import "WASubmissionPhotoGalleryViewController.h"
#import "NSNumber+FormatSI.h"
#import "UIActionSheet+Blocks.h"


#import <UIKit/UITableView.h>

#define ENABLE_SUBMISSION_UPDATE_NOTIFICATION [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submissionUpdated) name:kWASubmissionUpdatedNotification object:submission];
#define DISABLE_SUBMISSION_UPDATE_NOTIFICATION [[NSNotificationCenter defaultCenter] removeObserver:self name:kWASubmissionUpdatedNotification object:submission]

static const int kTakePhotoButton = 0;
static const int kUseExistingPhotoButton = 1;


@interface WASubmissionOverviewViewController ()

-(void) loadPhotoViews;
@end

@implementation WASubmissionOverviewViewController

- (id)initWithSubmission:(WASubmission *)_submission {
	self = [self initWithNibName:@"WASubmissionOverviewViewController" bundle:nil];
	if(self) {
		// Set up
		submission = _submission;
		self.navigationItem.title = @"Submission";
		ENABLE_SUBMISSION_UPDATE_NOTIFICATION;
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadPhotoViews];
	mainTableView.tableHeaderView = topView;
}

- (void)viewDidUnload {
	slider = nil;
	emailField = nil;
	mainTableView = nil;
	emailCell = nil;
	topView = nil;
    photoScrollView = nil;
	addPhotoView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions
- (IBAction)sliderChanged:(id)sender {
	[mainTableView beginUpdates];
	if(!slider.on){
		[mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else {
		[mainTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	DISABLE_SUBMISSION_UPDATE_NOTIFICATION;
	submission.anonymous = slider.on;
	ENABLE_SUBMISSION_UPDATE_NOTIFICATION;
	[mainTableView endUpdates];
}

- (IBAction) addAdditionalPhoto:(id)sender {
    UIActionSheet *addSheet = [[UIActionSheet alloc] initWithTitle:@"Add a photo"
                                                          callback:^(NSInteger buttonIndex) {
															  //0 is the topmost (Take a photo) button
															  if(buttonIndex==kTakePhotoButton){
																  UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
																  // TODO: check if the camera is available
																  photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
																  photoPicker.delegate = self;
																  [self presentModalViewController:photoPicker animated:YES];
															  }
															  //1 is the topmost (Use an existing photo) button
															  else if(buttonIndex==kUseExistingPhotoButton){
																  UIImagePickerController *cameraRollPicker = [[UIImagePickerController_Always alloc] init];
																  cameraRollPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
																  cameraRollPicker.delegate = self;
																  [self presentModalViewController: cameraRollPicker animated:YES];
															  }
														  }
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Take a photo", @"Add an exisiting photo",nil ];
    [addSheet showInView:self.view];
    
}

-( IBAction) photoTapped:(UITapGestureRecognizer *)sender{
	WASubmissionPhotoGalleryViewController *gallery = [[WASubmissionPhotoGalleryViewController alloc] initWithSubmission:submission andPhotoIndex:sender.view.tag];
	[self.navigationController pushViewController:gallery animated:YES];
	
	
	
}

- (void)submissionUpdated {
	[mainTableView reloadData];
	[self loadPhotoViews];
}

#pragma mark - Utilities

- (void)loadPhotoViews {
	for(UIView *view in photoScrollView.subviews) {
		[view removeFromSuperview]; // TODO: be carefull of scrollbars!
	}
	
    CGRect frame = CGRectMake(8, 4, 98, 98);
	static const CGFloat kPhotoSpacing = 102;
	
    for(int n = 0;n<submission.numberOfSubmissionPhotos;n++){
        WASubmissionPhoto *photo = [submission submissionPhotoAtIndex:n];
        UIView *notmyview = [[UIView alloc] initWithFrame:frame];
        [photoScrollView addSubview:notmyview];
		
        notmyview.backgroundColor=[UIColor whiteColor];
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectInset(notmyview.bounds, 4, 4)];
        [notmyview addSubview:photoView];
        photoView.image = photo.image;
        photoView.contentMode=UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
		[notmyview addGestureRecognizer:tap];
		notmyview.tag = n;
		frame.origin.x += kPhotoSpacing;
        
    }
	addPhotoView.frame = frame;
	[photoScrollView addSubview:addPhotoView];
	
	frame.origin.x += kPhotoSpacing;
	
    photoScrollView.contentSize=CGSizeMake(frame.origin.x +4, frame.size.height);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
		case 0:
			return 1;
		case 1:
			return submission.anonymous?1:2;
		case 2:
			return 1;
		default:
			return 0;
			
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell) {
		if(indexPath.section==0&&indexPath.row==0){
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		}
		else{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
	}
    
    // Configure the cell...
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = @"Description";
			cell.detailTextLabel.text = submission.descriptionText;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Anonymous";
					cell.accessoryView = slider;
					slider.on = submission.anonymous;
					break;
				case 1:
					cell = emailCell;
					emailField.text = submission.email;
					break;
			}
			break;
		case 2:
			cell.textLabel.text = @"Submit";
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			break;
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row ==0){
		WASubmissionDescriptionViewController *controller = [[WASubmissionDescriptionViewController alloc] initWithSubmission:submission];
		[self.navigationController pushViewController: controller animated:YES];
	}
	else if (indexPath.section == 2 && indexPath.row ==0){
		size_t actualSize = 0;
		for(int n=0;n<submission.numberOfSubmissionPhotos;n++) {
			actualSize += [[submission submissionPhotoAtIndex:n] estimatedFileSize:kWASubmissionPhotoSizeActual];
		}
		
		if(actualSize > kSubmissionSizeScaleThreshhold || YES) {
			// TODO: exclude upscalling
			
			size_t smallSize = 0;
			size_t mediumSize = 0;
			size_t largeSize = 0;
			for(int n=0;n<submission.numberOfSubmissionPhotos;n++) {
				smallSize += [[submission submissionPhotoAtIndex:n] estimatedFileSize:kWASubmissionPhotoSizeSmall];
				mediumSize += [[submission submissionPhotoAtIndex:n] estimatedFileSize:kWASubmissionPhotoSizeMedium];
				largeSize += [[submission submissionPhotoAtIndex:n] estimatedFileSize:kWASubmissionPhotoSizeLarge];
			}
			
			
			UIActionSheet *sizeActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"This submission is %@B. You can reduce the submission size by scaling images to one of the sizes below.", @(actualSize).formatSI]
																		 callback:^(NSInteger buttonIndex) {
																			 switch(buttonIndex) {
																				 case 0:
																					 submission.photoScaleSize = kWASubmissionPhotoSizeSmall;
																					 break;
																				 case 1:
																					 submission.photoScaleSize = kWASubmissionPhotoSizeMedium;
																					 break;
																				 case 2:
																					 submission.photoScaleSize = kWASubmissionPhotoSizeLarge;
																					 break;
																				 case 3:
																					 submission.photoScaleSize = kWASubmissionPhotoSizeActual;
																					 break;
																				 default:
																					 return;
																			 }
																			 
																			 WASubmitViewController *controller = [[WASubmitViewController alloc] initWithSubmission:submission];
																			 [self.navigationController pushViewController: controller animated:YES];
																			 [tableView deselectRowAtIndexPath:indexPath animated:YES];
																		 }
																cancelButtonTitle:@"Cancel"
														   destructiveButtonTitle:nil
																otherButtonTitles:[NSString stringWithFormat:@"Small (%@B)", @(smallSize).formatSI],
											  [NSString stringWithFormat:@"Medium (%@B)", @(mediumSize).formatSI],
											  [NSString stringWithFormat:@"Large (%@B)", @(largeSize).formatSI],
											  [NSString stringWithFormat:@"Actual size (%@B)", @(actualSize).formatSI], nil];
			[sizeActionSheet showInView:self.view];
		}
		else {
			WASubmitViewController *controller = [[WASubmitViewController alloc] initWithSubmission:submission];
			[self.navigationController pushViewController: controller animated:YES];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}
	
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	DISABLE_SUBMISSION_UPDATE_NOTIFICATION;
	submission.email = [textField.text stringByReplacingCharactersInRange:range withString:string];
	ENABLE_SUBMISSION_UPDATE_NOTIFICATION;
	return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [WASubmissionPhoto photoWithMediaPickingInfo:info
									 resultBlock:^(WASubmissionPhoto *photo) {
										 [submission addSubmissionPhoto:photo];
										 
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
