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
#import "OptionsOnboardingFeature/OptionsOnboardigViewController.h"
#import "RegistrationCodeViewController.h"
#import "SDKUtils.h"
#import "FirstBankApp-Swift.h"





// Import SmileID headers (v11+ uses modules)
@import SmileID;

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
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // --- Existing setup for shadows ---
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor = [UIColor whiteColor];
    
    // --- Existing logic for determining registration status ---
    loadingID = [SDKUtils loadIdentity];
    lockStateValue = [SDKUtils fetchLockState];
    if (loadingID == nil) {
        isRegistered = NO;
    } else {
        isRegistered = YES;
    }

    // --- Main window initialization ---
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (isRegistered) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (lockStateValue == nil) {
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"pinReq"];
        } else {
            RegistrationCodeViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"cardNum"];
            ivc.codeReuse = @"reset";
            self.window.rootViewController = ivc;
        }
    } else {
        OptionsOnboardigViewController *onboardingVC = [[OptionsOnboardigViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:onboardingVC];
        self.window.rootViewController = navigationController;
    }

    [self.window makeKeyAndVisible];
    
    // ✅ SmileID v11.1.0 setup
    // Use your credentials from SmileID dashboard
// or SmileIDEnvironmentProduction
    // Get path of local smile_config.json
    // --- SmileID v11.1.0 setup ---
    [SmileIDInitializer initializeSmileID];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Pause ongoing tasks if needed
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.window endEditing:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Undo changes made entering background
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart paused tasks
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}

@end

