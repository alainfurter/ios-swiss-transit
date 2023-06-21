//
//  ConnectionsDetailViewController.m
//  Swiss Trains
//
//  Created by Alain on 06.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsDetailViewController.h"

@interface ConnectionsDetailViewController ()

@end

@implementation ConnectionsDetailViewController

- (id)initWithFrame:(CGRect)viewFrame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.frame = viewFrame;
        self.selectedIndex = -1;
        self.tableViewCellsAreSelectable = NO;
        self.trackNumberInCellsAreVisible = YES;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        //self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        self.view.backgroundColor = [UIColor connectionsDetailviewCellTopGradientColorNormal];
        
        self.detailViewTableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
        self.detailViewTableView.rowHeight = 142;
        //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.detailViewTableView.separatorColor = [UIColor lightGrayColor];
        //self.detailViewTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
        //self.detailViewTableView.backgroundColor = [UIColor clearColor];
        self.detailViewTableView.backgroundColor = [UIColor connectionsDetailviewCellTopGradientColorNormal];
        
        //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
        [self.detailViewTableView registerClass:[ConnectionsDetailviewCell class] forCellReuseIdentifier: @"ConnectionsDetailviewCell"];
        [self.detailViewTableView registerClass:[ConnectionInfoTableviewCell class] forCellReuseIdentifier: @"ConnectionInfoTableviewCell"];
        [self.view addSubview: self.detailViewTableView];
        self.detailViewTableView.dataSource = self;
        self.detailViewTableView.delegate = self;
        
        self.view.clipsToBounds = NO;
        self.view.layer.masksToBounds = NO;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.view.layer.shadowOpacity = 1.0f;
        self.view.layer.shadowRadius = 2.5f;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320-80, size.height - TOOLBARHEIGHT)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
}

- (void) adjustTableViewHeightWithRect:(CGRect)rect reload:(BOOL)reload {
    CGRect tableFrame = self.detailViewTableView.frame;
    tableFrame.size.height = rect.size.height;
    self.detailViewTableView.frame = tableFrame;
    if (reload) {
        [self.detailViewTableView reloadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedIndex = -1;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        self.trackNumberInCellsAreVisible = YES;
            
        self.detailViewTableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
        self.detailViewTableView.rowHeight = 142;
        //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.detailViewTableView.separatorColor = [UIColor lightGrayColor];
        //self.detailViewTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
        self.detailViewTableView.backgroundColor = [UIColor clearColor];
        //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
        [self.detailViewTableView registerClass:[ConnectionsDetailviewCell class] forCellReuseIdentifier: @"ConnectionsDetailviewCell"];
        [self.detailViewTableView registerClass:[ConnectionInfoTableviewCell class] forCellReuseIdentifier: @"ConnectionInfoTableviewCell"];
        [self.view addSubview: self.detailViewTableView];
        self.detailViewTableView.dataSource = self;
        self.detailViewTableView.delegate = self;
        
        UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 0)];
        self.detailViewTableView.tableFooterView = dummyFooterView;
        dummyFooterView.hidden = YES;
        
        self.view.clipsToBounds = NO;
        self.view.layer.masksToBounds = NO;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.view.layer.shadowOpacity = 1.0f;
        self.view.layer.shadowRadius = 2.5f;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) adjustForViewWillAppear {

}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (void) adjustForViewWillDisappear {

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.selectedIndex >=0) {
        NSUInteger connectionInfoCount = 0;
        if ([[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex]) {
            //NSLog(@"Connection infos, number of rowns: %d", [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex]);
            connectionInfoCount = [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex];
        }
        
        if (self.selectedIndex < [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults]) {
            //NSLog(@"Detail, number of rowns: %d", [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.selectedIndex]);
            return [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.selectedIndex] + connectionInfoCount;
                
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
    
    //NSLog(@"Configure detail cell for row: %d", indexPath.row);
    
    if ([cell isKindOfClass: [ConnectionsDetailviewCell class]]) {
        NSUInteger consectionsCount = [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.selectedIndex];
        
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.selectedIndex consectionIndex: indexPath.row];
        ConnectionsDetailviewCell *detailViewCell = (ConnectionsDetailviewCell *)cell;
        NSString *startStationName; NSString *endStationName;
        
        startStationName = [[SBBAPIController sharedSBBAPIController] getDepartureStationNameForConsection: conSection];
        endStationName = [[SBBAPIController sharedSBBAPIController] getArrivalStationNameForConsection: conSection];
        
        startStationName = [self shortenStationNameIfTooLong: startStationName maxLenth: 23];
        endStationName = [self shortenStationNameIfTooLong: endStationName maxLenth: 23];
        
        if (indexPath.row == 0) {
            NSString *betterStartName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: self.selectedIndex];
            startStationName = [self shortenStationNameIfTooLong: betterStartName maxLenth: 23];
            /*
             if ([startStationName isEqualToString: NSLocalizedString(@"Current location", @"Selectstationscontroller current location replacment for nil station name")]) {
             NSString *betterStartName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: self.selectedIndex];
             if (betterStartName) {
             startStationName = [self shortenStationNameIfTooLong: betterStartName maxLenth: 24];
             }
             }
             */
        }
        if (indexPath.row == (consectionsCount - 1)) {
            NSString *betterEndName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: self.selectedIndex];
            endStationName = [self shortenStationNameIfTooLong: betterEndName maxLenth: 23];
            /*
             if ([endStationName isEqualToString: NSLocalizedString(@"Current location", @"Selectstationscontroller current location replacment for nil station name")]) {
             NSString *betterEndName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: self.selectedIndex];
             if (betterEndName) {
             endStationName = [self shortenStationNameIfTooLong: betterEndName maxLenth: 24];
             }
             }
             */
        }
        
        detailViewCell.startStationLabel.text = startStationName;
        detailViewCell.endStationLabel.text = endStationName;
        
        
        //detailViewCell.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 24];
        //detailViewCell.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 24];
        
        detailViewCell.startTimeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: conSection];
        detailViewCell.endTimeLabel.text = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForConsection: conSection];
        
        NSUInteger journeyTypeFlag = [conSection conSectionType];
        
        if (self.trackNumberInCellsAreVisible) {
            [detailViewCell setJourneyTrackNumberVisibleState: YES];
        } else {
            [detailViewCell setJourneyTrackNumberVisibleState: NO];
        }
        
        if (journeyTypeFlag == walkType) {
            //detailViewCell.consectionImageType = walkType;
            NSString *walkDurationInfo = [[conSection walk] getFormattedDurationStringFromDuration];
            NSString *walkDistanceInfo = [NSString stringWithFormat:@"%@", [[conSection walk] getFormattedMetresStringFromDistance]];
            NSString *walkInfo = [NSString stringWithFormat:@"%@ / %@", walkDurationInfo, walkDistanceInfo];
            detailViewCell.transportInfoLabel.text = walkInfo;
            
            detailViewCell.transportCapacity1stLabel.text = nil;
            detailViewCell.transportCapacity2ndLabel.text = nil;
            [detailViewCell.transportCapacity1stImageView setImage: nil];
            [detailViewCell.transportCapacity2ndImageView setImage: nil];
            
            detailViewCell.startStationTrackLabel.text = nil;
            detailViewCell.endStationTrackLabel.text = nil;
            
            [detailViewCell setJourneyInfoImageStateVisible: NO];
            
            detailViewCell.startStationExpectedTrackLabel.text = nil;
            detailViewCell.endStationExpectedTrackLabel.text = nil;
            detailViewCell.startExpectedTimeLabel.text = nil;
            detailViewCell.endExpectedTimeLabel.text = nil;
            
            //NSLog(@"Configure detail cell for row: %d, type: WALK", indexPath.row);
        } else if ([conSection conSectionType] == journeyType) {
            //NSLog(@"Configure detail cell for row: %d, type: JOURNEY", indexPath.row);
            //detailViewCell.consectionImageType = journey;
            NSString *journeyDirectionString = [self shortenStationNameIfTooLong: [[conSection journey] journeyDirection] maxLenth: 20];
            detailViewCell.transportInfoLabel.text = journeyDirectionString;
            
            NSString *startTrack = [[SBBAPIController sharedSBBAPIController] getDeparturePlatformForConsection: conSection];
            NSString *endTrack = [[SBBAPIController sharedSBBAPIController] getArrivalPlatformForConsection: conSection];
            
            //NSLog(@"Start, endtrack: %@, %@", startTrack, endTrack);
            
            //detailViewCell.startStationTrackLabel.text = [NSString stringWithFormat: @"/ %@ %@", NSLocalizedString(@"Tr.", @"Track description string"), startTrack];
            //detailViewCell.endStationTrackLabel.text = [NSString stringWithFormat: @"/ %@ %@", NSLocalizedString(@"Tr.", @"Track description string"), endTrack];
            
            detailViewCell.startStationTrackLabel.text = startTrack;
            detailViewCell.endStationTrackLabel.text = endTrack;
            
            
            BOOL journeyIsDelayed = [[SBBAPIController sharedSBBAPIController] isJourneyDelayedForConsection: conSection];
            
            NSString *expectedStartTime = [[SBBAPIController sharedSBBAPIController] getExpectedDepartureTimeForConsection: conSection];
            NSString *expectedEndTime = [[SBBAPIController sharedSBBAPIController] getExpectedArrivalTimeForConsection: conSection];
            NSString *expectedDepPlatform = [[SBBAPIController sharedSBBAPIController] getExpectedDeparturePlatformForConsection: conSection];
            NSString *expectedArrPlatform = [[SBBAPIController sharedSBBAPIController] getExpectedArrivalPlatformForConsection: conSection];
            detailViewCell.startStationExpectedTrackLabel.text = expectedDepPlatform;
            detailViewCell.endStationExpectedTrackLabel.text = expectedArrPlatform;
            detailViewCell.startExpectedTimeLabel.text = expectedStartTime;
            detailViewCell.endExpectedTimeLabel.text = expectedEndTime;
            
            if (journeyIsDelayed && expectedStartTime && expectedEndTime) {
                [detailViewCell setJourneyInfoImageStateVisible: YES];
            } else {
                [detailViewCell setJourneyInfoImageStateVisible: NO];
            }
            
            NSNumber *capacity1st = [[SBBAPIController sharedSBBAPIController] getCapacity1stForConsection: conSection];
            NSNumber *capacity2nd = [[SBBAPIController sharedSBBAPIController] getCapacity2ndForConsection: conSection];
            
            if (capacity1st && capacity2nd) {
                
                BOOL firstok = ([capacity1st integerValue] >= 0 && [capacity1st integerValue] <= 3);
                BOOL secondok = ([capacity2nd integerValue] >= 0 && [capacity2nd integerValue] <= 3);
                
                if (firstok && secondok) {
                    //NSLog(@"Capacities: %d, %d", [capacity1st integerValue], [capacity2nd integerValue]);
                    detailViewCell.transportCapacity1stLabel.text = @"1.";
                    detailViewCell.transportCapacity2ndLabel.text = @"2.";
                    UIImage *capacity1stimage = [[UIImage trainCapacityImage: capacity1st] resizedImage: CGSizeMake(10, 8) interpolationQuality:kCGInterpolationDefault];
                    UIImage *capacity2ndimage = [[UIImage trainCapacityImage: capacity2nd] resizedImage: CGSizeMake(10, 8) interpolationQuality:kCGInterpolationDefault];
                    //if (capacity1stimage && capacity2ndimage) {
                    //    NSLog(@"Capacity image set");
                    //}
                    [detailViewCell.transportCapacity1stImageView setImage: capacity1stimage];
                    [detailViewCell.transportCapacity2ndImageView setImage: capacity2ndimage];
                    detailViewCell.transportInfoLabel.text = nil;
                } else {
                    detailViewCell.transportCapacity1stLabel.text = nil;
                    detailViewCell.transportCapacity2ndLabel.text = nil;
                    [detailViewCell.transportCapacity1stImageView setImage: nil];
                    [detailViewCell.transportCapacity2ndImageView setImage: nil];
                }
                
            } else {
                detailViewCell.transportCapacity1stLabel.text = nil;
                detailViewCell.transportCapacity2ndLabel.text = nil;
                [detailViewCell.transportCapacity1stImageView setImage: nil];
                [detailViewCell.transportCapacity2ndImageView setImage: nil];
            }
        }
        
        //UIColor *transportColor = [[SBBAPIController sharedSBBAPIController] getTransportColorWithConsection: conSection];
        
        //NSUInteger consectionsCount = [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.selectedIndex];
        
        BOOL topLine = NO; BOOL bottomLine = NO;
        if ((indexPath.row == 0) && !(indexPath.row == (consectionsCount - 1))) {
            topLine = NO; bottomLine = YES;
        } else if (!(indexPath.row == 0) && indexPath.row == (consectionsCount - 1)) {
            topLine = YES; bottomLine = NO;
        } else if ((indexPath.row == 0) && (indexPath.row == (consectionsCount - 1))) {
            topLine = NO; bottomLine = NO;
        } else {
            topLine = YES; bottomLine = YES;
        }
        
        UIImage *transportTypeImage = [[SBBAPIController sharedSBBAPIController] renderTransportTypeImageForConsection: conSection];
        UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForConsection: conSection];
        UIImage *transportConnectionImage = [[SBBAPIController sharedSBBAPIController] renderTransportConnectionImageForConsection: conSection size: CGSizeMake(40, 142) topLine:topLine bottomLine: bottomLine];
        
        [detailViewCell.transportTypeImageView setImage: transportTypeImage];
        [detailViewCell.transportNameImageView setImage: transportNameImage];
        [detailViewCell.transportConnectionImageView setImage: transportConnectionImage];
        
        if (self.tableViewCellsAreSelectable) {
            [detailViewCell setSelectableState: YES];
        } else {
            [detailViewCell setSelectableState: NO];
        }
        
        [detailViewCell setNeedsDisplay];
        [detailViewCell setNeedsLayout];
        
    } else if ([cell isKindOfClass: [ConnectionInfoTableviewCell class]]) {
        
        NSUInteger connectionInfoCount = [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex];
        NSUInteger rowCount = [self tableView: self.detailViewTableView numberOfRowsInSection: 0];
        NSUInteger firstInfoRow = rowCount - connectionInfoCount;
        NSUInteger indexPathRowToConnectionInfoTranslation = indexPath.row - firstInfoRow;
    
        ConnectionInfo *connectionInfo = [[SBBAPIController sharedSBBAPIController] getConnectioninfoForConnectionResultWithIndexAndConnectioninfoIndex: self.selectedIndex infoIndex: indexPathRowToConnectionInfoTranslation];
        ConnectionInfoTableviewCell *connectionInfoCell = (ConnectionInfoTableviewCell *)cell;
        
#if LOGOUTPUTON
        NSLog(@"Is connection info cell: %@", connectionInfo.text);
#endif
        
        [connectionInfoCell setConnectionInfoText: connectionInfo.text];
        
        [connectionInfoCell setNeedsDisplay];
        [connectionInfoCell setNeedsLayout];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    //if (([cell isKindOfClass: [ConnectionsDetailviewCell class]])) {
    //ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: self.selectedIndex];
    //ConSection *conSection = [[[conResult conSectionList] conSections] objectAtIndex: indexPath.row];
    //ConnectionsDetailviewCell *detailViewCell = (ConnectionsDetailviewCell *)cell;
    
    NSUInteger connectionInfoCount = [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex];
    NSUInteger rowCount = [self tableView: self.detailViewTableView numberOfRowsInSection: 0];
    NSUInteger firstInfoRow = rowCount - connectionInfoCount;
    
    if ((connectionInfoCount > 0) && (indexPath.row >= firstInfoRow)) {
        //NSLog(@"ConnectionInfoCount is bigger 0 and indexPath is connection info row");
        //NSUInteger lastInfoRow = rowCount - 1;
        NSUInteger indexPathRowToConnectionInfoTranslation = indexPath.row - firstInfoRow;
        ConnectionInfo *connectionInfo = [[SBBAPIController sharedSBBAPIController] getConnectioninfoForConnectionResultWithIndexAndConnectioninfoIndex: self.selectedIndex infoIndex: indexPathRowToConnectionInfoTranslation];
        NSString *infoText = connectionInfo.text;
        return [ConnectionInfoTableviewCell neededHeightForInfo: infoText constrainedToWidth:tableView.bounds.size.width];
        return 50;
    }

    ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.selectedIndex consectionIndex: indexPath.row];
        
    if ([conSection conSectionType] == walkType) {
        //NSLog(@"Height for detail cell for row: %d, type: WALK", indexPath.row);
        //NSLog(@"Color: ")
        return 142;
        return 65;
    } else if ([conSection conSectionType] == journeyType) {
        //NSLog(@"Height for detail cell for row: %d, type: JOURNEY", indexPath.row);
        return 142;
    }
    return 142;
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [self.detailViewTableView indexPathForCell:cell];
        UITableViewCell *selectedCell = [self.detailViewTableView cellForRowAtIndexPath: indexPath];
        if ([selectedCell isKindOfClass: [ConnectionInfoTableviewCell class]]) {
            return;
        }
        
		// do something with this action
        
        #ifdef LOGOUTPUTON
		NSLog(@"Detailview: Long-pressed cell at row %@", indexPath);
        #endif
        
        ConSection *conSection =  [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.selectedIndex consectionIndex: indexPath.row];
        if ([conSection conSectionType] == walkType) {
            //NSLog(@"Detailview: Long-pressed cell is walk type");
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerDetailviewCellWithIndexLongPress:index:)])
            {
                [self.delegate didTriggerDetailviewCellWithIndexLongPress:self index: indexPath.row];
            }
        }
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger connectionInfoCount = [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex];
    NSUInteger rowCount = [self tableView: self.detailViewTableView numberOfRowsInSection: 0];
    NSUInteger firstInfoRow = rowCount - connectionInfoCount;
    
    UITableViewCell *cell;
    if ((connectionInfoCount > 0) && (indexPath.row >= firstInfoRow)) {
        //NSLog(@"Dequeue connectioninfo cell");
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionInfoTableviewCell"];
    } else {
        //NSLog(@"Dequeue detailview cell");
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsDetailviewCell"];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPressGesture.minimumPressDuration = 1.0;
        [cell addGestureRecognizer:longPressGesture];
    }
    
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConnectionsDetailviewCell *selectedCell = (ConnectionsDetailviewCell *)[tableView cellForRowAtIndexPath: indexPath];
    
    if ([selectedCell isKindOfClass:[ConnectionsDetailviewCell class]]) {
        //ConnectionsDetailviewCell *selectedCell = (ConnectionsDetailviewCell *)[tableView cellForRowAtIndexPath: indexPath];
        if (selectedCell.selected) {
            selectedCell.tableViewCellsIsSelectedAndShouldDeselect = YES;
        } else {
            selectedCell.tableViewCellsIsSelectedAndShouldDeselect = NO;
        }
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnectionsDetailviewCell *selectedCell = (ConnectionsDetailviewCell *)[tableView cellForRowAtIndexPath: indexPath];
    
    if ([selectedCell isKindOfClass:[ConnectionsDetailviewCell class]]) {
        if (self.tableViewCellsAreSelectable) {
            if (selectedCell.tableViewCellsIsSelectedAndShouldDeselect) {
                [tableView deselectRowAtIndexPath: indexPath animated: NO];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDetailviewCellWithIndex:index:)])
                {
                    [self.delegate didSelectDetailviewCellWithIndex:self index: 9999];
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDetailviewCellWithIndex:index:)])
                {
                    [self.delegate didSelectDetailviewCellWithIndex:self index: indexPath.row];
                }
            }
        } else {
            [tableView deselectRowAtIndexPath: indexPath animated: NO];
        }
    } else if ([selectedCell isKindOfClass:[ConnectionInfoTableviewCell class]]) {
        [tableView deselectRowAtIndexPath: indexPath animated: NO];
    }
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

- (void) updateDetailviewTableViewWithOverviewIndex:(NSUInteger)index {
    self.detailViewTableView.alpha = 0.0;
    self.selectedIndex = index;
    [self.detailViewTableView reloadData];
    [self.detailViewTableView setContentOffset:CGPointZero animated:NO];
    //[UIView beginAnimations: @"Showdetailtableview" context: NULL];
    [UIView animateWithDuration: 0.3 animations: ^{ self.detailViewTableView.alpha = 1.0;}];
    //self.detailViewTableView.alpha = 1.0;
    //[UIView commitAnimations];
    //[self performSelector: @selector(reloadAndUpdateTableView) withObject: nil afterDelay: 0.4];

}

- (void) setSelectableStateOfTableView:(BOOL)selectable {
    self.tableViewCellsAreSelectable = selectable;
    self.trackNumberInCellsAreVisible = !selectable;
}

- (void) setSelectableStateOfTableViewAndReload:(BOOL)selectable {
    self.tableViewCellsAreSelectable = selectable;
    self.trackNumberInCellsAreVisible = !selectable;
    [self.detailViewTableView reloadData];
}
     
- (void) reloadAndUpdateTableView {
    [self.detailViewTableView reloadData];
    [self.detailViewTableView setNeedsDisplay];
    [self.detailViewTableView setNeedsLayout];
}

/*
- (void) toggleTrackNumberVisibleState:(BOOL)visible {
    self.trackNumberInCellsAreVisible = visible;
    [self.detailViewTableView reloadData];
}
*/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
