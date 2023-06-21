//
//  StationPickerViewControlleriPad.m
//  Swiss Trains
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "StationPickerViewControlleriPad.h"

#define BUTTONHEIGHT 36.0
#define TEXTFIELDHEIGHT 30.0
#define SEGMENTHEIGHT 18.0

#define STATIONLEGAL          @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890' "
#define STATIONILLEGAL        @"-/:;()$&@\".,?![]{}#%^*+=_\\|~<>€£¥•"
#define NUMBERLEGAL           @"1234567890"

#define SECS_OLD_MAX 5.0f

#define KEYBOARDHEIGHTPORTRAIT  264
#define KEYBOARDHEIGHTLANDSCAPE 352

@interface StationPickerViewControlleriPad ()

@end

@implementation StationPickerViewControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    
    NSLog(@"StationPickerControlleriPad. Screen size: %.1f, %.1f", size.width, size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - TOOLBARHEIGHT - TABBARHEIGHT)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    NSLog(@"StationPickerControlleriPad view init: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"StationPickerControlleriPad layoutSubviews");
	
	CGSize size = [UIApplication currentScreenSize];
    CGSize newSize;
    if (beforeRotation) {
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            newSize.width = MAX(size.width, size.height) + STATUSBARHEIGHT;
            newSize.height = MIN(size.width, size.height) - STATUSBARHEIGHT;
        } else {
            newSize.height = MAX(size.width, size.height) - STATUSBARHEIGHT;
            newSize.width = MIN(size.width, size.height) + STATUSBARHEIGHT;
        }
    } else {
        newSize.width = size.width;
        newSize.height = size.height;
    }
        
    NSLog(@"StationPickerControlleriPad. New size: %.1f, %.1f", newSize.width, newSize.height);
    
    //self.stationsViewToolbar.frame = CGRectMake(0, 0, newSize.width, TOOLBARHEIGHTIPAD);
    self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.searchContainerView.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, STATIONPICKERSEARCHVIEWWIDTHL - SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    self.dividerLeft.frame = CGRectMake(STATIONPICKERSEARCHVIEWWIDTHL - SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    
    self.mapContainerView.frame = CGRectMake(STATIONPICKERSEARCHVIEWWIDTHL, TOOLBARHEIGHTIPAD + 4, newSize.width - STATIONPICKERSEARCHVIEWWIDTHL - STATIONPICKERLISTVIEWWIDTHL, newSize.height - TOOLBARHEIGHTIPAD - 4);
    self.mapView.frame = self.mapContainerView.bounds;
    MKMapRect visibleMapRect;
    BOOL portaitOrientation = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    if (portaitOrientation) {
        visibleMapRect = [self mapRectForRect: CGRectMake(0, 0, self.mapContainerView.bounds.size.width, self.mapContainerView.bounds.size.height - KEYBOARDHEIGHTPORTRAIT)];
    } else {
        visibleMapRect = [self mapRectForRect: CGRectMake(0, 0, self.mapContainerView.bounds.size.width, self.mapContainerView.bounds.size.height - KEYBOARDHEIGHTLANDSCAPE)];
    }
    //[self.mapView setVisibleMapRect: visibleMapRect];
    

    self.dividerRight.frame = CGRectMake(newSize.width - STATIONPICKERLISTVIEWWIDTHL, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    self.listContainerView.frame = CGRectMake(newSize.width - STATIONPICKERLISTVIEWWIDTHL + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHT + 4, STATIONPICKERLISTVIEWWIDTHL - SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHT - 4);

    if (animated) {
        [UIView beginAnimations:@"StationPickerControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
    //[self.view setNeedsDisplay];
    //[self.view setNeedsLayout];
}

- (void) layoutSubviews:(BOOL)beforeRotation toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self layoutSubviewsWithAnimated:NO beforeRotation: beforeRotation interfaceOrientation: toInterfaceOrientation];
}

- (MKMapRect)mapRectForRect:(CGRect)rect
{
    CLLocationCoordinate2D topleft = [self.mapView convertPoint:CGPointMake(rect.origin.x, rect.origin.y) toCoordinateFromView:self.mapContainerView];
    CLLocationCoordinate2D bottomeright = [self.mapView convertPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)) toCoordinateFromView:self.mapContainerView];
    MKMapPoint topleftpoint = MKMapPointForCoordinate(topleft);
    NSLog(@"Top left: %.1f, %.1f", topleftpoint.x, topleftpoint.y);
    
    MKMapPoint bottomrightpoint = MKMapPointForCoordinate(bottomeright);
    NSLog(@"Bottom right: %.1f, %.1f", bottomrightpoint.x, bottomrightpoint.y);
    
    return MKMapRectMake(topleftpoint.x, topleftpoint.y, bottomrightpoint.x - topleftpoint.x, bottomrightpoint.y - topleftpoint.y);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGSize size = [UIApplication currentScreenSize];
    
    NSLog(@"StationPickerControlleriPad. viewdidload. Screen size: %.1f, %.1f", size.width, size.height);
    NSLog(@"StationsPickerViewController viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    
    self.stationsViewToolbar = [[StatusToolbariPad alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor toolbarButtonsImageColorNormal]];
    //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor toolbarButtonsImageColorHighlighted]];
    UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.backButton setImage: backButtonImage forState: UIControlStateNormal];
    [self.backButton setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
    self.backButton.imageView.contentMode = UIViewContentModeCenter;
    self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.backButton.showsTouchWhenHighlighted = YES;
    [self.backButton addTarget: self action: @selector(pushBackController:) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, TOOLBARHEIGHTIPAD, STATIONPICKERSEARCHVIEWWIDTHL - SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD)];
    [self.view addSubview: self.searchContainerView];
    
    //self.stationTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, BUTTONHEIGHT + 4, self.view.frame.size.width - 8, TEXTFIELDHEIGHT)];
    self.stationTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 6, self.searchContainerView.bounds.size.width - 8, TEXTFIELDHEIGHT)];
    self.stationTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.stationTextField.font = [UIFont systemFontOfSize:15];
    self.stationTextField.placeholder = NSLocalizedString(@"Current location", @"Station text field default text");
    self.stationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.stationTextField.keyboardType = UIKeyboardTypeDefault;
    self.stationTextField.returnKeyType = UIReturnKeyGo;
    self.stationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //self.startTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.stationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.stationTextField.delegate = self;
    self.stationTextField.tag = 1;
    [self.searchContainerView addSubview:self.stationTextField];
    
    //self.stationsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, BUTTONHEIGHT + 4 + TEXTFIELDHEIGHT + 4, self.view.frame.size.width, self.view.frame.size.height - BUTTONHEIGHT - 4 - TEXTFIELDHEIGHT - 4) style:UITableViewStylePlain];
    self.stationsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 6 + TEXTFIELDHEIGHT + 4, self.searchContainerView.bounds.size.width, self.searchContainerView.bounds.size.height - 6 - TEXTFIELDHEIGHT - 4) style:UITableViewStylePlain];
    [self.searchContainerView addSubview: self.stationsTableView];
    
    self.stationsTableView.rowHeight = 25.0f;
    self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.stationsTableView.backgroundColor = [UIColor clearColor];
    [self.stationsTableView registerClass:[StationsCell class] forCellReuseIdentifier: @"StationsCell"];
    
    self.stationsTableView.dataSource = self;
    self.stationsTableView.delegate = self;
    
    self.separatorLineLayer = CAShapeLayer.layer;
    [self.view.layer addSublayer:self.separatorLineLayer];
    self.separatorLineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.separatorLineLayer.lineWidth = .5;
    self.separatorLineLayer.fillColor = nil;
    [self.searchContainerView.layer addSublayer: self.separatorLineLayer];
    
    CGRect ownframe = self.searchContainerView.frame;
    CGFloat lineWidth = self.separatorLineLayer.lineWidth;
    //UIBezierPath *borderBottomPath = [UIBezierPath bezierPathWithRect: CGRectMake(ownframe.origin.x, BUTTONHEIGHT + 4 + TEXTFIELDHEIGHT + 4 - lineWidth, ownframe.size.width, lineWidth)];
    UIBezierPath *borderBottomPath = [UIBezierPath bezierPathWithRect: CGRectMake(ownframe.origin.x, 6 + TEXTFIELDHEIGHT + 4 - lineWidth, ownframe.size.width, lineWidth)];
    //const CGFloat lineY = bottom - self.borderBottomLayer.lineWidth;
    //[self addArrowAtPoint:CGPointMake(position, lineY) toPath:borderBottomPath withLineWidth:_borderBottomLayer.lineWidth];
    self.separatorLineLayer.path = borderBottomPath.CGPath;
    
    self.dividerLeft = [[SplitSeparatorView alloc] initWithFrame: CGRectMake(STATIONPICKERSEARCHVIEWWIDTHL - SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD)];
    self.dividerLeft.backgroundColor = [UIColor lightGrayColor];
    self.dividerLeft.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview: self.dividerLeft];
    UIImage *image = [UIImage imageNamed:@"split-divider.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(-4, 0, image.size.width, image.size.height);
    [self.dividerLeft addSubview:imageView];
    
    self.mapContainerView = [[UIView alloc] initWithFrame: CGRectMake(STATIONPICKERSEARCHVIEWWIDTHL, TOOLBARHEIGHTIPAD + 4, self.view.frame.size.width -STATIONPICKERSEARCHVIEWWIDTHL - STATIONPICKERLISTVIEWWIDTHL, self.view.frame.size.height - TOOLBARHEIGHTIPAD - 4)];
    [self.view addSubview: self.mapContainerView];
    self.mapContainerView.alpha = 1.0;
    
    self.mapView = [[MKMapView alloc] initWithFrame: CGRectMake(0, 0, self.mapContainerView.bounds.size.width, self.mapContainerView.bounds.size.height)];
    [self.mapContainerView addSubview: self.mapView];
    //CLLocationCoordinate2D zoomLocation;
    //zoomLocation.latitude = 40.7310;
    //zoomLocation.longitude= -73.9977;
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
    //[self.mapView setRegion:viewRegion animated:NO];
    self.mapView.delegate = self;
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.897739, 8.426514),
                                                 MKCoordinateSpanMake(4.026846,4.032959));
    
    MKMapRect visibleMapRect;
    BOOL portaitOrientation = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    if (portaitOrientation) {
        NSLog(@"Map visible rect is portait");
        visibleMapRect = [self mapRectForRect: CGRectMake(0, 0, self.mapContainerView.bounds.size.width, self.mapContainerView.bounds.size.height - KEYBOARDHEIGHTPORTRAIT)];
    } else {
        NSLog(@"Map visible rect is landscape");
        visibleMapRect = [self mapRectForRect: CGRectMake(0, 0, self.mapContainerView.bounds.size.width, self.mapContainerView.bounds.size.height - KEYBOARDHEIGHTLANDSCAPE)];
    }
    //[self.mapView setVisibleMapRect: visibleMapRect];
    
    self.dividerRight = [[SplitSeparatorView alloc] initWithFrame: CGRectMake(self.view.frame.size.width - STATIONPICKERLISTVIEWWIDTHL, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD)];
    self.dividerRight.backgroundColor = [UIColor lightGrayColor];
    self.dividerRight.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview: self.dividerRight];
    [self.dividerRight addSubview:imageView];
    
    self.listContainerView = [[UIView alloc] initWithFrame: CGRectMake(self.view.frame.size.width - STATIONPICKERLISTVIEWWIDTHL + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHT + 4, STATIONPICKERLISTVIEWWIDTHL - SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHT - 4)];
    [self.view addSubview: self.listContainerView];
    self.listContainerView.alpha = 1.0;
    
    self.nextStationsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.listContainerView.bounds.size.width, self.listContainerView.bounds.size.height) style:UITableViewStylePlain];
    [self.searchContainerView addSubview: self.nextStationsTableView];
    
    self.nextStationsTableView.rowHeight = 25.0f;
    self.nextStationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nextStationsTableView.backgroundColor = [UIColor clearColor];
    [self.nextStationsTableView registerClass:[ClosestStationsCell class] forCellReuseIdentifier: @"ClosestStationsCell"];
    [self.listContainerView addSubview: self.nextStationsTableView];
    
    self.nextStationsTableView.dataSource = self;
    self.nextStationsTableView.delegate = self;
    
    [self.view addSubview: self.stationsViewToolbar];
    [self.view addSubview: self.backButton];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

- (void) pushBackController:(id)sender {
    
    NSLog(@"StationPickerControlleriPad pushback");
    [self.stationTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressPushBackViewController:)])
    {
        [self.delegate didPressPushBackViewController: self];
    }
}

-(void) forcePushBackToPreviousViewController {
    NSLog(@"StationsPickerViewControlleriPad force push back");
    [self.stationTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressPushBackViewController:)])
    {
        [self.delegate didPressPushBackViewController: self];
    }
}

- (void)fetchStationsForSearchText:(NSString*)searchText {
    
    NSLog(@"Searchtext: %@", searchText);
    
    if (!(searchText && searchText.length)) {
        if (self.fetchedResultsController != nil) {
            self.fetchedResultsController = nil;
        }
        [self.stationsTableView reloadData];
        
        NSLog(@"Clear controller");
        
        return;
    }
    
    if ([searchText length]==1) {
        NSLog(@"First letter search");
        if (self.fetchedResultsController != nil) {
            self.fetchedResultsController = nil;
            NSLog(@"First letter search, clear controller");
        }
    }
    
    NSString *firstLetter = [searchText substringToIndex:1];
    if ([[firstLetter uppercaseString] isEqualToString: @"Ä"]) {
        firstLetter = @"a";
    }
    if ([[firstLetter uppercaseString] isEqualToString: @"Ö"]) {
        firstLetter = @"o";
    }
    if ([[firstLetter uppercaseString] isEqualToString: @"Ü"]) {
        firstLetter = @"u";
    }
    if ([[firstLetter uppercaseString] isEqualToString: @"É"]) {
        firstLetter = @"e";
    }
    if ([[firstLetter uppercaseString] isEqualToString: @"È"]) {
        firstLetter = @"e";
    }
    if ([[firstLetter uppercaseString] isEqualToString: @"À"]) {
        firstLetter = @"a";
    }
    
    NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    //NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    //NSCharacterSet *invertedS = [s invertedSet];
    NSRange nr = [firstLetter rangeOfCharacterFromSet:numberSet];
    NSString *relationTo;
    if (nr.location != NSNotFound) {
        relationTo = [NSString stringWithFormat: @"numsTo"];
        firstLetter = @"NUMS";
    } else {
        relationTo = [NSString stringWithFormat: @"%@To", [firstLetter lowercaseString]];
    }
    
    NSLog(@"Firstletter: %@", firstLetter);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    if (self.managedObjectContext == nil) {
        NSLog(@"Context error");
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[firstLetter uppercaseString] inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:100];
    
    NSString *sortKeyM = @"snp";
    NSString *sortKeyP2 = [NSString stringWithFormat: @"%@.firstlettercode", relationTo];
    NSString *sortKeyP1 = [NSString stringWithFormat: @"%@.transportcode", relationTo];
    //NSString *sortKey = @"sn";
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *stationSortDescM = [[NSSortDescriptor alloc] initWithKey:sortKeyM ascending:YES];
    NSSortDescriptor *stationSortDescP1 = [[NSSortDescriptor alloc] initWithKey:sortKeyP1 ascending:NO];
    NSSortDescriptor *stationSortDescP2 = [[NSSortDescriptor alloc] initWithKey:sortKeyP2 ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: stationSortDescM ,stationSortDescP1, stationSortDescP2, nil];
    //NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: stationSortDescM ,stationSortDescP2, stationSortDescP1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    if (self.fetchedResultsController) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sn beginswith[cd] %@", searchText];
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@.sn beginswith[cd] %@", relationFrom, searchText];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
        [self.fetchedResultsController.fetchRequest setFetchLimit:100];
    } else {
        NSFetchedResultsController *aFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:self.managedObjectContext
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
        
        
        
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
    }
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Handle error
        NSLog(@"Fetch error");
    }
    
    NSLog(@"Entities fetched: %d", [[self.fetchedResultsController fetchedObjects] count]);
    
    [self.stationsTableView reloadData];
}

- (void)fetchFavoritesForSearchText:(NSString*)searchText {
    
    [[FavoritesDataController sharedFavoritesDataController] fetchFavoritesListForStationStartingWithName: searchText];
    
    [self.stationsTableView reloadData];
}


#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual: self.stationsTableView]) {
        return 2;
    } else if ([tableView isEqual: self.nextStationsTableView]) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual: self.stationsTableView]) {
        if (section == 0) {
            NSLog(@"Search. number of rows in favorites: %d", [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations]);
            if ([[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations] > 0) {
                return [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations];
            }
            return 0;
        } else if (section == 1) {
            NSLog(@"Search. number of rows in stations: %d", [[self.fetchedResultsController fetchedObjects] count]);
            if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
                self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            } else {
                self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            return [[self.fetchedResultsController fetchedObjects] count];
            
        }
        return  0;
    } else if ([tableView isEqual: self.nextStationsTableView]) {
        NSLog(@"List. number of rows: %d", [self.sortedStationsToCurrentLocation count]);
        if ([self.sortedStationsToCurrentLocation count] > 0) {
            self.nextStationsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        } else {
            self.nextStationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        return [self.sortedStationsToCurrentLocation count];
    }
    return 0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[StationsCell class]]) {
        NSLog(@"Config stationscell");
        if (indexPath.section == 0) {
            NSLog(@"Config stationscell. favorite");
            Station *currentStation = [[FavoritesDataController sharedFavoritesDataController]getFavoritesStationWithIndex: indexPath.row];
            StationsCell *stationsCell = (StationsCell *)cell;
            [stationsCell.titleLabel setText: currentStation.stationName];
            stationsCell.stationId = currentStation.stationId;
            [stationsCell setFavoriteCell:YES];
        } else if (indexPath.section == 1) {
            NSLog(@"Config stationscell. search");
            if (self.fetchedResultsController) {
                NSString *entityName = self.fetchedResultsController.fetchRequest.entityName;
                NSString *relationName = [NSString stringWithFormat: @"%@To", [entityName lowercaseString]];
                NSLog(@"Config stationscell. search. get object from fetched resultscontroller: %d %d", indexPath.section, indexPath.row);
                NSIndexPath *indexPathWithSectionZero = [NSIndexPath indexPathForRow: indexPath.row inSection: 0];
                NSManagedObject *stationshort = (NSManagedObject *)[[self fetchedResultsController] objectAtIndexPath:indexPathWithSectionZero];
                NSManagedObject *station = (NSManagedObject *)[stationshort valueForKey: relationName];
                NSLog(@"Config stationscell. search. get object from fetched resultscontroller. Got it");
                StationsCell *stationsCell = (StationsCell *)cell;
                [stationsCell.titleLabel setText: [station valueForKey: @"stationname"]];
                stationsCell.stationId = [station valueForKey: @"externalid"];
                [stationsCell setFavoriteCell:NO];
            }
        }
    } else if ([cell isKindOfClass:[ClosestStationsCell class]]) {
        NSLog(@"Config nextstationscell");
        if (self.sortedStationsToCurrentLocation) {
            Stations *currentStation = [self.sortedStationsToCurrentLocation objectAtIndex: indexPath.row];
            
            ClosestStationsCell *closestStationsCell = (ClosestStationsCell *)cell;
            [closestStationsCell.titleLabel setText: currentStation.stationname];
            closestStationsCell.stationId = currentStation.externalid;
            NSLog(@"Station distance: %@", [currentStation getFormmattedStationDistance]);
            closestStationsCell.distanceLabel.text = [currentStation getFormmattedStationDistance];
            [closestStationsCell updateCellLabelWithRectWidth: self.listContainerView.bounds];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([tableView isEqual: self.stationsTableView]) {
        //NSLog(@"Dequeue stationscell");
        cell = (StationsCell *)[tableView dequeueReusableCellWithIdentifier:@"StationsCell"];
    } else if ([tableView isEqual: self.nextStationsTableView]) {
        //NSLog(@"Dequeue nextstationscell");
        cell = (ClosestStationsCell *)[tableView dequeueReusableCellWithIdentifier:@"ClosestStationsCell"];
    }
    
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    Station *station = [[Station alloc] init];
    
    if ([tableView isEqual: self.stationsTableView]) {
        StationsCell *stationCell = (StationsCell *)[tableView cellForRowAtIndexPath: indexPath];
        self.stationName = stationCell.titleLabel.text;
        self.stationID = stationCell.stationId;
    } else if ([tableView isEqual: self.nextStationsTableView]) {
        ClosestStationsCell *closestStationCell = (ClosestStationsCell *)[tableView cellForRowAtIndexPath: indexPath];
        self.stationName = closestStationCell.titleLabel.text;
        self.stationID = closestStationCell.stationId;
    }
    
    station.stationName = self.stationName;
    station.stationId = self.stationID;
    
    [[FavoritesDataController sharedFavoritesDataController] addStationToFavoritesList: station];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationWithStationTypeIndex:stationTypeIndex:station:)])
    {
        [self.delegate didSelectStationWithStationTypeIndex: self stationTypeIndex: self.stationTypeIndex station: station];
    }
    
    [self.stationTextField resignFirstResponder];
    
    if (self.fetchedResultsController != nil) {
        self.fetchedResultsController = nil;
    }
    [self.stationsTableView reloadData];
    [self.nextStationsTableView reloadData];
    
    [self pushBackController:nil];
    //[self dismissViewControllerAnimated: YES completion: nil];
    //[self.navigationController popViewControllerAnimated: YES];
}

// override to support editing the table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark -
#pragma mark user choosed station on map button

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"User tapped on annotation button");
    Stations *annotation = view.annotation;
    
    Station *station = [[Station alloc] init];
    
    self.stationName = annotation.stationname;
    self.stationID = annotation.externalid;
    
    station.stationName = self.stationName;
    station.stationId = self.stationID;
    
    [[FavoritesDataController sharedFavoritesDataController] addStationToFavoritesList: station];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationWithStationTypeIndex:stationTypeIndex:station:)])
    {
        [self.delegate didSelectStationWithStationTypeIndex: self stationTypeIndex: self.stationTypeIndex station: station];
    }
    
    [self.stationTextField resignFirstResponder];
    
    if (self.fetchedResultsController != nil) {
        self.fetchedResultsController = nil;
    }
    [self.stationsTableView reloadData];
    [self.nextStationsTableView reloadData];
    
    [self pushBackController:nil];
    //[self dismissViewControllerAnimated: YES completion: nil];
}

- (void) userChoosedStationOnMap:(id)sender {
    
}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"NSFetchedResultsController will change content");
    //[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSLog(@"NSFetchedResultscontroller did change object");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"NSFetchedResultsController did change content");
}

#pragma mark -
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.stationsTableView.frame;
    frame.size.height = self.view.frame.size.height - BUTTONHEIGHT - 4 - TEXTFIELDHEIGHT - 4 - keyboardSize.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //self.stationsTableView.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    //NSDictionary *info = [aNotification userInfo];
    //NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    //CGSize keyboardSize = [aValue CGRectValue].size;
    
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.stationsTableView.frame;
    frame.size.height = self.view.frame.size.height - BUTTONHEIGHT - 4 - TEXTFIELDHEIGHT - 4;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //self.stationsTableView.frame = frame;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self fetchStationsForSearchText: textField.text];
    [self fetchFavoritesForSearchText: textField.text];
    [textField resignFirstResponder];
	return (YES);
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    
    [self fetchStationsForSearchText: textField.text];
    [self fetchFavoritesForSearchText: textField.text];
    //[textField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.1];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSCharacterSet *cs;
	NSString *filtered;
    
    NSLog(@"Searchtext: %@", textField.text);
    NSLog(@"Replacement string: %@", string);
    
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if (isBackSpace == -8) {
        NSLog(@"Characters in range is backspace");
        NSString *textfieldText = textField.text;
        if ([textfieldText length]>0) {
            NSString *searchString = [textfieldText substringToIndex:[textfieldText length]-1];
            NSLog(@"Searchstring: %@", searchString);
            [self fetchFavoritesForSearchText: searchString];
            [self fetchStationsForSearchText: searchString];
            NSLog(@"Textfield before backspace: %@", textField.text);
            return YES;
        }
        
        [self fetchFavoritesForSearchText: nil];
        [self fetchStationsForSearchText: nil];
        return YES;
    }
    
	if (textField.text.length >= 35 && range.length == 0)
	{
		
        //NSString *searchString = [textField.text stringByAppendingString: string];
        //[self fetchFavoritesForSearchText: searchString];
        //[self fetchStationsForSearchText: searchString];
        return(NO);
	}
    
    cs = [NSCharacterSet characterSetWithCharactersInString:STATIONILLEGAL];
    filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    NSString *searchString = [textField.text stringByAppendingString: filtered];
    [self fetchFavoritesForSearchText: searchString];
    [self fetchStationsForSearchText: searchString];
    return [string isEqualToString:filtered];
}

- (void) clearStationSetting {
    self.stationTextField.text = nil;
    self.stationName = nil;
    self.stationID = nil;
}

// ------------------------------------------------------------------------------------------------------

- (float) calculateDistance: (CLLocationCoordinate2D) aPoint bPoint:(CLLocationCoordinate2D)bPoint {
	CLLocation *startpoint = [[CLLocation alloc] initWithLatitude:aPoint.latitude longitude:aPoint.longitude];
	CLLocation *endPoint = [[CLLocation alloc] initWithLatitude:bPoint.latitude longitude:bPoint.longitude];
	CLLocationDistance calculatedDistance;
	calculatedDistance = [startpoint distanceFromLocation:endPoint];
	return ((float)calculatedDistance);
}

- (void)updateToStation:(Stations *)aStation {
	if (aStation) {
		//double cMapSpan = [self getCurrentMapSpan];
        double cMapSpan = mapSpaniPad;
		[self.mapView setRegion: MKCoordinateRegionMakeWithDistance(aStation.coordinate, cMapSpan, cMapSpan) animated: YES];
	}
}

- (BOOL) checkIfInCH: (CLLocationCoordinate2D) coordinate {
    if (coordinate.latitude > 47.818688) return NO;
    if (coordinate.latitude < 45.79817) return NO;
    if (coordinate.longitude > 10.508423) return NO;
    if (coordinate.longitude < 5.921631) return NO;
    return YES;
}

- (void)selectAnnotation:(Stations *)aStation
{
	[self.mapView selectAnnotation:aStation animated:YES];
    
}

- (NSArray *) fetchStationsClosestToCurrentLocation:(CLLocationCoordinate2D)coordinate {
    NSManagedObjectContext *context = self.managedObjectContext;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity: [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:context]];
    
    double cSearchSpan = searchSpaniPad;
    
	[request setPredicate:[NSPredicate predicateWithFormat:
                           @"latitude BETWEEN {%@, %@} AND longitude BETWEEN {%@, %@}",
                           [NSNumber numberWithFloat:coordinate.latitude - cSearchSpan],
                           [NSNumber numberWithFloat:coordinate.latitude + cSearchSpan],
                           [NSNumber numberWithFloat:coordinate.longitude - cSearchSpan],
                           [NSNumber numberWithFloat:coordinate.longitude + cSearchSpan]]];
    
	NSError *error = nil;
	NSArray *results = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
        //abort();
	}
    
    if (results) {
        if ([results count]>0) {
            NSLog(@"Stations fetched and calculating distances...");
            for (Stations *currentPOI in results) {
                //NSLog(@"Current station: %@", currentPOI.stationname);
                currentPOI.distance = [self calculateDistance: coordinate bPoint: [currentPOI coordinate]];
            }
            NSLog(@"Stations fetched. Distances calculated. Return results.");
            return results;
        }
    }
    return  nil;
}

- (void) getStationsClosestToCurrentLocationAndUpdateResultsArray:(void(^)(CLLocationCoordinate2D))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    self.locationManager = nil;
    
    if (!self.locationManager) {
        self.locationManager = [BKLocationManager sharedManager];
        
        __weak StationPickerViewControlleriPad *weakSelf = self;
        
        [self.locationManager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
            NSLog(@"didUpdateLocation: lat: %.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            
            self.userLocation = newLocation;
            self.userLocationDate = [NSDate date];
            
            [manager stopUpdatingLocation];
            manager = nil;
            
            
            if (![weakSelf checkIfInCH: newLocation.coordinate]) {
                /*
                 WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInWindow:NSLocalizedString(@"No network", @"No network available alert view title") message:NSLocalizedString(@"There is no WiFi or cellular network available. Please check or try again later.", @"No network available alert view message")];
                 [notice show];
                 
                 return;
                 */
                
                UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                [[NoticeviewMessages sharedNoticeMessagesController] showLocationOutsideSwitzerland: currentWindow];
            }
            
            NSLog(@"Got current location. FetchStationsClosestToCurrentLocation.");
            NSArray *resultArray = [weakSelf fetchStationsClosestToCurrentLocation: newLocation.coordinate];
            
            if (resultArray) {
                if ([resultArray count] > 0) {
                    if (self.stationsToCurrentLocation) {
                        self.stationsToCurrentLocation = nil;
                    }
                    self.stationsToCurrentLocation = resultArray;
                    if (successBlock) {
                        successBlock(newLocation.coordinate);
                    }
                } else {
                    int kStationsFetchAroundCurrentLocationDidNotReturnResults = 9988;
                    if (failureBlock) {
                        failureBlock(kStationsFetchAroundCurrentLocationDidNotReturnResults);
                    }
                }
            }
        }];
        
        [self.locationManager setDidFailBlock:^(CLLocationManager *manager, NSError *error) {
            NSLog(@"didFailUpdateLocation");
            
            //[self.activityIndicatorView stopAnimating];
            //self.activityIndicatorView.alpha = 0.0;
            
            NSString * errorMessage;
            
            switch ([error code]) {
                    
                case kCLErrorLocationUnknown:
                    errorMessage =
                    NSLocalizedString(@"We could not determine your location. Please try again later.", nil);
                    break;
                    
                case kCLErrorDenied:
                    errorMessage =
                    NSLocalizedString(@"We could not access your current location.", nil);
                    break;
                    
                default:
                    errorMessage =
                    NSLocalizedString(@"An unexpected error occured when trying to determine your location.", nil);
                    break;
                    
            };
            
            NSLog(@"Error: %@", errorMessage);
            
            //int kFailedToLocationStationsNearCurrentLocation = 1;
            if (failureBlock) {
                failureBlock([error code]);
            }
        }];
    }
    
    [self.locationManager startUpdatingLocationWithAccuracy:kCLLocationAccuracyHundredMeters];
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(Stations* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.8;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void) updateMapViewWithStationsAnnotationAndSelectedClosestStationToCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"Update map view with annotations");
    
    NSInteger closestIndex = 0;
    NSInteger currentIndex = 0;
    
    double closestDistanceSquared = CGFLOAT_MAX;
    for (Stations *current in self.stationsToCurrentLocation)
    {
        double longitude = [[current valueForKey:@"longitude"] doubleValue];
        double latitude = [[current valueForKey:@"latitude"] doubleValue];
        double delatLongitude = longitude - coordinate.longitude;
        double delatLatitude = latitude - coordinate.latitude;
        
        double distanceSquared =
        delatLongitude * delatLongitude + delatLatitude * delatLatitude;
        if (distanceSquared < closestDistanceSquared)
        {
            closestDistanceSquared = distanceSquared;
            closestIndex = currentIndex;
        }
        currentIndex++;
    }
    
    [self updateToStation:[self.stationsToCurrentLocation objectAtIndex:closestIndex]];
    [self.mapView removeAnnotations: self.mapView.annotations];
    
    [self.mapView addAnnotations:self.stationsToCurrentLocation];
    
    /*
    MKMapRect r = [self.mapView visibleMapRect];
    MKMapPoint pt = MKMapPointForCoordinate([[self.stationsToCurrentLocation objectAtIndex:closestIndex] coordinate]);
    r.origin.x = pt.x - r.size.width * 0.5;
    r.origin.y = pt.y - r.size.height * 0.25;
    //r.origin.x = pt.x - 0.4;
    //r.origin.y = pt.y - 0.4;
    //MKMapRect pointRect = MKMapRectMake(pt.x, pt.y, 0.2, 0.2);
    [self.mapView setVisibleMapRect:r animated:NO];
    */
    
    [self zoomToFitMapAnnotations:self.mapView];
    
    [self performSelector:@selector(selectAnnotation:)
               withObject:[self.stationsToCurrentLocation objectAtIndex:closestIndex]
               afterDelay:AnnotationDelayiPad];
    
}

- (void) updateListViewWithSortedStationsClosestToLocation:(CLLocationCoordinate2D)coordinate {
    NSLog(@"Update list view after sorting array");
    NSArray *sortedArray;
    sortedArray = [self.stationsToCurrentLocation sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        Stations *station1 = (Stations *)a;
        Stations *station2 = (Stations *)b;
        NSNumber *distance1 = [NSNumber numberWithFloat: station1.distance];
        NSNumber *distance2 = [NSNumber numberWithFloat: station2.distance];
        return [distance1 compare:distance2];
    }];
    
    if (self.sortedStationsToCurrentLocation) {
        self.sortedStationsToCurrentLocation = nil;
    }
    self.sortedStationsToCurrentLocation = sortedArray;
    
    [self.nextStationsTableView reloadData];
}


- (void) getStationsAndUpdateMapViewAndListView {
    NSLog(@"GetStationsAndUpdateMapView");
    if (self.stationsToCurrentLocation) {
        if (self.userLocationDate && self.userLocation) {
            NSTimeInterval howRecent = [self.userLocationDate timeIntervalSinceNow];
            if (abs(howRecent) < SECS_OLD_MAX) {
                return;
            }
        }
    }
    [self getStationsClosestToCurrentLocationAndUpdateResultsArray:^(CLLocationCoordinate2D coordinate) {
        [self updateMapViewWithStationsAnnotationAndSelectedClosestStationToCoordinate: coordinate];
        [self updateListViewWithSortedStationsClosestToLocation: coordinate];
        
    }
                                                      failureBlock: ^(NSUInteger errorCode){
                                                          NSLog(@"Error code: %d", errorCode);
                                                      }];
}

/*
- (void) getStationsAndUpdateMapView {
    NSLog(@"GetStationsAndUpdateMapView");
    if (self.stationsToCurrentLocation) {
        if (self.userLocationDate && self.userLocation) {
            NSTimeInterval howRecent = [self.userLocationDate timeIntervalSinceNow];
            if (abs(howRecent) < SECS_OLD_MAX) {
                return;
            }
        }
    }
    [self getStationsClosestToCurrentLocationAndUpdateResultsArray:^(CLLocationCoordinate2D coordinate) {
        [self updateMapViewWithStationsAnnotationAndSelectedClosestStationToCoordinate: coordinate];
    }
                                                      failureBlock: ^(NSUInteger errorCode){
                                                          NSLog(@"Error code: %d", errorCode);
                                                      }];
}




- (void) getStationsAndUpdateListView {
    NSLog(@"GetStationsAndUpdateListView");
    if (self.sortedStationsToCurrentLocation) {
        if (self.userLocationDate && self.userLocation) {
            NSTimeInterval howRecent = [self.userLocationDate timeIntervalSinceNow];
            if (abs(howRecent) < SECS_OLD_MAX) {
                return;
            }
        }
    }
    [self getStationsClosestToCurrentLocationAndUpdateResultsArray:^(CLLocationCoordinate2D coordinate) {
        [self updateListViewWithSortedStationsClosestToLocation: coordinate];
    }
                                                      failureBlock: ^(NSUInteger errorCode){
                                                          NSLog(@"Error code: %d", errorCode);
                                                      }];
    
}
*/

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //NSLog(@"mapView:%@ viewForAnnotation:%@", mapView, annotation);
    
    static NSString *const kAnnotationIdentifier = @"StationPickerStationAnnotation";
    StationPickerStationAnnotationView *annotationView = (StationPickerStationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
    if (! annotationView) {
        annotationView = [[StationPickerStationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
    }
    
    annotationView.canShowCallout = YES;
    
    //UIButton *chooseStationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIButton *chooseStationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *chooseStationButtonImage = [UIImage newImageFromMaskImage: [UIImage chooseStationButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *chooseStationButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage chooseStationButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
    [chooseStationButton setImage: chooseStationButtonImage forState: UIControlStateNormal];
    [chooseStationButton setImage: chooseStationButtonImageHighlighted forState: UIControlStateHighlighted];
    chooseStationButton.imageView.contentMode = UIViewContentModeCenter;
    chooseStationButton.frame = CGRectMake(0, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    //[chooseStationButton addTarget: self action: @selector(userChoosedStationOnMap:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView=chooseStationButton;
    annotationView.enabled = YES;
    annotationView.multipleTouchEnabled = NO;
    
    [annotationView setAnnotation:annotation];
    
    return annotationView;
    
    /*
     
     
     MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapStationAnnotation"];
     
     if (pin == nil) {
     pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapStationAnnotation"];
     } else {
     pin.annotation = annotation;
     }
     
     //pin.draggable = YES;
     pin.animatesDrop = YES;
     pin.canShowCallout = YES;
     
     
     UIButton *btnViewVenue = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     pin.rightCalloutAccessoryView=btnViewVenue;
     pin.enabled = YES;
     pin.multipleTouchEnabled = NO;
     //view.animatesDrop = YES;
     
     return pin;
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"StationPickerControlleriPad: should autororate");
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"StationPickerControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
    //[self.connectionsMapViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"StationPickerControlleriPad: didRotateToInterfaceOrientation");
    //[self.connectionsMapViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"StationPickerControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
	//[self.connectionsMapViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"StationPickerControlleriPad: viewdidappear");
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
	//[self.connectionsMapViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"StationPickerControlleriPad: viewwilldisappear");
	[super viewWillDisappear:animated];
	//[self.connectionsMapViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"StationPickerControlleriPad: viewdiddisappear");
	[super viewDidDisappear:animated];
	//[self.connectionsMapViewController viewDidDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"StationPickerControlleriPad: viewdidappear");
    [super viewWillAppear: animated];
    [self fetchFavoritesForSearchText: nil];
    [self fetchStationsForSearchText: nil];
    //[self.stationTextField becomeFirstResponder];
}

-(void) updateStationPickerWithMapData {
    [self fetchFavoritesForSearchText: nil];
    [self fetchStationsForSearchText: nil];
    [self.stationTextField becomeFirstResponder];
    [self getStationsAndUpdateMapViewAndListView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
