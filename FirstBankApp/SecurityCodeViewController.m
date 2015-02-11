//
//  SecurityCodeViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "SecurityCodeViewController.h"
int timeRemaining = 29;
#define kMaxIdleTimeSeconds 15.0

@interface SecurityCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showOTP;
@property (weak, nonatomic) IBOutlet UILabel *showTimer;


@end

@implementation SecurityCodeViewController
@synthesize getIdentity;



- (void)viewDidLoad {
    [super viewDidLoad];
    OTP = [SecurityCodeViewController getOtpForIdentity:getIdentity];
    [_showOTP setText:OTP];
    [self countdownTimer];
    [self resetIdleTimer];
    
    
    // Do any additional setup after loading the view.
}

-(void) viewDidDisappear:(BOOL)animated {
    
    
    [super viewDidDisappear:YES];
    
    if ([timer isValid]) {
        [timer invalidate];
        [idleTimer invalidate];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)resetIdleTimer {
    if (!idleTimer) {
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                                                      target:self
                                                    selector:@selector(idleTimerExceeded)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    else {
        if (fabs([idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds-1.0) {
            [idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}

- (void)idleTimerExceeded {
    [self resetIdleTimer];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"TimeOut" sender:self];
    
    //[self dismissViewControllerAnimated:YES completion:nil];


    
    //[self.storyboard instantiateViewControllerWithIdentifier:@"pinReq"];
}

- (UIResponder *)nextResponder {
    [self resetIdleTimer];
    return [super nextResponder];
}



+ (NSString *) getOtpForIdentity:(ETIdentity *)identity {
    return [identity getOTP:[NSDate date]];
}


- (void)updateCounter:(NSTimer *)theTimer {
    if(timeRemaining > 0 ){
        timeRemaining -- ;
        
        _showTimer.text = [NSString stringWithFormat:@"%ds", timeRemaining];
        
    }else if (timeRemaining == 0){
        _showTimer.text = @"29s";
        OTP = [SecurityCodeViewController getOtpForIdentity:getIdentity];
        [_showOTP setText:OTP];
        timeRemaining = 29;
    }
    }


-(void) countdownTimer{
    /**if([timer isValid])
    {
        [timer release];
    }**/
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    /*CGRect frame = CGRectMake(60, 360, 200, 150);
    cpw = [[CircularProgressView alloc] initWithFrame:frame];
    cpw.percent = 100;
    [self.view addSubview: cpw];**/
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
