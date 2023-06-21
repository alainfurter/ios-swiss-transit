//
//  IntroMoviePlayerController.h
//  Swiss Trains
//
//  Created by Alain on 07.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "Config.h"

//#import "IntroMoviePlayerControlleriPad.h"

#import "FTWButton.h"

@class IntroMoviePlayerController;

@protocol IntroMoviePlayerControllerDelegate <NSObject>
- (void)movieDidFinish:(IntroMoviePlayerController *)controller;
@end

@interface IntroMoviePlayerController : UIViewController

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (strong, nonatomic) FTWButton *searchButton;

@property (weak) id <IntroMoviePlayerControllerDelegate> delegate;

@end
