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

@class IntroMoviePlayerControlleriPad;

@protocol IntroMoviePlayerControlleriPadDelegate <NSObject>
- (void)movieDidFinish:(IntroMoviePlayerControlleriPad *)controller;
@end

@interface IntroMoviePlayerControlleriPad : UIViewController

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UITapGestureRecognizer *recognizer;

@property (weak) id <IntroMoviePlayerControlleriPadDelegate> delegate;

@end
