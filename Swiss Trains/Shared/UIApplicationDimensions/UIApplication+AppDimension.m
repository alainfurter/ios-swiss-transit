//
//  UIApplication+AppDimension.m
//  NoteIt iOS
//
//  Created by Alain on 02.09.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "UIApplication+AppDimension.h"

@implementation UIApplication (AppDimension)

+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

+(CGSize) currentScreenSize {
    UIScreen *screen = [UIScreen mainScreen];
	CGRect bounds = screen.bounds; // always implicitly in Portrait orientation.
	CGRect appFrame = screen.applicationFrame;
	CGSize size = bounds.size;
	
	float statusBarHeight = MAX((bounds.size.width - appFrame.size.width), (bounds.size.height - appFrame.size.height));
	    
	// let's figure out if width/height must be swapped
	if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
	{
		// we're going to landscape, which means we gotta swap them
		size.width = bounds.size.height;
		size.height = bounds.size.width;
	}
	
	size.height = size.height - statusBarHeight;
	//size.height = size.height - statusBarHeight;
    return size;
}

@end
