//
//  CameraTableViewController.m
//  Ribbit
//
//  Created by A658308 on 11/5/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import "CameraTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraTableViewController ()

@end

@implementation CameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self presentPickerVC];
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


#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // a photo was taken or selected
    // casts the kUTTypeImage to NSString and checks if the media type was a photo
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
