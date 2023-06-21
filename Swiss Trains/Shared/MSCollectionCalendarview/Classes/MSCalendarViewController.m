//
//  MSCalendarViewController.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSCalendarViewController.h"
#import "MSCollectionViewCalendarLayout.h"
#import "MSEvent.h"
#import "NSDate+CupertinoYankee.h"

// Collection View
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"

//#import "CoreData.h"

NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

@interface MSCalendarViewController () <MSCollectionViewDelegateCalendarLayout>

@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *dataarray;

- (void)loadData;

@end

@implementation MSCalendarViewController

- (id)init
{
    self.collectionViewLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewLayout.delegate = self;
    self = [super initWithCollectionViewLayout:self.collectionViewLayout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];

    // These are optional—if you don't want any of the decoration views, just don't register a class for it
    [self.collectionViewLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    //[self.collectionViewLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    //[self.collectionViewLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    /*
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES]];
    // No events with undecided times or dates
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(dateToBeDecided == NO) AND (timeToBeDecided == NO)"];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext
                                                                          sectionNameKeyPath:@"day"
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    */
    
    //[self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionViewLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
}

#pragma mark - MSCalendarViewController

- (void)loadData
{
    /*
    
    // 1000 "Sports" events near Denver, Colorado
    NSDictionary *parameters = @{
        @"lat" : @(39.750),
        @"lon" : @(-104.984),
        @"range" : @"10mi",
        @"taxonomies.name" : @"sports",
        @"per_page" : @(1000)
    };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"events" parameters:parameters success:nil failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Unable to Load Events" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil] show];
    }];
    
    */
    
    MSEvent *event1 = [[MSEvent alloc] init];
    event1.remoteID = [NSNumber numberWithInt: 1];
    event1.start = [NSDate date];
    event1.end = [[NSDate date] dateByAddingTimeInterval: 60*60];
    event1.title = @"Train 1";
    event1.timeToBeDecided = [NSNumber numberWithInt: 0];
    event1.dateToBeDecided = [NSNumber numberWithInt: 0];
    event1.location = @"Olten";
    
    MSEvent *event2 = [[MSEvent alloc] init];
    event2.remoteID = [NSNumber numberWithInt: 2];
    event2.start = [[NSDate date] dateByAddingTimeInterval: 60*60];
    event2.end = [[NSDate date] dateByAddingTimeInterval: 60*60*3];
    event2.title = @"Train 2";
    event2.timeToBeDecided = [NSNumber numberWithInt: 0];
    event2.dateToBeDecided = [NSNumber numberWithInt: 0];
    event2.location = @"HB";
    
    NSMutableArray *sectionarray1 = [NSMutableArray array];
    [sectionarray1 addObject: event1];
    [sectionarray1 addObject: event2];
    
    MSEvent *event3 = [[MSEvent alloc] init];
    event3.remoteID = [NSNumber numberWithInt: 1];
    event3.start = [NSDate date];
    event3.end = [[NSDate date] dateByAddingTimeInterval: 60*60];
    event3.title = @"Train 1";
    event3.timeToBeDecided = [NSNumber numberWithInt: 0];
    event3.dateToBeDecided = [NSNumber numberWithInt: 0];
    event3.location = @"Olten";
    
    MSEvent *event4 = [[MSEvent alloc] init];
    event4.remoteID = [NSNumber numberWithInt: 2];
    event4.start = [[NSDate date] dateByAddingTimeInterval: 60*60];
    event4.end = [[NSDate date] dateByAddingTimeInterval: 60*60*3];
    event4.title = @"Train 2";
    event4.timeToBeDecided = [NSNumber numberWithInt: 0];
    event4.dateToBeDecided = [NSNumber numberWithInt: 0];
    event4.location = @"HB";
    
    NSMutableArray *sectionarray2 = [NSMutableArray array];
    [sectionarray2 addObject: event3];
    [sectionarray2 addObject: event4];
    
    NSMutableArray *dataarray = [NSMutableArray array];
    [dataarray addObject: sectionarray1];
    [dataarray addObject: sectionarray2];
    self.dataarray = dataarray;
    
}

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex {
    
    if (consecionIndex == 9999) {
        //NSLog(@"Set connectionAllTypeiPad");
        self.connectionIndex = connectionIndex;
        self.consectionIndex = consecionIndex;
        self.selectedConsectionType = consectionAllTypeiPad;
        
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
    }
    
    [self updateViewData];
}

- (void) updateViewData {
    
    NSUInteger numberofresults = [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults];
    NSDate *mindate = [NSDate distantFuture];
    NSDate *maxdate = [NSDate distantPast];
    
    for (int i = 0; i < numberofresults; i++) {
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getAllBasicStopsForConnectionResultWithIndex: i];
        NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
        NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
        
        ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: i];
        NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overview];
        BOOL isDepartureTime = [[SBBAPIController sharedSBBAPIController] getConnectionDateIsDepartureFlagForConnectionResultWithIndex: i];
        NSUInteger durationhours = [overview getHoursFromDuration];
        NSUInteger durationminutes = [overview getMinutesFromDuration];
        NSUInteger durationseconds = durationminutes * 60 + durationhours * 60 * 60;
                
        NSString *dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, departureTime];
        
        if (!isDepartureTime) {
            dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, arrivalTime];
        }
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
        
        NSDate *startdate = [timeFormatter dateFromString: dateString];
        NSDate *enddate = [startdate dateByAddingTimeInterval: durationseconds];
        
        
        if ([startdate compare:mindate] == NSOrderedAscending) { mindate = startdate; }
        if ([enddate compare:maxdate] == NSOrderedDescending)  { maxdate = enddate; }
        
        startdate = nil;
        enddate = nil;
    }
    
    NSTimeInterval distanceBetweenDates = [maxdate timeIntervalSinceDate:mindate];
    double secondsInAnHour = 3600;
    CGFloat hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    NSLog(@"Max hours: %.1f", hoursBetweenDates);
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    NSString *mind = [timeFormatter stringFromDate:mindate];
    NSString *maxd = [timeFormatter stringFromDate:maxdate];
    NSLog(@"Min: %@", mind);
    NSLog(@"Max: %@", maxd);
    
    CGFloat hourheight =  (self.view.frame.size.height - 50 - 50) / (roundf(hoursBetweenDates) + 0);
    self.collectionViewLayout.hourHeight = hourheight;

    [self.collectionViewLayout invalidateLayoutCache];
    [self.collectionView reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate

/*
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionViewLayout invalidateLayoutCache];
    [self.collectionView reloadData];
}
*/
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //return self.fetchedResultsController.sections.count;
    //return self.dataarray.count;
    return [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    //return [sectionInfo numberOfObjects];
    //return [[self.dataarray objectAtIndex: section] count];
    return [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    
    ConSection *consection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex:indexPath.section consectionIndex:indexPath.row];
    
    //NSArray *data = [self.dataarray objectAtIndex: indexPath.section];
    //cell.event = [data objectAtIndex: indexPath.row];
    
    cell.consection = consection;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if ([kind isEqualToString:MSCollectionElementKindDayColumnHeader]) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        dayColumnHeader.day = [self.collectionViewLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        view = dayColumnHeader;
    }
    else if ([kind isEqualToString:MSCollectionElementKindTimeRowHeader]) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
    //id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    //MSEvent *event = sectionInfo.objects[0];
    
    //NSArray *data = [self.dataarray objectAtIndex: section];
    //MSEvent *event = [data objectAtIndex: 0];
    
    NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getAllBasicStopsForConnectionResultWithIndex: section];

    //NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
    //NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
    NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
    NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
    
    
    
    ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: section];
    NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overview];
    BOOL isDepartureTime = [[SBBAPIController sharedSBBAPIController] getConnectionDateIsDepartureFlagForConnectionResultWithIndex: section];
    //NSUInteger durationhours = [overview getHoursFromDuration];
    //NSUInteger durationminutes = [overview getMinutesFromDuration];
    //NSUInteger durationseconds = durationminutes * 60 + durationhours * 60 * 60;
    
    //NSString *title = [NSString stringWithFormat: @"%@ - %@", fromStationName, toStationName];
    
    NSString *dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, departureTime];
    
    if (!isDepartureTime) {
        //NSLog(@"Is arrival time");
        dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, arrivalTime];
    }
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSDate *startdate = [timeFormatter dateFromString: dateString];
    
    //NSDate *enddate = [startdate dateByAddingTimeInterval: durationseconds];
    
    return [startdate beginningOfDay];
    
    //return [event day];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //MSEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    /*
    NSArray *data = [self.dataarray objectAtIndex: indexPath.section];
    MSEvent *event = [data objectAtIndex: indexPath.row];
    
    return event.start;
    */
    
    ConSection *consection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: indexPath.section consectionIndex:indexPath.row];
    NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: consection];
    
    ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: indexPath.section];
    NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overview];
    
    NSString *dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, departureTime];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSDate *startdate = [timeFormatter dateFromString: dateString];
    
    return startdate;
    
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //MSEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Sports usually last about 3 hours, and SeatGeek doesn't provide an end time
    /*
    NSArray *data = [self.dataarray objectAtIndex: indexPath.section];
    MSEvent *event = [data objectAtIndex: indexPath.row];
    
    //return [event.start dateByAddingTimeInterval:(60 * 60 * 3)];
    return event.end;
    */
    
    ConSection *consection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: indexPath.section consectionIndex:indexPath.row];
    
    //NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: consection];
    NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForConsection:consection];
    
    ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: indexPath.section];
    NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overview];
    
    NSString *dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, departureTime];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSDate *startdate = [timeFormatter dateFromString: dateString];
    
    //NSDate *enddate = [startdate dateByAddingTimeInterval: durationseconds];
    
    return startdate;
    
    
    
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout
{
    return [NSDate date];
}

@end
