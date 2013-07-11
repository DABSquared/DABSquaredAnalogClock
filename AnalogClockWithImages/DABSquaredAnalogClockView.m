//
//  DABSquaredAnalogClock.m
//  AnalogClockWithImages
//
//  Created by DABSquared on 07/11/2013.
//  Copyright 2013 www.dabsquared.com. All rights reserved.
//

#import "DABSquaredAnalogClockView.h"

#define degreesToRadians(deg) (deg / 180.0 * M_PI)

NSString * const DABSquaredAnalogClockViewClockFace  = @"clock_face";
NSString * const DABSquaredAnalogClockViewHourHand   = @"hour_hand";
NSString * const DABSquaredAnalogClockViewMinuteHand = @"minute_hand";
NSString * const DABSquaredAnalogClockViewSecondHand = @"second_hand";
NSString * const DABSquaredAnalogClockViewCenterCap  = @"center_cap";

@interface DABSquaredAnalogClockView ()

@property (nonatomic, strong) NSTimer    *clockUpdateTimer;

@property (nonatomic, strong) UIImageView *secondHandImageView;
@property (nonatomic, strong) UIImageView *minuteHandImageView;
@property (nonatomic, strong) UIImageView *hourHandImageView;
@property (nonatomic, strong) UIImageView *clockFaceImageView;
@property (nonatomic, strong) UIImageView *centreCapImageView;

@property (nonatomic, assign) DABSquaredAnalogClockViewOption options;

@end

@implementation DABSquaredAnalogClockView

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame
{
  return [self initWithFrame:frame andImages:nil withOptions:DABSquaredAnalogClockViewOptionNone];
}

- (id)initWithFrame:(CGRect)frame andImages:(NSDictionary *)images
{
  return  [self initWithFrame:frame andImages:images withOptions:DABSquaredAnalogClockViewOptionNone];
}

- (id)initWithFrame:(CGRect)frame andImages:(NSDictionary *)images withOptions:(DABSquaredAnalogClockViewOption)options
{
  self = [super initWithFrame:frame];
  if (self) {
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _options  = options;
    
    CGRect imageViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    _clockFaceImageView  = [[UIImageView alloc] initWithFrame:imageViewFrame];
    _hourHandImageView   = [[UIImageView alloc] initWithFrame:imageViewFrame];
    _minuteHandImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    _secondHandImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    _centreCapImageView  = [[UIImageView alloc] initWithFrame:imageViewFrame];
    
    if (images) {
      self.clockFaceImage  = images[DABSquaredAnalogClockViewClockFace];
      self.hourHandImage   = images[DABSquaredAnalogClockViewHourHand];
      self.minuteHandImage = images[DABSquaredAnalogClockViewMinuteHand];
      self.secondHandImage = images[DABSquaredAnalogClockViewSecondHand];
      self.centerCapImage  = images[DABSquaredAnalogClockViewCenterCap];
      
      [self addImageViews];
    }
  }
  return self;
}

- (void)addImageViews
{
  NSArray *subViews = [self subviews];
  
  if (self.clockFaceImageView.image && ![subViews containsObject:self.clockFaceImageView]) {
    [self addSubview:self.clockFaceImageView];
  }
  if (self.hourHandImageView.image && ![subViews containsObject:self.hourHandImageView]) {
    [self addSubview:self.hourHandImageView];
  }
  if (self.minuteHandImageView.image && ![subViews containsObject:self.minuteHandImageView]) {
    [self addSubview:self.minuteHandImageView];
  }
  if (self.secondHandImageView.image && ![subViews containsObject:self.secondHandImageView]) {
    [self addSubview:self.secondHandImageView];
  }
  if (self.centreCapImageView.image && ![subViews containsObject:self.centreCapImageView]) {
    [self addSubview:self.centreCapImageView];
  }
}

#pragma mark - Start and Stop the clock

- (void)start
{
  if (self.clockUpdateTimer) {
    return;
  }
  
	self.clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(updateClockTimeAnimated:)
                                                         userInfo:nil
                                                          repeats:YES];
  [self updateClockTimeAnimated:NO];
}

- (void)stop
{
	[self.clockUpdateTimer invalidate]; self.clockUpdateTimer = nil;
}

- (void)updateClockWithTime:(NSDate *)time animated:(BOOL)animated
{
  [self addImageViews];
  
  self.clockTime = time;
  
  void (^updateClocks)(void) = ^ {
    [self updateHoursHand];
    [self updateMinutesHand];
    [self updateSecondsHand];
  };
  
  if (animated) {
    
    CGFloat duration           = 1.f;
    UIViewAnimationCurve curve = UIViewAnimationCurveLinear;
    
    if (DABSquaredAnalogClockViewOptionClunkyHands & self.options) {
      duration = 0.3f;
      curve    = UIViewAnimationCurveEaseOut;
    }
    
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:curve
                     animations:updateClocks
                     completion:nil];
  } else {
    updateClocks();
  }
}

- (void)updateClockTimeAnimated:(BOOL)animated
{
  [self addImageViews];
  
  self.clockTime = [NSDate date];
  
  void (^updateClocks)(void) = ^ {
    [self updateHoursHand];
    [self updateMinutesHand];
    [self updateSecondsHand];
  };
  
  if (animated) {
    
    CGFloat duration           = 1.f;
    UIViewAnimationCurve curve = UIViewAnimationCurveLinear;
    
    if (DABSquaredAnalogClockViewOptionClunkyHands & self.options) {
      duration = 0.3f;
      curve    = UIViewAnimationCurveEaseOut;
    }
    
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:curve
                     animations:updateClocks
                     completion:nil];
  } else {
    updateClocks();
  }
}

- (void)updateHoursHand
{
  if (!self.hourHandImage) {
    return;
  }
  
  int degreesPerHour   = 30;
  int degreesPerMinute = 0.5;
  
  int hours = [self hours];
  
  int hoursFor12HourClock = hours % 12;
  
  float rotationForHoursComponent  = hoursFor12HourClock * degreesPerHour;
  float rotationForMinuteComponent = degreesPerMinute * [self minutes];
  
  float totalRotation = rotationForHoursComponent + rotationForMinuteComponent;
  
  double hourAngle = degreesToRadians(totalRotation);
  
  self.hourHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, hourAngle);
}

- (void)updateMinutesHand
{
  if (!self.minuteHandImage) {
    return;
  }
  
  int degreesPerMinute = 6;
  
  double minutesAngle = degreesToRadians([self minutes] * degreesPerMinute);
  
  self.minuteHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, minutesAngle);
}

- (void)updateSecondsHand
{
  if (!self.secondHandImage) {
    return;
  }
  
  int degreesPerSecond = 6;
  
  double secondsAngle = degreesToRadians([self seconds] * degreesPerSecond);
  
  self.secondHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, secondsAngle);
}

- (int)hours
{
  return [[self.calendar components:NSHourCalendarUnit fromDate:self.clockTime] hour];
}

- (int)minutes
{
  return [[self.calendar components:NSMinuteCalendarUnit fromDate:self.clockTime] minute];
}

- (int)seconds
{
  return [[self.calendar components:NSSecondCalendarUnit fromDate:self.clockTime] second];;
}

#pragma mark - Setters + getters for adding clock images

- (void)setSecondHandImage:(UIImage *)secondHandImage
{
  self.secondHandImageView.image = secondHandImage;
}

- (UIImage *)secondHandImage
{
  return self.secondHandImageView.image;
}

- (void)setMinuteHandImage:(UIImage *)minuteHandImage
{
  self.minuteHandImageView.image = minuteHandImage;
}

- (UIImage *)minuteHandImage
{
  return self.minuteHandImageView.image;
}

- (void)setHourHandImage:(UIImage *)hourHandImage
{
  self.hourHandImageView.image = hourHandImage;
}

- (UIImage *)hourHandImage
{
  return  self.hourHandImageView.image;
}

- (void)setCenterCapImage:(UIImage *)centerCapImage
{
  self.centreCapImageView.image = centerCapImage;
}

- (UIImage *)centerCapImage
{
  return  self.centreCapImageView.image;
}

- (void)setClockFaceImage:(UIImage *)clockFaceImage
{
  self.clockFaceImageView.image = clockFaceImage;
}

- (UIImage *)clockFaceImage
{
  return self.clockFaceImageView.image;
}

@end
