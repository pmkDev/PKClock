//
//  ViewController.h
//  PKClock
//
//  Created by phil koulen on 07.03.13.
//  Copyright (c) 2013 phil koulen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController{
    UIImageView *clock;
    UIImageView *hourIV;
    UIImageView *minuteIV;
    UIImageView *secondIV;
    UILabel *digitalClock;
    
    NSDateFormatter *dateFormatter;
}
@property (retain, nonatomic) UIImageView *hourIV;
@property (retain, nonatomic) UIImageView *minuteIV;
@property (retain, nonatomic) UIImageView *secondIV;

@end
