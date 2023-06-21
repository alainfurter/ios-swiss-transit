//
//  ConnectionsListViewController.m
//  Swiss Trains
//
//  Created by Alain on 03.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "StationboardListViewController.h"

@interface StationboardListViewController ()

@end

@implementation StationboardListViewController

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
        //[self.tableView registerClass:[ConnectionsJourneyDetailDirectionsCell class] forCellReuseIdentifier: @"ConnectionsJourneyDetailDirectionsCell"];
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

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[SBBAPIController sharedSBBAPIController] journeyResult]) {
        Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
        NSArray *basicstopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
        //NSLog(@"Journey detail view. Jounrey. %d", [basicstopList count]);
        return [basicstopList count];
    }
    return  0;
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
    
    ConnectionsJourneyDetailPasslistCelliPad *passlistcell = (ConnectionsJourneyDetailPasslistCelliPad *)cell;
    
    Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
    NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
    
    NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
    NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
    NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
    NSString *platform = [[SBBAPIController sharedSBBAPIController] getPlatformForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
    
    //passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong:stationName maxLenth: 22];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConnectionsJourneyDetailPasslistCelliPad *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailPasslistCelliPad"];
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
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

- (void) updateJourneyTableView {
    //self.selectedStationboardJourney = index;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
