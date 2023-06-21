//
//  StationboardListViewController.h
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

//#import "ConnectionsJourneyDetailDirectionsCell.h"
#import "ConnectionsJourneyDetailPasslistCelliPad.h"

#import "SBBAPIController.h"

#import "MBProgressHUD.h"

#import "Config.h"

#import "UIApplication+AppDimension.h"

//#import "UIActionSheet+Blocks.h"
//#import "ConnectionsMapViewController.h"

@interface StationboardListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (void) updateJourneyTableView;

@end
