//
//  AddIdentityViewController.h
//  FirstBankApp
//
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EntrustIGMobile/ETIdentity.h>
#import "EstablishPINViewController.h"
#import <EntrustIGMobile/ETIdentityProvider.h>
#import <EntrustIGMobile/ETSoftTokenSDK.h>

@interface AddIdentityViewController : UIViewController<UITextFieldDelegate>{
    ETIdentity *identity;
}

@property (nonatomic, retain) ETIdentity *identity;


@end
