//
//  PINRequestViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/8/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKUtils.h"
#import "ETIdentity.h"

@interface PINRequestViewController : UIViewController<UITextFieldDelegate>{
    ETIdentity *retrievedID;
    NSString *retrievedPIN;
}

@property (nonatomic, retain) ETIdentity *retrievedID;
@property (nonatomic, strong, readwrite) NSString *retrievedPIN;;

@end
