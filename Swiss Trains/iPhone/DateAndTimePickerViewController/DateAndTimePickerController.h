//
//  DateAndTimePickerController.h
//  Swiss Trains
//
//  Created by Alain on 05.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSegmentedControl.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

@class DateAndTimePickerController;

@protocol DateTimePickerDelegate <NSObject>

- (void)dateTimePickerOK:(DateAndTimePickerController *)controller didPickDate:(NSDate *)date depArr:(BOOL)depArr;
- (void)dateTimePickerCancel:(DateAndTimePickerController *)controller;

@end

@interface DateAndTimePickerController : UIViewController

@property (weak) id < DateTimePickerDelegate > delegate;

@property (strong, nonatomic) NSDate *defaultDate;
@property (strong, nonatomic) UIDatePicker *datePicker;

//@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (strong, nonatomic) UIButton *goButton;
@property (strong, nonatomic) UIButton *timenowButton;

- (void) updatePickerWithTimeNow:(id)sender;
- (void) takeNewRequestTime:(id)sender;

@end
