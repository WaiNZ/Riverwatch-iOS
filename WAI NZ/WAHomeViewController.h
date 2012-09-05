//
//  WAHomeViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The home controller for the WAI NZ application. This controller is the first screen presented to the user.
 */
@interface WAHomeViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
	__unsafe_unretained IBOutlet UITableView *mainTableView;
	IBOutlet UIView *headerView;
	IBOutlet UIView *footerView;
}

@end
