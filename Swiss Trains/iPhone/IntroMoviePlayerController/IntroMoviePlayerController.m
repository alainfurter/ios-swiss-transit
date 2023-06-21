//
//  IntroMoviePlayerController.m
//  Swiss Trains
//
//  Created by Alain on 07.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "IntroMoviePlayerController.h"

@interface IntroMoviePlayerController ()

@end

@implementation IntroMoviePlayerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //NSLog(@"ConnectionsContainer viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.searchButton = [[FTWButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - BUTTONHEIGHT - 10, self.view.frame.size.width - 40, BUTTONHEIGHT)];
    [self.searchButton addGrayStyleForState:UIControlStateNormal];
    [self.searchButton setColors:[NSArray arrayWithObjects:
                                  [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                  [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                  nil] forControlState:UIControlStateHighlighted];
    [self.searchButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.searchButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.searchButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
    NSString *searchButtonText = NSLocalizedString(@"Cancel", @"Cancel movie button title title text");
    [self.searchButton setText:searchButtonText forControlState:UIControlStateNormal];
    [self.searchButton setText:searchButtonText forControlState:UIControlStateHighlighted];
    [self.searchButton setText:searchButtonText forControlState:UIControlStateSelected];
    
    [self.searchButton addTarget: self action: @selector(cancelMovie:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.searchButton];
    
    
    //self.view.frame = CGRectMake(0, 0, 320, 200);
    //CGRect viewFrameIntro = self.view.frame;
    //CGFloat originX = (viewFrameIntro.size.width - 540) / 2;
    //CGFloat originY = (viewFrameIntro.size.height - 620) / 2;
    //self.view.frame = CGRectMake(0, 0, self.frame.s, IPADMOVIEHEIGHT * IPADMOVIESCALEFACTOR);
    
    //introMoviePlayerControlleriPad.view.frame = CGRectMake(originX, originY, 540, 620);
        
    NSURL *movieURL = [[NSBundle mainBundle] URLForResource: @"Introiphone" withExtension:@"m4v"];
    
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL: movieURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = NO;
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    //CGRect viewFrame = self.view.frame;
    CGFloat startX = -(IPHONEMOVIEWIDTH * IPHONEMOVIESCALEFACTOR - self.view.frame.size.width) / 2;
    CGFloat startY = (self.view.frame.size.height - IPHONEMOVIEHEIGHT * IPHONEMOVIESCALEFACTOR) / 2 - 50;
    
    //NSLog(@"Start: %.1f, %.1f",startX, startY);
    
    _moviePlayer.view.frame = CGRectMake(startX, startY, IPHONEMOVIEWIDTH * IPHONEMOVIESCALEFACTOR, IPHONEMOVIEWIDTH * IPHONEMOVIESCALEFACTOR);
    
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer prepareToPlay];
    
    [self performSelector: @selector(setMoviePlayerControlsVisible) withObject: self afterDelay: 1.0];
    
}

- (void) cancelMovie:(id)sender {
    
    //NSLog(@"Cancel movie tapped");
    
    [_moviePlayer stop];
    [_moviePlayer.view removeFromSuperview];
    self.moviePlayer = nil;
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(movieDidFinish:)]) {
        [self.delegate movieDidFinish: self];
    }
    
    [self dismissViewControllerAnimated: YES completion: ^{}];
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    //NSLog(@"Handle tapp outside model view");
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
            
        // See if the point touched is within these rectangular bounds
        if (!CGRectContainsPoint(CGRectMake(10, 60, self.view.frame.size.width - 20, self.view.frame.size.height - 10 - BUTTONHEIGHT - 10), location)) {
            //NSLog(@"Touch point is outside rect");
            [self.view removeGestureRecognizer:sender];
            [_moviePlayer stop];
            [_moviePlayer.view removeFromSuperview];
            self.moviePlayer = nil;
            
            if (self.delegate && [self.delegate respondsToSelector: @selector(movieDidFinish:)]) {
                [self.delegate movieDidFinish: self];
            }
            
            [self dismissViewControllerAnimated: YES completion: ^{}];
        }
    }
}

- (void) setMoviePlayerControlsVisible {
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
}

-(void)playMovie {
    
    //[_moviePlayer setFullscreen:YES animated:YES];
    [_moviePlayer play];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
        self.moviePlayer = nil;
    }
    [self dismissViewControllerAnimated: YES completion: ^{}];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.view.superview.bounds = CGRectMake(0, 0, 540, 500);  // your size here
    [self playMovie];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [_moviePlayer play];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view addGestureRecognizer:recognizer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
