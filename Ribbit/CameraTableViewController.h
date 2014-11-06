//
//  CameraTableViewController.h
//  Ribbit
//
//  Created by A658308 on 11/5/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraTableViewController : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *videoFilePath;
@end
