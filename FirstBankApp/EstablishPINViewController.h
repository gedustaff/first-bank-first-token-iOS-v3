//
//  EstablishPINViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"
#import "ETIdentityProvider.h"
#import "ETSoftTokenSDK.h"
#import "CreateUserViewController.h"
#import "SDKUtils.h"

@interface EstablishPINViewController : UIViewController<UITextFieldDelegate>{
    NSString *otpReference, *userID, *accountNumber;
    NSMutableData *responseDataEP;
    ETIdentity *identity;
    
}
@property (nonatomic, strong, readwrite) NSString *otpReference, *userID, *accountNumber;
@property (nonatomic, retain) NSMutableData *responseDataEP;
@property (nonatomic, retain) ETIdentity *identity;


@end
