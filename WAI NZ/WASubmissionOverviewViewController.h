//
//  WASubmissionOverviewViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 15/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class WASubmission;

/**
 This controller displays the overview of a submission, and must be initilized
 using the -initWithSubmission: constructor.
 
 The kinds of data this controller displays about a submission are:
 
 - The photos
 - The location the event was noted at
 - The time the submission was made
 - A description of the submission
 - The tags on this submission
 - Which email address should be used to send to the council
 - Whether this email address should be submitted to the council if specified
 
 Of these the all but the time the submission was made can be edited by the
 user.
 */
@interface WASubmissionOverviewViewController : UITableViewController <UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,MKMapViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate> {
	__unsafe_unretained IBOutlet UITableView *mainTableView;
	IBOutlet UITableViewCell *emailCell;
	IBOutlet UITextField *emailField;
	IBOutlet UISwitch *slider;
	IBOutlet UIView *topView;
	WASubmission *submission;
    __unsafe_unretained IBOutlet UIScrollView *photoScrollView;
	IBOutlet UIView *addPhotoView;
    IBOutlet MKMapView *mapView;   
    __unsafe_unretained IBOutlet UILabel *photoLabel;
    __unsafe_unretained IBOutlet UILabel *timestampLabel;
	__unsafe_unretained IBOutlet UIView *mapContainerView;
	__unsafe_unretained IBOutlet UIView *mapTapInterceptor;
	IBOutlet UIView *shadeView;
	__unsafe_unretained IBOutlet UIView *shadeViewTop;
	UIStatusBarStyle oldStatusBarStyle;
	__unsafe_unretained IBOutlet UIView *mapSidePanel;
	__unsafe_unretained IBOutlet UIView *mapPleaseSpecifyView;
	BOOL editingMap;
    
    CLLocationManager *locationManager;

    IBOutlet UIButton *pinButton;
}

/**
 This interprets the pressing action on the pin in the map view so the user can move the pin to the desired location
 
 @param sender the gesture recogniser associated with the action
 */
- (IBAction)pinButtonPressed:(id)sender;

/**
 Initilize a WASubmissionOverviewViewController with the specified submission
 
 @param _submission the submission to display in this controller
 */
- (id)initWithSubmission:(WASubmission *)_submission;


@end
