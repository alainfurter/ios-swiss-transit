//
//  DateAndTimePickerController.m
//  Swiss Trains
//
//  Created by Alain on 05.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "DateAndTimePickerController.h"

//#define VIEWHEIGHT 286.0
#define VIEWHEIGHT 256.0
#define BUTTONHEIGHT 36.0
#define SEGMENTHEIGHT 18.0

@interface DateAndTimePickerController ()

@end

@implementation DateAndTimePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        CGRect saveFrame = self.view.frame;
        CGRect newFrame = CGRectMake(0, saveFrame.size.height - VIEWHEIGHT, saveFrame.size.width, VIEWHEIGHT);
        self.view.frame = newFrame;
        
        self.goButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *goButtonImage = [UIImage newImageFromMaskImage: [UIImage goButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        UIImage *goButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage goButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        [self.goButton setImage: goButtonImage forState: UIControlStateNormal];
        [self.goButton setImage: goButtonImageHighlighted forState: UIControlStateHighlighted];
        self.goButton.imageView.contentMode = UIViewContentModeCenter;
        self.goButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.goButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.goButton.showsTouchWhenHighlighted = YES;
        [self.goButton addTarget: self action: @selector(takeNewRequestTime:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.goButton];
        
        self.timenowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *timenowButtonImage = [UIImage newImageFromMaskImage: [UIImage timenowButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        UIImage *timenowButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage timenowButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        [self.timenowButton setImage: timenowButtonImage forState: UIControlStateNormal];
        [self.timenowButton setImage: timenowButtonImageHighlighted forState: UIControlStateHighlighted];
        self.timenowButton.imageView.contentMode = UIViewContentModeCenter;
        self.timenowButton.frame = CGRectMake(5 + BUTTONHEIGHT + 20, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.timenowButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.timenowButton.showsTouchWhenHighlighted = YES;
        [self.timenowButton addTarget:self action: @selector(updatePickerWithTimeNow:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.timenowButton];
        
        /*
        self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
        //navSC.height = BUTTONHEIGHT;
        //CGRect navFrame = navSC.frame;
        //CGRect newNavFrame = CGRectMake(self.view.frame.size.width - navFrame.size.width * 2, 0, navFrame.size.width, navFrame.size.width);
        //navSC.frame = newNavFrame;
        UIImage *depImage =  [[UIImage journeyFromImage] resizedImage: CGSizeMake(SEGMENTHEIGHT, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
        UIImage *arrImage = [[UIImage journeyToImage] resizedImage: CGSizeMake(SEGMENTHEIGHT, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
        self.navSC.sectionImages = [NSArray arrayWithObjects: depImage, arrImage, nil];
        //navSC.sectionTitles = nil;
        self.navSC.changeHandler = ^(NSUInteger newIndex) {
            NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
        };
        self.navSC.center = CGPointMake(260, 20);
        //[self.view addSubview: self.navSC];
        [self.navSC setSelectedIndex: 0];
        */
        
        self.datePicker = [[UIDatePicker alloc] init];
        CGRect pickerFrame = self.datePicker.frame;
        pickerFrame.origin.x = 0;
        pickerFrame.origin.y = self.view.frame.size.height - pickerFrame.size.height;
        self.datePicker.frame = pickerFrame;
        [self.view addSubview: self.datePicker];
    }
    return self;
}

- (void) updatePickerWithTimeNow:(id)sender {
    //NSLog(@"Set time now");
    [self.datePicker setDate: [NSDate date] animated: YES];
}

- (void) takeNewRequestTime:(id)sender {
    //NSLog(@"Set time");
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateTimePickerOK:didPickDate:depArr:)])
	{
		//BOOL depArrSelection = (self.navSC.selectedIndex == 0)?YES:NO;
        //[self.delegate dateTimePickerOK:self didPickDate: self.datePicker.date depArr: depArrSelection];
        [self.delegate dateTimePickerOK:self didPickDate: self.datePicker.date depArr: YES];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
