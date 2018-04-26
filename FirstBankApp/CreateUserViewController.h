//
//  CreateUserViewController.h
//  FirstBankApp
//
//  Created by Dapsonco on 17/04/2018.
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"
#import "ETIdentityProvider.h"
#import "ETSoftTokenSDK.h"
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
