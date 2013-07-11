//
//  DABSquaredAnalogClock.h
//  AnalogClockWithImages
//
//  Created by DABSquared on 07/11/2013.
//  Copyright 2013 www.dabsquared.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const DABSquaredAnalogClockViewClockFace;
extern NSString * const DABSquaredAnalogClockViewHourHand;
extern NSString * const DABSquaredAnalogClockViewMinuteHand;
extern NSString * const DABSquaredAnalogClockViewSecondHand;
extern NSString * const DABSquaredAnalogClockViewCenterCap;

typedef enum {
    DABSquaredAnalogClockViewOptionNone        = 1 << 0, // Default to DABSquaredAnalogClockViewOptionSmoothHands
    DABSquaredAnalogClockViewOptionSmoothHands = 1 << 1, // Makes the second hand move in one continous smooth motion
    DABSquaredAnalogClockViewOptionClunkyHands = 1 << 2, // Makes the second hand move more like a classic analog clock
    DABSquaredAnalogClockViewOptionShowTitle = 1 << 3, // shows the Titlelabel

} DABSquaredAnalogClockViewOption;

@interface DABSquaredAnalogClockView : UIView

@property (nonatomic, strong) UIImage *secondHandImage;
@property (nonatomic, strong) UIImage *minuteHandImage;
@property (nonatomic, strong) UIImage *hourHandImage;
@property (nonatomic, strong) UIImage *centerCapImage;
@property (nonatomic, strong) UIImage *clockFaceImage;
@property (nonatomic, strong) NSDate *clockTime;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UILabel *clockTitleLabel;
@property (nonatomic, strong) NSString *clockTitle;



- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andImages:(NSDictionary *)images;
- (id)initWithFrame:(CGRect)frame andImages:(NSDictionary *)images withOptions:(DABSquaredAnalogClockViewOption)options;
- (void)start;
- (void)stop;
- (void)updateClockTimeAnimated:(BOOL)animated;
- (void)updateClockWithTime:(NSDate *)time animated:(BOOL)animated;

@end
