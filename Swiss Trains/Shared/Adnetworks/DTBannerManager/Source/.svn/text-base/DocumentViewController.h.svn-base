//
//  DocumentViewController.h
//  iCatalog
//
//  Created by Oliver Drobnik on 7/23/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTBigProgressView.h"

@class DocumentViewController;

@protocol DocumentViewControllerDelegate <NSObject>

- (void)didDismissDocumentViewController:(DocumentViewController *)documentViewController;

@optional
- (NSString *)documentViewController:(DocumentViewController *)documentViewController customTitleForURL:(NSURL *)url;

@end

@interface DocumentViewController : UIViewController <UIWebViewDelegate>
{
	NSURL *_url;

	UIWebView *_webView;
	UIToolbar *toolbar;
	UIImageView *_coveringImageView;
	
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
	UIBarButtonItem *titleButton;
	
	UIActivityIndicatorView *activity;
	
	__unsafe_unretained id <DocumentViewControllerDelegate> delegate;
	
	BOOL allowBrowsingToExitApp;
	
	NSURL *urlToOpenAfterPermission;
	
	DTBigProgressView *_bigProgressView;
	
	UIImage *imageToShowUntilFirstPageLoaded;
	
	// manual loading
	NSString *userAgent;
	NSString *mimeType;
	NSString *textEncodingName;
	NSMutableData *receivedData;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *titleButton;

@property (nonatomic, retain) DTBigProgressView *bigProgressView;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, retain) UIImage *imageToShowUntilFirstPageLoaded;


@property (nonatomic, assign) id <DocumentViewControllerDelegate> delegate;

@property (nonatomic, retain) NSString *userAgent;

- (id)initWithURL:(NSURL *)url;

- (void)loadURL:(NSURL *)url;

- (IBAction)done:(id)sender;
- (IBAction)titleButtonPushed:(id)sender;

- (void)blockViewWithMessage:(NSString *)message;

@end
