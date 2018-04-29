//
//  EstablishPINViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "EstablishPINViewController.h"
#import "RegistrationCodeViewController.h"

BOOL isCreated = NO;
BOOL activeIssue = NO;
NSString *submittedOTP, *submitPIN, *submitConfirm, *ref, *responseCode, *userIdentity, *account, *serial, *activation, *registration, *serialNumber, *pinCode, *activationCode;
NSURLConnection *connValidateOTP, *connCheckUser, *connIssuance, *connActive, *connSerial, *connActivate;
NSMutableURLRequest *requestVerify, *requestUser, *requestIssuance, *requestActive, *requestSerial, *requestActivate;
UIAlertController * alertIncorrect;
@interface EstablishPINViewController ()

@property (weak, nonatomic) IBOutlet UITextField *enteredOTP;
@property (weak, nonatomic) IBOutlet UITextField *pinValue;
@property (weak, nonatomic) IBOutlet UITextField *pinConfirm;


@end

@implementation EstablishPINViewController
@synthesize otpReference, responseDataEP, userID, accountNumber, identity;

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
        
        [EstablishPINViewController checkUser];
        connCheckUser = [[NSURLConnection alloc] initWithRequest:requestUser delegate:self];
        
        /**[EstablishPINViewController validateOTP];
        
        connValidateOTP = [[NSURLConnection alloc] initWithRequest:requestVerify delegate:self];
        
        if(connValidateOTP) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }*/
        
        
        
    }else if(![_pinValue hasText]){
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
    
    
  //  if (submittedOTP.)
    
    
 //   if (isCreated){
   // [self performSegueWithIdentifier:@"otpToactive" sender:self];
   // }else{
    //    [self performSegueWithIdentifier:@"otpTocreate" sender:self];
   // }
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseDataEP setLength:0];
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    
    [responseDataEP appendData: data];
    NSLog(@"recieved data @push %@", data);
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"error message: %@", error);
    
    alertIncorrect.title = @"Activation Error";
    alertIncorrect.message = @"Please check your internet connection and try again";
    
    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                         actionWithTitle:@"Close"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
    [alertIncorrect addAction:yesIncorrectButton];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Finished Loading");
    
    if (connection ==connValidateOTP){
        NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response COnn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"OTPReferenceNumber"]){
            responseCode = [json valueForKey:@"ResponseCode"];
            NSLog(@"Received Code, %@", responseCode);
            //if ([responseCode isEqualToString:@"000"]){
            if ([responseCode isEqualToString:@"111"]){
                
                alertIncorrect.message = @"Verifying User Details...";
                [EstablishPINViewController checkUser];
                connCheckUser = [[NSURLConnection alloc] initWithRequest:requestUser delegate:self];
                if(connCheckUser) {
                    NSLog(@"Connection Successful Get Account");
                } else {
                    NSLog(@"Connection could not be made");
                }
                
            }else{
                
                alertIncorrect.title = @"Error validating OTP";
                alertIncorrect.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrect addAction:yesIncorrectButton];
                
            }
        }else{
            alertIncorrect.title = @"Error Activating App";
            alertIncorrect.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
        }
        
    }else if(connection==connCheckUser){
        
        NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response COnn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"ResponseCode"]){
            responseCode = [json valueForKey:@"ResponseCode"];
            NSLog(@"Received Code, %@", responseCode);
            if ([responseCode isEqualToString:@"000"]){
                alertIncorrect.message = @"Validating Status...";
                [EstablishPINViewController checkIssuance];
                connIssuance = [[NSURLConnection alloc] initWithRequest:requestIssuance delegate:self];
                if(connActive) {
                    NSLog(@"Connection Successful Check Issuance");
                } else {
                    NSLog(@"Connection could not be made");
                }
                
            }else if([responseCode isEqualToString:@"1001"]){
                NSLog(@"User does not exist creating user");
                pinCode = submitPIN;
                 [self performSegueWithIdentifier:@"otpTocreate" sender:self];
                
            }else{
                
                alertIncorrect.title = @"Error checking user state";
                alertIncorrect.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrect addAction:yesIncorrectButton];
                
            }
        }else{
            alertIncorrect.title = @"Error Activating App";
            alertIncorrect.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
        }
        
    }else if(connection==connIssuance){
        
        NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response COnn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Status"]){
            NSLog(@"1");
            
            BOOL statusRetrieved = [[json valueForKey:@"Status"] boolValue];
            //NSString *statusRetrieved = [json valueForKey:@"Status"];
            NSLog(@"Received Code, %d", statusRetrieved);
            NSLog(@"2");
            if (statusRetrieved){
                
                //Get Serial
                 alertIncorrect.message = @"Activating token...";
                [EstablishPINViewController getSerial];
                connSerial = [[NSURLConnection alloc] initWithRequest:requestSerial delegate:self];
                if(connSerial) {
                    NSLog(@"Connection Successful Get Serial");
                } else {
                    NSLog(@"Connection could not be made");
                }
                
            }else{
                //Get Active Token
                alertIncorrect.message = @"Validating token...";
                [EstablishPINViewController checkActiveToken];
                connActive = [[NSURLConnection alloc] initWithRequest:requestActive delegate:self];
                if(connActive) {
                    NSLog(@"Connection Successful Active Token");
                } else {
                    NSLog(@"Connection could not be made");
                }
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            alertIncorrect.title = @"Error Activating App";
            alertIncorrect.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
        }
        
    }else if(connection==connActive){
        
        NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response COnn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Status"]){
            BOOL statusRetrieved = [[json valueForKey:@"Status"] boolValue];
            NSLog(@"Received Code, %d", statusRetrieved);
            if (statusRetrieved){
                
                //Get Serial
                
                alertIncorrect.message =@"Please note that existing token will be deactivated";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                         //alertIncorrect.message = @"Activating token...";
                                                         activeIssue = YES;
                                                         alertIncorrect = [UIAlertController
                                                                           alertControllerWithTitle:@"Activating App"
                                                                           message:@"Activating token..."
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                        
                                                         [self presentViewController:alertIncorrect animated:YES completion:nil];
                                                        // [self presentViewController:alertIncorrect animated:YES completion:nil];
                                                         [EstablishPINViewController getSerial];
                                                         connSerial = [[NSURLConnection alloc] initWithRequest:requestSerial delegate:self];
                                                         if(connSerial) {
                                                             NSLog(@"Connection Successful Get Serial");
                                                         } else {
                                                             NSLog(@"Connection could not be made");
                                                         }
                                                     }];
                UIAlertAction* noIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Cancel Activation"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                         exit(0);
                                                         
                                                     }];
                
                [alertIncorrect addAction:yesIncorrectButton];
                [alertIncorrect addAction:noIncorrectButton];
                
                
                
            }else{
                //Get Token Serial
                alertIncorrect.message = @"Activating token...";
                [EstablishPINViewController getSerial];
                connSerial = [[NSURLConnection alloc] initWithRequest:requestSerial delegate:self];
                if(connSerial) {
                    NSLog(@"Connection Successful Get Serial");
                } else {
                    NSLog(@"Connection could not be made");
                }
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            alertIncorrect.title = @"Error Activating App";
            alertIncorrect.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
        }
        
    }else if(connection==connSerial){
        
        if(activeIssue){
            
        }
        
        NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response Conn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Message"]){
            NSString *messageReceived = [json valueForKey:@"Message"];
            NSLog(@"Received Code, %@", messageReceived);
            if ([messageReceived isEqualToString:@"SUCCESS" ]){
                serialNumber = [json valueForKey:@"SerialNumber"];
                activationCode = [json valueForKey:@"ActivationCode"];
                NSLog(@"Received Serial and ActivationCode, %@,%@", serialNumber,activationCode);
                identity = [ETIdentityProvider generate:nil
                                           serialNumber:serialNumber
                                         activationCode:activationCode];
                 NSLog(@"Created Identity, %@",identity);
                
                registration = identity.registrationCode;
                NSLog(@"Created Registration Code, %@",registration);
                
                BOOL checkSave = [SDKUtils saveIdentity:identity];
                
                if(checkSave){
                    alertIncorrect.message=@"Completing Activation";
                    [EstablishPINViewController activateSoftToken];
                    connActivate = [[NSURLConnection alloc] initWithRequest:requestActivate delegate:self];
                    if(connActivate) {
                        NSLog(@"Connection Successful Activate Token");
                    } else {
                        NSLog(@"Connection could not be made");
                    }
                }else{
                    //Display Error Message
                    NSLog(@"Error Activating App. Please try again");
                    alertIncorrect.title = @"Error Activating App";
                    alertIncorrect.message = @"Please try again";
                    
                    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                         actionWithTitle:@"Okay"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //Handle your yes please button action here
                                                         }];
                    [alertIncorrect addAction:yesIncorrectButton];
                    
                }
                
               
                
                
            }else{
                //Display Error Message
                NSLog(@"Error Activating App. Please try again");
                alertIncorrect.title = @"Error Activating App";
                alertIncorrect.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrect addAction:yesIncorrectButton];
                
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            alertIncorrect.title = @"Error Activating App";
            alertIncorrect.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
        }
        
    }else if(connection==connActivate){
        
        NSString *responseText = [[NSString alloc] initWithData:responseDataEP encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response Conn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Message"]){
            NSString *messageReceived = [json valueForKey:@"Message"];
            NSLog(@"Received Code, %@", messageReceived);
            if ([messageReceived isEqualToString:@"Successful" ]){
                BOOL checkStorePIN = [SDKUtils savePIN:submitPIN];
                if (checkStorePIN){
                    [self performSegueWithIdentifier:@"otpToactive" sender:self];
                }
                
            }else{
                //Display Error Message
                NSLog(@"Error Activating App. Please try again");
                alertIncorrect.title = @"Error Activating App";
                alertIncorrect.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrect addAction:yesIncorrectButton];
                
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            alertIncorrect.title = @"Error Activating App";
            alertIncorrect.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
        }
        
    }else{
        NSLog(@"Critical Application Error");
    }
}

+ (void) validateOTP {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&one=%@&ref=%@",@"2",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", submittedOTP,ref ];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestVerify = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestVerify setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/validateOTP.php"]];
    
    //set HTTP Method
    [requestVerify setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestVerify setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestVerify setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestVerify setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestVerify);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestVerify.HTTPBody);
    
    
    
}

+ (void) checkUser {
    
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&fid=%@",@"9",@"f8d66c19-ed29-403e-9cf1-387f6c15b223", userIdentity ];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestUser = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestUser setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    
    //set HTTP Method
    [requestUser setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestUser setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestUser setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestUser setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestUser);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestUser.HTTPBody);
    
    
    
}

+ (void) checkIssuance {
    
    
    //NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"11",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userIdentity ];
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"11",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", @"12321321" ];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestIssuance = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestIssuance setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkIssuance.php"]];
    
    //set HTTP Method
    [requestIssuance setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestIssuance setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestIssuance setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestIssuance setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestIssuance);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestIssuance.HTTPBody);
    
    
    
}

+ (void) checkActiveToken {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"10",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userIdentity ];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestActive = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestActive setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkActive.php"]];
    
    //set HTTP Method
    [requestActive setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestActive setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestActive setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestActive setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestActive);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestActive.HTTPBody);
    
}

+ (void) getSerial {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"5",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userIdentity ];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestSerial = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestSerial setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/getSerial.php"]];
    
    //set HTTP Method
    [requestSerial setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestSerial setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestSerial setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestSerial setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestSerial);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestSerial.HTTPBody);
    
}

+ (void) activateSoftToken {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&acc=%@&reg=%@&act=%@&ser=%@",@"6",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userIdentity, account, registration, activationCode, serialNumber];
    NSLog(@"Post Request, %@", post);
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"Final Posted Data , %@", posted);
    NSLog(@"Final Post Data , %@", postData);
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //Create URL Request
    requestActivate = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    //[request setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/checkUser.php"]];
    [requestActivate setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/activateSoft.php"]];
    
    //set HTTP Method
    [requestActivate setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestActivate setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestActivate setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestActivate setHTTPBody:postData];
    
    NSLog(@"Final Request Structure, %@", requestActivate);
    //NSString *postedRequest = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
    
    NSLog(@"Posted Request, %@", requestActivate.HTTPBody);
    
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == _enteredOTP){
    
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
