//
//  RegistrationCodeViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"
#import "TripleDES.h"
#import <QuartzCore/QuartzCore.h>

@interface RegistrationCodeViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate>{
    NSString *responseCode, *message;
    NSMutableData *responseData;
    
}

@property (nonatomic, strong, readwrite) NSString *responseCode, *message ;
@property (nonatomic, retain) NSMutableData *responseData;
@end
