//
//  UIWebView+DT.m
//  iCatalog
//
//  Created by Oliver Drobnik on 8/11/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import "UIWebView+DT.h"


@implementation UIWebView (DT)


- (void)disableBounce
{
	for (id subview in self.subviews)
	{
		if ([[subview class] isSubclassOfClass: [UIScrollView class]])
		{
			((UIScrollView *)subview).bounces = NO;
		}
	}
}

@end
