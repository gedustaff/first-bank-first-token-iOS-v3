//
//  AddIdentityViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"
#import "EstablishPINViewController.h"
#import "ETIdentityProvider.h"
#import "ETSoftTokenSDK.h"

@interface AddIdentityViewController : UIViewController<UITextFieldDelegate>{
    ETIdentity *identity;
}

@property (nonatomic, retain) ETIdentity *identity;
- (IBAction)validateIdentity:(id)sender;


@end
