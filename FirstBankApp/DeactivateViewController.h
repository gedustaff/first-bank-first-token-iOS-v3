//
//  DeactivateViewController.h
//  FirstBankApp
//
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKUtils.h"
#import <EntrustIGMobile/ETIdentity.h>

@interface DeactivateViewController : UIViewController<UITextFieldDelegate>{
    NSString *ref, *serial, *userID;
    NSMutableData *responseDataDC;
    NSString *responseCode;
}

@property (nonatomic, strong, readwrite) NSString *ref, *serial, *userID;
@property (nonatomic, strong, readwrite) NSString *responseCode;
@property (nonatomic, retain) NSMutableData *responseDataDC;


@end
