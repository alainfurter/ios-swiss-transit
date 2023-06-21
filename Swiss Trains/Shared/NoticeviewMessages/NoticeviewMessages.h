//
//  NoticeviewMessages.h
//  Swiss Trains
//
//  Created by Alain on 31.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBErrorNoticeView.h"
#import "WBInfoNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "WBStickyNoticeView.h"

@interface NoticeviewMessages : NSObject

+ (NoticeviewMessages *) sharedNoticeMessagesController;

- (void) showSbbReqDidNotReturnAnyResultNotice:(UIView *)view;
- (void) showSbbReqFailedNotice:(UIView *)view;
- (void) showSbbReqStationsNotAvailableNotice:(UIView *)view;
- (void) showSbbReqOtherUndefinedErrorNotice:(UIView *)view;

- (void) showSbbReqNoProductsForStbStation:(UIView *)view;

- (void) showNoNetworkErrorMessage:(UIView *)view;
- (void) showNoStationSelected:(UIView *)view;
- (void) showConStationsIdenticalMessage:(UIView *)view;
- (void) showStbStationsIdenticalMessage:(UIView *)view;

- (void) showLocationOutsideSwitzerland:(UIView *)view;

- (void) showLocationManagerDenied:(UIView *)view;
- (void) showLocationManagerError:(UIView *)view;

- (void) showCalendarAccessDenied:(UIView *)view;

- (void) showCalendarEntryAdded:(UIView *)view;
- (void) showAlarmEntryAdded:(UIView *)view;

- (void) showGeocodingErrorMessage:(UIView *)view;

- (void) showShopCannotOpenErrorMessage:(UIView *)view;
- (void) showShopNotReadyErrorMessage:(UIView *)view;
- (void) showInvalidReceiptErrorMessage:(UIView *)view;
- (void) showProductSuccessfullyPurchasedMessage:(UIView *)view;

@end
