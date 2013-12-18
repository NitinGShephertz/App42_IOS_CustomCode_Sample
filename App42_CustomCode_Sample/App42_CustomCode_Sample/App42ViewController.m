//
//  App42ViewController.m
//  App42_CustomCode_Sample
//
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import "App42ViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>

#define API_KEY     @"e4bec93d487515a9050f83afe472fb9e4add95e9e5a03a24a37f02f9afd67f40"
#define SECRET_KEY  @"b770ec6f46e878522ec3664fe914ff9e4d400c834ac144fd2373c9ebd71df7f6"

@interface App42ViewController ()

@end

@implementation App42ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    NSString *_messageStr = nil;
    BOOL _canRegister = FALSE;
    NSInteger _nameLength    = [[_nameTextField text] length];
    NSInteger _emailLength   = [[_emailTextField text] length];
    NSInteger _passLength    = [[_passwordTextField text] length];

    if (!_nameLength && !_emailLength && !_passLength) {
        _messageStr = @"Looks like few filed are empty,All fields are mandate, Please enter data";
    } else if (!_nameLength) {
        _messageStr = @"User Name is mandate, Please enter username";
    } else if (!_emailLength) {
        _messageStr = @"Email is mandate, Please enter emailId";
    } else if (!_passLength) {
        _messageStr = @"Password is mandate, Please enter password";
    } else {
        BOOL _validEmail = [self isValidEmail:[_emailTextField text]];
        if (_validEmail) {
            _canRegister = TRUE;
        } else {
            _messageStr = @"Invalid Email,Please enter valid emailId";
        }
    }
    
    if (_canRegister) {
        [_nameTextField resignFirstResponder];
        [_emailTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];
        [_responseView setHidden:NO];
        
        [self registerUser];

    } else {
        [_responseView setHidden:YES];
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:_messageStr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [_alert show];
        _alert = nil;
    }
    
}

/*! Resistering For User*/
- (void) registerUser {
    NSString *_name    = [_nameTextField text];
    NSString *_email   = [_emailTextField text];
    NSString *_pass    = [_passwordTextField text];
    
    [App42API initializeWithAPIKey:API_KEY andSecretKey:SECRET_KEY];
    CustomCodeService *_service = [App42API buildCustomCodeService];
    
    /*! Creating Request Body*/
    NSDictionary *_requestBody = [NSDictionary dictionaryWithObjectsAndKeys:API_KEY,@"apiKey",
                                  SECRET_KEY,@"secretKey",
                                  @"CustomCodeTestSample",@"moduleName",
                                  _name,@"userName",
                                  _pass,@"password",
                                  _email,@"emailId",nil];
    
    App42Response *_response = [_service runJavaCode:@"CustomCodeTestSample" requestBody:_requestBody];
    NSLog(@"[_response strResponse] = %@",[_response strResponse]);
    [_responseTextView setText:[_response strResponse]];
}

-(BOOL) isValidEmail:(NSString *)_aCheckString {
    NSString *_aRegString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,6}";
    NSPredicate *_aTestString = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _aRegString];
    return [_aTestString evaluateWithObject:_aCheckString];
}



@end
