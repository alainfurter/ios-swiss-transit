//
//  RssDetailInfoViewController.m
//  Swiss Trains
//
//  Created by Alain on 21.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "RssDetailInfoViewController.h"

#define BUTTONHEIGHT 36.0

@interface RssDetailInfoViewController ()

@end

@implementation RssDetailInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor rssDetailBackgroundColor];
        
        self.stationsViewToolbar = [[StationsViewToolbar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        
        UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
        UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
        
        [self.backButton setImage: backButtonImage forState: UIControlStateNormal];
        [self.backButton setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
        self.backButton.imageView.contentMode = UIViewContentModeCenter;
        self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.backButton.showsTouchWhenHighlighted = YES;
        [self.backButton addTarget: self action: @selector(pushBackController:) forControlEvents:UIControlEventTouchUpInside];
        
        self.descriptionDetailView = [[UIWebView alloc] initWithFrame: CGRectMake(0, TOOLBARHEIGHT , self.view.frame.size.width, self.view.frame.size.height - TOOLBARHEIGHT)];
        self.descriptionDetailView.backgroundColor = [UIColor clearColor];
        [self.descriptionDetailView setOpaque: NO];
        
        for (id subview in self.descriptionDetailView.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
                for (UIView *scrollSubview in [subview subviews])
                    if ([[scrollSubview class] isSubclassOfClass:[UIImageView class]])
                        scrollSubview.hidden = YES;
            }
        
        [self.view addSubview: self.descriptionDetailView];
        [self.view addSubview: self.stationsViewToolbar];
        [self.view addSubview: self.backButton];
        
        NSString *paths = [[NSBundle mainBundle] resourcePath];
        NSString *htmlPath = [paths stringByAppendingPathComponent:@"rssitem.html"];
        self.rsshtmlsource = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];

    }
    return self;
}

/*
- (void) loadDescriptionIntoDetailView:(NSString *)description {
    [self.descriptionDetailView loadHTMLString: description baseURL: nil];
}
*/

- (void) loadDescriptionIntoDetailView:(RssInfoItem *)rssinfoitem {
    //NSLog(@"Item: %@, %@, %@", rssinfoitem.pubdatestring, rssinfoitem.title, rssinfoitem.description);
    
    if (self.rsshtmlsource) {
        NSString *htmlstring = [self.rsshtmlsource copy];
        
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_TITLE" withString: rssinfoitem.title];
        
        if (rssinfoitem.pubdatestring) {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_PUBDATE" withString: rssinfoitem.pubdatestring];
        } else {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_PUBDATE" withString: @"-"];
        }
        if (rssinfoitem.description) {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_DESCRIPTION" withString: rssinfoitem.description];
        } else {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_DESCRIPTION" withString: rssinfoitem.title];
        }
        
        [self.descriptionDetailView loadHTMLString: htmlstring baseURL: nil];
    } else {
        [self.descriptionDetailView loadHTMLString: rssinfoitem.description baseURL: nil];
    }
}

- (void) pushBackController:(id)sender {

    [self.navigationController popViewControllerAnimated: YES];
}

-(void) forcePushBackToPreviousViewController {
    NSLog(@"RssDetailViewController force push back");
    [self.navigationController popViewControllerAnimated: NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
