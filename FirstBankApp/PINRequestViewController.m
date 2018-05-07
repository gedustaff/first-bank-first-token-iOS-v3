//
//  PINRequestViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 1/8/15.
//  Copyright (c) 2015 Gedu Technologies. All rights reserved.
//

#import "PINRequestViewController.h"
NSString *inputValue, *retrievedPIN;

int counter;

@interface PINRequestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *oneL;
@property (weak, nonatomic) IBOutlet UILabel *twoL;
@property (weak, nonatomic) IBOutlet UILabel *threeL;
@property (weak, nonatomic) IBOutlet UILabel *fourL;
@property (weak, nonatomic) IBOutlet UILabel *fiveL;
@property (weak, nonatomic) IBOutlet UILabel *sixL;
@property (weak, nonatomic) IBOutlet UILabel *sevenL;
@property (weak, nonatomic) IBOutlet UILabel *eightL;
@property (weak, nonatomic) IBOutlet UILabel *nineL;
@property (weak, nonatomic) IBOutlet UILabel *emptyL;
@property (weak, nonatomic) IBOutlet UILabel *zeroL;
@property (weak, nonatomic) IBOutlet UILabel *deleteL;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@end

@implementation PINRequestViewController
@synthesize retrievedID, retrievedPIN;


- (void)viewDidLoad {
    [super viewDidLoad];
    counter = 3;
    retrievedPIN = [SDKUtils retrievePIN];
    
    inputValue = @"";
    _inputLabel.text = inputValue;

    //Number 1 Border
    UIView *border = [UIView new];
    border.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, _oneL.frame.size.height - 1.0f, _oneL.frame.size.width, 1.0f);
    
    UIView *border2 = [UIView new];
    border2.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border2.frame = CGRectMake(_oneL.frame.size.width - 1.0f, 0, 1.0f, _oneL.frame.size.height);
    [_oneL addSubview:border];
    [_oneL addSubview:border2];
    
    //Number 2 Border
    
    UIView *border3 = [UIView new];
    border3.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border3.frame = CGRectMake(0, _twoL.frame.size.height - 1.0f, _twoL.frame.size.width, 1.0f);
    
    UIView *border4 = [UIView new];
    border4.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border4.frame = CGRectMake(_twoL.frame.size.width - 1.0f, 0, 1.0f, _twoL.frame.size.height);
    [_twoL addSubview:border3];
    [_twoL addSubview:border4];
    
    //Number 4 Border
    
    UIView *border5 = [UIView new];
    border5.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border5 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border5.frame = CGRectMake(0, _fourL.frame.size.height - 1.0f, _fourL.frame.size.width, 1.0f);
    
    UIView *border6 = [UIView new];
    border6.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border6.frame = CGRectMake(_fourL.frame.size.width - 1.0f, 0, 1.0f, _fourL.frame.size.height);
    [_fourL addSubview:border5];
    [_fourL addSubview:border6];
    
    //Number 5 Border
    
    UIView *border7 = [UIView new];
    border7.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border7 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border7.frame = CGRectMake(0, _fiveL.frame.size.height - 1.0f, _fiveL.frame.size.width, 1.0f);
    
    UIView *border8 = [UIView new];
    border8.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border8 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border8.frame = CGRectMake(_fiveL.frame.size.width - 1.0f, 0, 1.0f, _fiveL.frame.size.height);
    [_fiveL addSubview:border7];
    [_fiveL addSubview:border8];
    
    //Number 7 Border
    
    UIView *border9 = [UIView new];
    border9.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border9 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border9.frame = CGRectMake(0, _sevenL.frame.size.height - 1.0f, _sevenL.frame.size.width, 1.0f);
    
    UIView *border10 = [UIView new];
    border10.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border10 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border10.frame = CGRectMake(_sevenL.frame.size.width - 1.0f, 0, 1.0f, _sevenL.frame.size.height);
    [_sevenL addSubview:border9];
    [_sevenL addSubview:border10];
    
    //Number 8 Border
    
    UIView *border11 = [UIView new];
    border11.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border11 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border11.frame = CGRectMake(0, _eightL.frame.size.height - 1.0f, _eightL.frame.size.width, 1.0f);
    
    UIView *border12 = [UIView new];
    border12.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border12 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border12.frame = CGRectMake(_eightL.frame.size.width - 1.0f, 0, 1.0f, _eightL.frame.size.height);
    [_eightL addSubview:border11];
    [_eightL addSubview:border12];
    
    //Number 3 Border
    
    UIView *border13 = [UIView new];
    border13.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border13 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border13.frame = CGRectMake(0, _threeL.frame.size.height - 1.0f, _threeL.frame.size.width, 1.0f);
    [_threeL addSubview:border13];
    
    //Number 6 Border
    
    UIView *border14 = [UIView new];
    border14.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border14 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border14.frame = CGRectMake(0, _sixL.frame.size.height - 1.0f, _sixL.frame.size.width, 1.0f);
    [_sixL addSubview:border14];
    
    //Number 9 Border
    
    UIView *border15 = [UIView new];
    border15.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border15 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border15.frame = CGRectMake(0, _nineL.frame.size.height - 1.0f, _nineL.frame.size.width, 1.0f);
    [_nineL addSubview:border15];
    
    //Number Empty Border
    
    UIView *border16 = [UIView new];
    border16.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border16 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border16.frame = CGRectMake(_emptyL.frame.size.width - 1.0f, 0, 1.0f, _emptyL.frame.size.height);
    [_emptyL addSubview:border16];
    
    //Number 0 Border
    
    UIView *border17 = [UIView new];
    border17.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border17 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border17.frame = CGRectMake(_zeroL.frame.size.width - 1.0f, 0, 1.0f, _zeroL.frame.size.height);
    [_zeroL addSubview:border17];
    
    
    //Input Box Border
    
    //Number 9 Border
    
    UIView *border18 = [UIView new];
    border18.backgroundColor = [PINRequestViewController colorFromHexString:@"#eaab00"];
    [border18 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border18.frame = CGRectMake(0, _inputLabel.frame.size.height - 1.0f, _inputLabel.frame.size.width, 1.0f);
    [_inputLabel addSubview:border18];
    
    
    
    
    
    
    
    
    
    if (![ETSoftTokenSDK isDeviceSecure]) {
        // Display a waring or error message to user.
        // Possibly quit the application.
        
        UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"Application Login Error " message:@"Your device is rooted \nIt is recommended that you do not continue \n Do you?" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [pinAlert show];

        
    }
    
    
    // Do any additional setup after loading the view.
    retrievedID = [SDKUtils loadIdentity];
    
    
    
    
    
    
}


- (IBAction)resetPIN:(id)sender {
    
    [self performSegueWithIdentifier:@"pinReqToappBlock" sender:self];
}

- (IBAction)changePIN:(id)sender {
    [self performSegueWithIdentifier:@"pinTochange" sender:self];
    
}

- (IBAction)deactivate:(id)sender {
    
    [self performSegueWithIdentifier:@"pinTodeac" sender:self];
}



- (IBAction)one:(id)sender {
    
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
    inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"1"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)two:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
    
    inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"2"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)three:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"3"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)four:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"4"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);}
- (IBAction)five:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"5"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)six:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"6"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)seven:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"7"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)eight:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"8"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)nine:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"9"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)zero:(id)sender {
    if ([inputValue length] > 3) {
        NSRange range = [inputValue rangeOfComposedCharacterSequencesForRange:(NSRange){0, 4}];
        inputValue = [inputValue substringWithRange:range];
    }else{
        inputValue = [NSString stringWithFormat:@"%@%@",inputValue, @"0"];
    }
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}
- (IBAction)delete:(id)sender {
    inputValue = [inputValue substringToIndex:inputValue.length-(inputValue.length>0)];
    _inputLabel.text = [@"" stringByPaddingToLength: [inputValue length] withString: @"*" startingAtIndex:0];
    NSLog(@"%@",inputValue);
}




- (IBAction)submitPIN:(id)sender {
    
    //Get PIN Code from TextField/Label
    
    if(inputValue.length==4 && [inputValue isEqualToString:retrievedPIN]){
        //Segue to Security Code
        
        [self performSegueWithIdentifier:@"pinReqTosecCode" sender:self];
        [self.inputLabel setText:@""];
        inputValue=@"";
    }else{
        CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
        anim.autoreverses = YES ;
        anim.repeatCount = 2.0f ;
        anim.duration = 0.07f ;
        
        [ _inputLabel.layer addAnimation:anim forKey:nil ];
        
        [self.inputLabel setText:@""];
        inputValue=@"";
        
        
        if (counter > 1) {
            NSString *displayAlert = [NSString stringWithFormat: @"You have entered the incorrect PIN. \n %i more tries remaining", counter];
            counter--;
            
            UIAlertController *alertIncorrection = [UIAlertController
                                                                     alertControllerWithTitle:@"PIN Error"
                                                                     message:displayAlert
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Close"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrection addAction:yesIncorrectButton];
             [self presentViewController:alertIncorrection animated:YES completion:nil];
            
            
        } else if(counter == 1) {
            NSString *displayAlert = [NSString stringWithFormat: @"You have entered the incorrect PIN. \n %i more try remaining", counter];
            counter--;
            
            UIAlertController *alertIncorrection = [UIAlertController
                                                    alertControllerWithTitle:@"PIN Error"
                                                    message:displayAlert
                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Close"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                 }];
            [alertIncorrection addAction:yesIncorrectButton];
            [self presentViewController:alertIncorrection animated:YES completion:nil];
            
        }else{
            counter--;
            
        }
        if (counter == -1) {
            NSString *lock = @"AppLocked";
            [SDKUtils saveLockState:lock];
            UIAlertController *alertIncorrection = [UIAlertController
                                                    alertControllerWithTitle:@"PIN Error"
                                                    message:@"You have entered the incorrect PIN too many times. \n Your FirstToken app is now locked"
                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesIncorrectButton = [UIAlertAction
                                                 actionWithTitle:@"Close"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Handle your yes please button action here
                                                     [self performSegueWithIdentifier:@"pinReqToappBlock" sender:self];
                                                 }];
            [alertIncorrection addAction:yesIncorrectButton];
            [self presentViewController:alertIncorrection animated:YES completion:nil];
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length==4) {
      //  [self submitPIN:@"b"];
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

- (BOOL)label:(UILabel *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    
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


- (IBAction)openSettings:(id)sender {
    [self performSegueWithIdentifier:@"ReqToSettings" sender:self];
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
    
    if ([[segue identifier] isEqualToString:@"ReqToSettings"]) {
        SettingsViewController *vcSett = [segue destinationViewController];
        vcSett.setIdentity = self.retrievedID;
    }
    if ([[segue identifier] isEqualToString:@"pinReqToappBlock"]) {
        RegistrationCodeViewController *regVC = [segue destinationViewController];
        regVC.codeReuse = @"reset";
    }
    
}


@end
