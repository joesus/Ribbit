//
//  ImageViewController.h
//  Ribbit
//
//  Created by A658308 on 11/7/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (strong, nonatomic) PFObject *message;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
