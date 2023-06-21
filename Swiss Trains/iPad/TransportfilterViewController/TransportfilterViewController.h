//
//  TransportfilterViewController.h
//  Swiss Trains
//
//  Created by Alain on 30.03.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRTableViewCell.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

@interface TransportfilterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *productsstring;
@property (nonatomic, strong) NSArray *productimagenames;
@property (nonatomic, strong) NSArray *productimagetitles;
@property (nonatomic, strong) NSArray *productimagetexts;
@property (nonatomic, strong) NSMutableArray *productflags;

@end
