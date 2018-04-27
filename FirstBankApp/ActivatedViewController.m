//
//  ActivatedViewController.m
//  FirstBankApp
//
//  Created by Dapsonco on 17/04/2018.
//  Copyright © 2018 Gedu Technologies. All rights reserved.
//

#import "ActivatedViewController.h"

@interface ActivatedViewController ()

@end

@implementation ActivatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self countdownTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCounter:(NSTimer *)theTimer {
    
        
        [self.timer invalidate];
        self.timer=nil;
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"activateTosecurity" sender:self];
    
}

-(void) countdownTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:NO];
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
