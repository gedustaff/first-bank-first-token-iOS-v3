////
////  AppDelegate.m
////  FirstBankApp
////
////  Created by Gedu Technologies on 12/16/14.
////  Copyright (c) 2014 Gedu Technologies. All rights reserved.
////
//
//#import "AppDelegate.h"
//#import "AddIdentityViewController.h"
//#import "PINRequestViewController.h"
//#import "OptionsOnboardingFeature/OptionsOnboardigViewController.h"
//#import "CorporateEnrollmentViewController.h"
//#import "RegistrationCodeViewController.h"
//#import "SDKUtils.h"
//#import "FirstBankApp-Swift.h"
//
//// Import SmileID headers (v11+ uses modules)
//@import SmileID;
//
//BOOL isRegistered = NO;
//
//@interface AppDelegate ()
//@end
//
//@implementation AppDelegate
//@synthesize loadingID, lockStateValue;
//
//+ (UIColor *)colorFromHexString:(NSString *)hexString {
//    unsigned rgbValue = 0;
//    NSScanner *scanner = [NSScanner scannerWithString:hexString];
//    [scanner setScanLocation:1]; // bypass '#' character
//    [scanner scanHexInt:&rgbValue];
//    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
//                           green:((rgbValue & 0xFF00) >> 8)/255.0
//                            blue:(rgbValue & 0xFF)/255.0
//                           alpha:1.0];
//}
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    // --- Existing setup for shadows ---
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
//    shadow.shadowColor = [UIColor whiteColor];
//    
//    // --- Existing logic for determining registration status ---
//    loadingID = [SDKUtils loadIdentity];
//    lockStateValue = [SDKUtils fetchLockState];
//    if (loadingID == nil) {
//        isRegistered = NO;
//    } else {
//        isRegistered = YES;
//    }
//
//    // --- Main window initialization ---
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
//    if (isRegistered) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        if (lockStateValue == nil) {
//            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"pinReq"];
//        } else {
//            RegistrationCodeViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"cardNum"];
//            ivc.codeReuse = @"reset";
//            self.window.rootViewController = ivc;
//        }
//    } else {
//        CorporateEnrollmentViewController *onboardingVC = [[CorporateEnrollmentViewController alloc] initWithNibName:nil bundle:nil];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:onboardingVC];
//        self.window.rootViewController = navigationController;
//    }
//
//    [self.window makeKeyAndVisible];
//    
//    // ✅ SmileID v11.1.0 setup
//    // Use your credentials from SmileID dashboard
//// or SmileIDEnvironmentProduction
//    // Get path of local smile_config.json
//    // --- SmileID v11.1.0 setup ---
//
//
//    return YES;
//}
//
//- (void)applicationWillResignActive:(UIApplication *)application {
//    // Pause ongoing tasks if needed
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [self.window endEditing:YES];
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    // Undo changes made entering background
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart paused tasks
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Save data if appropriate
//}
//
//@end
//


//
//  AppDelegate.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/2025.
//  Copyright (c) 2025 Gedu Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileManager.h" // For checking saved profiles and PIN status
#import "ProfilesViewController.h" // Existing data, launch to profile list
#import "EnterPinViewController.h" // Existing data, launch to PIN request (if PIN is not stored, but Identity is)
#import "CorporateEnrollmentViewController.h" // Initial flow for new users
#import "RegistrationCodeViewController.h"
#import "SDKUtils.h" // Assuming SDKUtils is still needed for loading/fetching
#import "FirstBankApp-Swift.h" // Swift interoperability header

// Import SmileID headers (v11+ uses modules)
@import SmileID;

// Remove global BOOL isRegistered = NO;

@interface AppDelegate ()
// Move color method to a utility or keep it for now, but not ideal in AppDelegate
+ (UIColor *)colorFromHexString:(NSString *)hexString;
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
    // --- Appearance Setup (Moved to a dedicated method) ---
    [self setupGlobalAppearance];

    // --- Main window initialization ---
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // --- 1. Determine Registration and PIN Status using ProfileManager ---
    BOOL profilesExist = [ProfileManager hasSavedProfiles];
    BOOL pinIsSet = [ProfileManager isPinSet];
    
    UIViewController *rootViewController;
    
    // --- 2. Conditional Root View Controller Logic ---
    if (profilesExist) {
        // User has at least one saved token/identity
        NSLog(@"Startup: Profiles found. Checking PIN status.");
        
        // Use PinSetUp/PINRequestVC if the user needs to enter their PIN
        // to unlock the Profiles View, or if a global lock screen is needed.
        if (pinIsSet) {
             // If PIN is set, launch directly to the Profiles list
             // (Assuming PIN check happens on entry to the token generation screen)
             rootViewController = [[ProfilesViewController alloc] init];
        } else {
             // If profiles exist but PIN is NOT set (e.g., initial setup halfway)
             // Navigate to PIN entry/creation screen
             // NOTE: You might use PINRequestViewController here if it's your login screen
//             rootViewController = [[EnterPinViewController alloc] init];
            
            rootViewController = [[ProfilesViewController alloc] init];
        }
    } else {
        // New user or all profiles deleted. Start onboarding flow.
        NSLog(@"Startup: No profiles found. Launching initial enrollment flow.");
        rootViewController = [[CorporateEnrollmentViewController alloc] init];
    }
    
    // Fallback/Legacy logic using SDKUtils (keep only if ProfileManager isn't fully reliable yet)
    // loadingID = [SDKUtils loadIdentity];
    // lockStateValue = [SDKUtils fetchLockState];
    
    // NOTE: If using Storyboard-based VCs, you must instantiate them differently:
    // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"YOUR_STORYBOARD_ID"];


    // Wrap the determined root view controller in a Navigation Controller
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:rootViewController];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    // --- SmileID v11.1.0 setup ---
    // Placeholder for SmileID config if needed later
    /*
    NSString *smileConfigPath = [[NSBundle mainBundle] pathForResource:@"smile_config" ofType:@"json"];
    if (smileConfigPath) {
        NSURL *configURL = [NSURL fileURLWithPath:smileConfigPath];
        [SmileID initializeWithConfig:configURL];
    }
    */
    
    return YES;
}

#pragma mark - Appearance Setup

- (void)setupGlobalAppearance {
    // Set the background color (BarTintColor) for the entire app's navigation bar
    UIColor *primaryColor = [AppDelegate colorFromHexString:@"#003380"]; // Example dark blue
    
    // Use the modern UINavigationBarAppearance
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = primaryColor;

    // Set title text attributes
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    
    // Apply the appearance globally
    [[UINavigationBar appearance] setStandardAppearance:appearance];
    [[UINavigationBar appearance] setScrollEdgeAppearance:appearance];
    
    // Set the tint color (for icons/buttons)
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Clean up the legacy shadow setup from original code
    // NSShadow *shadow = [[NSShadow alloc] init];
    // shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    // shadow.shadowColor = [UIColor whiteColor];
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
