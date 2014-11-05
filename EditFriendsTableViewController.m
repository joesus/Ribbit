//
//  EditFriendsTableViewController.m
//  Ribbit
//
//  Created by A658308 on 11/5/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import "EditFriendsTableViewController.h"
#import <Parse/Parse.h>

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // queries all users by default
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@ %@", error, [error userInfo]);
        } else {
            self.allUsers = objects;
            NSLog(@"%@", objects);
            // Reloads the data in the tableview when the call completes.
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = user.username;
    
    return cell;
}

@end
