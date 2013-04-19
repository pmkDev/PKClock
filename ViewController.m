//
//  ViewController.m
//  PKClock
//
//  Created by phil koulen on 07.03.13.
//  Copyright (c) 2013 phil koulen. All rights reserved.
//

#import "ViewController.h"
#import <math.h>

#define ANIMATE_TICK @"perform clock animated"

@interface ViewController ()

@end

@implementation ViewController
@synthesize minuteIV;
@synthesize secondIV ;
@synthesize hourIV;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:ANIMATE_TICK] == nil) {
        [defaults setBool:NO forKey:ANIMATE_TICK];
        [defaults synchronize];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //digital clock
    digitalClock                = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    digitalClock.autoresizingMask   = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    digitalClock.textAlignment  = NSTextAlignmentCenter;
    dateFormatter               = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM-dd-yyyy, HH:mm:ss"];
    NSDate *dateNow             = [NSDate date];
    digitalClock.text           = [dateFormatter stringFromDate:dateNow];
    [self.view addSubview:digitalClock];
    
    
    clock           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
    clock.autoresizingMask   = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    clock.frame     = CGRectMake(0, 0, 200, 200);
    clock.center    = self.view.center;
    [self.view addSubview:clock];
    
    hourIV        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hourHand"]];
    hourIV.frame  = CGRectMake(self.view.frame.size.width/2-25/2, self.view.frame.size.height/2-79/2, 25, 100);
    hourIV.center    = self.view.center;
    [self.view addSubview:hourIV];
    minuteIV        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minuteHand"]];
    minuteIV.frame  = CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-79/4*3, 50, 150);
    minuteIV.center    = self.view.center;
    [self.view addSubview:minuteIV];
     
    secondIV        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondHand"]];
    secondIV.frame  = CGRectMake(self.view.frame.size.width/2-102, self.view.frame.size.height/2-79, 200, 200);
    secondIV.center    = self.view.center;
    [self.view addSubview:secondIV];
    
    //UISwitch for animation
    UISwitch *animationSwitch           = [[UISwitch alloc] initWithFrame:CGRectZero];
    animationSwitch.frame               = CGRectMake(CGRectGetMidX(self.view.frame)- animationSwitch.frame.size.width/2, self.view.frame.size.height-40, animationSwitch.frame.size.width, animationSwitch.frame.size.height);
    animationSwitch.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

    [animationSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:ANIMATE_TICK]];
    [animationSwitch addTarget:self action:@selector(changeToAnimate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:animationSwitch];
   
    
    NSTimer *secondTimer    = [NSTimer timerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(updateClock:)
                                                    userInfo:nil
                                                     repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:secondTimer forMode: NSDefaultRunLoopMode];
    
    //update even before it is visible
    [self updateClock:nil];
}

- (void)updateClock:(NSTimer *)timer{
    //update my digital clock
    [self setDigitalClock];
    
    NSDateFormatter *formatter      = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH mm ss"];
    NSDate *dateNow                 = [NSDate date];
    NSArray *timeArray              = [[formatter stringFromDate:dateNow] componentsSeparatedByString:@" "];
    int seconds                     = [[timeArray objectAtIndex:2] intValue];
    int minutes                     = [[timeArray objectAtIndex:1] intValue];
    int hours                       = [[timeArray objectAtIndex:0] intValue];
    
    //initialize the timer
    CGFloat duration = 0.0;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:ANIMATE_TICK]) {
        duration = .8f;
    }
    [UIView animateWithDuration:duration
                     animations:^(void){
                         //set secondHand pro sek aktualisieren
                         [self setSecondHandWithDegrees:seconds];
                         
                         //set minuteHand
                         //1sek später ausführen
                         [self setMinuteHandWithDegrees:minutes];
                         
                         //set hourHand
                         [self setHourHandWithHour:hours andMinutes:minutes];
                     }];

    
}

- (void)setDigitalClock{
    NSDate *dateNow             = [NSDate date];
    digitalClock.text           = [dateFormatter stringFromDate:dateNow];
}

- (void)setSecondHandWithDegrees:(int)degrees{
    CGAffineTransform transform = CGAffineTransformMakeRotation(degrees * 6 * M_PI/180);
    self.secondIV.transform     = transform;
}
- (void)setMinuteHandWithDegrees:(int)degrees{
    CGAffineTransform transform = CGAffineTransformMakeRotation(degrees * 6 * M_PI/180);
    self.minuteIV.transform     = transform;
}
- (void)setHourHandWithHour:(int)hours andMinutes:(int)minutes{
    float rot = minutes * 6 /12 ;
    CGAffineTransform transform = CGAffineTransformMakeRotation(hours * 360 / 60 * 5 * M_PI/180 + rot *M_PI/180 );
    self.hourIV.transform     = transform;
}

#pragma mark - switch
- (void)changeToAnimate:(UISwitch *)theSwitch{
    BOOL animate = [[NSUserDefaults standardUserDefaults] boolForKey:ANIMATE_TICK];
    animate = !animate;
 
    [[NSUserDefaults standardUserDefaults] setBool:animate forKey:ANIMATE_TICK];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - rotation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    CGRect selfFrame = CGRectZero;
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        selfFrame   = CGRectMake(0, 0, 320, 460);
    }else{
        selfFrame   = CGRectMake(0, 0, 480, 300);
    }
    
    clock.center    = CGPointMake(CGRectGetMidX(selfFrame), CGRectGetMidY(selfFrame));
    hourIV.center   = CGPointMake(CGRectGetMidX(selfFrame), CGRectGetMidY(selfFrame));
    minuteIV.center = CGPointMake(CGRectGetMidX(selfFrame), CGRectGetMidY(selfFrame));
    secondIV.center = CGPointMake(CGRectGetMidX(selfFrame), CGRectGetMidY(selfFrame));
}

@end
















