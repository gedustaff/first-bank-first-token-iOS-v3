//
//  AppDelegate.h
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETIdentity.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    ETIdentity *loadingID;
    NSString *lockStateValue;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readwrite) ETIdentity *loadingID;
@property (nonatomic, strong, readwrite) NSString *lockStateValue;





@end

