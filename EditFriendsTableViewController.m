//
//  EditFriendsTableViewController.m
//  Ribbit
//
//  Created by A658308 on 11/5/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import "EditFriendsTableViewController.h"

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //sets the current user to a property on the controller
    self.currentUser = [PFUser currentUser];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = user.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // instantiates a new cell based on the cell at the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Creates a relation object based on currentUser, essentially adds a join column.
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    // Redefines the clicked user
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    // Adds the user to the new column locally
    [friendsRelation addObject:user];
    // Saves it to the backend
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@ %@", error, [error userInfo]);
        }
    }];
}

@end










