//
//  AddIdentityViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "AddIdentityViewController.h"

NSString *serialNumber;
NSString *activationCode;

#define MAXLENGTH1 10
#define MAXLENGTH2 16

@interface AddIdentityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tvSerNum;
@property (weak, nonatomic) IBOutlet UITextField *tvActNum;
@property (nonatomic, assign) BOOL checkSerial;

@end


@implementation AddIdentityViewController
@synthesize identity;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tvSerNum.delegate = self;
    self.tvActNum.delegate = self;
    UIColor *mycolor = [AddIdentityViewController colorFromHexString:@"#01214C"];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:15.0], NSFontAttributeName, mycolor, NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    //Custom Keyboard
    
    //[super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    if (textField==self.tvSerNum) {
        return newLength <= MAXLENGTH1 || returnKey;
            }else{
        return newLength <= MAXLENGTH2 || returnKey;
    }
    
    
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.tvSerNum) {
        [self animateTextField:textField up:NO];
    }else{
         [self animateTextField:textField up:NO];
    }
    
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



+ (BOOL) checkSerialNumber{
    
    
    BOOL checkSerialNum = NO;
    
    
    @try {
        
        [ETIdentityProvider
         validateSerialNumber:serialNumber];
        checkSerialNum = YES;
    }
    @catch (NSException * e) {
        checkSerialNum = NO;
        UIAlertView *serialAlert = [[UIAlertView alloc] initWithTitle:@"Application Activation Error " message:@"The serial number was entered incorrectly. Check the number and try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [serialAlert show];
    }
    
    return checkSerialNum;
}


+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (BOOL) checkActivationNumber{
    
    BOOL checkAccNum = NO;
    
    
    @try {
        
        [ETIdentityProvider
         validateActivationCode:activationCode];
        checkAccNum = YES;
    }
    @catch (NSException * e) {
        checkAccNum = NO;
        UIAlertView *activationAlert = [[UIAlertView alloc] initWithTitle:@"Application Activation Error " message:@"The activation number was entered incorrectly. Check the number and try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [activationAlert show];
    }
    
    return checkAccNum;
}


- (IBAction)validateIdentity:(id)sender {
    
    serialNumber = self.tvSerNum.text;
    activationCode = self.tvActNum.text;
    NSString *fakeSerial1 = @"9999999999";
    NSString *fakeSerial2 = @"0000000000";
    NSString *fakeAct1 = @"9999999999999995";
    NSString *fakeAct2 = @"0000000000000000";
    [self.tvActNum resignFirstResponder];
    [self.tvSerNum resignFirstResponder];
    
    
    if ([serialNumber isEqualToString :fakeSerial1] || [serialNumber isEqualToString: fakeSerial2] || [serialNumber isEqualToString: fakeAct1] || [serialNumber isEqualToString: fakeAct2] ) {
        UIAlertView *activationAlert = [[UIAlertView alloc] initWithTitle:@"Application Activation Error " message:@"Invalid Serial Number and Activation Number Combination" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [activationAlert show];
        [_tvSerNum setText:@""];
        [_tvActNum setText:@""];
    }else{
    
        // See if the serial number is valid
        
        if ([AddIdentityViewController checkSerialNumber] && [AddIdentityViewController checkActivationNumber]) {
            
            // Both codes are valid at this point. Create
            // a new identity.
            // This identity is not going to be registered for
            // transactions, so pass in nil for the device ID.
            
            identity = [ETIdentityProvider generate:nil
                                       serialNumber:serialNumber
                                     activationCode:activationCode];
            [self performSegueWithIdentifier:@"AddIdToEstablishPin" sender:self];
            
            //NSString *idnum = identity.registrationCode;
            // The registrationCode property of the returned
            
            // identity should be displayed to the user,
            // so the user can complete the soft token activation
            // with Entrust IdentityGuard.
            //return identity;
            
            //[self.lblIdentity setText:idnum];
           
            
            // The identity can be encoded using the NSCoding protocol,
            // or it can be saved by accessing and saving all
            // of the properties individually.
            // Note: an identity may or may not require PIN protection.
            // It is up to the application to implement such protection,sdfsdafdasfdafas // if required. Although not recommended, applications may
            // choose to ignore PIN protection.
            
        }
        
    }
    

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"AddIdToEstablishPin"]) {
        EstablishPINViewController *vc = [segue destinationViewController];
        vc.idPIN = self.identity;
    }
}


@end
