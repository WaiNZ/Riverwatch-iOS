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

#import <UIKit/UITableView.h>

static const int kTakePhotoButton = 0;
static const int kUseExistingPhotoButton = 1;

@interface WASubmissionOverviewViewController ()

-(void) addAdditionalPhoto;
@end

@implementation WASubmissionOverviewViewController

- (id)init {
	self = [self initWithNibName:@"WASubmissionOverviewViewController" bundle:nil];
	if(self) {
		// Set up
		self.navigationItem.title = @"Submission";
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	mainTableView.tableHeaderView = topView;
}

- (void)viewDidUnload {
	slider = nil;
	emailField = nil;
	mainTableView = nil;
	emailCell = nil;
	topView = nil;
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
	[mainTableView endUpdates];
}

- (void) addAdditionalPhoto {
    UIActionSheet *addSheet = [[UIActionSheet alloc] initWithTitle:@"Add a photo"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Take a photo", @"Add an exisiting photo",nil ];
    [addSheet showInView:self.view];
    
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
			return slider.on? 1:2;
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
			cell.detailTextLabel.text = @"hi";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Anonymous";
					cell.accessoryView = slider;
					break;
				case 1:
					cell = emailCell;
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
		WASubmissionDescriptionViewController *controller = [[WASubmissionDescriptionViewController alloc] init];
		[self.navigationController pushViewController: controller animated:YES];
	}
	else if (indexPath.section == 2 && indexPath.row ==0){
		WASubmitViewController *controller = [[WASubmitViewController alloc] init];
		[self.navigationController pushViewController: controller animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //0 is the topmost (Take a photo) button
    if(buttonIndex==kTakePhotoButton){
        UIImagePickerController *cameraRollPicker = [[UIImagePickerController alloc] init];
        cameraRollPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraRollPicker.delegate = self;
        [self presentModalViewController: cameraRollPicker animated:YES];
    }
    //1 is the topmost (Use an existing photo) button
    else if(buttonIndex==kUseExistingPhotoButton){
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        // TODO: check if the camera is available
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        photoPicker.delegate = self;
        [self presentModalViewController:photoPicker animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //TODO: Adding the actual photo
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

@end
