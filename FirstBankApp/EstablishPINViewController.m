//
//  EstablishPINViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "EstablishPINViewController.h"
#import "RegistrationCodeViewController.h"


@interface EstablishPINViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mPin;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPin;

@end

@implementation EstablishPINViewController
@synthesize pinValue, idPIN;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(submitPIN:)];
    // Do any additional setup after loading the view.
    self.mPin.delegate = self;
    self.mConfirmPin.delegate = self;
    self.mPin.borderStyle = UITextBorderStyleRoundedRect;
    self.mConfirmPin.borderStyle = UITextBorderStyleRoundedRect;
    self.title = @"PIN Registration";
    UIColor *mycolor = [EstablishPINViewController colorFromHexString:@"#01214C"];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:15.0], NSFontAttributeName, mycolor, NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    
    
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitPIN:(id)sender {
    [self.mPin resignFirstResponder];
    [self.mConfirmPin resignFirstResponder];
    NSString *pin = self.mPin.text;
    NSString *confirmPin = self.mConfirmPin.text;
    int pinLength = [confirmPin length];
    
    if ([pin isEqualToString:confirmPin] && pinLength == 4) {
        pinValue = confirmPin;
        [self performSegueWithIdentifier:@"PINtoRegCode" sender:self];
    } else {
        if (pinLength < 4) {
            UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"PIN Creation Error " message:@"PIN must be 4 digits long" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [pinAlert show];
        } else {
            UIAlertView *pinAlert2 = [[UIAlertView alloc] initWithTitle:@"PIN Creation Error " message:@"Error creating PIN, Please make sure that the PIN values are equal" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [pinAlert2 show];
        }
    }
    
}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 4 || returnKey;
    }

-(BOOL)textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    [self resignFirstResponder];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -170; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
    
    if ([[segue identifier] isEqualToString:@"PINtoRegCode"]) {
        RegistrationCodeViewController *vcReg = [segue destinationViewController];
        vcReg.strIdentity = self.idPIN;
        vcReg.strPIN = self.pinValue;
    }
}


@end
