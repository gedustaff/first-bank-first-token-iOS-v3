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

NSString *userid, *account, *otp_reference;
NSURLConnection *conn, *conn1, *conn2, *conn3;
NSMutableURLRequest *requested, *requestOTP;
UIAlertController * alertIncorrection;


@interface RegistrationCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *panCode;
@property (weak, nonatomic) IBOutlet UITextField *pinCode;

@end

@implementation RegistrationCodeViewController
@synthesize responseData, message, responseCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        return newLength <= 16 || returnKey;
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

+ (NSData *)tripleDesEncryptString:(NSString *)input
                               key:(NSString *)key
                             error:(NSError **)error
{
    NSParameterAssert(input);
    NSParameterAssert(key);
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t outLength;
    
    NSAssert(keyData.length == kCCKeySize3DES, @"the keyData is an invalid size");
    
    NSMutableData *outputData = [NSMutableData dataWithLength:(inputData.length  +  kCCBlockSize3DES)];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kCCAlgorithm3DES, // Algorithm
                     kCCOptionPKCS7Padding | kCCOptionECBMode, // options
                     keyData.bytes, // key
                     keyData.length, // keylength
                     nil,// iv
                     inputData.bytes, // dataIn
                     inputData.length, // dataInLength,
                     outputData.mutableBytes, // dataOut
                     outputData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result != kCCSuccess) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.your_domain.your_project_name.your_class_name."
                                         code:result
                                     userInfo:nil];
        }
        return nil;
    }
    [outputData setLength:outLength];
    return outputData;
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
    
    NSString *pan = @"5399236573241351";
    NSString *pin =@"1234";
    //NSString *key = @"RXg0VDY3WXZmZCQhOTh5";
    NSString *key = @"RXg0VDY3WXZmZCQhOTh50000";
    NSData *panData = [pan dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *pinData = [pin dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSString *encryptedString = [pan AES256EncryptWithKey:key];
    //NSLog( @"Encrypted String: %@", encryptedString );
    
    //NSData *encrypted = [RegistrationCodeViewController tripleDesEncryptData:panData key:keyData error:nil];
    //NSData *pinEncrpt = [RegistrationCodeViewController tripleDesEncryptData:pinData key:keyData error:nil];
    
    //NSString *encpan = [[NSString alloc] initWithData:encrypted encoding:NSUTF8StringEncoding];
    //NSLog(@"responseDat String Encrypted, %@", encpan);
    
    //NSLog(@"encrypted data length: %lu", (unsigned long)encrypted.length);
    
    //NSData *encrypted = [TripleDES transformData:panData operation:kCCEncrypt withPassword:key];
    NSData *encrypted = [RegistrationCodeViewController tripleDesEncryptString:pan key:key error:nil];
    NSString *encpan = [[NSString alloc] initWithData:encrypted encoding:NSUTF8StringEncoding];
    NSLog(@"responseDat String Encrypted, %@", encpan);
    
    
    
    
    if(retrievedPan.length==16 && retrievedPin.length==4 && [_panCode hasText] && [_pinCode hasText]){
        alertIncorrection = [UIAlertController
                          alertControllerWithTitle:@"Activating App"
                          message:@"Verifying Card Details..."
                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertIncorrection animated:YES completion:nil];
    
    //NSData *data = [TripleDES transformData:panData operation:kCCEncrypt withPassword:key];
    //NSData *pinValue = [TripleDES transformData:pinData operation:kCCEncrypt withPassword:key];
    
  //  NSLog(@"Data Encrypted, %@", data);
    //NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Data String Encrypted, %@", responseData);
        
      //   NSLog(@"Request PAN %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    
    NSString *encpan = @"0/qt7xBjMq/OkvToHh3Y7A0WkVXxj9EW";
        
       
    NSString *enpin = @"igs6jt4xW1E=";
       
    //compose string to send
    
    //NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&fid=%@",@"9",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", @"168406579"];
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&pac=%@&pic=%@",@"3",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",encpan, enpin];
       // NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"4",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", @"FirstToken", userid];
        
    
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/getID.php"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [request setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", request);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", request.HTTPBody);
        
        NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    
    //Create URLConnection
     conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
        request = nil;
    } else {
        NSLog(@"Connection could not be made");
    }
        
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



   // [self performSegueWithIdentifier:@"panTootp" sender:self];
}



+ (void) getAccount {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"4",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", @"FirstToken", userid];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requested = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requested setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/getAccount.php"]];
    
    //set HTTP Method
    [requested setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requested setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requested setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requested setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requested);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requested.HTTPBody);
    
    
   
}

+ (void) sendOTP {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&acc=%@",@"1",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", account ];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestOTP = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestOTP setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/sendOTP.php"]];
    
    //set HTTP Method
    [requestOTP setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestOTP setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestOTP setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestOTP setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestOTP);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestOTP.HTTPBody);
    
    
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    
    [responseData appendData: data];
    NSLog(@"recieved data @push %@", data);
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //[alertIncorrection dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"error message: %@", error);
    alertIncorrection.title = @"Activation Error";
    alertIncorrection.message = @"Please check your internet connection and try again";
    
    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                         actionWithTitle:@"Close"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
    [alertIncorrection addAction:yesIncorrectButton];
   // [self presentViewController:alertIncorrection animated:YES completion:nil];
    
    
}



// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
     NSLog(@"Finished Loading");
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (connection ==conn){
        
        NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response COnn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Cif_id"]){
            responseCode = [json valueForKey:@"ResponseCode"];
            NSLog(@"Received Code, %@", responseCode);
            if ([responseCode isEqualToString:@"00"]){
                userid = [json valueForKey:@"Cif_id"];
                //Test User ID
                //userid = @"101000526";
                alertIncorrection.message = @"Fetching Account Details...";
                [RegistrationCodeViewController getAccount];
                conn1 = [[NSURLConnection alloc] initWithRequest:requested delegate:self];
                if(conn1) {
                    NSLog(@"Connection Successful Get Account");
                } else {
                    NSLog(@"Connection could not be made");
                }
                
            }else{
                alertIncorrection.title = @"Activation Error";
                alertIncorrection.message = @"Error verifying card details. Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Close"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrection addAction:yesIncorrectButton];
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            
            alertIncorrection.title = @"Error Activating App";
            alertIncorrection.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrection addAction:yesIncorrectButton];
        }
        
    }else if(connection == conn1){
        //[self performSegueWithIdentifier:@"panTootp" sender:self];
        NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response Conn1, %@", responseText);
        //Parse Response
        NSData *dataAccount = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id jsonAccount = [NSJSONSerialization JSONObjectWithData:dataAccount options:0 error:nil];
        
        if ([jsonAccount objectForKey:@"AccountNumbers"]){
            responseCode = [jsonAccount valueForKey:@"Message"];
            NSLog(@"Received Code Get Account, %@", responseCode);
            if ([responseCode isEqualToString:@"Success"]){
                NSArray *account_numbers = [jsonAccount valueForKey:@"AccountNumbers"];
                @try{
                account = [account_numbers objectAtIndex:0];
                    NSLog(@"Received Account Number, %@", account);
                    alertIncorrection.message = @"Sending OTP...";
                    [RegistrationCodeViewController sendOTP];
                    conn2 = [[NSURLConnection alloc] initWithRequest:requestOTP delegate:self];
                    if(conn2) {
                        NSLog(@"Connection Successful send OTP");
                    } else {
                        NSLog(@"Connection could not be made");
                    }
                }@catch(NSException *esc){
                    
                    alertIncorrection.title = @"Error fetching account number";
                    alertIncorrection.message = @"Please try again";
                    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                         actionWithTitle:@"Okay"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //Handle your yes please button action here
                                                         }];
                    [alertIncorrection addAction:yesIncorrectButton];
                    
                }
                
            }else{
                
                alertIncorrection.title = @"Error fetching account number";
                alertIncorrection.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrection addAction:yesIncorrectButton];
               
            }
            
        }else{
          
            NSLog(@"Error Activating App. Please contact the bank");
            alertIncorrection.title = @"Error Activating App";
            alertIncorrection.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrection addAction:yesIncorrectButton];
        }
        
    }else if (connection == conn2){
        NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response Conn2, %@", responseText);
        //Parse Response
        NSData *dataOTP = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id jsonOTP = [NSJSONSerialization JSONObjectWithData:dataOTP options:0 error:nil];
        
        if ([jsonOTP objectForKey:@"ResponseDescription"]){
            responseCode = [jsonOTP valueForKey:@"ResponseCode"];
            NSLog(@"Received Code Get Account, %@", responseCode);
            if ([responseCode isEqualToString:@"000"]){
                otp_reference = [jsonOTP valueForKey:@"OTPReferenceNumber"];
                
                [self performSegueWithIdentifier:@"panTootp" sender:self];
                
            }else{
               
                alertIncorrection.title = @"Error sending OTP";
                alertIncorrection.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrection addAction:yesIncorrectButton];
                
                
            }
            
        }else{
          [alertIncorrection dismissViewControllerAnimated:YES completion:nil];
           // [self dismissView]
            NSLog(@"Error Activating App. Please contact the bank");
            alertIncorrection.title = @"Error Activating App";
            alertIncorrection.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrection addAction:yesIncorrectButton];
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
    if ([[segue identifier] isEqualToString:@"panTootp"]) {
        EstablishPINViewController *vcSett = [segue destinationViewController];
        vcSett.otpReference = otp_reference;
        vcSett.userID = userid;
        vcSett.accountNumber = account;
    }
    
   
}

@end
