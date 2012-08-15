//
//  WASubmissionOverviewViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 15/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WASubmissionOverviewViewController : UITableViewController <UITextFieldDelegate>
{
	
	__unsafe_unretained IBOutlet UITableView *mainTableView;
	IBOutlet UITableViewCell *emailCell;
	IBOutlet UITextField *emailField;
	IBOutlet UISwitch *slider;
}
@end
