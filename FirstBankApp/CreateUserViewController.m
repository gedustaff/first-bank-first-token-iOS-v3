//
//  CreateUserViewController.m
//  FirstBankApp
//
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "CreateUserViewController.h"

NSString * userId, *account_num, *identityCreated, *userRegistration, *UserserialNumber, *userActivationCode, *phone_number, *full_name, *email;
NSURLConnection *connCreateUser, *connGetSerial, *connActivateToken;
NSMutableURLRequest *requestCreateUser, *requestUserSerial, *requestUserActivate;
UIAlertController * alertIncorrects;

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
    
    self.fullName.delegate = self;
    self.phoneNumber.delegate = self;
    self.emailAdress.delegate = self;
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
    
    [self.fullName resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.emailAdress resignFirstResponder];
    
    full_name = self.fullName.text;
    phone_number = self.phoneNumber.text;
    email = self.emailAdress.text;
    
    if([_fullName hasText] && [_phoneNumber hasText] && [_emailAdress hasText]){
        
        alertIncorrects = [UIAlertController
                          alertControllerWithTitle:@"Activating App"
                          message:@"Creating User..."
                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertIncorrects animated:YES completion:nil];
        
        //Carry out User Creation
        [CreateUserViewController createUser];
        
        connCreateUser = [[NSURLConnection alloc] initWithRequest:requestCreateUser delegate:self];
        
        
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
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    alertIncorrects.title = @"Activation Error";
    alertIncorrects.message = @"Please check your internet connection and try again";
    
    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                         actionWithTitle:@"Close"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
    [alertIncorrects addAction:yesIncorrectButton];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (connection ==connCreateUser){
        NSString *responseText = [[NSString alloc] initWithData:responseDataCU encoding:NSUTF8StringEncoding];
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Created"]){
            BOOL response = [[json valueForKey:@"Created"] boolValue];
            if (response){
                alertIncorrects.message = @"Activating Token...";
                [CreateUserViewController getSerial];
                connGetSerial = [[NSURLConnection alloc] initWithRequest:requestUserSerial delegate:self];
                
            }else{
                alertIncorrects.title = @"Error Creating User";
                alertIncorrects.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                     }];
                [alertIncorrects addAction:yesIncorrectButton];
            }
        }else{
            alertIncorrects.title = @"Error Activating App";
            alertIncorrects.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                
                                                 }];
            [alertIncorrects addAction:yesIncorrectButton];
        }
    }else if (connection ==connGetSerial){
        NSString *responseText = [[NSString alloc] initWithData:responseDataCU encoding:NSUTF8StringEncoding];
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Message"]){
            NSString *messageReceived = [json valueForKey:@"Message"];
            if ([messageReceived isEqualToString:@"SUCCESS" ]){
                UserserialNumber = [json valueForKey:@"SerialNumber"];
                userActivationCode = [json valueForKey:@"ActivationCode"];
                identityCreate = [ETIdentityProvider generate:nil
                                                 serialNumber:UserserialNumber
                                         activationCode:userActivationCode];
                userRegistration = identityCreate.registrationCode;
                
                BOOL checkSave = [SDKUtils saveIdentity:identityCreate];
                
                if(checkSave){
                    alertIncorrects.message=@"Completing Activation";
                    [CreateUserViewController activateSoftToken];
                    connActivateToken = [[NSURLConnection alloc] initWithRequest:requestUserActivate delegate:self];
                  
                }else{
                    alertIncorrects.title = @"Error activating app";
                    alertIncorrects.message = @"Please try again";
                    
                    UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                         actionWithTitle:@"Okay"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         
                                                         }];
                    [alertIncorrects addAction:yesIncorrectButton];
                }
                
                
            }else{
                alertIncorrects.title = @"Error activating app";
                alertIncorrects.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                        
                                                     }];
                [alertIncorrects addAction:yesIncorrectButton];
                
            }
        }else{
            alertIncorrects.title = @"Error Activating App";
            alertIncorrects.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrects addAction:yesIncorrectButton];
        }
        
    }else if (connection ==connActivateToken){
        
        NSString *responseText = [[NSString alloc] initWithData:responseDataCU encoding:NSUTF8StringEncoding];
        //Parse Response
        NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json objectForKey:@"Message"]){
            NSString *messageReceived = [json valueForKey:@"Message"];
            if ([messageReceived isEqualToString:@"Successful" ]){
                BOOL checkStorePIN = [SDKUtils savePIN:pin];
                if (checkStorePIN){
                    [self performSegueWithIdentifier:@"createToactive" sender:self];
                }
                
            }else{
                //Display Error Message
                alertIncorrects.title = @"Error activating app";
                alertIncorrects.message = @"Please try again";
                
                UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                     actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                     }];
                [alertIncorrects addAction:yesIncorrectButton];
                
            }
        }else{
            alertIncorrects.title = @"Error Activating App";
            alertIncorrects.message = @"Please contact the bank";
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrects addAction:yesIncorrectButton];
        }
        
    }else{
        
    }
}

+ (void) getSerial {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@",@"5",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userId ];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestUserSerial = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestUserSerial setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/getSerial.php"]];
    
    //set HTTP Method
    [requestUserSerial setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestUserSerial setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestUserSerial setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestUserSerial setHTTPBody:postData];
    
}

+ (void) createUser {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&pho=%@&eml=%@&fnm=%@&grp=%@",@"8",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userId, phone_number, email, full_name, @"Default"];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestCreateUser = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestCreateUser setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/create.php"]];
    
    //set HTTP Method
    [requestCreateUser setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestCreateUser setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestCreateUser setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestCreateUser setHTTPBody:postData];
    
}

+ (void) activateSoftToken {
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&key=%@&app=%@&fid=%@&acc=%@&reg=%@&act=%@&ser=%@",@"6",@"f8d66c19-ed29-403e-9cf1-387f6c15b223",@"FirstToken", userId, account_num, userRegistration, userActivationCode, UserserialNumber];
    
    //Encode string
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *posted = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    //Calculate Length of message
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    //Create URL Request
    requestUserActivate = [[NSMutableURLRequest alloc] init];
    
    //Set URL
    [requestUserActivate setURL:[NSURL URLWithString:@"https://firsttokenprod.firstbanknigeria.com/FirstTokenmiddleware/activateSoft.php"]];
    
    //set HTTP Method
    [requestUserActivate setHTTPMethod:@"POST"];
    
    //set HTTP Header
    [requestUserActivate setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set Encoded header
    [requestUserActivate setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set Body
    [requestUserActivate setHTTPBody:postData];
}

@end
