//
//  IntroMoviePlayerController.m
//  Swiss Trains
//
//  Created by Alain on 07.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "IntroMoviePlayerControlleriPad.h"

@interface IntroMoviePlayerControlleriPad ()

@end

@implementation IntroMoviePlayerControlleriPad

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
    self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    //self.view.frame = CGRectMake(0, 0, 320, 200);
    //CGRect viewFrameIntro = self.view.frame;
    //CGFloat originX = (viewFrameIntro.size.width - 540) / 2;
    //CGFloat originY = (viewFrameIntro.size.height - 620) / 2;
    self.view.frame = CGRectMake(0, 0, IPADMOVIEWIDTH * IPADMOVIESCALEFACTOR, IPADMOVIEHEIGHT * IPADMOVIESCALEFACTOR);

    NSURL *movieURL = [[NSBundle mainBundle] URLForResource: @"Introipad" withExtension:@"m4v"];

    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL: movieURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieEventFullscreenHandler:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieEventFullscreenHandler:)
                                                 name:MPMoviePlayerDidEnterFullscreenNotification
                                               object:nil];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = NO;
    //_moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer prepareToPlay];
    
    UIButton *coverbutton = [UIButton buttonWithType: UIButtonTypeCustom];
    coverbutton.userInteractionEnabled = YES;
    coverbutton.backgroundColor = [UIColor clearColor];
    coverbutton.frame = CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 45, 60, 45);
    [coverbutton addTarget: self action:@selector(catchfs:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coverbutton];
    
        
    //[self performSelector: @selector(setMoviePlayerControlsVisible) withObject: self afterDelay: 1.0];
    
}

- (void)catchfs:(id)sender {
    //NSLog(@"Catch");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSSet *set = [event allTouches];
    NSArray *arr = [set allObjects];
    for (int i = 0; i < arr.count; i++) {
        UITouch *touch = (UITouch *) [arr objectAtIndex:i];
        
        NSArray *recognisers = touch.gestureRecognizers;
        for (UIGestureRecognizer *recogniser in recognisers) {
            if (recogniser.enabled && [recogniser isMemberOfClass:[UIPinchGestureRecognizer class]]) {
                recogniser.enabled = NO;
            }
        }
    }
}

- (void)movieEventFullscreenHandler:(NSNotification*)notification {
    [self.moviePlayer setFullscreen:NO animated:NO];
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    //NSLog(@"Handle tapp outside model view");
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            // Remove the recognizer first so it's view.window is valid.
            
            if (self.recognizer) {
                [self.view.window removeGestureRecognizer: self.recognizer];
                self.recognizer = nil;
            }
            
            [_moviePlayer stop];
            [_moviePlayer.view removeFromSuperview];
            self.moviePlayer = nil;
            
            if (self.delegate && [self.delegate respondsToSelector: @selector(movieDidFinish:)]) {
                [self.delegate movieDidFinish: self];
            }
            [[NSNotificationCenter defaultCenter] removeObserver: self];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if (self.recognizer) {
        [self.view.window removeGestureRecognizer: self.recognizer];
        self.recognizer = nil;
    }
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [_moviePlayer stop];
        [player.view removeFromSuperview];
        self.moviePlayer = nil;
    }
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(movieDidFinish:)]) {
        [self.delegate movieDidFinish: self];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
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
    
    /*
    UIView *fsbutton = [[_moviePlayer view] viewWithTag:512];
    [fsbutton setHidden:YES];
    
    for (UIView *view in _moviePlayer.view.subviews) {
        if ([view isKindOfClass: [UIButton class]]) {
            NSLog(@"button class with tag: %d", view.tag);
        }
    }
    */
    
    [_moviePlayer play];
    
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [self.recognizer setNumberOfTapsRequired:1];
    self.recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer: self.recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
