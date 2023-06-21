//
//  ConnectionInfoViewController.h
//  Swiss Trains
//
//  Created by Alain on 28.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "ConnectionInfoCell.h"

#import "SBBAPIController.h"

@interface ConnectionInfoViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign) NSInteger selectedIndex;

- (void) updateConnectionInfoTableViewWithInfoFromConnectionWithIndex:(NSUInteger)index;

@end
