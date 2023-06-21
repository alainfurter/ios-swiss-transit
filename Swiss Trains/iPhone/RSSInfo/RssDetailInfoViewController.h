//
//  RssDetailInfoViewController.h
//  Swiss Trains
//
//  Created by Alain on 21.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "StationsViewToolbar.h"

#import "RssInfoItem.h"

#import "Config.h"

@class RssHeaderView;

@interface RssDetailInfoViewController : UIViewController

@property (strong, nonatomic) UIWebView *descriptionDetailView;

@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;

@property (strong, nonatomic) UIButton *backButton;

@property (nonatomic, strong) NSString *rsshtmlsource;

- (void) loadDescriptionIntoDetailView:(RssInfoItem *)rssinfoitem;

-(void) forcePushBackToPreviousViewController;

@end


