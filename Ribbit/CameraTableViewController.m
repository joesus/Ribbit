//
//  CameraTableViewController.m
//  Ribbit
//
//  Created by A658308 on 11/5/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import "CameraTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>


@interface CameraTableViewController ()

@end

@implementation CameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipients = [[NSMutableArray alloc] init];
    
    // sets user to current user
    PFUser *user = [PFUser currentUser];
    // grabs the friends relation properties of the current user it's a PFRelation
    self.friendsRelation = [user objectForKey:@"friendsRelation"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self presentPickerVC];
    
    // Sets up a query object which is basically just our search term
    PFQuery *query = [self.friendsRelation query];
    // adds to our query
    [query orderByAscending:@"username"];
    
    // Uses query to search the backend
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@ %@", error, [error userInfo]);
        } else {
            // sets it to the array of returned objects
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.friends.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

 // Configure the cell...
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     
     PFUser *user = self.friends[indexPath.row];
     cell.textLabel.text = user.username;
     
     if ([self.recipients containsObject:user.objectId]) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
     } else {
         cell.accessoryType = UITableViewCellAccessoryNone;
     }
     return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = self.friends[indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // saves only the objectId because that's all the parse needs to find the user object
        [self.recipients addObject:user.objectId];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    // a photo was taken or selected
    // First checks if mediaType is null, then casts the kUTTypeImage to NSString and checks if the media type was a photo
    if (mediaType && [mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // TODO - how to find the keys for info?
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // checks if the image was taken with a camera
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    } else {
        // Assumes a video was taken
        self.videoFilePath = [[info objectForKey:UIImagePickerControllerMediaURL] pathExtension];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save video
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    // dismiss the image picker view
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)cancel:(id)sender {
    [self reset];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
    // make sure that a photo or movie is set and send it if it is
    if (self.image == nil && [self.videoFilePath length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again!" message:@"Please capture a photo or video" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self presentPickerVC];
    } else {
        // proceeds with the upload and takes the user to the inbox view
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Helper methods

- (void) presentPickerVC {
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
        // creates new imagepicker controller and sets delegate to self since we imported the delegates in the header file
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        self.imagePicker.allowsEditing = NO;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        self.imagePicker.videoMaximumDuration = 10;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}

- (void) uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    // check if image or video
    if (self.image != nil) {
         // if image shrink
        UIImage *newImage = [self resize:self.image toWidth:320.0 andHeight:480.0];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    // Creates a file object parse can handle
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    // Everything was successful so clear the local data
                    [self reset];
                }
            }];
        }
    }];
}

- (void)reset {
    self.videoFilePath = nil;
    self.image = nil;
    [self.recipients removeAllObjects];
}

- (UIImage *)resize:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    // creates a new size
    CGSize newSize = CGSizeMake(width, height);
    // creates a new rectangle from our new size
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    
    // begins an image context
    UIGraphicsBeginImageContext(newSize);
    // adds our image to that container
    [self.image drawInRect:newRectangle];
    // gets the image back out of the box
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    // ends the image context
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end









