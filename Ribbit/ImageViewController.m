//
//  ImageViewController.m
//  Ribbit
//
//  Created by A658308 on 11/7/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // grabs the file property of our message
    PFFile *imageFile = self.message[@"file"];
    // grabs the data from the file with a helper method
    NSData *imageData = [imageFile getData];
    // sets the image
    self.imageView.image = [UIImage imageWithData:imageData];
    
    NSString *senderName = self.message[@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    } else {
        NSLog(@"selector missing");
    }
}

#pragma mark - Helper methods

- (void)timeout {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
