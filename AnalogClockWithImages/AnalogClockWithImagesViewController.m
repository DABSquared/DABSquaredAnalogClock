//
//  AnalogClockWithImagesViewController.m
//  AnalogClockWithImages
//
//  Created by DABSquared on 07/11/2013.
//  Copyright 2013 www.dabsquared.com. All rights reserved.
//

#import "AnalogClockWithImagesViewController.h"
#import "DABSquaredAnalogClockView.h"

@interface AnalogClockWithImagesViewController ()

@property (nonatomic, strong) DABSquaredAnalogClockView *clockView;

@end

@implementation AnalogClockWithImagesViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  /*
   * 4 different looks at instantiating the view
   */
  [self instantiateClockAndAddImagesAfterAndDoNotStartAnimation];
  
  [self instantiateClockAndAddImagesAfterWithSomeImagesMissing];
  
  [self instantiateClockUsingADictionaryOfImages];
  
  [self instantiateClockUsingADictionaryOfImagesAndOptionsForControllingSecondHandAnimation];
  
}


- (void)instantiateClockAndAddImagesAfterAndDoNotStartAnimation
{
  DABSquaredAnalogClockView *analogClock = [[DABSquaredAnalogClockView alloc] initWithFrame:CGRectMake(220, 20, 80, 80)];
  analogClock.clockFaceImage  = [UIImage imageNamed:@"clock"];
  analogClock.hourHandImage   = [UIImage imageNamed:@"clock_hour_hand"];
  analogClock.minuteHandImage = [UIImage imageNamed:@"clock_minute_hand"];
  analogClock.secondHandImage = [UIImage imageNamed:@"clock_second_hand"];
  analogClock.centerCapImage  = [UIImage imageNamed:@"clock_centre_point"];
  
  [self.view addSubview:analogClock];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateClock:)];
  [analogClock addGestureRecognizer:tap];
  
  self.clockView = analogClock;
  
  [analogClock updateClockTimeAnimated:YES];
}

- (void)updateClock:(id)sender
{
  [self.clockView updateClockTimeAnimated:YES];
}

- (void)instantiateClockAndAddImagesAfterWithSomeImagesMissing
{
  DABSquaredAnalogClockView *analogClock2 = [[DABSquaredAnalogClockView alloc] initWithFrame:CGRectMake(220, 138, 80, 80)];
  analogClock2.hourHandImage   = [UIImage imageNamed:@"clock_hour_hand"];
  analogClock2.minuteHandImage = [UIImage imageNamed:@"clock_minute_hand"];
  analogClock2.secondHandImage = [UIImage imageNamed:@"clock_second_hand"];
  analogClock2.centerCapImage  = [UIImage imageNamed:@"clock_centre_point"];
  
  [self.view addSubview:analogClock2];
  
  [analogClock2 start];
}

- (void)instantiateClockUsingADictionaryOfImages
{  
  DABSquaredAnalogClockView *analogClock3 = [[DABSquaredAnalogClockView alloc] initWithFrame:CGRectMake(220, 246, 80, 80) 
                                                                   andImages:[self images]];
  
  [self.view addSubview:analogClock3];
  
  [analogClock3 start];
}

- (void)instantiateClockUsingADictionaryOfImagesAndOptionsForControllingSecondHandAnimation
{
  DABSquaredAnalogClockView *analogClock4 = [[DABSquaredAnalogClockView alloc] initWithFrame:CGRectMake(220, 350, 80, 80) 
                                                                   andImages:[self images]
                                                                 withOptions:DABSquaredAnalogClockViewOptionClunkyHands|DABSquaredAnalogClockViewOptionShowTitle];
    [analogClock4 setClockTitle:@"hi"];
  [self.view addSubview:analogClock4];
  
  [analogClock4 start];
}

- (NSDictionary *)images
{
  return @{
            DABSquaredAnalogClockViewClockFace:  [UIImage imageNamed:@"clock"],
            DABSquaredAnalogClockViewHourHand:   [UIImage imageNamed:@"clock_hour_hand"],
            DABSquaredAnalogClockViewMinuteHand: [UIImage imageNamed:@"clock_minute_hand"],
            DABSquaredAnalogClockViewSecondHand: [UIImage imageNamed:@"clock_second_hand"],
            DABSquaredAnalogClockViewCenterCap:  [UIImage imageNamed:@"clock_centre_point"]
         };
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
