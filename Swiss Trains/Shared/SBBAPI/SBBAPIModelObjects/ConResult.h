//
//  ConResult.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConOverview.h"
#import "ConSectionList.h"

@interface ConResult : NSObject

@property (strong, nonatomic) NSString *conResId;

@property (strong, nonatomic) ConOverview *overView;
@property (strong, nonatomic) ConSectionList *conSectionList;

@property (strong, nonatomic) NSString *knownBetterStartLocationName;
@property (strong, nonatomic) NSString *knownBetterEndLocationName;

@property (strong, nonatomic) NSMutableArray *connectionInfoList;

@property (strong, nonatomic) NSArray *routes;
@property (assign) BOOL detailedroutesprechecked;
@property (assign) BOOL detailedroutesavailable;

@property (strong, nonatomic) NSDate *searchdate;
@property (assign) BOOL searchdateisdeparturedate;

@property (assign) BOOL hasTransferInConSections;

@end
