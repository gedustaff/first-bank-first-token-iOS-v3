//
//  CreateUserViewController.m
//  FirstBankApp
//
//  Created by Dapsonco on 17/04/2018.
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "CreateUserViewController.h"

NSString * userId, *account_num, *identityCreated, *registration, *serialNumber, *activationCode, *phone_number, *full_name, *email;
NSURLConnection *connCreateUser, *connGetSerial, *connActivateToken;
NSMutableURLRequest *requestUser, *requestSerial, *requestActivate;

@interface CreateUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *emailAdress;

@end

@implementation CreateUserViewController
@synthesize userIDCode, accountNumberCreate, identityCreate, responseDataCU, pin;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    responseDataCU = [NSMutableData new];
    
    UIColor *color = [UIColor whiteColor];
    
    userId = userIDCode;
    account_num = accountNumberCreate;
    
    
    _fullName.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter Full Name"
     attributes:@{NSForegroundColorAttributeName:color}];
    _phoneNumber.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter Phone Number"
     attributes:@{NSForegroundColorAttributeName:color}];
    _emailAdress.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Enter Email Address"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    _fullName.layer.masksToBounds=YES;
    _fullName.layer.borderColor = [[CreateUserViewController colorFromHexString:@"#eaab00"] CGColor];
    _fullName.layer.borderWidth= 2.0f;
    
    _phoneNumber.layer.masksToBounds=YES;
    _phoneNumber.layer.borderColor = [[CreateUserViewController colorFromHexString:@"#eaab00"] CGColor];
    _phoneNumber.layer.borderWidth= 2.0f;
    
    _emailAdress.layer.masksToBounds=YES;
    _emailAdress.layer.borderColor = [[CreateUserViewController colorFromHexString:@"#eaab00"] CGColor];
    _emailAdress.layer.borderWidth= 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (IBAction)submitCreate:(id)sender {
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    full_name = self.fullName.text;
    phone_number = self.phoneNumber.text;
    email = self.emailAdress.text;
    
    if([_fullName hasText] && [_phoneNumber hasText] && [_emailAdress hasText]){
        
        //Carry out User Creation
        [CreateUserViewController createUser];
        
        connCreateUser = [[NSURLConnection alloc] initWithRequest:requestUser delegate:self];
        
        if(connCreateUser) {
            NSLog(@"Connection Successful Create User");
        } else {
            NSLog(@"Connection could not be made");
        }
        
    }else if(![_fullName hasText]){
        [ _fullName.layer addAnimation:anim forKey:nil ];
    }else if (![_phoneNumber hasText]){
        [ _phoneNumber.layer addAnimation:anim forKey:nil ];
    }else if (![_emailAdress hasText]){
        [ _emailAdress.layer addAnimation:anim forKey:nil ];
    }else{
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

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseDataCU setLength:0];
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    
    [responseDataCU appendData: data];
    NSLog(@"recieved data @push %@", data);
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"error message: %@", error);
    UIAlertController * alertIncorrect = [UIAlertController
                                          alertControllerWithTitle:@"Activation Error"
                                          message:@"Please check your internet connection and try again"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                         actionWithTitle:@"Close"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
    [alertIncorrect addAction:yesIncorrectButton];
    [self presentViewController:alertIncorrect animated:YES completion:nil];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Finished Loading");
    
    if (connection ==connCreateUser){
        NSString *responseText = [[NSString alloc] initWithData:responseDataCU encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response COnn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Created"]){
            BOOL response = [json boolForKey:@"Created"];
            NSLog(@"Received Code, %d", response);
            if (response){
                [CreateUserViewController getSerial];
                connGetSerial = [[NSURLConnection alloc] initWithRequest:requestSerial delegate:self];
                if(connGetSerial) {
                    NSLog(@"Connection Successful Get Account");
                } else {
                    NSLog(@"Connection could not be made");
                }
                
            }else{
                UIAlertController * alertIncorrect = [UIAlertController
                                                      alertControllerWithTitle:@"Error Creating User"
                                                      message:@"Please try again"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrect addAction:yesIncorrectButton];
                [self presentViewController:alertIncorrect animated:YES completion:nil];
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            UIAlertController * alertIncorrect = [UIAlertController
                                                  alertControllerWithTitle:@"Error Activating App"
                                                  message:@"Please contact the bank"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
            [self presentViewController:alertIncorrect animated:YES completion:nil];
        }
    }else if (connection ==connGetSerial){
        NSString *responseText = [[NSString alloc] initWithData:responseDataCU encoding:NSUTF8StringEncoding];
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
                identityCreate = [ETIdentityProvider generate:nil
                                           serialNumber:serialNumber
                                         activationCode:activationCode];
                NSLog(@"Created Identity, %@",identityCreate);
                registration = identityCreate.registrationCode;
                NSLog(@"Created Registration Code, %@",registration);
                
                BOOL checkSave = [SDKUtils saveIdentity:identityCreate];
                
                if(checkSave){
                    [CreateUserViewController activateSoftToken];
                    connActivateToken = [[NSURLConnection alloc] initWithRequest:requestActivate delegate:self];
                    if(connActivateToken) {
                        NSLog(@"Connection Successful Activate Token");
                    } else {
                        NSLog(@"Connection could not be made");
                    }
                }else{
                    //Display Error Message
                    NSLog(@"Error Activating App. Please try again");
                    UIAlertController * alertIncorrect = [UIAlertController
                                                          alertControllerWithTitle:@"Error Activating App"
                                                          message:@"Please try again"
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                         actionWithTitle:@"Okay"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //Handle your yes please button action here
                                                         }];
                    [alertIncorrect addAction:yesIncorrectButton];
                    [self presentViewController:alertIncorrect animated:YES completion:nil];
                }
                
                
                
                
            }else{
                //Display Error Message
                NSLog(@"Error Activating App. Please try again");
                UIAlertController * alertIncorrect = [UIAlertController
                                                      alertControllerWithTitle:@"Error Activating App"
                                                      message:@"Please try again"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrect addAction:yesIncorrectButton];
                [self presentViewController:alertIncorrect animated:YES completion:nil];
                
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            UIAlertController * alertIncorrect = [UIAlertController
                                                  alertControllerWithTitle:@"Error Activating App"
                                                  message:@"Please contact the bank"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
            [self presentViewController:alertIncorrect animated:YES completion:nil];
        }
        
    }else if (connection ==connActivateToken){
        
        NSString *responseText = [[NSString alloc] initWithData:responseDataCU encoding:NSUTF8StringEncoding];
        NSLog(@"Received Response Conn, %@", responseText);
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Message"]){
            NSString *messageReceived = [json valueForKey:@"Message"];
            NSLog(@"Received Code, %@", messageReceived);
            if ([messageReceived isEqualToString:@"Successful" ]){
                BOOL checkStorePIN = [SDKUtils savePIN:pin];
                if (checkStorePIN){
                    [self performSegueWithIdentifier:@"createToactive" sender:self];
                }
                
            }else{
                //Display Error Message
                NSLog(@"Error Activating App. Please try again");
                UIAlertController * alertIncorrect = [UIAlertController
                                                      alertControllerWithTitle:@"Error Activating App"
                                                      message:@"Please try again"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrect addAction:yesIncorrectButton];
                [self presentViewController:alertIncorrect animated:YES completion:nil];
                
            }
        }else{
            NSLog(@"Error Activating App. Please contact the bank");
            UIAlertController * alertIncorrect = [UIAlertController
                                                  alertControllerWithTitle:@"Error Activating App"
                                                  message:@"Please contact the bank"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrect addAction:yesIncorrectButton];
            [self presentViewController:alertIncorrect animated:YES completion:nil];
        }
        
    }else{
        
    }
}

+ (void) getSerial {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"5",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userId ];
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

+ (void) createUser {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&pho=%@&eml=%@&fnm=%@&grp=%@",@"8",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userId, phone_number, email, full_name, @"Default"];
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
    [requestUser setURL:[NSURL URLWithString:@"https://firsttokendev.firstbanknigeria.com/middleware/create.php"]];
    
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

+ (void) activateSoftToken {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&acc=%@&reg=%@&act=%@&ser=%@",@"6",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userId, serialNumber, activationCode, registration, account_num];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
