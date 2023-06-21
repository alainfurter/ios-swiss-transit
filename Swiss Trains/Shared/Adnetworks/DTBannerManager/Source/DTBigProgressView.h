//
//  BigProgressView.h
//  ELO
//
//  Created by Oliver on 02.09.09.
//  Copyright 2009 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTBigProgressView : UIView 
{
	UIActivityIndicatorView *actView;
	UIView *grayView;
	UILabel *textLabel;
	NSString *text;
	UIView *_viewToBlock;
	
	UIImage *progressImage;
	UIImage *resultImage;
	
	UIImageView *imageView;
	
	NSTimeInterval fadeOutDelay;
	
	BOOL _isShowing;
	BOOL _showingInProgress;
	BOOL _hideImmediatelyAfterShowing;
}


@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIImage *progressImage;
@property (nonatomic, retain) UIImage *resultImage;

@property (nonatomic) NSTimeInterval fadeOutDelay;


- (id)initWithView:(UIView *)view;
- (void)show:(BOOL)show;

- (void)showMessage:(NSString *)message withImage:(UIImage *)image;



@end
