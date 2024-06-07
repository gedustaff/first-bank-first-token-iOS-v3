//
//  RegistrationCodeViewController.m
//  FirstBankApp
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "RegistrationCodeViewController.h"
#import <EntrustIGMobile/ETIdentityProvider.h>
#import "EstablishPINViewController.h"
#import "SDKUtils.h"
#import "SecurityCodeViewController.h"
#import <CommonCrypto/CommonDigest.h>

NSString *userid, *regPhoneNumber, *regAccount, *otp_reference, *reusedCode;
NSURLConnection *conn, *conn1, *conn2, *conn3;
NSMutableURLRequest *requested, *requestOTP;
UIAlertController * alertIncorrection;


@interface RegistrationCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *panCode;
@property (weak, nonatomic) IBOutlet UITextField *pinCode;

@end

@implementation RegistrationCodeViewController
@synthesize responseData, message, responseCode, codeReuse;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    reusedCode = codeReuse;
    
    responseData = [NSMutableData new];
    
    UIColor *color = [UIColor whiteColor];
    _panCode.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Debit/ATM Card Number"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    _pinCode.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Card PIN"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    
    _panCode.layer.masksToBounds=YES;
    _panCode.layer.borderColor = [[RegistrationCodeViewController colorFromHexString:@"#eaab00"] CGColor];
    _panCode.layer.borderWidth= 2.0f;
    
    _pinCode.layer.masksToBounds=YES;
    _pinCode.layer.borderColor = [[RegistrationCodeViewController colorFromHexString:@"#eaab00"] CGColor];
    _pinCode.layer.borderWidth= 2.0f;
    
    // Do any additional setup after loading the view.
    
    self.panCode.delegate = self;
    self.pinCode.delegate = self;
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField==_panCode){
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 19 || returnKey;
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



+ (NSData*)encryptData:(NSData*)inputData
{
    NSData * key = [@"RXg0VDY3WXZmZCQhRXg0VDY3" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData* outputData = [NSMutableData dataWithLength:(inputData.length + kCCBlockSize3DES)];
    
    size_t outLength;
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt,                // CCOperation op
                                     kCCAlgorithm3DES,          // CCAlgorithm alg
                                     kCCOptionPKCS7Padding,     // CCOptions options
                                     key.bytes,                 // const void *key
                                     key.length,                // size_t keyLength
                                     nil,                       // const void *iv
                                     inputData.bytes,           // const void *dataIn
                                     inputData.length,          // size_t dataInLength
                                     outputData.mutableBytes,   // void *dataOut
                                     outputData.length,         // size_t dataOutAvailable
                                     &outLength);               // size_t *dataOutMoved
    
    if (result != kCCSuccess)
        return nil;
    
    [outputData setLength:outLength];
    return outputData;
   // NSString * outputString = [outputData base64EncodingWithLineLength:0];
    //return outputString;
}


+ (NSString*) doCipher:(NSString*)plainText operation:(CCOperation)encryptOrDecrypt
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *EncryptData = [[NSData alloc] initWithBase64EncodedString:plainText];
    plainTextBufferSize = [EncryptData length];
    vplainText = [EncryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x00, (size_t) sizeof(iv));
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    NSString *key = @"RXg0VDY3WXZmZCQhOTh5";
    
    NSData *testData = [self md5DataFromString:key];
    const char *constSource = [testData bytes];
    
    unsigned char source[24];
    memcpy(source, constSource, sizeof (source));
    
    for (int j = 0, k = 16; j < 8;) {
        source[k++] = source[j++];
    }
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCAlgorithm3DES,
                       source,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (ccStatus == kCCSuccess);
    else if (ccStatus == kCCParamError) return @"PARAM ERROR";
    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    
    NSString *result;
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    result = [myData base64EncodingWithLineLength:0];
    return result;
}

+ (NSData *)md5DataFromString:(NSString *)input
{
    const char *cStr = [input UTF8String];
   // unsigned char digest[16];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

//New cipher
+ (NSString*) doNewCipher:(NSString*)plainText operation:(CCOperation)encryptOrDecrypt {
   NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
   const void *vplainText = [plainTextData bytes];
   size_t plainTextBufferSize = [plainTextData length];

   uint8_t *bufferPtr = NULL;
   size_t bufferPtrSize = 0;
   size_t movedBytes = 0;

   bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
   bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
   memset((void *)bufferPtr, 0x0, bufferPtrSize);

   NSString *key = @"R3IzM25TbkBLZVVuZEVSWTNsbDB3R3JAJCQ=";
   NSData *keyData = [self md5DataFromString:key];
   uint8_t *rawKey = (uint8_t *)[keyData bytes];
   uint8_t keyBytes[24];
   memcpy(keyBytes, rawKey, 16);
   for (int j = 0, k = 16; j < 8;) {
       keyBytes[k++] = keyBytes[j++];
   }

   CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt,
                                      kCCAlgorithm3DES,
                                      kCCOptionPKCS7Padding | kCCOptionECBMode,
                                      keyBytes,
                                      kCCKeySize3DES,
                                      NULL,
                                      vplainText,
                                      plainTextBufferSize,
                                      (void *)bufferPtr,
                                      bufferPtrSize,
                                      &movedBytes);

   if (ccStatus != kCCSuccess) {
       free(bufferPtr);
       return nil; // Handle error based on ccStatus
   }

   NSData *resultData = [NSData dataWithBytesNoCopy:bufferPtr length:movedBytes];
   NSString *result = [resultData base64EncodedStringWithOptions:0];
   return result;
}


- (IBAction)submitPan:(id)sender {
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    [self.panCode resignFirstResponder];
    [self.pinCode resignFirstResponder];
    
    NSString *retrievedPan = self.panCode.text;
    NSString *retrievedPin = self.pinCode.text;
    
  
    if(retrievedPan.length>=16 && retrievedPin.length==4 && [_panCode hasText] && [_pinCode hasText]){
        alertIncorrection = [UIAlertController
                          alertControllerWithTitle:@"Activating App"
                          message:@"Verifying Card Details..."
                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertIncorrection animated:YES completion:nil];
        
        NSString *encryptPAN = [RegistrationCodeViewController doNewCipher:retrievedPan operation:kCCEncrypt];
        
        NSString *encryptPIN = [RegistrationCodeViewController doNewCipher:retrievedPin operation:kCCEncrypt];
        
        if (!encryptPAN || !encryptPIN) {
            return;
        }
        //EncodedPAN and PIN
        NSString *encodedPAN = [encryptPAN stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
        
        NSString *encodedPIN = [encryptPIN stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
        
    
        NSString *post = [NSString stringWithFormat:@"id=%@&key=%@&pac=%@&pic=%@",@"3",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",encodedPAN, encodedPIN];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    //Create URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/firsttokenmiddleware/getID.php"]];
   
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [request setHTTPBody:postData];
    
    //Create URLConnection
     conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }else if (![_panCode hasText]){
        // show alert that text view is empty
        [ _panCode.layer addAnimation:anim forKey:nil ];
        
    }else if( ![_pinCode hasText]){
        // Show alert that text view is incomplete
        [ _pinCode.layer addAnimation:anim forKey:nil ];
        
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


+ (void) getAccount {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"4",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", @"FirstToken", userid];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requested = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requested setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/firsttokenmiddleware/getAccount.php"]];
    
    //set HTTP Method
    [requested setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requested setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requested setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requested setHTTPBody:postData];
}



+ (void) sendOTP {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&acc=%@",@"1",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", regAccount ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestOTP = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestOTP setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/sendOTP.php"]];
    
    //set HTTP Method
    [requestOTP setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestOTP setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestOTP setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestOTP setHTTPBody:postData];
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // Load the .cer file from the app bundle
        NSString *certPath = [[NSBundle mainBundle] pathForResource:@"fbnnewcert_new" ofType:@"der"];
        NSData *certData = [NSData dataWithContentsOfFile:certPath];
        CFDataRef certDataRef = (__bridge CFDataRef)certData;
        SecCertificateRef certRef = SecCertificateCreateWithData(NULL, certDataRef);
        NSArray *certArray = @[(__bridge id)certRef];
       
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        SecPolicyRef policy = SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host);
       
        SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)certArray);
        SecTrustSetAnchorCertificatesOnly(trust, false);
       
        SecTrustResultType result;
        SecTrustEvaluate(trust, &result);
       
        BOOL trusted = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
       
        if (trusted) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        } else {
            [challenge.sender cancelAuthenticationChallenge:challenge];
        }
       
        if (certRef) CFRelease(certRef);
        if (policy) CFRelease(policy);
    } else {
        [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    [responseData appendData: data];
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //[alertIncorrection dismissViewControllerAnimated:YES completion:nil];
    
    alertIncorrection.title = @"Activation Error";
    alertIncorrection.message = @"Please check your internet connection and try again";
    
    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                         actionWithTitle:@"Close"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
    [alertIncorrection addAction:yesIncorrectButton];
}



// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (connection ==conn){
        
        NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Cif_id"]){
            responseCode = [json valueForKey:@"ResponseCode"];
            if ([responseCode isEqualToString:@"00"]){
                userid = [json valueForKey:@"Cif_id"];
                alertIncorrection.message = @"Fetching Account Details...";
                [RegistrationCodeViewController getAccount];
                conn1 = [[NSURLConnection alloc] initWithRequest:requested delegate:self];
                
            }else{
                [self showAlertWithTitle:@"Activation Error" message:@"Error verifying card details. Please try again"];
            }
        }else{
            [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
        }
        
    }else if(connection == conn1){
        NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        //Parse Response
        NSData *dataAccount = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id jsonAccount = [NSJSONSerialization JSONObjectWithData:dataAccount options:0 error:nil];
        
        if ([jsonAccount objectForKey:@"AccountNumbers"]){
            responseCode = [jsonAccount valueForKey:@"Message"];
            if ([responseCode isEqualToString:@"Success"]){
                NSArray *account_numbers = [jsonAccount valueForKey:@"AccountNumbers"];
                NSArray *phone_numbers = [jsonAccount valueForKey:@"phonelist"];
                @try{
                    regAccount = [account_numbers objectAtIndex:0];
                    regPhoneNumber = [phone_numbers objectAtIndex:0];
                    alertIncorrection.message = @"Sending OTP...";
                    [RegistrationCodeViewController sendOTP];
                    conn2 = [[NSURLConnection alloc] initWithRequest:requestOTP delegate:self];
                }@catch(NSException *esc){
                    [self showAlertWithTitle:@"Error fetching account number" message:@"Please try again"];
                }
                
            }else{
                [self showAlertWithTitle:@"Error fetching account number" message:@"Please try again"];
               
            }
            
        }else{
            [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
        }
        
    }else if (connection == conn2){
        NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        //Parse Response
        NSData *dataOTP = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id jsonOTP = [NSJSONSerialization JSONObjectWithData:dataOTP options:0 error:nil];
        
        if ([jsonOTP objectForKey:@"ResponseDescription"]){
            responseCode = [jsonOTP valueForKey:@"ResponseCode"];
            if ([responseCode isEqualToString:@"000"]){
                
                otp_reference = [jsonOTP valueForKey:@"OTPReferenceNumber"];
                
                if ([codeReuse isEqualToString: @"reset"]){
                    [self dismissAlertAndPerformSegue:@"numberToreset"];
                    
                }else if([codeReuse isEqualToString:@"deactivate"]){
                    [self dismissAlertAndPerformSegue:@"cardTodeac"];
                    
                }else{
                    [self dismissAlertAndPerformSegue:@"panTootp"];
                }

                
            }else{
 
                [self showAlertWithTitle:@"Error sending OTP" message:@"Please try again"];
  
            }
            
        }else{
            [self dismissAlertIfNeeded];
                   [self showAlertWithTitle:@"Error Activating App" message:@"Please contact the bank"];
        }
        
    }
    
    
}

- (void)dismissAlertIfNeeded {
    if (alertIncorrection) {
        [alertIncorrection dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self dismissAlertIfNeeded];
    alertIncorrection = [UIAlertController alertControllerWithTitle:title
                                                            message:message
                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertIncorrection addAction:okAction];
    [self presentViewController:alertIncorrection animated:YES completion:nil];
}


- (void)dismissAlertAndPerformSegue:(NSString *)segueIdentifier {
    [self dismissAlertIfNeeded];
    [self performSegueWithIdentifier:segueIdentifier sender:self];
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
    if ([[segue identifier] isEqualToString:@"panTootp"]) {
        EstablishPINViewController *vcSett = [segue destinationViewController];
        vcSett.otpReference = otp_reference;
        vcSett.userID = userid;
        vcSett.accountNumber = regAccount;
        vcSett.phoneNumber = regPhoneNumber;
    }else if ([[segue identifier] isEqualToString:@"numberToreset"]) {
        ResetPINViewController *rpVC = [segue destinationViewController];
        rpVC.ref = otp_reference;
    }else if ([[segue identifier] isEqualToString:@"cardTodeac"]) {
        DeactivateViewController *rpVC = [segue destinationViewController];
        rpVC.ref = otp_reference;
        rpVC.userID = userid;
    }
    
   
}

@end
