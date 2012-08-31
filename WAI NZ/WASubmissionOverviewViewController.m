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
    [self updatePhotoText];
    [self updateTimestampText];
    [self updateMapView];
	
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
    mapView = nil;
    cowButton = nil;
    runoffButton = nil;
    pollutionButton = nil;
    photoLabel = nil;
    timestampLabel = nil;
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
	// Update the table
	if(!slider.on){
		[mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else {
		[mainTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	// Make sure we dont end up resursing
	DISABLE_SUBMISSION_UPDATE_NOTIFICATION;
	submission.anonymous = slider.on;
	ENABLE_SUBMISSION_UPDATE_NOTIFICATION;
	[mainTableView endUpdates];
}

- (IBAction)addAdditionalPhoto:(id)sender {
	// Show the action sheet asking about source of the image
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
                                                 otherButtonTitles:@"Take a photo", @"Add an exisiting photo", nil];
    [addSheet showInView:self.view];
}

- (IBAction)photoTapped:(UITapGestureRecognizer *)sender {
	WASubmissionPhotoGalleryViewController *gallery = [[WASubmissionPhotoGalleryViewController alloc] initWithSubmission:submission andPhotoIndex:sender.view.tag];
	[self.navigationController pushViewController:gallery animated:YES];
}

//TODO: BUTTONS SHOULD STAY COLOURED ON PRESS
- (IBAction)cowTagSelected:(id)sender {
    if([submission containsTag:@"cow"]){
        [submission removeTag:@"cow"];
        NSLog(@"cow tag got removed");
    }
    else{
        [submission addTag:@"cow"];
        NSLog(@"cow tag got added");
    }
}

- (IBAction)runoffTagSelected:(id)sender {
    if([submission containsTag:@"runoff"]){
        [submission removeTag:@"runoff"];
        NSLog(@"runoff tag got removed");
        
    }
    else{
        [submission addTag:@"runoff"];
        NSLog(@"runoff tag got added");
    }
}

- (IBAction)pollutionTagSelected:(id)sender {
    if([submission containsTag:@"pollution"]){
        [submission removeTag:@"pollution"];
        NSLog(@"pollution tag got removed");
    }
    else{
        [submission addTag:@"pollution"];
        NSLog(@"pollution tag got added");
    }
}


- (void)submissionUpdated {
	[mainTableView reloadData];
	
	[self loadPhotoViews];
    [self updatePhotoText];
    [self updateTimestampText];
    [self updateMapView];
}

#pragma mark - Utilities

- (void)updatePhotoText {
    NSString *newText;
    if([submission numberOfSubmissionPhotos]>1){
        newText = [NSMutableString stringWithFormat:@"%d photos attached", [submission numberOfSubmissionPhotos]];
    }
    else{
        newText = [NSMutableString stringWithFormat:@"%d photo attached", [submission numberOfSubmissionPhotos]];
    }
    [photoLabel setText:newText];
}

- (void)updateTimestampText {
    NSDateFormatter *formatter;
    NSString *dateString;
    dateString = @"Observed at ";
    formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    [formatter setDateFormat:@"h:mma EEEE MMMM dd"];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:submission.timestamp];
    dateString = [dateString stringByAppendingString:[formatter stringFromDate:newDate]];
    
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"dd"];
    int date_day = [[monthDayFormatter stringFromDate:newDate] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    dateString = [dateString stringByAppendingString:suffix];
    
    dateString = [dateString stringByAppendingString:@" at the following location"];
    
    [timestampLabel setText:dateString];
}

- (void) updateMapView{
//    WAGeolocation *loc = submission.location;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = .01;
    span.longitudeDelta = .01;
    CLLocationCoordinate2D location;
    //location.latitude = loc.latitude;
    location.latitude = -41.3;
    //location.longitude = loc.longitude;
    location.longitude = 174.9;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
    NSLog(@"lat is: %f", mapView.region.center.latitude);
    NSLog(@"long is: %f", mapView.region.center.longitude);
    mapView.centerCoordinate = location;
}

- (void)loadPhotoViews {
	for(UIView *view in photoScrollView.subviews) {
		[view removeFromSuperview]; // TODO: be carefull of scrollbars!
	}
	
    CGRect frame = CGRectMake(8, 4, 98, 98);
	static const CGFloat kPhotoSpacing = 102;
	
    for(int n = 0;n<submission.numberOfSubmissionPhotos;n++) {
        WASubmissionPhoto *photo = [submission submissionPhotoAtIndex:n];
		
		// Create the background view
        UIView *notmyview = [[UIView alloc] initWithFrame:frame];
        [photoScrollView addSubview:notmyview];
        notmyview.backgroundColor = [UIColor whiteColor];
		
		// Create the image view
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectInset(notmyview.bounds, 4, 4)];
        [notmyview addSubview:photoView];
        photoView.image = photo.image;
        photoView.contentMode=UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
		
		// Add a gesture recognizer
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
		[notmyview addGestureRecognizer:tap];
		notmyview.tag = n;
		frame.origin.x += kPhotoSpacing;
    }
	
	// Add the add photo view using the latest rect from the for loop
	addPhotoView.frame = frame;
	[photoScrollView addSubview:addPhotoView];
	
	// Update the content size of the scrollview
	frame.origin.x += kPhotoSpacing;
    photoScrollView.contentSize = CGSizeMake(frame.origin.x +4, frame.size.height);
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
		if(indexPath.section == 0 && indexPath.row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		}
		else {
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
		[self.navigationController pushViewController:controller animated:YES];
	}
	else if(indexPath.section == 2 && indexPath.row == 0) {
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
			
			// TODO: make this much nicer
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
																			 
																			 // Go submit the submission object to the backend
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
