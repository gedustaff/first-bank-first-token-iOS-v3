//
//  EstablishPINViewController.h
//  FirstBankApp
//
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EntrustIGMobile/ETIdentity.h>
#import <EntrustIGMobile/ETIdentityProvider.h>
#import <EntrustIGMobile/ETSoftTokenSDK.h>
#import "CreateUserViewController.h"
#import "SDKUtils.h"

@interface EstablishPINViewController : UIViewController<UITextFieldDelegate>{
    NSString *otpReference, *userID, *accountNumber, *phoneNumber;
    NSMutableData *responseDataEP;
    ETIdentity *identity;
    
}
@property (nonatomic, strong, readwrite) NSString *otpReference, *userID, *phoneNumber, *accountNumber;
@property (nonatomic, retain) NSMutableData *responseDataEP;
@property (nonatomic, retain) ETIdentity *identity;


@end
