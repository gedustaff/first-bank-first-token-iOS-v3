//
//  AppBlockViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/14/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import "AppBlockViewController.h"
#import "ResetPINViewController.h"
CAKeyframeAnimation *anim;
NSString *retreivedPIN;
NSInteger timerems = 2;

@interface AppBlockViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPIN;
@property (weak, nonatomic) IBOutlet UITextField *confirmPIN;
@property (weak, nonatomic) IBOutlet UITextField *freshPIN;



@end

@implementation AppBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    timerems =2;
    UIColor *color = [UIColor whiteColor];
    
    // Set Placeholder Colour as White
    _oldPIN.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter Old PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    _confirmPIN.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter New PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    _freshPIN.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Confirm New PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    //Set Border Colour as Gold colour
    
    _oldPIN.layer.masksToBounds=YES;
    _oldPIN.layer.borderColor = [[AppBlockViewController colorFromHexString:@"#eaab00"] CGColor];
    _oldPIN.layer.borderWidth= 2.0f;
    
    _confirmPIN.layer.masksToBounds=YES;
    _confirmPIN.layer.borderColor = [[AppBlockViewController colorFromHexString:@"#eaab00"] CGColor];
    _confirmPIN.layer.borderWidth= 2.0f;
    
    _freshPIN.layer.masksToBounds=YES;
    _freshPIN.layer.borderColor = [[AppBlockViewController colorFromHexString:@"#eaab00"] CGColor];
    _freshPIN.layer.borderWidth= 2.0f;
    
    //Fetch Identity Value
    retreivedPIN = [SDKUtils retrievePIN];
    
    
    
}
- (IBAction)submitChangePIN:(id)sender {
    
    NSString *old_pin = _oldPIN.text;
    NSString *new_pin = _freshPIN.text;
    NSString *confirm_pin = _confirmPIN.text;
    if([_oldPIN hasText]&&[_confirmPIN hasText]&&[_freshPIN hasText]&& old_pin.length==4&&new_pin.length==4&& confirm_pin.length==4 && [new_pin isEqualToString:confirm_pin] && [old_pin isEqualToString:retreivedPIN]){
        
        if([SDKUtils deletePIN]){
            [SDKUtils savePIN:new_pin];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"FirstToken"
                                         message:@"PIN change successful"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Okay"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            [self performSegueWithIdentifier:@"changeTorequest" sender:self];
                                        }];
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else{
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"PIN Creation Error"
                                         message:@"Error creating new PIN \n Please contact the nearest branch"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Okay"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                           
                                        }];
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }else if(![_oldPIN hasText]){
        [ _oldPIN.layer addAnimation:anim forKey:nil ];
    }else if (![_freshPIN hasText]){
        [ _freshPIN.layer addAnimation:anim forKey:nil ];
    }else if (![_confirmPIN hasText]){
        [ _confirmPIN.layer addAnimation:anim forKey:nil ];
    }else if(![new_pin isEqualToString:confirm_pin]){
        [ _freshPIN.layer addAnimation:anim forKey:nil ];
        [ _confirmPIN.layer addAnimation:anim forKey:nil ];
        _freshPIN.text = @"";
        _confirmPIN.text = @"";
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"PIN Creation Error"
                                     message:@"PIN values do not match. Please verify and try again"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (![old_pin isEqualToString:retreivedPIN]){
        [ _oldPIN.layer addAnimation:anim forKey:nil ];
        _freshPIN.text = @"";
        _confirmPIN.text = @"";
        _oldPIN.text = @"";
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"PIN Creation Error"
                                     message:@"Wrong PIN value. \n If you have forgotten your PIN, please use the PIN Reset option"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        timerems--;
                                        if(timerems==0){
                                            [self performSegueWithIdentifier:@"changeTorequest" sender:self];
                                        }
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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
    
    return newLength <= 4 || returnKey;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

/**
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"resetTosec"]) {
        ResetPINViewController *rpvc = [segue destinationViewController];
        rpvc.resetID = self.blockRetrievedID;
    }
}
**/

@end
