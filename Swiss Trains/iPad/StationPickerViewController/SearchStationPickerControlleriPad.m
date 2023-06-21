//
//  SearchStationPickerControlleriPad.m
//  Swiss Trains
//
//  Created by Alain on 06.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SearchStationPickerControlleriPad.h"

#define BUTTONHEIGHT 36.0
#define TEXTFIELDHEIGHT 30.0
#define SEGMENTHEIGHT 18.0

#define STATIONLEGAL          @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890ÄÖÜÉÈÀÙÌÇÂÊÎÔÛËÏÜŸÒÓäöüéèàùìçâêîôûëïüÿòó "
#define STATIONILLEGAL        @"-/:;()$&@\".,?![]{}#%^*+=_\\|~<>€£¥•'"
#define NUMBERLEGAL           @"1234567890"

#define SECS_OLD_MAX 5.0f

#define KEYBOARDHEIGHTPORTRAIT  264.0
#define KEYBOARDHEIGHTLANDSCAPE 352.0

#define VALIDATIONKEYBOARDTIMEPASSED -1

const double searchSpaniPadListView = 0.00719942;
const double mapSpaniPadListView = 1600;

@interface SearchStationPickerControlleriPad ()

@end

@implementation SearchStationPickerControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    
    //NSLog(@"StationPickerControlleriPad. Screen size: %.1f, %.1f", size.width, size.height);
    
    CGFloat viewHeight = size.height - KEYBOARDHEIGHTLANDSCAPE - TABBARHEIGHT;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH * 2 + SPLITVIEWDIVIDERWIDTH, viewHeight)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    //NSLog(@"StationPickerControlleriPad view init: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //NSLog(@"StationPickerControlleriPad layoutSubviews");
	
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
    
    //NSLog(@"StationPickerControlleriPad. New size: %.1f, %.1f", newSize.width, newSize.height);
    
    //self.stationsViewToolbar.frame = CGRectMake(0, 0, newSize.width, TOOLBARHEIGHTIPAD);
    //self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    
    CGFloat viewHeight = newSize.height - KEYBOARDHEIGHTLANDSCAPE - TABBARHEIGHT;
    
    self.searchContainerView.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, viewHeight);
    self.divider.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH, 0, SPLITVIEWDIVIDERWIDTH, viewHeight);
    
    //self.mapContainerView.frame = CGRectMake(STATIONPICKERSEARCHVIEWWIDTHL, TOOLBARHEIGHTIPAD + 4, newSize.width - STATIONPICKERSEARCHVIEWWIDTHL - STATIONPICKERLISTVIEWWIDTHL, newSize.height - TOOLBARHEIGHTIPAD - 4);
    //self.mapView.frame = self.mapContainerView.bounds;
    //MKMapRect visibleMapRect;
    //BOOL portaitOrientation = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    //if (portaitOrientation) {
    //    visibleMapRect = [self mapRectForRect: CGRectMake(0, 0, self.mapContainerView.bounds.size.width, self.mapContainerView.bounds.size.height - KEYBOARDHEIGHTPORTRAIT)];
    //} else {
    //    visibleMapRect = [self mapRectForRect: CGRectMake(0, 0, self.mapContainerView.bounds.size.width, self.mapContainerView.bounds.size.height - KEYBOARDHEIGHTLANDSCAPE)];
    //}
    //[self.mapView setVisibleMapRect: visibleMapRect];
    
    
    //self.dividerRight.frame = CGRectMake(newSize.width - STATIONPICKERLISTVIEWWIDTHL, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    
    self.listContainerView.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, 0, SPLITVIEWMAINVIEWWIDTH, viewHeight);
    
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

/*
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
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //CGSize size = [UIApplication currentScreenSize];
    
    CGFloat viewHeight = self.view.frame.size.height;
    
    //NSLog(@"StationPickerControlleriPad. viewdidload. Screen size: %.1f, %.1f", size.width, size.height);
    //NSLog(@"StationsPickerViewController viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    
    //self.stationsViewToolbar = [[StatusToolbariPad alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    /*
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
    */
        
    self.searchContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, viewHeight)];
    [self.view addSubview: self.searchContainerView];
    
    //self.stationTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, BUTTONHEIGHT + 4, self.view.frame.size.width - 8, TEXTFIELDHEIGHT)];
    self.stationTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 6, self.searchContainerView.bounds.size.width - 15, TEXTFIELDHEIGHT)];
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
    
    self.divider = [[SplitSeparatorView alloc] initWithFrame: CGRectMake(SPLITVIEWMAINVIEWWIDTH, 0, SPLITVIEWDIVIDERWIDTH, viewHeight)];
    self.divider.backgroundColor = [UIColor lightGrayColor];
    self.divider.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview: self.divider];
    UIImage *image = [UIImage imageNamed:@"split-divider.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(-4, 0, image.size.width, image.size.height);
    [self.divider addSubview:imageView];
    
    /*
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
    */
         
    self.listContainerView = [[UIView alloc] initWithFrame: CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, 0, SPLITVIEWMAINVIEWWIDTH, viewHeight)];
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
    
    //[self.view addSubview: self.stationsViewToolbar];
    //[self.view addSubview: self.backButton];
    
    //NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //[nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    //[nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    self.fetchrequestresultsortingqueue = dispatch_queue_create("ch.fasoft.swisstransit.fetchrequestresultsortingqueue", NULL);
    
    self.searchactivityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    CGRect textfieldframe = self.stationTextField.frame;
    textfieldframe.origin.x = self.stationTextField.frame.size.width - 48;
    textfieldframe.origin.y = 5;
    textfieldframe.size.width = self.searchactivityindicator.frame.size.width;
    textfieldframe.size.height = self.searchactivityindicator.frame.size.height;
    self.searchactivityindicator.frame = textfieldframe;
    [self.stationTextField addSubview: self.searchactivityindicator];
    self.searchactivityindicator.alpha = 0.0;
    
    self.lastfavoritesearchresultcount = 0;
    self.laststationsearchresultcount = 0;
}

- (void) pushBackController:(id)sender {

    //NSLog(@"StationPickerControlleriPad pushback");
    
    [self.stationTextField resignFirstResponder];
    
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIValOperations];
    
    if (self.geocoder) {
        //NSLog(@"Cancel request pushback");
        [self.geocoder cancelGeocode];
        self.geocoder = nil;
    }
    
    if (self.searchResults != nil) {
        self.searchResults = nil;
    }
    
    if (self.validationResults != nil) {
        self.validationResults = nil;
    }
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressPushBackViewController:)])
    {
        [self.delegate didPressPushBackViewController: self];
    }
}

-(void) forcePushBackToPreviousViewController {

    //NSLog(@"StationsPickerViewControlleriPad force push back");
    [self.stationTextField resignFirstResponder];
    
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIValOperations];
    
    if (self.geocoder) {
        //NSLog(@"Cancel request forcepushback");
        [self.geocoder cancelGeocode];
        self.geocoder = nil;
    }
    
    if (self.searchResults != nil) {
        self.searchResults = nil;
    }
    
    if (self.validationResults != nil) {
        self.validationResults = nil;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressPushBackViewController:)])
    {
        [self.delegate didPressPushBackViewController: self];
    }
}

- (NSString *)removeDoublespacesInStringAndLeadingWhitespaces:(NSString *)string {
    
    NSString *trimmedstring = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [trimmedstring componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
}

- (void)fetchStationsForSearchText:(NSString*)searchText {
    
    NSString *filteredSearchText = [self removeDoublespacesInStringAndLeadingWhitespaces: searchText];
    
    //NSLog(@"Searchtext: %@", searchText);
        
    if (!(filteredSearchText && filteredSearchText.length)) {
        self.searchResults = nil;
        [self.stationsTableView reloadData];
        
        if (self.laststationsearchresultcount != 0) {
            self.laststationsearchresultchanged = YES;
            self.laststationsearchresultcount = 0;
        } else {
            self.laststationsearchresultchanged = NO;
            self.laststationsearchresultcount = 0;
        }
        
        //NSLog(@"Clear controller");
        
        return;
    }
    
    NSArray *searchTextSplit = [filteredSearchText componentsSeparatedByString: @" "];        
    NSMutableArray *searchresults = [NSMutableArray array];
    
    //NSLog(@"Start fetching entities....");
    
    if (searchTextSplit && searchTextSplit.count > 0) {
        NSString *searchtextstring = [searchTextSplit objectAtIndex: 0];
        
        //NSLog(@"Search text split: %@", searchtextstring);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sn beginswith[cd] %@", searchtextstring];
        
        NSString *firstLetter = [searchtextstring substringToIndex:1];
        
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
        if ([[firstLetter uppercaseString] isEqualToString: @"Ù"]) {
            firstLetter = @"u";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ì"]) {
            firstLetter = @"i";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ç"]) {
            firstLetter = @"c";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Â"]) {
            firstLetter = @"a";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ê"]) {
            firstLetter = @"e";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Î"]) {
            firstLetter = @"i";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ô"]) {
            firstLetter = @"o";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Û"]) {
            firstLetter = @"u";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ë"]) {
            firstLetter = @"e";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ï"]) {
            firstLetter = @"i";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ü"]) {
            firstLetter = @"u";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ÿ"]) {
            firstLetter = @"y";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ò"]) {
            firstLetter = @"o";
        }
        if ([[firstLetter uppercaseString] isEqualToString: @"Ó"]) {
            firstLetter = @"o";
        }
        
        NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSRange nr = [firstLetter rangeOfCharacterFromSet:numberSet];
        NSString *relationTo;
        if (nr.location != NSNotFound) {
            relationTo = [NSString stringWithFormat: @"numsTo"];
            firstLetter = @"NUMS";
        } else {
            relationTo = [NSString stringWithFormat: @"%@To", [firstLetter lowercaseString]];
        }
        
        NSManagedObjectContext *context = self.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity: [NSEntityDescription entityForName:[firstLetter uppercaseString] inManagedObjectContext:context]];
        [request setPredicate: predicate];
        
        [request setFetchBatchSize:100];
        
        NSString *sortKeyM = @"snp";
        NSString *sortKeyP2 = [NSString stringWithFormat: @"%@.firstlettercode", relationTo];
        NSString *sortKeyP1 = [NSString stringWithFormat: @"%@.transportcode", relationTo];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *stationSortDescM = [[NSSortDescriptor alloc] initWithKey:sortKeyM ascending:YES];
        NSSortDescriptor *stationSortDescP1 = [[NSSortDescriptor alloc] initWithKey:sortKeyP1 ascending:NO];
        NSSortDescriptor *stationSortDescP2 = [[NSSortDescriptor alloc] initWithKey:sortKeyP2 ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: stationSortDescM ,stationSortDescP1, stationSortDescP2, nil];
        
        [request setSortDescriptors:sortDescriptors];
        
        [request setFetchLimit:200];
        
        /*
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return;
            //abort();
        }
        */
        
        [context executeFetchRequestInBackground: request onComplete:^(NSArray *results) {
            if (searchTextSplit.count > 1) {
                                
                dispatch_async(_fetchrequestresultsortingqueue, ^(void) {
                
                NSArray *filteredArray = [results objectsAtIndexes:[results indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    
                    NSManagedObject *currentObject = (NSManagedObject *)obj;
                    NSString *entityName = currentObject.entity.name;
                    NSString *relationName = [NSString stringWithFormat: @"%@To", [entityName lowercaseString]];
                    NSManagedObject *station = (NSManagedObject *)[currentObject valueForKey: relationName];
                    NSString *stationname = [station valueForKey: @"stationname"];
                    NSString *teststring = [searchTextSplit objectAtIndex: 1];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", teststring];
                    BOOL result = [predicate evaluateWithObject:stationname];
                    return result;
                    
                }]];
                    
                [searchresults addObjectsFromArray: filteredArray];
                                        
                    if (searchresults && searchresults.count > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            self.searchResults = nil;
                            self.searchResults = searchresults;
                                                        
                            if (self.laststationsearchresultcount != searchresults.count) {
                                self.laststationsearchresultchanged = YES;
                                self.laststationsearchresultcount = searchresults.count;
                            } else {
                                self.laststationsearchresultchanged = NO;
                                self.laststationsearchresultcount = searchresults.count;
                            }
                            
                            #ifdef LOGOUTPUTON
                            NSLog(@"Entities fetched: %d", self.searchResults.count);
                            #endif
                            
                            [self.stationsTableView reloadData];
                            
                        });
                    } else {
                        self.searchResults = nil;
                                                
                        if (self.laststationsearchresultcount != 0) {
                            self.laststationsearchresultchanged = YES;
                            self.laststationsearchresultcount = 0;
                        } else {
                            self.laststationsearchresultchanged = NO;
                            self.laststationsearchresultcount = 0;
                        }
                        [self.stationsTableView reloadData];
                    }
                });
                
            } else {
                [searchresults addObjectsFromArray: results];
                
                if (searchresults && searchresults.count > 0) {
                    self.searchResults = nil;
                    self.searchResults = searchresults;
                    
                    if (self.laststationsearchresultcount != searchresults.count) {
                        self.laststationsearchresultchanged = YES;
                        self.laststationsearchresultcount = searchresults.count;
                    } else {
                        self.laststationsearchresultchanged = NO;
                        self.laststationsearchresultcount = searchresults.count;
                    }
                    
                    #ifdef LOGOUTPUTON
                    NSLog(@"Entities fetched: %d", self.searchResults.count);
                    #endif
                    
                    [self.stationsTableView reloadData];
                } else {
                    self.searchResults = nil;
                    
                    if (self.laststationsearchresultcount != 0) {
                        self.laststationsearchresultchanged = YES;
                        self.laststationsearchresultcount = 0;
                    } else {
                        self.laststationsearchresultchanged = NO;
                        self.laststationsearchresultcount = 0;
                    }
                    
                    [self.stationsTableView reloadData];
                }
            }
        }
                                         onError:^(NSError *error) {
                                             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                                             return;
                                         }];
        
        
    }
}

- (void)fetchFavoritesForSearchText:(NSString*)searchText {
    
    if (self.stationpickerType == connectionsStationpickerType) {
        [[FavoritesDataController sharedFavoritesDataController] fetchFavoritesListForStationStartingWithName: searchText onlystations:NO];
    } else {
        [[FavoritesDataController sharedFavoritesDataController] fetchFavoritesListForStationStartingWithName: searchText onlystations:YES];
    }
    
    NSUInteger numberoffavorites = [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations];
    
    if (numberoffavorites != self.lastfavoritesearchresultcount) {
        self.lastfavoritesearchresultchanged = YES;
        self.lastfavoritesearchresultcount = numberoffavorites;
    } else {
        self.lastfavoritesearchresultchanged = NO;
        self.lastfavoritesearchresultcount = numberoffavorites;
    }
    
    [self.stationsTableView reloadData];
}

- (void)fetchValidationResultsForSearchText:(NSString*)searchText {
    
    if (self.validationrequestalreadyexecuted) {
        return;
    }
    
    if (searchText && [searchText length]>= 6) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIValOperations];
        self.validationrequestalreadyexecuted = YES;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.searchactivityindicator.alpha = 1.0;
        [self.searchactivityindicator startAnimating];
        
        [[SBBAPIController sharedSBBAPIController] sendValidationReqXMLValidationRequest: searchText successBlock:^(NSArray *results){
            if (results && results.count > 0) {
                self.validationResults = results;
                [self.stationsTableView reloadData];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                self.searchactivityindicator.alpha = 0.0;
                [self.searchactivityindicator stopAnimating];
            }
        
        } failureBlock:^(NSUInteger errorcode) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            self.searchactivityindicator.alpha = 0.0;
            [self.searchactivityindicator stopAnimating];
            //NSLog(@"Validation errorcode: %d", errorcode);
        }];
    } else {
        self.validationResults = nil;
    }
}

- (void)startValidationResultTimer {
    self.validationtimer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(fetchValidationResultsIfTimePassed) userInfo:nil repeats: YES];
}

- (void)cancelValidationResultTimer {
    if (self.validationtimer) {
        [self.validationtimer invalidate];
    }
    self.validationtimer = nil;
}

- (void) fetchValidationResultsIfTimePassed {
    //NSLog(@"Timer");
    if ([self.dateoflastkeyboardtick timeIntervalSinceNow] < VALIDATIONKEYBOARDTIMEPASSED) {
        //NSLog(@"Time passes since last keyboard tick");
        if ([self.stationTextField.text length] >= 4) {
            //NSLog(@"Station name text length >= 4");
            NSUInteger numberoffavorites = [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations];
            NSUInteger numberofresults = self.searchResults.count;
            
            //NSLog(@"Station search result changed since last time: %@", self.laststationsearchresultchanged?@"Y":@"N");
            //NSLog(@"Favorites search result changed since last time: %@", self.lastfavoritesearchresultchanged?@"Y":@"N");
            
            if ((numberoffavorites == 0 && numberofresults == 0) || (!self.lastfavoritesearchresultchanged && !self.laststationsearchresultchanged)) {
                //NSLog(@"No other search results. Execute Validation request");
                if (!self.validationrequestalreadyexecuted) {
                    [self fetchValidationResultsForSearchText: self.stationTextField.text];
                } else {
                    //NSLog(@"Validation request already executed for that station");
                }
            
            }
            
        }
    }
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual: self.stationsTableView]) {
        return 3;
    } else if ([tableView isEqual: self.nextStationsTableView]) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual: self.stationsTableView]) {
        if (section == 0) {
            //NSLog(@"Search. number of rows in favorites: %d", [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations]);
            if ([[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations] > 0) {
                return [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations];
            }
            return 0;
        } else if (section == 1) {
            //NSLog(@"Search. number of rows in stations: %d", [[self.fetchedResultsController fetchedObjects] count]);
            
            if ([self.searchResults count] > 0) {
                self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            } else {
                self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            return [self.searchResults count];
        } else if (section == 2) {
            //NSLog(@"Search. number of rows in stations: %d", [[self.fetchedResultsController fetchedObjects] count]);
            
            if ([self.validationResults count] > 0) {
                self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            } else {
                self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            return [self.validationResults count];
        }
        return  0;
    } else if ([tableView isEqual: self.nextStationsTableView]) {
        //NSLog(@"List. number of rows: %d", [self.sortedStationsToCurrentLocation count]);
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
        //NSLog(@"Config stationscell");
        if (indexPath.section == 0) {
            //NSLog(@"Config stationscell. favorite");
            Station *currentStation = [[FavoritesDataController sharedFavoritesDataController]getFavoritesStationWithIndex: indexPath.row];
            StationsCell *stationsCell = (StationsCell *)cell;
            [stationsCell.titleLabel setText: currentStation.stationName];
            stationsCell.stationId = currentStation.stationId;
            stationsCell.stationlat = nil;
            stationsCell.stationlng = nil;
            [stationsCell setFavoriteCell:YES];
        } else if (indexPath.section == 1) {
            //NSLog(@"Config stationscell. search");
            if (self.searchResults) {
                NSManagedObject *currentObject = [self.searchResults objectAtIndex: indexPath.row];
                NSString *entityName = currentObject.entity.name;
                NSString *relationName = [NSString stringWithFormat: @"%@To", [entityName lowercaseString]];
                
                NSManagedObject *station = (NSManagedObject *)[currentObject valueForKey: relationName];
                StationsCell *stationsCell = (StationsCell *)cell;
                [stationsCell.titleLabel setText: [station valueForKey: @"stationname"]];
                stationsCell.stationId = [station valueForKey: @"externalid"];
                stationsCell.stationlat = nil;
                stationsCell.stationlng = nil;
                [stationsCell setFavoriteCell:NO];
            }
        } else if (indexPath.section == 2) {
            //NSLog(@"Config stationscell. search");
            if (self.validationResults) {
                Station *currentStation = [self.validationResults objectAtIndex: indexPath.row];
                StationsCell *stationsCell = (StationsCell *)cell;
                stationsCell.stationId = nil;
                stationsCell.stationlat = currentStation.latitude;
                stationsCell.stationlng = currentStation.longitude;
                [stationsCell.titleLabel setText: currentStation.stationName];
                [stationsCell setFavoriteCell:NO];
            }
        }
    } else if ([cell isKindOfClass:[ClosestStationsCell class]]) {
        //NSLog(@"Config nextstationscell");
        if (self.sortedStationsToCurrentLocation) {
            Stations *currentStation = [self.sortedStationsToCurrentLocation objectAtIndex: indexPath.row];
            
            ClosestStationsCell *closestStationsCell = (ClosestStationsCell *)cell;
            [closestStationsCell.titleLabel setText: currentStation.stationname];
            closestStationsCell.stationId = currentStation.externalid;
            //NSLog(@"Station distance: %@", [currentStation getFormmattedStationDistance]);
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
    
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIValOperations];
    
    if ([tableView isEqual: self.stationsTableView]) {
        StationsCell *stationCell = (StationsCell *)[tableView cellForRowAtIndexPath: indexPath];
        self.stationName = stationCell.titleLabel.text;
        
        if (!stationCell.stationId && !stationCell.stationlat && !stationCell.stationlng) {
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus internetStatus = [reachability currentReachabilityStatus];
            
            if (internetStatus == NotReachable) {
                // No network message
                if (self.delegate && [self.delegate respondsToSelector:@selector(showNoNetworkErrorMessage)]) {
                    [self.delegate showNoNetworkErrorMessage];
                }
                return;
            }
            
            if (self.geocoder) {
                //NSLog(@"Cancel request did select");
                [self.geocoder cancelGeocode];
                self.geocoder = nil;
            }
            
            self.geocoder = [[CLGeocoder alloc] init];
            NSString *codeString = [NSString stringWithFormat: @"Switzerland, %@", stationCell.titleLabel.text];
            //NSLog(@"Geocoding for Address: %@\n", codeString);
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            self.searchactivityindicator.alpha = 1.0;
            [self.searchactivityindicator startAnimating];
            
            [self.geocoder geocodeAddressString:codeString completionHandler:^(NSArray *placemarks, NSError *error) {
                
                if (!error) {                    
                    //for (CLPlacemark *placemark in placemarks) {
                    //    NSLog(@"%@\n %.2f,%.2f",[placemark description], placemark.location.horizontalAccuracy, placemark.location.verticalAccuracy);
                    //}
                    if (placemarks && placemarks.count > 0) {
                        
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        self.searchactivityindicator.alpha = 0.0;
                        [self.searchactivityindicator stopAnimating];
                        
                        //NSLog(@"Set station lat / long from placemark");
                        CLPlacemark *placemark = [placemarks objectAtIndex: 0];
                        stationCell.stationlat =  [NSNumber numberWithDouble: placemark.location.coordinate.latitude];
                        stationCell.stationlng =  [NSNumber numberWithDouble: placemark.location.coordinate.longitude];
                        
                        self.stationID = nil;
                        self.stationlat = stationCell.stationlat;
                        self.stationlng = stationCell.stationlng;
                        
                        station.stationName = self.stationName;
                        station.stationId = self.stationID;
                        station.latitude = self.stationlat;
                        station.longitude = self.stationlng;
                        
                        [[FavoritesDataController sharedFavoritesDataController] addStationToFavoritesList: station];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationWithStationTypeIndex:stationTypeIndex:station:)])
                        {
                            [self.delegate didSelectStationWithStationTypeIndex: self stationTypeIndex: self.stationTypeIndex station: station];
                        }
                        
                        [self.stationTextField resignFirstResponder];
                        
                        if (self.searchResults != nil) {
                            self.searchResults = nil;
                        }
                        
                        if (self.validationResults != nil) {
                            self.validationResults = nil;
                        }
                        
                        [self.stationsTableView reloadData];
                        [self.nextStationsTableView reloadData];
                        
                        [self pushBackController:nil];
                        
                        return ;
                    } else {
                        
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        self.searchactivityindicator.alpha = 0.0;
                        [self.searchactivityindicator stopAnimating];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(showGeocodingErrorMessage)]) {
                            [self.delegate showGeocodingErrorMessage];
                        }
                        return;
                    }
                } else {
                    if ([error code] == kCLErrorGeocodeCanceled) {
                        //NSLog(@"Geocode request was cancelled");
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        self.searchactivityindicator.alpha = 0.0;
                        [self.searchactivityindicator stopAnimating];
                    } else {
                        //NSLog(@"Geocoding error: %@", [error localizedDescription]);
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        self.searchactivityindicator.alpha = 0.0;
                        [self.searchactivityindicator stopAnimating];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(showGeocodingErrorMessage)]) {
                            [self.delegate showGeocodingErrorMessage];
                        }
                    }
                    return;
                }
            }];
            
        } else {
            self.stationID = stationCell.stationId;
            self.stationlat = stationCell.stationlat;
            self.stationlng = stationCell.stationlng;
            
            station.stationName = self.stationName;
            station.stationId = self.stationID;
            station.latitude = self.stationlat;
            station.longitude = self.stationlng;
            
            [[FavoritesDataController sharedFavoritesDataController] addStationToFavoritesList: station];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationWithStationTypeIndex:stationTypeIndex:station:)])
            {
                [self.delegate didSelectStationWithStationTypeIndex: self stationTypeIndex: self.stationTypeIndex station: station];
            }
            
            [self.stationTextField resignFirstResponder];
            
            
            if (self.geocoder) {
                //NSLog(@"Cancel request did select stationscell normal");
                [self.geocoder cancelGeocode];
                self.geocoder = nil;
            }
            
            if (self.searchResults != nil) {
                self.searchResults = nil;
            }
            
            if (self.validationResults != nil) {
                self.validationResults = nil;
            }
            
            [self.stationsTableView reloadData];
            [self.nextStationsTableView reloadData];
            
            [self pushBackController:nil];

        }
       
    } else if ([tableView isEqual: self.nextStationsTableView]) {
        ClosestStationsCell *closestStationCell = (ClosestStationsCell *)[tableView cellForRowAtIndexPath: indexPath];
        self.stationName = closestStationCell.titleLabel.text;
        self.stationID = closestStationCell.stationId;
        self.stationlat = nil;
        self.stationlng = nil;
        
        station.stationName = self.stationName;
        station.stationId = self.stationID;
        station.latitude = self.stationlat;
        station.longitude = self.stationlng;
        
        [[FavoritesDataController sharedFavoritesDataController] addStationToFavoritesList: station];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationWithStationTypeIndex:stationTypeIndex:station:)])
        {
            [self.delegate didSelectStationWithStationTypeIndex: self stationTypeIndex: self.stationTypeIndex station: station];
        }
        
        [self.stationTextField resignFirstResponder];
        
        if (self.geocoder) {
            //NSLog(@"Cancel request did select  next stationscell");
            [self.geocoder cancelGeocode];
            self.geocoder = nil;
        }
        
        if (self.searchResults != nil) {
            self.searchResults = nil;
        }
        
        if (self.validationResults != nil) {
            self.validationResults = nil;
        }
        
        [self.stationsTableView reloadData];
        [self.nextStationsTableView reloadData];
        
        [self pushBackController:nil];

    }
    
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

/*
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
*/
 
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
    
    //NSLog(@"Searchtext: %@", textField.text);
    //NSLog(@"Replacement string: %@", string);
    
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIValOperations];
    self.dateoflastkeyboardtick = [NSDate date];
    self.validationrequestalreadyexecuted = NO;
    if (self.geocoder) {
        [self.geocoder cancelGeocode];
        self.geocoder = nil;
    }
    self.validationResults = nil;
    
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if (isBackSpace == -8) {
        //NSLog(@"Characters in range is backspace");
        NSString *textfieldText = textField.text;
        if ([textfieldText length]>0) {
            NSString *searchString = [textfieldText substringToIndex:[textfieldText length]-1];
            //NSLog(@"Searchstring: %@", searchString);
            [self fetchFavoritesForSearchText: searchString];
            [self fetchStationsForSearchText: searchString];
            //NSLog(@"Textfield before backspace: %@", textField.text);
            
            /*
            NSUInteger numberoffavorites = [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations];
            NSUInteger numberofresults = self.searchResults.count;
            
            if (numberoffavorites == 0 && numberofresults == 0) {
                [self fetchValidationResultsForSearchText:searchString];
            }
            */
            
            return YES;
        }
        
        [self fetchFavoritesForSearchText: nil];
        [self fetchStationsForSearchText: nil];
        //[self fetchValidationResultsForSearchText: nil];
        
        return YES;
    }
    
	if (textField.text.length >= 35 && range.length == 0)
	{
		
        //NSString *searchString = [textField.text stringByAppendingString: string];
        //[self fetchFavoritesForSearchText: searchString];
        //[self fetchStationsForSearchText: searchString];
        return(NO);
	}
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:STATIONLEGAL] invertedSet];
    filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    NSString *searchString = [textField.text stringByAppendingString: filtered];
    [self fetchFavoritesForSearchText: searchString];
    [self fetchStationsForSearchText: searchString];
    
    /*
    NSUInteger numberoffavorites = [[FavoritesDataController sharedFavoritesDataController] getNumberOfFavoritesStations];
    NSUInteger numberofresults = self.searchResults.count;
    
    if (numberoffavorites == 0 && numberofresults == 0) {
        [self fetchValidationResultsForSearchText:searchString];
    }
    */
    
    return [string isEqualToString:filtered];
}

- (void) clearStationSetting {
    self.stationTextField.text = nil;
    self.stationName = nil;
    self.stationID = nil;
    self.stationlat = nil;
    self.stationlng = nil;
}

// ------------------------------------------------------------------------------------------------------

- (float) calculateDistance: (CLLocationCoordinate2D) aPoint bPoint:(CLLocationCoordinate2D)bPoint {
	CLLocation *startpoint = [[CLLocation alloc] initWithLatitude:aPoint.latitude longitude:aPoint.longitude];
	CLLocation *endPoint = [[CLLocation alloc] initWithLatitude:bPoint.latitude longitude:bPoint.longitude];
	CLLocationDistance calculatedDistance;
	calculatedDistance = [startpoint distanceFromLocation:endPoint];
	return ((float)calculatedDistance);
}

- (BOOL) checkIfInCH: (CLLocationCoordinate2D) coordinate {
    if (coordinate.latitude > 47.818688) return NO;
    if (coordinate.latitude < 45.79817) return NO;
    if (coordinate.longitude > 10.508423) return NO;
    if (coordinate.longitude < 5.921631) return NO;
    return YES;
}

- (NSArray *) fetchStationsClosestToCurrentLocation:(CLLocationCoordinate2D)coordinate {
    NSManagedObjectContext *context = self.managedObjectContext;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity: [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:context]];
    
    double cSearchSpan = searchSpaniPadListView;
    
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
            //NSLog(@"Stations fetched and calculating distances...");
            for (Stations *currentPOI in results) {
                //NSLog(@"Current station: %@", currentPOI.stationname);
                currentPOI.distance = [self calculateDistance: coordinate bPoint: [currentPOI coordinate]];
            }
            //NSLog(@"Stations fetched. Distances calculated. Return results.");
            return results;
        }
    }
    return  nil;
}

- (void) getStationsClosestToCurrentLocationAndUpdateResultsArray:(void(^)(CLLocationCoordinate2D))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    self.locationManager = nil;
    
    if (!self.locationManager) {
        self.locationManager = [BKLocationManager sharedManager];
        
        __weak SearchStationPickerControlleriPad *weakSelf = self;
        
        [self.locationManager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
            //NSLog(@"didUpdateLocation: lat: %.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            
            weakSelf.userLocation = newLocation;
            weakSelf.userLocationDate = [NSDate date];
            
            [manager stopUpdatingLocation];
            manager = nil;
            
            /*
            if (![weakSelf checkIfInCH: newLocation.coordinate]) {
                
                //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                //[[NoticeviewMessages sharedNoticeMessagesController] showLocationOutsideSwitzerland: currentWindow];
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showLocationOutsideSwitzerlandMessage)]) {
                    [weakSelf.delegate showLocationOutsideSwitzerlandMessage];
                }
            }
            */
            
            //NSLog(@"Got current location. FetchStationsClosestToCurrentLocation.");
            
            
            NSArray *resultArray = [weakSelf fetchStationsClosestToCurrentLocation: newLocation.coordinate];
            
            if (resultArray) {
                if ([resultArray count] > 0) {
                    if (weakSelf.stationsToCurrentLocation) {
                        weakSelf.stationsToCurrentLocation = nil;
                    }
                    weakSelf.stationsToCurrentLocation = resultArray;
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
            //NSLog(@"didFailUpdateLocation");
            
            //[self.activityIndicatorView stopAnimating];
            //self.activityIndicatorView.alpha = 0.0;
            
            NSString * errorMessage;
            
            switch ([error code]) {
                    
                case kCLErrorLocationUnknown:
                    errorMessage =
                    NSLocalizedString(@"We could not determine your location. Please try again later.", nil);
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showLocationManagerErrorMessage)]) {
                        [weakSelf.delegate showLocationManagerErrorMessage];
                    }
                    break;
                    
                case kCLErrorDenied:
                    errorMessage =
                    NSLocalizedString(@"We could not access your current location.", nil);
                    
                    /*
                    if (self.delegate && [self.delegate respondsToSelector:@selector(showLocationManagerDeniedMessage)]) {
                        [self.delegate showLocationManagerDeniedMessage];
                    }
                    */ 
                    
                    break;
                    
                default:
                    errorMessage =
                    NSLocalizedString(@"An unexpected error occured when trying to determine your location.", nil);
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showLocationManagerErrorMessage)]) {
                        [weakSelf.delegate showLocationManagerErrorMessage];
                    }
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

- (void) updateListViewWithSortedStationsClosestToLocation:(CLLocationCoordinate2D)coordinate {
    //NSLog(@"Update list view after sorting array");
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


- (void) getStationsAndUpdateListView {
    //NSLog(@"GetStationsAndUpdateMapView");
    if (self.stationsToCurrentLocation) {
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
    //NSLog(@"StationPickerControlleriPad: viewdidappear");
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
	//[self.connectionsMapViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"StationPickerControlleriPad: viewwilldisappear");
	[super viewWillDisappear:animated];
	//[self.connectionsMapViewController viewWillDisappear:animated];
    [self cancelValidationResultTimer];
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIValOperations];
}

- (void)viewDidDisappear:(BOOL)animated {
    //NSLog(@"StationPickerControlleriPad: viewdiddisappear");
	[super viewDidDisappear:animated];
	//[self.connectionsMapViewController viewDidDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    //NSLog(@"StationPickerControlleriPad: viewdidappear");
    [super viewWillAppear: animated];
    [self fetchFavoritesForSearchText: nil];
    [self fetchStationsForSearchText: nil];
    //[self.stationTextField becomeFirstResponder];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
#if IncludeAddressStationSearch
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *addresssearchenabledstring = [defaults objectForKey: @"addressSearchSwitch"];
    BOOL addresssearchenabled = [defaults boolForKey: @"addressSearchSwitch"];
    
    if (!addresssearchenabledstring) {
        addresssearchenabled = YES;
    }
    if (addresssearchenabled) {
        if (self.stationpickerType == connectionsStationpickerType) {
            [self startValidationResultTimer];
        }
    }
    
#endif
}

-(void) updateStationPickerWithData {
    [self fetchFavoritesForSearchText: nil];
    [self fetchStationsForSearchText: nil];
    [self.stationTextField becomeFirstResponder];
    [self getStationsAndUpdateListView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
