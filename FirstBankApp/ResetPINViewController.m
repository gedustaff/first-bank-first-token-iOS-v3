//
//  ResetPINViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/15/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import "ResetPINViewController.h"
#import "SecurityCodeViewController.h"
NSURLConnection *connResetValidateOTP;
NSMutableURLRequest *requestResetVerify;
NSString *otp, *resetReference;
NSString *pin;
UIAlertController * alertIncorrected;

@interface ResetPINViewController ()
@property (weak, nonatomic) IBOutlet UITextField *otpValue;
@property (weak, nonatomic) IBOutlet UITextField *pinOne;
@property (weak, nonatomic) IBOutlet UITextField *pinTwo;

@end

@implementation ResetPINViewController
@synthesize resetID, ref, responseDataRP;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    responseDataRP = [NSMutableData new];
    self.otpValue.delegate = self;
    self.pinOne.delegate = self;
    self.pinTwo.delegate = self;
    resetReference = ref;
    UIColor *color = [UIColor whiteColor];
    
    // Set Placeholder Colour as White
    _otpValue.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter OTP"
     attributes:@{NSForegroundColorAttributeName:color}];
    _pinOne.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter New PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    _pinTwo.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Confirm New PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    //Set Border Colour as Gold colour
    
    _otpValue.layer.masksToBounds=YES;
    _otpValue.layer.borderColor = [[ResetPINViewController colorFromHexString:@"#eaab00"] CGColor];
    _otpValue.layer.borderWidth= 2.0f;
    
    _pinOne.layer.masksToBounds=YES;
    _pinOne.layer.borderColor = [[ResetPINViewController colorFromHexString:@"#eaab00"] CGColor];
    _pinOne.layer.borderWidth= 2.0f;
    
    _pinTwo.layer.masksToBounds=YES;
    _pinTwo.layer.borderColor = [[ResetPINViewController colorFromHexString:@"#eaab00"] CGColor];
    _pinTwo.layer.borderWidth= 2.0f;
    
    // Do any additional setup after loading the view.
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (IBAction)submitReset:(id)sender {
    
    [self.otpValue resignFirstResponder];
    [self.pinOne resignFirstResponder];
    [self.pinTwo resignFirstResponder];
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    otp = self.otpValue.text;
    pin = self.pinOne.text;
    NSString *confirmPin = self.pinTwo.text;
    NSUInteger pinLength = [confirmPin length];
    
    if ([pin isEqualToString:confirmPin] && pinLength == 4 && otp.length==6) {
        alertIncorrected = [UIAlertController
                            alertControllerWithTitle:@"FirstToken Alert"
                            message:@"Unlocking App..."
                            preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertIncorrected animated:YES completion:nil];
        [ResetPINViewController validateOTP];
        connResetValidateOTP = [[NSURLConnection alloc] initWithRequest:requestResetVerify delegate:self];
        
    }else if(![_otpValue hasText]){
        [ _otpValue.layer addAnimation:anim forKey:nil ];
    }else if (![_pinOne hasText]){
        [ _pinOne.layer addAnimation:anim forKey:nil ];
    }else if (![_pinTwo hasText]){
        [ _pinTwo.layer addAnimation:anim forKey:nil ];
    } else {
        [self showAlertWithTitle:@"Incorrect Input" message:@"Please verify and try again"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetPIN:(id)sender {
   
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseDataRP setLength:0];
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    
    [responseDataRP appendData: data];
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    alertIncorrected.title = @"Activation Error";
    alertIncorrected.message = @"Please check your internet connection and try again";
    
    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                         actionWithTitle:@"Close"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
    [alertIncorrected addAction:yesIncorrectButton];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *responseText = [[NSString alloc] initWithData:responseDataRP encoding:NSUTF8StringEncoding];
    //Parse Response
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([json objectForKey:@"OTPReferenceNumber"]){
        NSString *responseCode = [json valueForKey:@"ResponseCode"];
        if ([responseCode isEqualToString:@"000"]){
            if([SDKUtils deletePIN]){
                [SDKUtils savePIN:pin];
                [self dismissAlertAndPerformSegue:@"resetTosec"];
            }
        }else{
            [self showAlertWithTitle:@"Error Validating OTP" message:@"Please try again"];
        }
    }else{
        [self dismissAlertIfNeeded];
        [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
    }
    
}


-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -70; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

+ (void) validateOTP {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&one=%@&ref=%@",@"2",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", otp,resetReference ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestResetVerify = [[NSMutableURLRequest alloc] init];
    
    //Set URL
  
    [requestResetVerify setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/validateOTP.php"]];
    
    //set HTTP Method
    [requestResetVerify setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestResetVerify setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestResetVerify setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestResetVerify setHTTPBody:postData];
    
}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == _otpValue){
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 6 || returnKey;
    }else{
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 4 || returnKey;
    }
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

- (void)dismissAlertIfNeeded {
    if (alertIncorrected) {
        [alertIncorrected dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self dismissAlertIfNeeded];
    alertIncorrected = [UIAlertController alertControllerWithTitle:title
                                                            message:message
                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertIncorrected addAction:okAction];
    [self presentViewController:alertIncorrected animated:YES completion:nil];
}


- (void)dismissAlertAndPerformSegue:(NSString *)segueIdentifier {
    [self dismissAlertIfNeeded];
    [self performSegueWithIdentifier:segueIdentifier sender:self];
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
