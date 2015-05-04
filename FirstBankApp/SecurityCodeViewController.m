//
//  SecurityCodeViewController.m
//  FirstBankApp
//
//  Created by Gedu Technologies on 12/16/14.
//  Copyright (c) 2014 Gedu Technologies. All rights reserved.
//

#import "SecurityCodeViewController.h"
NSInteger timeRemaining = 29;
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
    /*self.navigationController.toolbarHidden=NO;
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];*/
    /*UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];*/
    
    /*UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:35.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];*/
    
    /*UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];*/
    
    /*NSArray *items = [NSArray arrayWithObjects:flexiableItem, settingsButton, nil];
    self.toolbarItems = items;*/
    
    
    OTP = [SecurityCodeViewController getOtpForIdentity:getIdentity];
    [_showOTP setText:OTP];
    [self countdownTimer];
    timeRemaining = 29;
    
   /*UISwipeGestureRecognizer *swipeUp= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUp];*/
    
    
    
    
    
    //[self resetIdleTimer];
    
    /*if (timingout<=0) {
        timeRemaining=29;
    }else{
        timeRemaining = timingout;
    }*/
    
    
    // Do any additional setup after loading the view.
}

-(void) viewDidDisappear:(BOOL)animated {
    
    
    [super viewDidDisappear:YES];
        //[self.timer invalidate];
        //[self.idleTimer invalidate];
    //self.timer=nil;
    
   
    //[self.idleTimer invalidate];
    //self.idleTimer=nil;
    
    //New timer to calculate after time out
    
   // self.timeout = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounted:) userInfo:nil repeats:YES];
    
    
}


/*- (void)handleSwipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController setToolbarHidden:NO];
}*/

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    timeRemaining = 29;
    
    /*
    if (timingout<=0) {
        timeRemaining=29;
    }else{
        timeRemaining = timingout;
    }*/

}

- (void)viewWillDisappear:(BOOL)animated {
   // [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
    //    [self.timer invalidate];
      //  [self.idleTimer invalidate];
    //self.timer=nil;
    
    //[self.idleTimer invalidate];
    //self.idleTimer=nil;
   // self.timeout = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounted:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*- (void)resetIdleTimer {
    if (!self.idleTimer) {
        self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                                                      target:self
                                                    selector:@selector(idleTimerExceeded)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    else {
        if (fabs([self.idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds-1.0) {
            [self.idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}

- (void)idleTimerExceeded {
    //[self resetIdleTimer];
    [self.timer invalidate];
    self.timer=nil;
    [self.idleTimer invalidate];
    self.idleTimer=nil;
        //[self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"SecToReq" sender:self];
    [self.navigationController popViewControllerAnimated:NO];

    //[self dismissViewControllerAnimated:YES completion:nil];


    
    //[self.storyboard instantiateViewControllerWithIdentifier:@"pinReq"];
}
*/



+ (NSString *) getOtpForIdentity:(ETIdentity *)identity {
    return [identity getOTP:[NSDate date]];
}


- (void)updateCounter:(NSTimer *)theTimer {
    if(timeRemaining > 0 ){
        timeRemaining -- ;
        //timingout = timeRemaining;
        
        _showTimer.text = [NSString stringWithFormat:@"%lds", (long)timeRemaining];
        
    }else if (timeRemaining == 0){
        /*_showTimer.text = @"29s";
        OTP = [SecurityCodeViewController getOtpForIdentity:getIdentity];
        [_showOTP setText:OTP];
        timeRemaining = 29;*/
        [self.timer invalidate];
        self.timer=nil;
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"SecToReq" sender:self];
        [self.navigationController popViewControllerAnimated:NO];    }
    }



/*- (void)updateCounted:(NSTimer *)theTimer {
    
    timingout--;
    
}*/



-(void) countdownTimer{
    /**if([timer isValid])
    {
        [timer release];
    }**/
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    /*CGRect frame = CGRectMake(60, 360, 200, 150);
    cpw = [[CircularProgressView alloc] initWithFrame:frame];
    cpw.percent = 100;
    [self.view addSubview: cpw];**/
}
- (IBAction)showSettings:(id)sender {
    [self.timer invalidate];
    self.timer=nil;
    [self performSegueWithIdentifier:@"SecToSettings" sender:self];
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
