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

@interface AppBlockViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelLockKey;
@property (weak, nonatomic) IBOutlet UITextField *tvUnlockKey;

@end

@implementation AppBlockViewController
@synthesize blockKey, unblockKey, blockRetrievedID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tvUnlockKey.borderStyle = UITextBorderStyleRoundedRect;
    self.tvUnlockKey.delegate = self;
    
    //Set up animation package
    
    anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    //Alert User that application has been blocked
    UIAlertView *blockAlert = [[UIAlertView alloc] initWithTitle:@"Application Blocked " message:@"Your application has been blocked. Please contact your nearest branch to unlock it" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [blockAlert show];
    blockRetrievedID = [SDKUtils loadIdentity];
    // Get Block challenge from SDK
    blockKey = [ETIdentity getUnlockChallenge];
    //Set label as the retrieved key to use
    [_labelLockKey setText:blockKey];
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
    
    return newLength <= 8 || returnKey;
}

- (IBAction)unblockApp:(id)sender {
    //check that text has been entered into textbox
    
    if ([self.tvUnlockKey.text isEqualToString:@""]) {
        
        
        
        [_tvUnlockKey.layer addAnimation:anim forKey:nil ];
        
    } else {
        
        //fetch text from text box
        
        unblockKey = self.tvUnlockKey.text;
        
        //Validate Text in text box
        
        if (unblockKey.length!=8) {
           [_tvUnlockKey.layer addAnimation:anim forKey:nil ];
        
        
        
        }else{
            
            //Validate unblock action
            
            BOOL carryGo;
            carryGo = NO;
            carryGo = [blockRetrievedID confirmUnlockCode:unblockKey forChallenge:blockKey];
            if (carryGo) {
                [self performSegueWithIdentifier:@"appblockToReset" sender:self];
            }else{
                //Alert User that application has been blocked
                //[self performSegueWithIdentifier:@"appblockToReset" sender:self];
                UIAlertView *blockAlert = [[UIAlertView alloc] initWithTitle:@"Application Unlock Unsuccessful " message:@"Check the number and re-enter again" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [blockAlert show];
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
    const int movementDistance = -150; // tweak as needed
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
