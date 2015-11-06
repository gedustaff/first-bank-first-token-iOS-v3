//
//  RegistrationCodeViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "RegistrationCodeViewController.h"
#import "ETIdentityProvider.h"
#import "EstablishPINViewController.h"
#import "SDKUtils.h"
#import "SecurityCodeViewController.h"

@interface RegistrationCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tvRegDisplay;

@end

@implementation RegistrationCodeViewController
@synthesize strIdentity, strPIN;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    NSString *regCode = strIdentity.registrationCode;
    self.title = @"Registration Code";
    UIColor *mycolor = [RegistrationCodeViewController colorFromHexString:@"#01214C"];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:15.0], NSFontAttributeName, mycolor, NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    
    _tvRegDisplay.numberOfLines = 1;
    //_tvRegDisplay.minimumFontSize = 8;
    _tvRegDisplay.minimumScaleFactor = 10./_tvRegDisplay.font.pointSize;
    _tvRegDisplay.adjustsFontSizeToFitWidth = YES;
    
    
    
    [_tvRegDisplay setText: regCode];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitReg:(id)sender {
    //Get the values of the identity and PIN and protect or encrypted both of them before displaying the OTP.
    
    UIAlertView *activationAlert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Have you used this registration code yet? It will not be displayed again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [activationAlert show];
}
    - (void) alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex
    {
        if (buttonIndex==1) {
            
            BOOL saveID = [SDKUtils saveIdentity:strIdentity];
            BOOL savePIN =[SDKUtils savePIN:strPIN];
            if (saveID && savePIN) {
                
                [self performSegueWithIdentifier:@"regToSec" sender:self];
                //[self.navigationController popViewControllerAnimated:YES];
            }
            else{
                UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"Application Activation Error" message:@"Sorry this application cannot be activated. Please contact your administrator" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [pinAlert show];
            }
            
            
        }
    }

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"regToSec"]) {
        SecurityCodeViewController *vcSec = [segue destinationViewController];
        vcSec.getIdentity = self.strIdentity;
    }
}

@end
