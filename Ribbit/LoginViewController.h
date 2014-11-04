//
//  LoginViewController.h
//  Ribbit
//
//  Created by A658308 on 11/3/14.
//  Copyright (c) 2014 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)login:(id)sender;

@end
