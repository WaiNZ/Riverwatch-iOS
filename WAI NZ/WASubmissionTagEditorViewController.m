//
//  WASubmissionTagEditorViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 2/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionTagEditorViewController.h"

@interface WASubmissionTagEditorViewController ()

@end

static NSArray *kAllowedTags;

@implementation WASubmissionTagEditorViewController

+ (void)initialize {
	if(self.class == WASubmissionTagEditorViewController.class) {
		kAllowedTags = @[@"Cow", @"Pollution", @"Runoff",@"Paint",@"Drain",@"Waterway"];
	}
}

#pragma mark - Init/Dealloc

- (id)initWithSubmission:(WASubmission *)_submission {
	self = [self init];
	if(self) {
		submission = _submission;
		self.navigationItem.title = @"Tags";
	}
	return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section==0?kAllowedTags.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const CellIdentifier = @"TagCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	cell.textLabel.text = [kAllowedTags objectAtIndex:indexPath.row];
	cell.accessoryType = [submission containsTag:cell.textLabel.text]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *tag = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
	if([submission containsTag:tag]) {
		[submission removeTag:tag];
	}
	else {
		[submission addTag:tag];
	}
	
	[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
