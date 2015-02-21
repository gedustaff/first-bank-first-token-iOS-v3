//
//  AppDelegate.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "AddIdentityViewController.h"
#import "PINRequestViewController.h"
#import "SDKUtils.h"
BOOL isRegistered = NO;


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize loadingID, lockStateValue;


+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIColor *color = [AppDelegate colorFromHexString:@"#01214C"];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor = [UIColor whiteColor];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:color,
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont boldSystemFontOfSize:13]
       }
     forState:UIControlStateNormal];
    
    loadingID = [SDKUtils loadIdentity];
    lockStateValue = [SDKUtils fetchLockState];
    if (loadingID == nil) {
        isRegistered = NO;
    }
    else{
        isRegistered = YES;
    }
    
   /*
    NSString *storyboardId = isRegistered ? @"PINRequestViewController" : @"AddIdentityViewController";
    
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];*/
    
    
    if (isRegistered)
    {
        if (lockStateValue==nil) {
            self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"pinReq"];
            return YES;
        } else {
            self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"appBlock"];
            return YES;
        }
        
        
    }
    else
    {
       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"addID"];
        [(UINavigationController*)self.window.rootViewController pushViewController:ivc animated:NO];
        
        return YES;
        

           }
    
    
    
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.window endEditing:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
