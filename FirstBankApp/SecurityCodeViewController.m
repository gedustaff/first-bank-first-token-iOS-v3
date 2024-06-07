//
//  SecurityCodeViewController.m
//  FirstBankApp
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "SecurityCodeViewController.h"
NSInteger timeRemaining = 30;
NSInteger timingout;
#define kMaxIdleTimeSeconds 15.0

@interface SecurityCodeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *showOTP;
@property (weak, nonatomic) IBOutlet UILabel *showTimer;


@end

@implementation SecurityCodeViewController
@synthesize getIdentity, timer, idleTimer, timeout;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    getIdentity = [SDKUtils loadIdentity];
    OTP = [SecurityCodeViewController getOtpForIdentity:getIdentity];
    
    _showOTP.numberOfLines = 1;
    _showOTP.minimumScaleFactor = 10./_showOTP.font.pointSize;
    _showOTP.adjustsFontSizeToFitWidth = YES;
    
    [_showOTP setText:OTP];
    [self countdownTimer];
    timeRemaining = 30;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    timeRemaining = 30;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)copyPIN:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = OTP;
    
    NSString *message = @"PIN Copied";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    int duration = 1; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

+ (NSString *) getOtpForIdentity:(ETIdentity *)identity {
    return [identity getOTP:[NSDate date]];
}


- (void)updateCounter:(NSTimer *)theTimer {
    if(timeRemaining > 0 ){
        timeRemaining -- ;
        _showTimer.text = [NSString stringWithFormat:@"%lds", (long)timeRemaining];
        
    }else if (timeRemaining == 0){
        
        [self.timer invalidate];
        self.timer=nil;
        [self performSegueWithIdentifier:@"SecToReq" sender:self];
        
    }
}

-(void) countdownTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
   
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"SecToSettings"]) {
        SettingsViewController *vcSett = [segue destinationViewController];
        vcSett.setIdentity = self.getIdentity;
    }
}


@end
