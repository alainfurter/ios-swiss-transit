//
//  UIViewController+Email.m
//  ELO
//
//  Created by Oliver Drobnik on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Email.h"
#import "NSString+DT.h"


@implementation UIViewController (Email)


#pragma mark Mail

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheetWithToAddress:(NSString *)toAddress body:(NSString *)html subject:(NSString *)subject
{
	MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
	
	if (html)
	{
		[mailView setMessageBody:html isHTML:YES];
	}
	
	if (subject)
	{
		[mailView setSubject:subject];
	}
	
	if (toAddress)
	{
		[mailView setToRecipients:[NSArray arrayWithObject:toAddress]];
	}
	
	mailView.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
	mailView.navigationBar.barStyle = MIN(self.navigationController.navigationBar.barStyle, 1);
	
	mailView.mailComposeDelegate = self;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		mailView.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	
	[self presentModalViewController:mailView animated:YES];
}

// WORKAROUND: Launches the Mail application on the device.
-(void)launchMailAppOnDeviceWithToAddress:(NSString *)toAddress body:(NSString *)body subject:(NSString *)subject
{
	if (!toAddress)
	{
		toAddress = @"";  // prevent (null)
	}

	if (!subject)
	{
		subject = @"";  // prevent (null)
	}

	if (!body)
	{
		body = @"";  // prevent (null)
	}
	
	
	NSString *email = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", toAddress, [subject stringByUrlEncoding], [body stringByUrlEncoding]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	//message.hidden = NO;
	// Notifies users about errors associated with the interface
	/*	
	 switch (result)
	 {
	 case MFMailComposeResultCancelled:
	 message.text = @"Result: canceled";
	 break;
	 case MFMailComposeResultSaved:
	 message.text = @"Result: saved";
	 break;
	 case MFMailComposeResultSent:
	 message.text = @"Result: sent";
	 break;
	 case MFMailComposeResultFailed:
	 message.text = @"Result: failed";
	 break;
	 default:
	 message.text = @"Result: not sent";
	 break;
	 } */
	[self dismissModalViewControllerAnimated:YES];
}


- (BOOL)hasInAppMailAndCanSendWithIt
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			return YES;
		}
		else
		{
			return NO;
		}
	}
	else
	{
		return NO;
	}
}

- (void)openMailTo:(NSString *)toAddress body:(NSString *)body subject:(NSString *)subject
{
	if ([self hasInAppMailAndCanSendWithIt])
	{
		[self displayComposerSheetWithToAddress:toAddress body:body subject:subject];
	}
	else
	{
		[self launchMailAppOnDeviceWithToAddress:toAddress body:body subject:subject];
	}
}



@end
