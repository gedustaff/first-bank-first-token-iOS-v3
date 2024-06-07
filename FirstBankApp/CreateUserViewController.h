//
//  CreateUserViewController.h
//  FirstBankApp
//
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EntrustIGMobile/ETIdentity.h>
#import <EntrustIGMobile/ETIdentityProvider.h>
#import <EntrustIGMobile/ETSoftTokenSDK.h>
#import "SDKUtils.h"

@interface CreateUserViewController : UIViewController<UITextFieldDelegate>{
    NSString *userIDCode, *accountNumberCreate, *pin;
    NSMutableData *responseDataCU;
    ETIdentity *identityCreate;
}
@property (nonatomic, strong, readwrite) NSString *userIDCode, *accountNumberCreate, *pin;
@property (nonatomic, retain) NSMutableData *responseDataCU;
@property (nonatomic, retain) ETIdentity *identityCreate;
@end
