//
//  ConnectionsListViewController.h
//  Swiss Trains
//
//  Created by Alain on 03.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MTDirectionsKit/MTDirectionsKit.h>

#import "MTDJourneyParser.h"
#import "MTDJourneyRequest.h"

#import "StationAnnotation.h"
#import "StationsAnnotationView.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "ConnectionsJourneyDetailDirectionsCelliPad.h"
#import "ConnectionsJourneyDetailPasslistCelliPad.h"

#import "SBBAPIController.h"

#import "MBProgressHUD.h"

#import "Config.h"

#import "UIApplication+AppDimension.h"

#import "UIActionSheet+Blocks.h"

#import "ConnectionsMapViewController.h"

@interface ConnectionsListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

//@property (strong, nonatomic) UITableView *listTableView;

@property (assign) NSUInteger connectionIndex;
@property (assign) NSUInteger consectionIndex;
@property (assign) NSUInteger selectedConsectionType;

@property (weak) ConnectionsMapViewController *mapViewControllerReference;

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex;

@end
