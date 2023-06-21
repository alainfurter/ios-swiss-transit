//
//  UITableViewController+Ads.m
//  GeoCorder
//
//  Created by Oliver Drobnik on 7/29/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import "UITableViewController+Ads.h"
#import "DTBannerManager.h"

@implementation UITableViewController (Ads)



- (void)adjustTableViewInsetsForBanner
{
	if ([[DTBannerManager sharedManager] isBannerVisible])
	{
		[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
		[self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 50, 0)];
	}
	else 
	{
		[self.tableView setContentInset:UIEdgeInsetsZero];
		[self.tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
	}
}

- (void)subscribeToBannerNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustTableViewInsetsForBanner) name:@"BannerDidSlideIn" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustTableViewInsetsForBanner) name:@"BannerWillSlideOut" object:nil];
}																			  
																			 
- (void)unsubscribeFromBannerNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"BannerDidSlideIn" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"BannerWillSlideOut" object:nil];
}																			  


@end

