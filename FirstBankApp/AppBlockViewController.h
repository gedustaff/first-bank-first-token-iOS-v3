//
//  AppBlockViewController.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/14/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKUtils.h"
#import "ETIdentity.h"

@interface AppBlockViewController : UIViewController<UITextFieldDelegate>{
    NSString *blockKey;
    NSString *unblockKey;
    ETIdentity *blockRetrievedID;
}
@property (nonatomic, retain) ETIdentity *blockRetrievedID;
@property (nonatomic, strong, readwrite) NSString *blockKey;
@property (nonatomic, strong, readwrite) NSString *unblockKey;

@end
