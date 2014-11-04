//
//  InboxTableViewController.m
//  Ribbit
//
//  Created by A658308 on 11/3/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import "InboxTableViewController.h"
#import <Parse/Parse.h>

@interface InboxTableViewController ()

@end

@implementation InboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFUser *currentUser = [PFUser currentUser];
    
    if (!currentUser) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // checks if the segue is the login segue
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        // hides the bottom panel items
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}
@end
