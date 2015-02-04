//
//  ResetPINViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/15/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import "ResetPINViewController.h"
#import "SecurityCodeViewController.h"

@interface ResetPINViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mResetPIN;
@property (weak, nonatomic) IBOutlet UITextField *mResetConfirm;

@end

@implementation ResetPINViewController
@synthesize resetID;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mResetPIN.delegate = self;
    self.mResetConfirm.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetPIN:(id)sender {
    [self.mResetPIN resignFirstResponder];
    [self.mResetConfirm resignFirstResponder];
    
    NSString *pin = self.mResetPIN.text;
    NSString *confirmPin = self.mResetConfirm.text;
    int pinLength = [confirmPin length];
    
    if ([pin isEqualToString:confirmPin] && pinLength == 4) {
        
        if ([SDKUtils deleteLockState] && [SDKUtils deletePIN]) {
            resetID = [SDKUtils loadIdentity];
            [SDKUtils savePIN:confirmPin];
            
            [self performSegueWithIdentifier:@"resetTosec" sender:self];
        }
        else{
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"PIN Creation Error" message:@"Error creating new PIN \n Please contact Administrator" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alertError show];
        }
        
        
    } else {
        if (pinLength < 4) {
            UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"PIN Creation Error " message:@"PIN must be 4 digits long" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [pinAlert show];
        } else if (pin!=confirmPin) {
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
    const int movementDistance = -150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([[segue identifier] isEqualToString:@"resetTosec"]) {
        SecurityCodeViewController *svc = [segue destinationViewController];
        svc.getIdentity = self.resetID;
    }
    
}


@end
