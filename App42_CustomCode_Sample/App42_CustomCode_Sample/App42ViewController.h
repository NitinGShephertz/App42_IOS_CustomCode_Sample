//
//  App42ViewController.h
//  App42_CustomCode_Sample
//
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *responseView;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *responseIndicator;
@property (weak, nonatomic) IBOutlet UILabel *responseTitle;

- (IBAction)registerAction:(id)sender;

@end
