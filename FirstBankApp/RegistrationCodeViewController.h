//
//  RegistrationCodeViewController.h
//  FirstBankApp

//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EntrustIGMobile/ETIdentity.h>
#import "TripleDES.h"
#import "ResetPINViewController.h"
#import "DeactivateViewController.h"
#import "NSData+Base64.h"
#import <QuartzCore/QuartzCore.h>

@interface RegistrationCodeViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate>{
    NSString *responseCode, *message;
    NSMutableData *responseData;
    NSString *codeReuse;
    
}

@property (nonatomic, strong, readwrite) NSString *responseCode, *message, *codeReuse;
@property (nonatomic, retain) NSMutableData *responseData;
@end
