//
//  ConnectionsListViewController.m
//  Swiss Trains
//
//  Created by Alain on 03.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsListViewController.h"

@interface ConnectionsListViewController ()

@end

@implementation ConnectionsListViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        //self.listTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, CONJRNTOPINFOBARHEIGHT, 320 - 80 - padding, self.view.frame.size.height - CONJRNTOPINFOBARHEIGHT - CONJRNBOTTOMINFOBARHEIGHT) style:UITableViewStylePlain];
        self.listTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        //self.listTableView.rowHeight = 50;
        //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.listTableView.separatorColor = [UIColor lightGrayColor];
        self.listTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
        //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
        [self.listTableView registerClass:[ConnectionsJourneyDetailDirectionsCell class] forCellReuseIdentifier: @"ConnectionsJourneyDetailDirectionsCell"];
        [self.listTableView registerClass:[ConnectionsJourneyDetailPasslistCell class] forCellReuseIdentifier: @"ConnectionsJourneyDetailPasslistCell"];
        [self.view addSubview: self.listTableView];
        self.listTableView.dataSource = self;
        self.listTableView.delegate = self;
        
        UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 10)];
        self.listTableView.tableFooterView = dummyFooterView;
        dummyFooterView.hidden = YES;
        
        //self.listTableView.alpha = 0.0;
    }
    return self;
}
*/
 
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor clearColor];
        
        //self.listTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, CONJRNTOPINFOBARHEIGHT, 320 - 80 - padding, self.view.frame.size.height - CONJRNTOPINFOBARHEIGHT - CONJRNBOTTOMINFOBARHEIGHT) style:UITableViewStylePlain];
        self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        //self.listTableView.rowHeight = 50;
        //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor lightGrayColor];
        
        //self.tableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        
        //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
        [self.tableView registerClass:[ConnectionsJourneyDetailDirectionsCelliPad class] forCellReuseIdentifier: @"ConnectionsJourneyDetailDirectionsCelliPad"];
        [self.tableView registerClass:[ConnectionsJourneyDetailPasslistCelliPad class] forCellReuseIdentifier: @"ConnectionsJourneyDetailPasslistCelliPad"];
        //[self.view addSubview: self.listTableView];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 10)];
        self.tableView.tableFooterView = dummyFooterView;
        dummyFooterView.hidden = YES;
        
        //self.listTableView.alpha = 0.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
    
    
}

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex {
    
    if (consecionIndex == 9999) {
        //NSLog(@"Set connectionAllTypeiPad");
        self.connectionIndex = connectionIndex;
        self.consectionIndex = consecionIndex;
        self.selectedConsectionType = consectionAllTypeiPad;
        
        //NSLog(@"Set types and indexes: type: %d / overview: %d / detail: %d", self.selectedConsectionType, self.connectionIndex, self.consectionIndex);
        
    } else {
        //NSLog(@"Journey detail: set connection and consection index: %d, %d", connectionIndex, consecionIndex);
        self.connectionIndex = connectionIndex;
        self.consectionIndex = consecionIndex;
                
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
        NSUInteger journeyTypeFlag = [conSection conSectionType];
                        
        if (journeyTypeFlag == walkType) {
            self.selectedConsectionType = consectionWalkTypeiPad;
        } else if (journeyTypeFlag == journeyType) {
            self.selectedConsectionType = conSectionJourneyTypeiPad;
        }
        
        //NSLog(@"Set types and indexes: type: %d / overview: %d / detail: %d", self.selectedConsectionType, self.connectionIndex, self.consectionIndex);
        
        //NSLog(@"Set type: %@", (self.selectedConsectionType==consectionWalkTypeiPad)?@"WALK":@"JOURNEY");
    }

    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];

}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.selectedConsectionType == consectionAllTypeiPad) {
        //NSLog(@"List view. All connection number of sections. %d", [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.connectionIndex]);
        return [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.connectionIndex];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Nums of rows: %@", (self.selectedConsectionType==consectionWalkTypeiPad)?@"WALK":@"JOURNEY");
    //NSLog(@"Set types and indexes: type: %d / overview: %d / detail: %d", self.selectedConsectionType, self.connectionIndex, self.consectionIndex);
    
    if (self.selectedConsectionType == consectionAllTypeiPad) {
        ConSection *conSection =  [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: section];
        NSArray *stationsList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection: conSection];
        //NSLog(@"List view. All connection number of rows. %d", [stationsList count]);
        return [stationsList count];
    } else {
        if (self.selectedConsectionType == consectionWalkTypeiPad) {
            //NSLog(@"List view. Walk. check map view reference");
            if (self.mapViewControllerReference.mapView.directionsOverlay.activeRoute != nil) {
                //NSLog(@"List view. Walk. %d", [self.mapViewControllerReference.mapView.directionsOverlay.activeRoute.maneuvers count]);
                return [self.mapViewControllerReference.mapView.directionsOverlay.activeRoute.maneuvers count];
            }
        } else if (self.selectedConsectionType == conSectionJourneyTypeiPad) {
            //NSLog(@"List view. Joury. check sbb api reference");
            //ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: self.connectionIndex];
            //ConSection *conSection = [[[conResult conSectionList] conSections] objectAtIndex: self.consectionIndex];
            
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
            NSArray *stationsList = [[SBBAPIController sharedSBBAPIController] getStationsForConsection: conSection];
            //NSLog(@"List view. Jounrey. %d", [stationsList count]);
            return [stationsList count];
        }
        
    }
    
    return 0;
}

- (NSString *) shortenStationNameIfTooLong:(NSString *)stationName maxLenth:(NSUInteger)maxLength {
    if (!stationName) return  nil; if (maxLength == 0) return  nil;
    NSString *shortenStationName;
    if ([stationName length] > maxLength) {
        shortenStationName = [stationName substringToIndex: maxLength - 3];
        return [NSString stringWithFormat:@"%@...", shortenStationName];
    }
    return stationName;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"Configure cell");
    //NSLog(@"Set types and indexes: type: %d / overview: %d / detail: %d", self.selectedConsectionType, self.connectionIndex, self.consectionIndex);
    
    if (self.selectedConsectionType == consectionAllTypeiPad) {
        //NSLog(@"Configure cell: all type");
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: indexPath.section];
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:conSection];
        
        NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        NSString *platform = [[SBBAPIController sharedSBBAPIController] getPlatformForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        
        ConnectionsJourneyDetailPasslistCelliPad *passlistcell = (ConnectionsJourneyDetailPasslistCelliPad *)cell;
        
        passlistcell.arrivalTimeLabel.text = arrivalTime;
        passlistcell.departureTimeLabel.text = departureTime;
        
        if (platform && ([platform length] > 0)) {
            //[passlistcell shortenStationNameLabelIfTrackInfo];
            [passlistcell prolongStationNameLabelIfNoTrackInfo];
            passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 28];
        } else {
            [passlistcell prolongStationNameLabelIfNoTrackInfo];
            passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 32];
        }
        
        passlistcell.trackLabel.text = platform;
        
        //NSLog(@"Platform: %@", platform);
        //NSString *arrTime4 = [arrivalTime substringToIndex: 1];
        //NSString *depTime4 = [departureTime substringToIndex: 1];
        //NSLog(@"arr, dep 4: %@, %@", arrTime4, depTime4);
        
        if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
            passlistcell.oneTimeLabel.text = departureTime;
            passlistcell.arrivalTimeLabel.text = nil;
            passlistcell.departureTimeLabel.text = nil;
        } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
            passlistcell.oneTimeLabel.text = arrivalTime;
            passlistcell.arrivalTimeLabel.text = nil;
            passlistcell.departureTimeLabel.text = nil;
        } else {
            if (!arrivalTime && departureTime) {
                passlistcell.oneTimeLabel.text = departureTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (arrivalTime && !departureTime) {
                passlistcell.oneTimeLabel.text = arrivalTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (!arrivalTime && !departureTime) {
                passlistcell.oneTimeLabel.text = nil;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (arrivalTime && departureTime) {
                if ([arrivalTime isEqualToString:departureTime]) {
                    passlistcell.oneTimeLabel.text = departureTime;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else {
                    passlistcell.oneTimeLabel.text = nil;
                    passlistcell.arrivalTimeLabel.text = arrivalTime;
                    passlistcell.departureTimeLabel.text = departureTime;
                }
            }
        }
        
        BOOL topLine = NO; BOOL bottomLine = NO;
        
        if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
            topLine = NO; bottomLine = YES;
        } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
            topLine = YES; bottomLine = NO;
        } else if ((indexPath.row == 0) && (indexPath.row == ([basicStopList count] - 1))) {
            topLine = NO; bottomLine = NO;
        } else {
            topLine = YES; bottomLine = YES;
        }
        
        UIImage *passlistImage = [[SBBAPIController sharedSBBAPIController] renderPasslistImageWithSize:CGSizeMake(30, 50)  topLine: topLine bottomLine: bottomLine];
        [passlistcell.passlistImage setImage: passlistImage];
        
        //NSLog(@"Configure cell: all type. end.");
        
    } else {
        if (self.selectedConsectionType == consectionWalkTypeiPad) {
            //NSLog(@"Configure cell: walk type");
            if ([cell isKindOfClass: [ConnectionsJourneyDetailDirectionsCelliPad class]]) {
                if (self.mapViewControllerReference.mapView.directionsOverlay.activeRoute != nil) {
                    ConnectionsJourneyDetailDirectionsCelliPad *directionscell = (ConnectionsJourneyDetailDirectionsCelliPad *)cell;
                    MTDManeuver *maneuver = [self.mapViewControllerReference.mapView.directionsOverlay.activeRoute.maneuvers objectAtIndex:indexPath.row];
                    directionscell.maneuver = maneuver;
                }
            }
            //NSLog(@"Configure cell: walk type. end.");
        } else if (self.selectedConsectionType == conSectionJourneyTypeiPad) {
            //NSLog(@"Configure cell: journey type");
            //ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: self.connectionIndex];
            //ConSection *conSection = [[[conResult conSectionList] conSections] objectAtIndex: self.consectionIndex];
            
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
            NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:conSection];
            
            NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            NSString *platform = [[SBBAPIController sharedSBBAPIController] getPlatformForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            
            ConnectionsJourneyDetailPasslistCelliPad *passlistcell = (ConnectionsJourneyDetailPasslistCelliPad *)cell;
            
            if (platform && ([platform length] > 0)) {
                //[passlistcell shortenStationNameLabelIfTrackInfo];
                [passlistcell prolongStationNameLabelIfNoTrackInfo];
                passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 28];
            } else {
                [passlistcell prolongStationNameLabelIfNoTrackInfo];
                passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 32];
            }
            
            //passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong:stationName maxLenth: 22];
            
            passlistcell.arrivalTimeLabel.text = arrivalTime;
            passlistcell.departureTimeLabel.text = departureTime;
            passlistcell.trackLabel.text = platform;
            
            //NSString *arrTime4 = [arrivalTime substringToIndex: 1];
            //NSString *depTime4 = [departureTime substringToIndex: 1];
            //NSLog(@"arr, dep 4: %@, %@", arrTime4, depTime4);
            
            if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
                passlistcell.oneTimeLabel.text = departureTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
                passlistcell.oneTimeLabel.text = arrivalTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else {
                if (!arrivalTime && departureTime) {
                    passlistcell.oneTimeLabel.text = departureTime;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else if (arrivalTime && !departureTime) {
                    passlistcell.oneTimeLabel.text = arrivalTime;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else if (!arrivalTime && !departureTime) {
                    passlistcell.oneTimeLabel.text = nil;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else if (arrivalTime && departureTime) {
                    if ([arrivalTime isEqualToString:departureTime]) {
                        passlistcell.oneTimeLabel.text = departureTime;
                        passlistcell.arrivalTimeLabel.text = nil;
                        passlistcell.departureTimeLabel.text = nil;
                    } else {
                        passlistcell.oneTimeLabel.text = nil;
                        passlistcell.arrivalTimeLabel.text = arrivalTime;
                        passlistcell.departureTimeLabel.text = departureTime;
                    }
                }
            }
            
            BOOL topLine = NO; BOOL bottomLine = NO;
            
            if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
                topLine = NO; bottomLine = YES;
            } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
                topLine = YES; bottomLine = NO;
            } else if ((indexPath.row == 0) && (indexPath.row == ([basicStopList count] - 1))) {
                topLine = NO; bottomLine = NO;
            } else {
                topLine = YES; bottomLine = YES;
            }
            
            UIImage *passlistImage = [[SBBAPIController sharedSBBAPIController] renderPasslistImageWithSize:CGSizeMake(30, 50)  topLine: topLine bottomLine: bottomLine];
            [passlistcell.passlistImage setImage: passlistImage];
            
            //NSLog(@"Configure cell: journey type. end.");
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedConsectionType == consectionWalkTypeiPad) {
        //NSLog(@"Height for cell: walk type.");
        if (self.mapViewControllerReference.mapView.directionsOverlay.activeRoute != nil) {
            MTDManeuver *maneuver = [self.mapViewControllerReference.mapView.directionsOverlay.activeRoute.maneuvers objectAtIndex:indexPath.row];
            return [ConnectionsJourneyDetailDirectionsCelliPad neededHeightForManeuver:maneuver constrainedToWidth:tableView.bounds.size.width];
        }
    }
    //NSLog(@"Height for cell: all other.");
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.selectedConsectionType == consectionAllTypeiPad) {
        //NSLog(@"Cell for index: alltype");
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailPasslistCelliPad"];
    } else if (self.selectedConsectionType == consectionWalkTypeiPad) {
        //NSLog(@"Cell for index: walktype");
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailDirectionsCelliPad"];
    } else if (self.selectedConsectionType == conSectionJourneyTypeiPad) {
        //NSLog(@"Cell for index: journeytype");
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailPasslistCelliPad"];
    }
    
    /*
    if (!cell) {
        NSLog(@"Cell is nil");
    }
    */ 
    //NSLog(@"Cell for index: configure cell");
    
    [self configureCell: cell atIndexPath:indexPath];
    
    //NSLog(@"Cell for index: return cell");
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CONJRNTOPINFOBARHEIGHT;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //NSLog(@"View for header in section: %d", section);
    
    //float padding = -25;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, CONJRNTOPINFOBARHEIGHT)];
    //headerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    headerView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.6f];
    headerView.userInteractionEnabled = NO;
    
    UIImageView *topInfoTransportTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    //topInfoTransportTypeImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    topInfoTransportTypeImageView.backgroundColor = [UIColor clearColor];
    topInfoTransportTypeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:topInfoTransportTypeImageView];
    
    UIImageView *topInfoTransportNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 80 - 8, 13, 80, 20)];
    //topInfoTransportNameImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    topInfoTransportNameImageView.backgroundColor = [UIColor clearColor];
    topInfoTransportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:topInfoTransportNameImageView];
    
    ConSection *conSection;
    
    if (self.selectedConsectionType == consectionAllTypeiPad) {
        conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: section];
    } else {
        conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
    }
    
    UIImage *transportTypeImage = [[SBBAPIController sharedSBBAPIController] renderTransportTypeImageForConsection: conSection];
    UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForConsection: conSection];
    
    
    [topInfoTransportTypeImageView setImage: transportTypeImage];
    [topInfoTransportNameImageView setImage: transportNameImage];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

// override to support editing the table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
