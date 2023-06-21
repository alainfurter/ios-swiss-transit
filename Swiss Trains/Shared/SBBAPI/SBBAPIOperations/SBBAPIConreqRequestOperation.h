//
//  SBBAPIConreqRequestOperation.h
//  Swiss Trains
//
//  Created by Alain on 24.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

#import "TouchXML.h"

#import "UIDevice+IdentifierAddition.h"
#import "NSStringAdditions.h"

#import "Config.h"

#import "SBBAPIOperationsDefinitions.h"

@interface SBBAPIConreqRequestOperation : NSOperation

@property (strong, nonatomic) AFHTTPClient *conreqHttpClient;

@property (strong, nonatomic) Station *startstation;
@property (strong, nonatomic) Station *endstation;
@property (strong, nonatomic) Station *viastation;

@property (strong, nonatomic) NSDate *connectiondate;
@property (assign) BOOL isdeparturetime;

@property (assign) NSUInteger sbbApiLanguageLocale;
@property (assign) NSUInteger sbbConReqNumberOfConnectionsForRequest;
@property (assign) NSUInteger sbbApiConreqTimeout;

@property (strong, nonatomic) SBBAPIConreqRequestSuccessCompletionBlock sbbAPIConreqRequestSuccessCompletionBlock;
@property (strong, nonatomic) SBBAPIConreqRequestFailureCompletionBlock sbbAPIConreqRequestFailureCompletionBlock;
@property (strong, nonatomic) SBBAPIConreqRequestErrorReportingBlock sbbAPIConreqRequestErrorReportingBlock;

- (id)initWithStartstationEndstationViaStationDeparturetimeIsdeparturetimeflag:(Station *)startstation endstation:(Station *)endstation viastation:(Station *)viastation connectiondate:(NSDate *)connectiondate ispdeparturedate:(BOOL)isdeparturedate;

- (void)setCompletionBlockWithSuccess:(SBBAPIConreqRequestSuccessCompletionBlock)successblock
                              failure:(SBBAPIConreqRequestFailureCompletionBlock)failureblock;

- (void)setErrorReportingBlock:(SBBAPIConreqRequestErrorReportingBlock)errorblock;

- (void) setSBBAPILanguageLocale:(NSUInteger)languagelocale;
- (void) setSBBConReqNumberOfConnectionsForRequest:(NSUInteger)numberofconnections;
- (void) setSBBAPIConreqTimeout:(NSUInteger)timeout;

@end
