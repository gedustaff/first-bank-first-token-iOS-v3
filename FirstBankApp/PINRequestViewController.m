//
//  PINRequestViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/8/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import "PINRequestViewController.h"

int counter;

@interface PINRequestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mRetrievePIN;
@property (weak, nonatomic) IBOutlet UILabel *labelPIN;
@end

@implementation PINRequestViewController
@synthesize retrievedID, retrievedPIN;


- (void)viewDidLoad {
    [super viewDidLoad];
    if (![ETSoftTokenSDK isDeviceSecure]) {
        // Display a waring or error message to user.
        // Possibly quit the application.
        
        UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"Application Login Error " message:@"Your device is rooted \nIt is recommended that you do not continue \n Do you?" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [pinAlert show];

        
    }
    counter = 3;
    self.mRetrievePIN.delegate = self;    
    self.mRetrievePIN.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.mRetrievePIN addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length==4) {
        [self submitPIN:@"b"];
    }
}



+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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
    //NSUInteger length = [[textField text]length] - range.length + string.length;
    /**
    if ([textField isEqual:self.mRetrievePIN]) {
        NSString *ser = [_mRetrievePIN.text stringByReplacingCharactersInRange:range withString:string];
        
        if (ser.length==5) {
            [self submitPIN:@"b"];
        }
    }**/
    
    
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    
    return newLength <= 4 || returnKey;
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


+(void) submitPINValue{
    
}


- (IBAction)submitPIN:(id)sender {
    retrievedID = [SDKUtils loadIdentity];
    retrievedPIN = [SDKUtils retrievePIN];
    
    if (retrievedID == nil) {
        UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"Application Login Error " message:@"Sorry you cannot log into this application. Please contact your administrator" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [pinAlert show];
    } else {
        if ([retrievedPIN isEqualToString: self.mRetrievePIN.text]) {
            [self performSegueWithIdentifier:@"pinReqTosecCode" sender:self];
            [self.mRetrievePIN setText:@""];
        } else {
            //Clear textfield
            [_mRetrievePIN setText:@""];
            // Shake textField Animation
            CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
            anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
            anim.autoreverses = YES ;
            anim.repeatCount = 2.0f ;
            anim.duration = 0.07f ;
            
            [ _mRetrievePIN.layer addAnimation:anim forKey:nil ];
            
            
            if (counter > 1) {
                NSString *displayAlert = [NSString stringWithFormat: @"You have entered the incorrect PIN. \n %i more tries remaining", counter];
                counter--;
                
                UIColor *c = [PINRequestViewController colorFromHexString:@"#E39C08"];
               
                
                _labelPIN.backgroundColor =  c;
                [_labelPIN setText: displayAlert];
            } else if(counter == 1) {
                NSString *displayAlert = [NSString stringWithFormat: @"You have entered the incorrect PIN. \n %i more try remaining", counter];
                counter--;
                
                [_labelPIN setText: displayAlert];

            }else{
                counter--;
                
            }
            if (counter == -1) {
                NSString *lock = @"AppLocked";
                [SDKUtils saveLockState:lock];
                [self performSegueWithIdentifier:@"pinReqToappBlock" sender:self];
            }
            
            
        }
    }
    
    
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
    const int movementDistance = -140; // tweak as needed
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
    
    if ([[segue identifier] isEqualToString:@"pinReqTosecCode"]) {
        SecurityCodeViewController *svc = [segue destinationViewController];
        svc.getIdentity = self.retrievedID;
    }
    
}


@end
