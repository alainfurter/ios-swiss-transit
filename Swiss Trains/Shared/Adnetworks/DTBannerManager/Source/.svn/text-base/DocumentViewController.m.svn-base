//
//  DocumentViewController.m
//  iCatalog
//
//  Created by Oliver Drobnik on 7/23/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import "DocumentViewController.h"
#import "UIWebView+DT.h"
#import "UIBarButtonItem+DT.h"
#import "UIViewController+Email.h"
#import "NSURL+DT.h"

@interface DocumentViewController ()

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *mimeType;
@property (nonatomic, retain) NSString *textEncodingName;
@property (nonatomic, retain) NSURL *url;

@end




@implementation DocumentViewController

@synthesize  delegate;

@synthesize webView = _webView, toolbar;
@synthesize bigProgressView = _bigProgressView;
@synthesize backButton, forwardButton, titleButton, activity;
@synthesize userAgent, receivedData, mimeType, textEncodingName, url = _url;;
@synthesize imageToShowUntilFirstPageLoaded;



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithURL:(NSURL *)url 
{
    if ((self = [super initWithNibName:@"DocumentViewController" bundle:nil])) {
        // Custom initialization
		
		_url = url;
		
		//_url = [[NSURL URLWithString:@"http://www.sephora.com/browse/product.jhtml?id=P268702&categoryId=C8330&shouldPaginate=true"] retain];
		//self.userAgent = @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_3 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7E18 Safari/528.16";
	}
	
    return self;
}


- (void)loadURL:(NSURL *)url
{
	
	if (!_url)
	{
		self.url = url;
		return;
	}
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	
	if (userAgent)
	{
		// do the http request manually
		[request addValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
		
		NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
		[connection start];
		[self webViewDidStartLoad:_webView];
	}
	else 
	{
		[_webView loadRequest:request];
	}	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	// hide toolbar if we are on a navigation stack
	if ([self.navigationController.viewControllers count]>0)
	{
		[toolbar removeFromSuperview], toolbar = nil;
		[activity removeFromSuperview], activity = nil;
		_webView.frame = self.view.bounds;
		
		// add done button to navigation bar
		//		UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
		//		self.navigationItem.rightBarButtonItem = doneButton;
	}
	else 
	{
		if (self.modalPresentationStyle == UIModalPresentationFormSheet)
		{
			titleButton.width = 320;
		}
	}
	
	if ([_url isFileURL])
	{
		allowBrowsingToExitApp = YES;
		_webView.scalesPageToFit = NO; // assume local files have viewport set
		NSMutableArray *items = [[toolbar items] mutableCopy];
		
		[items removeObject:backButton];
		[items removeObject:forwardButton];
		
		UIBarButtonItem *fixedSpace = [UIBarButtonItem fixedSpaceWithWidth:90];
		[items insertObject:fixedSpace atIndex:0];
		
		[toolbar setItems:items];
	}
	else 
	{
		_webView.scalesPageToFit = YES;
	}
	
	if (_url)
	{
		[self loadURL:_url];
	}
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (imageToShowUntilFirstPageLoaded)
	{
		_coveringImageView = [[UIImageView alloc] initWithImage:imageToShowUntilFirstPageLoaded];
		_coveringImageView.contentMode = UIViewContentModeScaleToFill;
		_coveringImageView.autoresizingMask = _webView.autoresizingMask;
		_coveringImageView.frame = _webView.frame;
		
		_webView.hidden = YES;
		
		[self.view addSubview:_coveringImageView];
	}

	
	if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone)
	{
		[titleButton setWidth:95];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)blockViewWithMessage:(NSString *)message
{
	_bigProgressView = [[DTBigProgressView alloc] initWithView:self.view];
	_bigProgressView.text = message;
	[_bigProgressView show:YES];
}


#pragma mark Actions
- (IBAction)done:(id)sender
{
	_webView.delegate = nil;
	
	if ([delegate respondsToSelector:@selector(didDismissDocumentViewController:)])
	{
		[delegate didDismissDocumentViewController:self];
	}
	else 
	{
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (IBAction)titleButtonPushed:(id)sender
{
	NSURLRequest *request = [NSURLRequest requestWithURL:_url];
	[_webView loadRequest:request];
}

- (void)askPermissionToExitToUrl:(NSURL *)url
{
	
	if ([[UIApplication sharedApplication] canOpenURL:url])
	{
		urlToOpenAfterPermission = url;
	}
	else 
	{
		return;
	}
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Would you like to open this web page?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	alert.tag = 2;
	alert.delegate = self;
	[alert show];
}

#pragma mark Web View Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		// mailto:
		NSString *scheme = [request.URL scheme];
		
		if ([scheme isEqualToString:@"mailto"])
		{
			NSDictionary *parameters = [request.URL dictionaryOfParameters];
			
			[self openMailTo:[parameters objectForKey:@"recipient"] body:[parameters objectForKey:@"body"] subject:[parameters objectForKey:@"subject"]];
			
			return NO;
		}
		
		if (allowBrowsingToExitApp)
		{
			[self askPermissionToExitToUrl:request.URL];
			return NO;
		}
		else 
		{
			return YES;
		}
		
	}
	
	// different user agent:
	
	if (self.userAgent)
	{
		if ([request isKindOfClass:[NSMutableURLRequest class]])
		{
			[(NSMutableURLRequest *)request addValue:self.userAgent  forHTTPHeaderField:@"User-Agent"];
		}
	}
	
	return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
	if (_coveringImageView)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[_coveringImageView removeFromSuperview];
		_webView.hidden = NO;
		 _coveringImageView = nil;
		[UIView commitAnimations];
	}
	
	backButton.enabled = _webView.canGoBack;
	forwardButton.enabled = _webView.canGoForward;
	[activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
	[_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('AppVersion').innerText = '%@';", [infoDict objectForKey:@"CFBundleVersion"]]];
	
	
	NSString *title = nil;
	if ([delegate respondsToSelector:@selector(documentViewController:customTitleForURL:)])
	{
		title = [delegate documentViewController:self customTitleForURL:[_webView.request URL]];
	}
	
	if (!title)
	{
		title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	}
	
	// set title
	if ([title length])
	{
		self.navigationItem.title = title;
		self.titleButton.title = title;
	}
	
	[activity stopAnimating];
	backButton.enabled = _webView.canGoBack;
	forwardButton.enabled = _webView.canGoForward;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if (_bigProgressView)
	{
		_bigProgressView.resultImage = [UIImage imageNamed:@"DTBannerManager.bundle/Unchecked.png"];
		[_bigProgressView show:NO];
		_bigProgressView = nil;
	}
	
	NSInteger errorCode = [error code];
	
	if (errorCode ==-999) return; // aborted navigation
	
	[activity stopAnimating];
	backButton.enabled = _webView.canGoBack;
	forwardButton.enabled = _webView.canGoForward;
	
	
	// incorrect URL -1003
	// no internect connection -1009
	NSString *path = [[NSBundle mainBundle] pathForResource:@"DTBannerManager.bundle/Warning-NoInternet" ofType:@"html"];
	NSURL *url = [NSURL fileURLWithPath:path];
	
	[_webView loadRequest:[NSURLRequest requestWithURL:url]];
	_webView.scalesPageToFit = NO;
	return;
}

/*
 - (CGSize) contentSizeForViewInPopover
 {
 NSLog(@"%@", NSStringFromCGSize([super contentSizeForViewInPopover]));
 return CGSizeMake(320.0, 418);
 }
 */

#pragma mark Alert View delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1 || alertView.tag == 2)
	{
		if (buttonIndex!=alertView.cancelButtonIndex)
		{
			[[UIApplication sharedApplication] openURL:urlToOpenAfterPermission];
		}
		else 
		{
			urlToOpenAfterPermission = nil;
		}
	}	
}


#pragma mark Manual URL Loading for custom user agent
- (NSMutableData *)receivedData
{
	if (!receivedData)
	{
		receivedData = [[NSMutableData alloc] init];
	}
	
	return receivedData;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
	self.url = request.URL;
	
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.mimeType = response.MIMEType;
	self.textEncodingName = response.textEncodingName;
	
	// could be redirections, so we set the Length to 0 every time
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	receivedData = nil;
	
	[self webView:_webView didFailLoadWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *scheme = [_url scheme];
	NSString *host = [_url host];
	NSString *path = [[_url path] stringByDeletingLastPathComponent];
	
	NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@/", scheme, host, path]];
	
	[_webView loadData:receivedData MIMEType:self.mimeType textEncodingName:textEncodingName baseURL:baseURL];
	[self webViewDidFinishLoad:_webView];
}


@end
