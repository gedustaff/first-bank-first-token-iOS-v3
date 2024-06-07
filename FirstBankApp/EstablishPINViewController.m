//
//  EstablishPINViewController.m
//  FirstBankApp
//
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "EstablishPINViewController.h"
#import "RegistrationCodeViewController.h"

BOOL isCreated = NO;
BOOL activeIssue = NO;
NSString *submittedOTP, *submitPIN, *submitConfirm, *ref, *responseCode, *userIdentity, *account, *serial, *activation, *registration, *establishSerialNumber, *pinCode, *activationCode, *phone;
NSURLConnection *connValidateOTP, *connCheckUser, *connIssuance, *connActive, *connSerial, *connConsent, *connActivate;
NSMutableURLRequest *requestVerify, *requestUser, *requestIssuance, *requestActive, *requestSerial, *requestConsent, *requestActivate;
UIAlertController * alertIncorrect;
@interface EstablishPINViewController ()

@property (weak, nonatomic) IBOutlet UITextField *enteredOTP;
@property (weak, nonatomic) IBOutlet UITextField *pinValue;
@property (weak, nonatomic) IBOutlet UITextField *pinConfirm;


@end

@implementation EstablishPINViewController
@synthesize otpReference, responseDataEP, userID, phoneNumber, accountNumber, identity;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    responseDataEP = [NSMutableData new];
    activeIssue = NO;
    UIColor *color = [UIColor whiteColor];
    _enteredOTP.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter your OTP"
     attributes:@{NSForegroundColorAttributeName:color}];
    ref = otpReference;
    userIdentity = userID;
    account = accountNumber;
    phone = phoneNumber;
    
    _pinValue.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Select your token PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    _pinConfirm.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Confirm your token PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    
   
    
    
    _pinValue.layer.masksToBounds=YES;
    _pinValue.layer.borderColor = [[EstablishPINViewController colorFromHexString:@"#eaab00"] CGColor];
    _pinValue.layer.borderWidth= 2.0f;
    
    _enteredOTP.layer.masksToBounds=YES;
    _enteredOTP.layer.borderColor = [[EstablishPINViewController colorFromHexString:@"#eaab00"] CGColor];
    _enteredOTP.layer.borderWidth= 2.0f;
    
    _pinConfirm.layer.masksToBounds=YES;
    _pinConfirm.layer.borderColor = [[EstablishPINViewController colorFromHexString:@"#eaab00"] CGColor];
    _pinConfirm.layer.borderWidth= 2.0f;
    
    
    // Do any additional setup after loading the view.
    self.pinValue.delegate = self;
    self.pinConfirm.delegate = self;
    self.enteredOTP.delegate = self;
    
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (IBAction)submitPin:(id)sender {
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    [self.pinValue resignFirstResponder];
    [self.pinConfirm resignFirstResponder];
    [self.enteredOTP resignFirstResponder];
    
    submittedOTP = self.enteredOTP.text;
    submitPIN = self.pinValue.text;
    submitConfirm = self.pinConfirm.text;
    
    if(submittedOTP.length==6 && submitPIN.length==4 && submitConfirm.length==4 && [submitPIN isEqualToString: submitConfirm]){
        
        //Carry out OTP verification
        
        alertIncorrect = [UIAlertController
                             alertControllerWithTitle:@"Activating App"
                             message:@"Validating OTP..."
                             preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertIncorrect animated:YES completion:nil];
        
      //  [EstablishPINViewController checkUser];
      //  connCheckUser = [[NSURLConnection alloc] initWithRequest:requestUser delegate:self];
        
        [EstablishPINViewController validateOTP];
        
        connValidateOTP = [[NSURLConnection alloc] initWithRequest:requestVerify delegate:self];
        
    }else {
        [self handleInvalidInputWithAnimation:anim];
    }

    
}

-(void)handleInvalidInputWithAnimation: (CAKeyframeAnimation *)anim {
    if(![_pinValue hasText]){
       [ _pinValue.layer addAnimation:anim forKey:nil ];
   }else if (![_pinConfirm hasText]){
       [ _pinConfirm.layer addAnimation:anim forKey:nil ];
   }else if (![_enteredOTP hasText]){
       [ _enteredOTP.layer addAnimation:anim forKey:nil ];
   }else{
       UIAlertController * alert = [UIAlertController
                                    alertControllerWithTitle:@"Incorrect Input"
                                    message:@"Please verify and try again"
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
}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseDataEP setLength:0];
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    
    [responseDataEP appendData: data];
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [self showAlertWithTitle:@"Activation Error" message:@"Please check your internet connection and try again"];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == connValidateOTP) {
        [self handleValidateOTPResponse];
    } else if (connection == connCheckUser) {
        [self handleCheckUserResponse];
    } else if (connection == connIssuance) {
        [self handleIssuanceResponse];
    } else if (connection == connActive) {
        [self handleActiveTokenResponse];
    } else if (connection == connSerial) {
        [self handleSerialResponse];
    } else if (connection == connConsent) {
        [self handleConsentResponse];
    } else if (connection == connActivate) {
        [self handleActivateResponse];
    } else {
        NSLog(@"Critical Application Error");
    }
}

- (void)handleValidateOTPResponse {
    NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if ([json objectForKey:@"OTPReferenceNumber"]) {
        responseCode = [json valueForKey:@"ResponseCode"];

        if ([responseCode isEqualToString:@"000"]) {
            alertIncorrect.message = @"Verifying User Details...";
            [EstablishPINViewController checkUser];
            connCheckUser = [[NSURLConnection alloc] initWithRequest:requestUser delegate:self];
        } else {
            [self showAlertWithTitle:@"Error validating OTP" message:@"Please try again"];
        }
    } else {
        [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
    }
}

- (void)handleCheckUserResponse {
    NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if ([json objectForKey:@"ResponseCode"]) {
        responseCode = [json valueForKey:@"ResponseCode"];

        if ([responseCode isEqualToString:@"000"]) {
            alertIncorrect.message = @"Validating Status...";
            [EstablishPINViewController checkIssuance];
            connIssuance = [[NSURLConnection alloc] initWithRequest:requestIssuance delegate:self];
        } else if ([responseCode isEqualToString:@"1001"]) {
            pinCode = submitPIN;
            [self performSegueWithIdentifier:@"otpTocreate" sender:self];
        } else {
            [self showAlertWithTitle:@"Error checking user state" message:@"Please try again"];
        }
    } else {
        [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
    }
}

- (void)handleIssuanceResponse {
    NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if ([json objectForKey:@"Status"]) {
        BOOL statusRetrieved = [[json valueForKey:@"Status"] boolValue];
        if (statusRetrieved) {
            alertIncorrect.message = @"Activating token...";
            [EstablishPINViewController getSerial];
            connSerial = [[NSURLConnection alloc] initWithRequest:requestSerial delegate:self];
        } else {
            alertIncorrect.message = @"Validating token...";
            [EstablishPINViewController checkActiveToken];
            connActive = [[NSURLConnection alloc] initWithRequest:requestActive delegate:self];
        }
    } else {
        [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
    }
}

- (void)handleActiveTokenResponse {
    NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if ([json objectForKey:@"Status"]) {
        BOOL statusRetrieved = [[json valueForKey:@"Status"] boolValue];

        if (statusRetrieved) {
            alertIncorrect.message = @"Please note that existing token will be deactivated";
            [self showAlertForActiveToken];
        } else {
            alertIncorrect.message = @"Activating token...";
            [EstablishPINViewController getSerial];
            connSerial = [[NSURLConnection alloc] initWithRequest:requestSerial delegate:self];
        }
    } else {
        [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
    }
}

- (void)handleSerialResponse {
    NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if ([json objectForKey:@"Message"]) {
        NSString *messageReceived = [json valueForKey:@"Message"];

        if ([messageReceived isEqualToString:@"SUCCESS"]) {
            establishSerialNumber = [json valueForKey:@"SerialNumber"];
            activationCode = [json valueForKey:@"ActivationCode"];
            identity = [ETIdentityProvider generate:nil serialNumber:establishSerialNumber activationCode:activationCode];

            registration = identity.registrationCode;

            BOOL checkSave = [SDKUtils saveIdentity:identity];

            if (checkSave) {
                alertIncorrect.message = @"Completing Activation";
                [EstablishPINViewController sendConsent];
                connConsent = [[NSURLConnection alloc] initWithRequest:requestConsent delegate:self];

                [EstablishPINViewController activateSoftToken];
                connActivate = [[NSURLConnection alloc] initWithRequest:requestActivate delegate:self];
            } else {
                [self showAlertWithTitle:@"Error Activating App" message:@"Please try again"];
            }
        } else {
            [self showAlertWithTitle:@"Error Activating App" message:@"Please try again"];
        }
    } else {
        [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
    }
}

- (void)handleConsentResponse {
    NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)handleActivateResponse {
    NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if ([json objectForKey:@"Message"]) {
        NSString *messageReceived = [json valueForKey:@"Message"];

        if ([messageReceived isEqualToString:@"Successful"]) {
            BOOL checkStorePIN = [SDKUtils savePIN:submitPIN];
            if (checkStorePIN) {
                [self dismissAlertIfNeeded];
                [self performSegueWithIdentifier:@"otpToactive" sender:self];
            }
        } else {
            [self showAlertWithTitle:@"Error Activating App" message:@"Please try again"];
        }
    } else {
        [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self dismissAlertIfNeeded];
    alertIncorrect = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alertIncorrect addAction:yesButton];
    [self presentViewController:alertIncorrect animated:YES completion:nil];
}

- (void)showAlertForActiveToken {
    UIAlertAction *yesIncorrectButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        activeIssue = YES;
        alertIncorrect = [UIAlertController alertControllerWithTitle:@"Activating App" message:@"Activating token..." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertIncorrect animated:YES completion:nil];
        [EstablishPINViewController getSerial];
        connSerial = [[NSURLConnection alloc] initWithRequest:requestSerial delegate:self];
    }];
    UIAlertAction *noIncorrectButton = [UIAlertAction actionWithTitle:@"Cancel Activation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        exit(0);
    }];

    [alertIncorrect addAction:yesIncorrectButton];
    [alertIncorrect addAction:noIncorrectButton];
}

- (void)dismissAlertIfNeeded {
    if (alertIncorrect) {
        [alertIncorrect dismissViewControllerAnimated:YES completion:nil];
        alertIncorrect = nil;
    }
}



+ (void) validateOTP {
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&one=%@&ref=%@",@"2",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", submittedOTP,ref ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestVerify = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestVerify setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/validateOTP.php"]];
    
    //set HTTP Method
    [requestVerify setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestVerify setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestVerify setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestVerify setHTTPBody:postData];
    
}

+ (void) checkUser {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&fid=%@",@"9",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", userIdentity ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestUser = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestUser setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/checkUser.php"]];
    
    //set HTTP Method
    [requestUser setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestUser setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestUser setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestUser setHTTPBody:postData];
    
}

+ (void) checkIssuance {

    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"11",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", @"12321321" ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestIssuance = [[NSMutableURLRequest alloc] init];
    
    [requestIssuance setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/checkIssuance.php"]];
    
    //set HTTP Method
    [requestIssuance setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestIssuance setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestIssuance setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestIssuance setHTTPBody:postData];
    
    
}

+ (void) checkActiveToken {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"10",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userIdentity ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestActive = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestActive setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/checkActive.php"]];
    
    //set HTTP Method
    [requestActive setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestActive setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestActive setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestActive setHTTPBody:postData];
    
    
}

+ (void) getSerial {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"5",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userIdentity ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestSerial = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestSerial setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/getSerial.php"]];
    
    //set HTTP Method
    [requestSerial setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestSerial setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestSerial setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestSerial setHTTPBody:postData];
    
}

+ (NSString *)generateRandomStringWithLength:(NSInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];

    for (NSInteger i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((uint32_t)[letters length])]];
    }

    return randomString;
}


+ (void) sendConsent {
    
    NSString *randomID = [self generateRandomStringWithLength:10];
    
    NSString *post = [NSString stringWithFormat:@"&con=%@&acc=%@&fid=%@&phone=%@&user=%@&ref=%@&channel=%@&purpose=%@&app=%@&id=%@",@YES,account,userIdentity,phone,userIdentity,randomID,@"FirstTokeniOS", @"FirstTokenEnrollment", @"iO05255J5KkmnirnrrRh72", @"FirstToken"];
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestConsent = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    
    [requestConsent setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/sendConsent.php"]];
  
    
    //set HTTP Method
    [requestConsent setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestConsent setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestConsent setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestConsent setHTTPBody:postData];
    
}

+ (void) activateSoftToken {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&acc=%@&reg=%@&act=%@&ser=%@",@"6",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userIdentity, account, registration, activationCode, establishSerialNumber];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestActivate = [[NSMutableURLRequest alloc] init];
    
    //Set URL

    [requestActivate setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/activateSoft.php"]];
    
    //set HTTP Method
    [requestActivate setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestActivate setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestActivate setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestActivate setHTTPBody:postData];
    
    
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    if(textField == _enteredOTP){
    return newLength <= 6 || returnKey;
    }else{
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




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"otpTocreate"]) {
        CreateUserViewController *vcSett = [segue destinationViewController];
        vcSett.userIDCode = userIdentity;
        vcSett.accountNumberCreate = account;
        vcSett.pin = pinCode;
    }
    
    
}


@end
