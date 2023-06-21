//
//  NoticeviewMessages.m
//  Swiss Trains
//
//  Created by Alain on 31.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "NoticeviewMessages.h"

@implementation NoticeviewMessages

+ (NoticeviewMessages *)sharedNoticeMessagesController
{
    static NoticeviewMessages *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NoticeviewMessages alloc] init];
        // Do any other initialisation stuff here        
    });
    return sharedInstance;
}

- (void) showSbbReqDidNotReturnAnyResultNotice:(UIView *)view {
    
    NSString *noticeTitle = NSLocalizedString(@"No result", @"SBB Req notice - no results title");
    NSString *noticeText = NSLocalizedString(@"The request did not return any results. Either there is no information available for the selected station(s) or there is a temporary problem.", @"SBB Req notice - no results message");
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: noticeTitle message:noticeText];
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        //NSLog(@"showSbbReqDidNotReturnAnyResultNotice dismissed!");
    }];
    [notice show];
}

- (void) showSbbReqFailedNotice:(UIView *)view {
    
    NSString *noticeTitle = NSLocalizedString(@"Request failed", @"SBB Req notice - request failed title");
    NSString *noticeText = NSLocalizedString(@"The request failed. There may be several reasons. Either there is a temporary problem with the internet connection or the SBB server is temporarily unavailable. Please try again later.", @"SBB Req notice - request failed message");
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: noticeTitle message:noticeText];
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        //NSLog(@"showSbbReqDidNotReturnAnyResultNotice dismissed!");
    }];
    [notice show];
}

- (void) showSbbReqStationsNotAvailableNotice:(UIView *)view {
    
    NSString *noticeTitle = NSLocalizedString(@"Station undefined", @"SBB Req notice - station undefined title");
    NSString *noticeText = NSLocalizedString(@"One or more of the stations are not defined. This is a rare error. Please report this error to the support.", @"SBB Req notice - station undefined message");
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: noticeTitle message:noticeText];
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        //NSLog(@"showSbbReqDidNotReturnAnyResultNotice dismissed!");
    }];
    [notice show];
}

- (void) showSbbReqOtherUndefinedErrorNotice:(UIView *)view {
    
    NSString *noticeTitle = NSLocalizedString(@"Error", @"SBB Req notice - undefined error title");
    NSString *noticeText = NSLocalizedString(@"There was an error with this request. Please report this error to the support, if possible with the station names", @"SBB Req notice - undefined error message");
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: noticeTitle message:noticeText];
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        //NSLog(@"showSbbReqDidNotReturnAnyResultNotice dismissed!");
    }];
    [notice show];
}

- (void) showSbbReqNoProductsForStbStation:(UIView *)view {
    
    NSString *noticeTitle = NSLocalizedString(@"No products", @"SBB Req notice - no products error title");
    NSString *noticeText = NSLocalizedString(@"No connection was found for the selectd station. Please report this error to the support, if possible with the station name.", @"SBB Req notice - no products error message");
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: noticeTitle message:noticeText];
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        //NSLog(@"showSbbReqDidNotReturnAnyResultNotice dismissed!");
    }];
    [notice show];
}

- (void) showNoNetworkErrorMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: NSLocalizedString(@"No network", @"No network available alert view title") message: NSLocalizedString(@"There is no WiFi or cellular network available. Please check or try again later.", @"No network available alert view message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showNoStationSelected:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: NSLocalizedString(@"No station", @"No station stb request stations identical title") message: NSLocalizedString(@"You need to select a station first", @"No station stb request stations identical message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showConStationsIdenticalMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: NSLocalizedString(@"From and to identical", @"Selectstationsviewcontroller con request stations identical title") message: NSLocalizedString(@"The from and to are identical, please selected different locations", @"Selectstationsviewcontroller con request stations identical message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showStbStationsIdenticalMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title: NSLocalizedString(@"Start and direction identical", @"Selectstationsviewcontroller stb request stations identical title") message: NSLocalizedString(@"The start and the direction is the same, please selected different locations", @"Selectstationsviewcontroller stb request stations identical message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showLocationOutsideSwitzerland:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Outside Switzerland", @"Outside Switzerland error title") message: NSLocalizedString(@"Your current location is outside Switzerland. You may not find any stations nearby.", @"Outside Switzerland error title message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showLocationManagerDenied:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Location services disabled", @"Location access denied error title") message: NSLocalizedString(@"You did not allow this app to use your current location. Please enable this app to use your current location in order to make from/to current location requests. You can change this in the iPhone settings under Settings / Privacy / Location services. Alternatively you need to choose a station for the from/to location.", @"Location access denied error title message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showLocationManagerError:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Location service error", @"Location service error title") message: NSLocalizedString(@"An error occurred while determining your current location. Please try again later.", @"Location service error title message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showCalendarAccessDenied:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Calendar access disabled", @"Calendar access denied error title") message: NSLocalizedString(@"You did not allow this app to access your calendar. Please enable this app to access your calendar in order to save connections in there. You can change this in the iPhone settings under Settings / Privacy / Calendars.", @"Calendar access denied error title message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showCalendarEntryAdded:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView: view title: NSLocalizedString(@"The connection has been added to the calendar.", @"Added to calendar title message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showAlarmEntryAdded:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView: view title: NSLocalizedString(@"The alarm for the connection has been added.", @"Alarm added title message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showGeocodingErrorMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Location error", @"Location error title") message: NSLocalizedString(@"Unfortunately it was not possible to resolve the selected address, poi, location into GPS coordinates.", @"Location error title message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showShopCannotOpenErrorMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Shop cannot be opened", @"Shop cannot be opened alert view title") message: NSLocalizedString(@"The shop currently cannot be opened. Please try again later.", @"Shop cannot be opened alert view message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showShopNotReadyErrorMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Shop not ready", @"Shop not ready alert view title") message: NSLocalizedString(@"The shop is currently not ready for purchasing. Trying to initialize the shop. Please wait...", @"Shop not ready alert view message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showInvalidReceiptErrorMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView: view title: NSLocalizedString(@"Invalid receipt", @"Invalid receipt alert view title") message: NSLocalizedString(@"The receipt for this purchase transaction is invalid. Either the transaction is not valid or a severe unknown error occurred. You may report this to the support", @"Invalid receipt alert view message")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

- (void) showProductSuccessfullyPurchasedMessage:(UIView *)view {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView: view title: NSLocalizedString(@"Product successfully purchased", @"Product successfully purchased alert view")];
    if ([view isEqual: currentWindow]) {
        notice.originY = 20.0f;
    }
    [notice show];
}

@end
