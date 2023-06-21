//
//  NSURL+DT.m
//  dictionary
//
//  Created by Oliver Drobnik on 9/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSURL+DT.h"
#import "NSString+DT.h"


@implementation NSURL (DT)

- (NSDictionary *) dictionaryOfParameters
{
	NSString *paramName;
	NSString *paramValue;
	
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
	
	NSString *parameters = [self query];
	
	if (!parameters)
	{
		if ([[self scheme] isEqualToString:@"mailto"])
		{
			NSString *string = [[self description] stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
			
			NSScanner *mailScanner = [NSScanner scannerWithString:string];
			
			NSString *address = nil;
			
			if ([mailScanner scanUpToString:@"?" intoString:&address])
			{
				[mailScanner scanString:@"?" intoString:NULL];
				[tmpDict setObject:address forKey:@"recipient"];
			}
				 
			parameters = [string substringFromIndex:[mailScanner scanLocation]];
		}
	}
	
	NSScanner *scanner = [NSScanner scannerWithString:parameters];
	
	// NOTE: This cannot deal with values that contain &amp; or similar HTML entities
	while (![scanner isAtEnd])
	{
		[scanner scanUpToString:@"=" intoString:&paramName];
		[scanner scanString:@"=" intoString:nil];
		[scanner scanUpToString:@"&" intoString:&paramValue];
		[scanner scanString:@"&" intoString:nil];
		
		[tmpDict setObject:[paramValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:paramName];
	}
	
	return [NSDictionary dictionaryWithDictionary:tmpDict];
}

@end
