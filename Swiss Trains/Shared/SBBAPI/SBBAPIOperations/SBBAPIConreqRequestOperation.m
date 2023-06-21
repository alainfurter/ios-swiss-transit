//
//  SBBAPIConreqRequestOperation.m
//  Swiss Trains
//
//  Created by Alain on 24.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SBBAPIConreqRequestOperation.h"

@implementation SBBAPIConreqRequestOperation

- (id)initWithStartstationEndstationViaStationDeparturetimeIsdeparturetimeflag:(Station *)startstation endstation:(Station *)endstation viastation:(Station *)viastation connectiondate:(NSDate *)connectiondate ispdeparturedate:(BOOL)isdeparturedate {
    
    self = [super init];
    if (self) {
        _startstation = startstation;
        _endstation = endstation;
        _viastation = viastation;
        _connectiondate = connectiondate;
        _isdeparturetime = isdeparturedate;
        _sbbApiLanguageLocale = reqEnglish;
        _sbbConReqNumberOfConnectionsForRequest = 4;
        _sbbApiConreqTimeout = SBBAPIREQUESTCONREQSTANDARDTIMEOUT;
    }
    return self;
    
}

- (void)setCompletionBlockWithSuccess:(SBBAPIConreqRequestSuccessCompletionBlock)successblock
                              failure:(SBBAPIConreqRequestFailureCompletionBlock)failureblock
{
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-retain-cycles"
    //__weak __typeof(&*self)weakSelf = self;
    
    if (successblock) {
        
        self.sbbAPIConreqRequestSuccessCompletionBlock = ^(Connections *connections){
            dispatch_async(dispatch_get_main_queue(), ^{
                successblock(connections);
            });
        };
    }
    
    if (failureblock) {
        self.sbbAPIConreqRequestFailureCompletionBlock = ^(NSUInteger errorcode){
            dispatch_async(dispatch_get_main_queue(), ^{
                failureblock(errorcode);
            });
        };
    }
    
    //#pragma clang diagnostic pop
}

- (void)setErrorReportingBlock:(SBBAPIConreqRequestErrorReportingBlock)errorblock {
    if (errorblock) {
        
        self.sbbAPIConreqRequestErrorReportingBlock = ^(NSString *errorurlpath){
            dispatch_async(dispatch_get_main_queue(), ^{
                errorblock(errorurlpath);
            });
        };
    }
}

- (void) setSBBAPILanguageLocale:(NSUInteger)languagelocale {
    if (languagelocale == reqEnglish || languagelocale == reqGerman || languagelocale == reqFrench || languagelocale == reqItalian) {
        self.sbbApiLanguageLocale = languagelocale;
    }
}

- (void) setSBBConReqNumberOfConnectionsForRequest:(NSUInteger)numberofconnections {
    if (numberofconnections > 4) {
        self.sbbConReqNumberOfConnectionsForRequest = numberofconnections;
    }
}

- (void) setSBBAPIConreqTimeout:(NSUInteger)timeout {
    self.sbbApiConreqTimeout = timeout;
}

- (NSString *) getUniqueId {
    return [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString *) createErrorReportingUrlString:(NSString *)errorcode errortext:(NSString *)errortext startname:(NSString *)startname startid:(NSString *)startid endname:(NSString *)endname endid:(NSString *)endid{
    if (errortext && errorcode) {
        
        NSString *appid = AppIDIPHONE;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                appid = AppIDIPAD;
        } else {
                appid = AppIDIPHONE;
        }
        
        NSString *stStationName = @"NA";
        NSString *enStationName = @"NA";
        NSString *stStationId = @"NA";
        NSString *enStationId = @"NA";
        if (startname && [startname length] >= 2) {
            stStationName = startname;
        }
        if (endname && [endname length] >= 2) {
            enStationName = endname;
        }
        if (startid && [startid length] >= 2) {
            stStationId = startid;
        }
        if (endid && [endid length] >= 2) {
            enStationId = endid;
        }
        
        
        NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *countrycode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
        
        NSString *deviceid = [self getUniqueId];
        NSString *uuid = [NSString getSessionId];
        
        NSString *urlpath = [NSString stringWithFormat: @"%@?ap=%@&di=%@&ds=%@&dn=%@&dh=%@&dc=%@&dl=%@&dp=%@&db=%@&ec=%@&et=%@&sn=%@&si=%@&en=%@&ei=%@&dm=%@&dy=%@&dv=%@", kERROR_REPORTING_URL_PATH,
                             appid, [deviceid stringByEscapingURL], [uuid stringByEscapingURL], [[[UIDevice currentDevice] name] stringByEscapingURL],
                             [@"0" stringByEscapingURL], [countrycode stringByEscapingURL], [languageCode stringByEscapingURL],
                             [@"NA" stringByEscapingURL], [@"NA" stringByEscapingURL], [errorcode stringByEscapingURL], [errortext stringByEscapingURL],
                             [stStationName stringByEscapingURL], [stStationId stringByEscapingURL], [enStationName stringByEscapingURL], [enStationId stringByEscapingURL],
                             [[[UIDevice currentDevice] model] stringByEscapingURL], [[[UIDevice currentDevice] systemName] stringByEscapingURL],
                             [[[UIDevice currentDevice] systemVersion] stringByEscapingURL]];
        return urlpath;
    }
    return nil;
}

- (NSString *) fromISOLatinToUTF8: (NSString *) input
{
	if (!input) return (nil);
	NSData *tempData = [input dataUsingEncoding: NSISOLatin1StringEncoding];
	NSString *utfString = [[NSString alloc] initWithData: tempData encoding:NSUTF8StringEncoding];
	return (utfString);
}

- (void)main {
    
    @autoreleasepool {
        
        if (!_startstation || !_endstation || !_connectiondate) {
            return;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSString *dateString = [dateFormatter stringFromDate: _connectiondate];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSString *timeString = [timeFormatter stringFromDate: _connectiondate];
        
        NSString *xmlString = kConReq_XML_SOURCE;
        NSString *xmlStartString;
        NSString *xmlEndString;
        
        #ifdef SBBAPILogLevelReqEnterExit
        NSLog(@"Put together XML request");
        #endif
        
        if (_startstation.stationName && _startstation.stationId) {
            
            #ifdef SBBAPILogLevelFull
            NSLog(@"Start station set");
            #endif
            
            xmlStartString = kConReq_XML_START_STATION_SOURCE;
            xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"STARTSTATIONNAME" withString: [_startstation stationName]];
            xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"STARTSTATIONID" withString: [_startstation stationId]];
            xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
        } else {
            
            #ifdef SBBAPILogLevelFull
            NSLog(@"Start poi set: %.6f, %.6f", [[startStation latitude] floatValue], [[startStation longitude] floatValue]);
            #endif
            
            xmlStartString = kConReq_XML_START_POI_SOURCE;
            int latitude = (int)([[_startstation latitude] floatValue] * 1000000);
            int longitude = (int)([[_startstation longitude] floatValue] * 1000000);
            
            xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"LATITUDE" withString: [NSString stringWithFormat: @"%d", latitude]];
            xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"LONGITUDE" withString: [NSString stringWithFormat: @"%d", longitude]];
            xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
        }
        
        if (_endstation.stationName && _endstation.stationId) {
            
            #ifdef SBBAPILogLevelFull
            NSLog(@"End station set");
            #endif
            
            xmlEndString = kConReq_XML_END_STATION_SOURCE;
            xmlEndString = [xmlEndString stringByReplacingOccurrencesOfString: @"ENDSTATIONNAME" withString: [_endstation stationName]];
            xmlEndString = [xmlEndString stringByReplacingOccurrencesOfString: @"ENDSTATIONID" withString: [_endstation stationId]];
        } else {
            
            #ifdef SBBAPILogLevelFull
            NSLog(@"End poi set: %.6f, %.6f", [[endStation latitude] floatValue], [[endStation longitude] floatValue]);
            #endif
            
            int latitude = (int)([[_endstation latitude] floatValue] * 1000000);
            int longitude = (int)([[_endstation longitude] floatValue] * 1000000);
            xmlEndString = kConReq_XML_END_POI_SOURCE;
            xmlEndString = [xmlEndString stringByReplacingOccurrencesOfString: @"LATITUDE" withString: [NSString stringWithFormat: @"%d", latitude]];
            xmlEndString = [xmlEndString stringByReplacingOccurrencesOfString: @"LONGITUDE" withString: [NSString stringWithFormat: @"%d", longitude]];
        }
        
        NSString *languageLocaleString = @"EN";
        if (self.sbbApiLanguageLocale == reqEnglish) {
            languageLocaleString = @"EN";
        } else if (self.sbbApiLanguageLocale == reqGerman) {
            languageLocaleString = @"DE";
        } else if (self.sbbApiLanguageLocale == reqFrench) {
            languageLocaleString = @"FR";
        } else if (self.sbbApiLanguageLocale == reqItalian) {
            languageLocaleString = @"IT";
        }
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"APILOCALE" withString: languageLocaleString];
        
        NSString *numberofrequestsstring = [NSString stringWithFormat: @"%d", self.sbbConReqNumberOfConnectionsForRequest];
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"NUMBEROFREQUESTS" withString: numberofrequestsstring];
        
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STARTXML" withString: xmlStartString];
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"ENDXML" withString: xmlEndString];
        
        if (_viastation) {
            NSString *xmlViaString = kConReq_XML_VIA_SOURCE;
            xmlViaString = [xmlViaString stringByReplacingOccurrencesOfString: @"VIASTATIONNAME" withString: [_viastation stationName]];
            xmlViaString = [xmlViaString stringByReplacingOccurrencesOfString: @"VIASTATIONID" withString: [_viastation stationId]];
            xmlViaString = [xmlViaString stringByReplacingOccurrencesOfString: @"VIAPRODUCTCODE" withString: kPRODUCT_CODE_ALL];
            xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONVIAXML" withString: xmlViaString];
            
        } else {
            xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONVIAXML" withString: @""];
            //xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STARTSTATIONID" withString: [startStation stationId]];
        }
        
        if (_isdeparturetime) {
            xmlString = [xmlString stringByReplacingOccurrencesOfString: @"ARRDEPCODE" withString: @"0"];
        } else {
            xmlString = [xmlString stringByReplacingOccurrencesOfString: @"ARRDEPCODE" withString: @"1"];
        }
        
        
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONDATE" withString: dateString];
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONTIME" withString: timeString];
        
        
        #ifdef SBBAPILogLevelXMLReqRes
        NSLog(@"XML String: %@", xmlString);
        #endif
        
        //return;
                
        NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
        
        if (self.conreqHttpClient) {
            [self.conreqHttpClient cancelAllHTTPOperationsWithMethod: @"POST" path:kSBBXMLAPI_URL_PATH];
            self.conreqHttpClient = nil;
        }
        
        self.conreqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [self.conreqHttpClient defaultValueForHeader:@"Accept"];
        
        NSMutableURLRequest *request = [self.conreqHttpClient requestWithMethod:@"POST" path: kSBBXMLAPI_URL_PATH parameters:nil];
        [request setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
        
        [request setTimeoutInterval: self.sbbApiConreqTimeout];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"SUCCESS");
            
            #ifdef SBBAPILogLevelTimeStamp
            [self logTimeStampWithText:@"Conreq end operation"];
            #endif
            
            NSString *responseString = [operation responseString];
            
            if ([operation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Conreq cancelled. Op success block start");
                #endif
                
                if (_sbbAPIConreqRequestFailureCompletionBlock) {
                    _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                }
                return;
            }
            
            //NSBlockOperation *conreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
            //__weak NSBlockOperation *weakConreqDecodingXMLOperation = conreqDecodingXMLOperation;
            
            //[conreqDecodingXMLOperation addExecutionBlock: ^(void) {
                
                #ifdef SBBAPILogLevelXMLReqEndRes
                NSLog(@"Result:\n%@",responseString);
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSLog(@"Output directory: %@", documentsDirectory);
                NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_conreq_response.txt"];
                [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
                #endif
                
                //return;
                
                Connections *tempConnections = nil;
                tempConnections = [[Connections alloc] init];
                
                if (responseString)
                {
                    NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                    cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                    
                    #ifdef SBBAPILogLevelCancel
                    if (!weakConreqDecodingXMLOperation) {
                        NSLog(@"Weak reference not set");
                    } else {
                        if ([weakConreqDecodingXMLOperation isConcurrent]) {
                            NSLog(@"Conreq op is concurrent");
                        }
                        if ([weakConreqDecodingXMLOperation isExecuting]) {
                            NSLog(@"Conreq op is executing");
                        }
                        if ([weakConreqDecodingXMLOperation isFinished]) {
                            NSLog(@"Conreq op is finished");
                        }
                    }
                    #endif
                    
                    
                    if ([self isCancelled]) {
                        #ifdef SBBAPILogLevelCancel
                        NSLog(@"Conreq cancelled. Con queue block. cleanedstring");
                        #endif
                        
                        if (_sbbAPIConreqRequestFailureCompletionBlock) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                            }];
                        }
                        return;
                    }
                    
                    CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                    if (xmlResponse)
                    {
                        //NSLog(@"XML Response: %@", xmlResponse);
                        CXMLNode *conResNode = [xmlResponse nodeForXPath: @"//ConRes" error: nil];
                        if (conResNode) {
                            NSString *direction = [[(CXMLElement *)conResNode attributeForName: @"dir"] stringValue];
                            tempConnections.direction = direction;
                            //NSLog(@"ConRes direction: %@", tempConnections.direction);
                            
                            for (CXMLElement *conResElement in [conResNode children]) {
                                
                                if ([self isCancelled]) {
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Conreq cancelled. Con queue block. For each 1");
                                    #endif
                                    
                                    if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                            _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                                        }];
                                    }
                                    return;
                                }
                                
                                #ifdef SBBAPILogLevelFull
                                NSLog(@"Current child: %@", [conResElement name]);
                                #endif
                                
                                if ([[conResElement name] isEqualToString: @"ConResCtxt"]) {
                                    NSString *conId = [conResElement stringValue];
                                    NSArray *conIdSplit = [conId componentsSeparatedByString: @"#"];
                                    if (conIdSplit && conIdSplit.count == 2) {
                                        tempConnections.conIdexconscrid = [conIdSplit objectAtIndex: 0];
                                        tempConnections.conscridbackwards = [NSNumber numberWithInt: [[conIdSplit objectAtIndex: 1] integerValue]];
                                        tempConnections.conscridforward = [NSNumber numberWithInt: [[conIdSplit objectAtIndex: 1] integerValue]];
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Conidex: %@, conidback, conidfwd: %d", [conIdSplit objectAtIndex: 0], [[conIdSplit objectAtIndex: 1] integerValue]);
                                        #endif
                                    }
                                    tempConnections.conId = [conResElement stringValue];
                                    
                                    #ifdef SBBAPILogLevelFull
                                    NSLog(@"ConRes id: %@",tempConnections.conId);
                                    #endif
                                }
                                if ([[conResElement name] isEqualToString: @"Err"]) {
                                    NSString *errorcode = [[(CXMLElement *)conResElement attributeForName: @"code"] stringValue];
                                    NSString *errortext = [[(CXMLElement *)conResElement attributeForName: @"text"] stringValue];
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Conreq: error received: %@, %@", errorcode, errortext);
                                    #endif

                                    if (_sbbAPIConreqRequestErrorReportingBlock) {
                                        
                                        NSString *errorcodestring = [NSString stringWithFormat:@"Conreq:%@", errorcode];
                                        NSString *requesturlpath = [self createErrorReportingUrlString: errorcodestring errortext: errortext startname: _startstation.stationName startid:_startstation.stationId endname:_endstation.stationName endid:_endstation.stationId];
                                        _sbbAPIConreqRequestErrorReportingBlock(requesturlpath);
                                        
                                    }
                                }
                            }
                            
                            CXMLNode *connections = [xmlResponse nodeForXPath: @"//ConnectionList" error: nil];
                            if (connections) {
                                for (CXMLElement *currentConnection in [connections children]) {
                                    
                                    if ([self isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Conreq cancelled. Con queue block. For each 2");
                                        #endif
                                        
                                        if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
                                    ConResult *conResult = [[ConResult alloc] init];
                                    NSString *connectionId = [[currentConnection attributeForName: @"id"] stringValue];
                                    conResult.conResId = connectionId;
                                    
                                    #ifdef SBBAPILogLevelFull
                                    NSLog(@"Connection id: %@", conResult.conResId);
                                    #endif
                                    
                                    for (CXMLElement *currentConnectionElement in [currentConnection children]) {
                                        
                                        if ([self isCancelled]) {
                                            #ifdef SBBAPILogLevelCancel
                                            NSLog(@"Conreq cancelled. Con queue block. For each 3");
                                            #endif
                                            
                                            if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                    _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                                                }];
                                            }
                                            return;
                                        }
                                        
                                        if ([[currentConnectionElement name] isEqualToString: @"Overview"]) {
                                            //NSLog(@"Overview: %@", currentConnectionElement);
                                            ConOverview *conOverView = [[ConOverview alloc] init];
                                            for (CXMLElement *currentOverviewElement in [currentConnectionElement children]) {
                                                
                                                if ([self isCancelled]) {
                                                    #ifdef SBBAPILogLevelCancel
                                                    NSLog(@"Conreq cancelled. Con queue block. For each 4");
                                                    #endif
                                                    
                                                    if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                            _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                                                        }];
                                                    }
                                                    return;
                                                }
                                                
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Overview element: %@", [currentOverviewElement name]);
                                                #endif
                                                
                                                if ([[currentOverviewElement name] isEqualToString: @"Date"]) {
                                                    NSString *dateString = [currentOverviewElement stringValue];
                                                    conOverView.date = dateString;
                                                    
                                                    #ifdef SBBAPILogLevelFull
                                                    NSLog(@"Overview date: %@", dateString);
                                                    #endif
                                                }
                                                if ([[currentOverviewElement name] isEqualToString: @"Departure"]) {
                                                    BasicStop *departureStop = [[BasicStop alloc] init];
                                                    departureStop.basicStopType = departureType;
                                                    Dep *dep = [[Dep alloc] init];
                                                    departureStop.dep = dep;
                                                    
                                                    CXMLNode *departureElements = [currentOverviewElement childAtIndex: 0];
                                                    
                                                    for (CXMLElement *departureElement in [departureElements children]) {
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Departure element name: %@", [departureElement name]);
                                                        #endif
                                                        
                                                        if ([[departureElement name] isEqualToString: @"Station"]) {
                                                            Station *departureStation = [[Station alloc] init];
                                                            departureStation.stationName = [self fromISOLatinToUTF8: [[departureElement attributeForName: @"name"] stringValue]];
                                                            departureStation.stationId = [self fromISOLatinToUTF8: [[departureElement attributeForName: @"externalId"] stringValue]];
                                                            double latitude = [[[departureElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                            double longitude = [[[departureElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                            departureStation.latitude = [NSNumber numberWithFloat: latitude];
                                                            departureStation.longitude = [NSNumber numberWithFloat: longitude];
                                                            departureStop.station = departureStation;
                                                        } else if ([[departureElement name] isEqualToString: @"Dep"]) {
                                                            //Dep *dep = [[Dep alloc] init];
                                                            for (CXMLElement *currentDepElement in [departureElement children]) {
                                                                if ([[currentDepElement name] isEqualToString: @"Time"]) {
                                                                    departureStop.dep.timeString = [currentDepElement stringValue];
                                                                    //departureStop.dep = dep;
                                                                } else if ([[currentDepElement name] isEqualToString: @"Platform"]) {
                                                                    CXMLNode *platformElements = [currentDepElement childAtIndex: 0];
                                                                    NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                    departureStop.dep.platform = platformString;
                                                                }
                                                            }
                                                        } else if ([[departureElement name] isEqualToString: @"StopPrognosis"]) {
                                                            for (CXMLElement *currentDepElement in [departureElement children]) {
                                                                if ([[currentDepElement name] isEqualToString: @"Capacity1st"]) {
                                                                    NSString *capstring = [currentDepElement stringValue];
                                                                    departureStop.capacity1st = [NSNumber numberWithInt: [capstring integerValue]];
                                                                } else if ([[currentDepElement name] isEqualToString: @"Capacity2nd"]) {
                                                                    NSString *capstring = [currentDepElement stringValue];
                                                                    departureStop.capacity2nd = [NSNumber numberWithInt: [capstring integerValue]];
                                                                } else if ([[currentDepElement name] isEqualToString: @"Status"]) {
                                                                    NSString *statusstring = [currentDepElement stringValue];
                                                                    departureStop.scheduled = statusstring;
                                                                } else if ([[currentDepElement name] isEqualToString: @"Dep"]) {
                                                                    for (CXMLElement *currentDepProgElement in [currentDepElement children]) {
                                                                        if ([[currentDepProgElement name] isEqualToString: @"Time"]) {
                                                                            // To implement time changes
                                                                            NSString *depTimeChange = [currentDepProgElement stringValue];
                                                                            departureStop.dep.expectedTimeString = depTimeChange;
                                                                        } else if ([[currentDepProgElement name] isEqualToString: @"Platform"]) {
                                                                            // To implement track changes
                                                                            NSString *depTrackChange = [currentDepProgElement stringValue];
                                                                            departureStop.dep.expectedPlatform = depTrackChange;
                                                                        }
                                                                    }
                                                                    NSString *statusstring = [currentDepElement stringValue];
                                                                    departureStop.scheduled = statusstring;
                                                                }
                                                            }
                                                        }
                                                    }
                                                    conOverView.departure = departureStop;
                                                    
                                                }
                                                if ([[currentOverviewElement name] isEqualToString: @"Arrival"]) {
                                                    BasicStop *arrivalStop = [[BasicStop alloc] init];
                                                    arrivalStop.basicStopType = arrivalType;
                                                    Arr *arr = [[Arr alloc] init];
                                                    arrivalStop.arr = arr;
                                                    
                                                    CXMLNode *arrivalElements = [currentOverviewElement childAtIndex: 0];
                                                    
                                                    for (CXMLElement *arrivalElement in [arrivalElements children]) {
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Arrival element name: %@", [arrivalElement name]);
                                                        #endif
                                                        
                                                        if ([[arrivalElement name] isEqualToString: @"Station"]) {
                                                            Station *arrivalStation = [[Station alloc] init];
                                                            arrivalStation.stationName = [self fromISOLatinToUTF8: [[arrivalElement attributeForName: @"name"] stringValue]];
                                                            arrivalStation.stationId = [self fromISOLatinToUTF8: [[arrivalElement attributeForName: @"externalId"] stringValue]];
                                                            double latitude = [[[arrivalElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                            double longitude = [[[arrivalElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                            arrivalStation.latitude = [NSNumber numberWithFloat: latitude];
                                                            arrivalStation.longitude = [NSNumber numberWithFloat: longitude];
                                                            arrivalStop.station = arrivalStation;
                                                        } else if ([[arrivalElement name] isEqualToString: @"Arr"]) {
                                                            //Arr *arr = [[Arr alloc] init];
                                                            for (CXMLElement *currentArrElement in [arrivalElement children]) {
                                                                if ([[currentArrElement name] isEqualToString: @"Time"]) {
                                                                    arrivalStop.arr.timeString = [currentArrElement stringValue];
                                                                    //arrivalStop.arr = arr;
                                                                } else if ([[currentArrElement name] isEqualToString: @"Platform"]) {
                                                                    CXMLNode *platformElements = [currentArrElement childAtIndex: 0];
                                                                    NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                    arrivalStop.arr.platform = platformString;
                                                                }
                                                            }
                                                        } else if ([[arrivalElement name] isEqualToString: @"StopPrognosis"]) {
                                                            for (CXMLElement *currentArrElement in [arrivalElement children]) {
                                                                /*
                                                                 if ([[currentArrElement name] isEqualToString: @"Capacity1st"]) {
                                                                 NSString *capstring = [currentArrElement stringValue];
                                                                 ar.capacity1st = [NSNumber numberWithInt: [capstring integerValue]];
                                                                 } else if ([[currentArrElement name] isEqualToString: @"Capacity2nd"]) {
                                                                 NSString *capstring = [currentDepElement stringValue];
                                                                 departureStop.capacity2nd = [NSNumber numberWithInt: [capstring integerValue]];
                                                                 } else if ([[currentArrElement name] isEqualToString: @"Status"]) {
                                                                 NSString *statusstring = [currentDepElement stringValue];
                                                                 departureStop.scheduled = statusstring;
                                                                 } else */
                                                                if ([[currentArrElement name] isEqualToString: @"Arr"]) {
                                                                    for (CXMLElement *currentArrProgElement in [currentArrElement children]) {
                                                                        if ([[currentArrProgElement name] isEqualToString: @"Time"]) {
                                                                            // To implement time changes
                                                                            NSString *arrTimeChange = [currentArrProgElement stringValue];
                                                                            arrivalStop.arr.expectedTimeString = arrTimeChange;
                                                                        } else if ([[currentArrProgElement name] isEqualToString: @"Platform"]) {
                                                                            // To implement track changes
                                                                            NSString *arrTrackChange = [currentArrProgElement stringValue];
                                                                            arrivalStop.arr.expectedPlatform = arrTrackChange;
                                                                        }
                                                                    }
                                                                    //NSString *statusstring = [currentArrElement stringValue];
                                                                    //arrivalStop.scheduled = statusstring;
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                    conOverView.arrival = arrivalStop;
                                                    
                                                }
                                                if ([[currentOverviewElement name] isEqualToString: @"Transfers"]) {
                                                    NSString *transfers = [currentOverviewElement stringValue];
                                                    conOverView.transfers = transfers;
                                                    
                                                    #ifdef SBBAPILogLevelFull
                                                    NSLog(@"Overview transfers: %@", transfers);
                                                    #endif
                                                }
                                                if ([[currentOverviewElement name] isEqualToString: @"Duration"]) {
                                                    CXMLNode *durationTimeElement = [currentOverviewElement childAtIndex: 0];
                                                    NSString *timeString = [(CXMLElement *)durationTimeElement stringValue];
                                                    conOverView.duration = timeString;
                                                    
                                                    #ifdef SBBAPILogLevelFull
                                                    NSLog(@"Overview duration: %@", timeString);
                                                    #endif
                                                }
                                                if ([[currentOverviewElement name] isEqualToString: @"Products"]) {
                                                    NSString *productString = nil;
                                                    for (CXMLElement *currentProduct in [currentOverviewElement children]) {
                                                        NSString *productCategory = [[(CXMLElement *)currentProduct attributeForName: @"cat"] stringValue];
                                                        //NSLog(@"Overview product category: %@", productCategory);
                                                        if (!productString) productString = @"";
                                                        productString = [productString stringByAppendingFormat: @"|%@", [productCategory stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
                                                        //NSLog(@"Overview product category string: %@", productString);
                                                    }
                                                    if (productString) {
                                                        productString = [productString substringFromIndex: 1];
                                                        conOverView.products = productString;
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Overview products: %@", productString);
                                                        #endif
                                                    }
                                                }
                                                
                                            }
                                            conResult.overView = conOverView;
                                        } else if ([[currentConnectionElement name] isEqualToString: @"ConSectionList"]) {
                                            ConSectionList *conSectionList = [[ConSectionList alloc] init];
                                            
                                            for (CXMLElement *currentConSectionElement in [currentConnectionElement children]) {
                                                
                                                if ([self isCancelled]) {
                                                    #ifdef SBBAPILogLevelCancel
                                                    NSLog(@"Conreq cancelled. Con queue block. For each 5");
                                                    #endif
                                                    
                                                    if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                            _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                                                        }];
                                                    }
                                                    return;
                                                }
                                                
                                                ConSection *conSection = [[ConSection alloc] init];
                                                
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Consection element: %@", [currentConSectionElement name]);
                                                #endif
                                                
                                                //if ([[currentOverviewElement name] isEqualToString: @"Date"]) {
                                                for (CXMLElement *currentConSectionDetailElement in [currentConSectionElement children]) {
                                                    
                                                    #ifdef SBBAPILogLevelFull
                                                    NSLog(@"Consection detail element: %@", [currentConSectionDetailElement name]);
                                                    #endif
                                                    
                                                    if ([[currentConSectionDetailElement name] isEqualToString: @"Departure"]) {
                                                        BasicStop *departureStop = [[BasicStop alloc] init];
                                                        departureStop.basicStopType = departureType;
                                                        Dep *dep = [[Dep alloc] init];
                                                        departureStop.dep = dep;
                                                        CXMLNode *departureElements = [currentConSectionDetailElement childAtIndex: 0];
                                                        
                                                        for (CXMLElement *departureElement in [departureElements children]) {
                                                            
                                                            if ([self isCancelled]) {
                                                                #ifdef SBBAPILogLevelCancel
                                                                NSLog(@"Conreq cancelled. Con queue block. For each 6");
                                                                #endif
                                                                
                                                                if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                                        _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                                                                    }];
                                                                }
                                                                return;
                                                            }
                                                            
                                                            #ifdef SBBAPILogLevelFull
                                                            NSLog(@"Consection detail element departure: %@", [departureElement name]);
                                                            #endif
                                                            
                                                            if ([[departureElement name] isEqualToString: @"Station"]) {
                                                                Station *departureStation = [[Station alloc] init];
                                                                departureStation.stationName = [self fromISOLatinToUTF8: [[departureElement attributeForName: @"name"] stringValue]];
                                                                departureStation.stationId = [self fromISOLatinToUTF8: [[departureElement attributeForName: @"externalId"] stringValue]];
                                                                double latitude = [[[departureElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                                double longitude = [[[departureElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                                departureStation.latitude = [NSNumber numberWithFloat: latitude];
                                                                departureStation.longitude = [NSNumber numberWithFloat: longitude];
                                                                departureStop.station = departureStation;
                                                            } else if ([[departureElement name] isEqualToString: @"Dep"]) {
                                                                //Dep *dep = [[Dep alloc] init];
                                                                for (CXMLElement *currentDepElement in [departureElement children]) {
                                                                    if ([[currentDepElement name] isEqualToString: @"Time"]) {
                                                                        departureStop.dep.timeString = [currentDepElement stringValue];
                                                                        //departureStop.dep = dep;
                                                                    } else if ([[currentDepElement name] isEqualToString: @"Platform"]) {
                                                                        CXMLNode *platformElements = [currentDepElement childAtIndex: 0];
                                                                        NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                        departureStop.dep.platform = platformString;
                                                                    }
                                                                }
                                                            } else if ([[departureElement name] isEqualToString: @"Address"]) {     // Currenty no name check
                                                                Station *departureStation = [[Station alloc] init];
                                                                departureStation.stationName = [self fromISOLatinToUTF8: [[departureElement attributeForName: @"name"] stringValue]];
                                                                double latitude = [[[departureElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                                double longitude = [[[departureElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                                departureStation.latitude = [NSNumber numberWithFloat: latitude];
                                                                departureStation.longitude = [NSNumber numberWithFloat: longitude];
                                                                departureStop.station = departureStation;
                                                            } else if ([[departureElement name] isEqualToString: @"StopPrognosis"]) {
                                                                for (CXMLElement *currentDepElement in [departureElement children]) {
                                                                    if ([[currentDepElement name] isEqualToString: @"Capacity1st"]) {
                                                                        NSString *capstring = [currentDepElement stringValue];
                                                                        departureStop.capacity1st = [NSNumber numberWithInt: [capstring integerValue]];
                                                                    } else if ([[currentDepElement name] isEqualToString: @"Capacity2nd"]) {
                                                                        NSString *capstring = [currentDepElement stringValue];
                                                                        departureStop.capacity2nd = [NSNumber numberWithInt: [capstring integerValue]];
                                                                    } else if ([[currentDepElement name] isEqualToString: @"Status"]) {
                                                                        NSString *statusstring = [currentDepElement stringValue];
                                                                        departureStop.scheduled = statusstring;
                                                                    } else if ([[currentDepElement name] isEqualToString: @"Dep"]) {
                                                                        for (CXMLElement *currentDepProgElement in [currentDepElement children]) {
                                                                            if ([[currentDepProgElement name] isEqualToString: @"Time"]) {
                                                                                // To implement time changes
                                                                                NSString *depTimeChange = [currentDepProgElement stringValue];
                                                                                departureStop.dep.expectedTimeString = depTimeChange;
                                                                            } else if ([[currentDepProgElement name] isEqualToString: @"Platform"]) {
                                                                                // To implement track changes
                                                                                NSString *depTrackChange = [currentDepProgElement stringValue];
                                                                                departureStop.dep.expectedPlatform = depTrackChange;
                                                                            }
                                                                        }
                                                                        NSString *statusstring = [currentDepElement stringValue];
                                                                        departureStop.scheduled = statusstring;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        conSection.departure = departureStop;
                                                        
                                                    } else if ([[currentConSectionDetailElement name] isEqualToString: @"Arrival"]) {
                                                        BasicStop *arrivalStop = [[BasicStop alloc] init];
                                                        arrivalStop.basicStopType = arrivalType;
                                                        Arr *arr = [[Arr alloc] init];
                                                        arrivalStop.arr = arr;
                                                        CXMLNode *arrivalElements = [currentConSectionDetailElement childAtIndex: 0];
                                                        
                                                        for (CXMLElement *arrivalElement in [arrivalElements children]) {
                                                            
                                                            #ifdef SBBAPILogLevelFull
                                                            NSLog(@"Consection detail element arrival: %@", [arrivalElement name]);
                                                            #endif
                                                            
                                                            if ([[arrivalElement name] isEqualToString: @"Station"]) {
                                                                Station *arrivalStation = [[Station alloc] init];
                                                                arrivalStation.stationName = [self fromISOLatinToUTF8: [[arrivalElement attributeForName: @"name"] stringValue]];
                                                                arrivalStation.stationId = [self fromISOLatinToUTF8: [[arrivalElement attributeForName: @"externalId"] stringValue]];
                                                                double latitude = [[[arrivalElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                                double longitude = [[[arrivalElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                                arrivalStation.latitude = [NSNumber numberWithFloat: latitude];
                                                                arrivalStation.longitude = [NSNumber numberWithFloat: longitude];
                                                                arrivalStop.station = arrivalStation;
                                                            } else if ([[arrivalElement name] isEqualToString: @"Arr"]) {
                                                                //Arr *arr = [[Arr alloc] init];
                                                                for (CXMLElement *currentArrElement in [arrivalElement children]) {
                                                                    if ([[currentArrElement name] isEqualToString: @"Time"]) {
                                                                        arrivalStop.arr.timeString = [currentArrElement stringValue];
                                                                        //arrivalStop.arr = arr;
                                                                    } else if ([[currentArrElement name] isEqualToString: @"Platform"]) {
                                                                        CXMLNode *platformElements = [currentArrElement childAtIndex: 0];
                                                                        NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                        arrivalStop.arr.platform = platformString;
                                                                    }
                                                                }
                                                            } else if ([[arrivalElement name] isEqualToString: @"Address"]) {       // Currenty no name check
                                                                Station *arrivalStation = [[Station alloc] init];
                                                                arrivalStation.stationName = [self fromISOLatinToUTF8: [[arrivalElement attributeForName: @"name"] stringValue]];
                                                                double latitude = [[[arrivalElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                                double longitude = [[[arrivalElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                                arrivalStation.latitude = [NSNumber numberWithFloat: latitude];
                                                                arrivalStation.longitude = [NSNumber numberWithFloat: longitude];
                                                                arrivalStop.station = arrivalStation;
                                                            } else if ([[arrivalElement name] isEqualToString: @"StopPrognosis"]) {
                                                                for (CXMLElement *currentArrElement in [arrivalElement children]) {
                                                                    /*
                                                                     if ([[currentArrElement name] isEqualToString: @"Capacity1st"]) {
                                                                     NSString *capstring = [currentArrElement stringValue];
                                                                     ar.capacity1st = [NSNumber numberWithInt: [capstring integerValue]];
                                                                     } else if ([[currentArrElement name] isEqualToString: @"Capacity2nd"]) {
                                                                     NSString *capstring = [currentDepElement stringValue];
                                                                     departureStop.capacity2nd = [NSNumber numberWithInt: [capstring integerValue]];
                                                                     } else if ([[currentArrElement name] isEqualToString: @"Status"]) {
                                                                     NSString *statusstring = [currentDepElement stringValue];
                                                                     departureStop.scheduled = statusstring;
                                                                     } else */
                                                                    if ([[currentArrElement name] isEqualToString: @"Arr"]) {
                                                                        for (CXMLElement *currentArrProgElement in [currentArrElement children]) {
                                                                            if ([[currentArrProgElement name] isEqualToString: @"Time"]) {
                                                                                // To implement time changes
                                                                                NSString *arrTimeChange = [currentArrProgElement stringValue];
                                                                                arrivalStop.arr.expectedTimeString = arrTimeChange;
                                                                            } else if ([[currentArrProgElement name] isEqualToString: @"Platform"]) {
                                                                                // To implement track changes
                                                                                NSString *arrTrackChange = [currentArrProgElement stringValue];
                                                                                arrivalStop.arr.expectedPlatform = arrTrackChange;
                                                                            }
                                                                        }
                                                                        //NSString *statusstring = [currentArrElement stringValue];
                                                                        //arrivalStop.scheduled = statusstring;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        conSection.arrival = arrivalStop;
                                                        
                                                    } else if ([[currentConSectionDetailElement name] isEqualToString: @"Journey"]) {
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Consection passing though journey type");
                                                        #endif
                                                        
                                                        conSection.conSectionType = journeyType;
                                                        Journey *journey = [[Journey alloc] init];
                                                        for (CXMLElement *currentJourneyElement in [currentConSectionDetailElement children]) {
                                                            if ([[currentJourneyElement name] isEqualToString: @"JHandle"]) {
                                                                NSString *journeytnr = [[currentJourneyElement attributeForName: @"tNr"] stringValue];
                                                                NSString *journeypuic = [[currentJourneyElement attributeForName: @"puic"] stringValue];
                                                                NSString *journeycycle = [[currentJourneyElement attributeForName: @"cycle"] stringValue];
                                                                
                                                                #ifdef SBBAPILogLevelFull
                                                                NSLog(@"Consection detail element journey handle attribute element type: %@, %@, %@", journeytnr, journeypuic, journeycycle);
                                                                #endif
                                                                
                                                                JourneyHandle *journeyhandle = [[JourneyHandle alloc] init];
                                                                journeyhandle.tnr = journeytnr;
                                                                journeyhandle.puic = journeypuic;
                                                                journeyhandle.cycle = journeycycle;
                                                                journey.journeyHandle = journeyhandle;
                                                            } else if ([[currentJourneyElement name] isEqualToString: @"JourneyAttributeList"]) {
                                                                for (CXMLElement *journeyAttributeElement in [currentJourneyElement children]) {
                                                                    //NSLog(@"Consection detail element journey attribute element: %@", journeyAttributeElement);
                                                                    CXMLNode *journeyAttributeElementDetail = [journeyAttributeElement childAtIndex: 0];
                                                                    //NSLog(@"Array: %@", journeyAttributeElementDetail);
                                                                    
                                                                    NSString *attributeType = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"type"] stringValue];
                                                                    
                                                                    #ifdef SBBAPILogLevelFull
                                                                    NSLog(@"Consection detail element journey attribute element type: %@", attributeType);
                                                                    #endif
                                                                    
                                                                    if ([attributeType isEqualToString: @"NAME"]) {
                                                                        for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                                            NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                                            //NSLog(@"Name attribute variant element type: %@", attributeVariantElement);
                                                                            if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                                                journey.journeyName = [journeyAttributeVariantElement stringValue];
                                                                                
                                                                                #ifdef SBBAPILogLevelFull
                                                                                NSLog(@"Name attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                                                #endif
                                                                            }
                                                                        }
                                                                        
                                                                    } else if ([attributeType isEqualToString: @"CATEGORY"]) {
                                                                        NSString *categoryCode = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"code"] stringValue];
                                                                        journey.journeyCategoryCode = categoryCode;
                                                                        
                                                                        #ifdef SBBAPILogLevelFull
                                                                        NSLog(@"Category attribute variant element code: %@", categoryCode);
                                                                        #endif
                                                                        
                                                                        for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                                            NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                                            //NSLog(@"Category attribute variant element type: %@", attributeVariantElement);
                                                                            if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                                                journey.journeyCategoryName = [journeyAttributeVariantElement stringValue];
                                                                                
                                                                                #ifdef SBBAPILogLevelFull
                                                                                NSLog(@"Category attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                                                #endif
                                                                            }
                                                                        }
                                                                        
                                                                    } else if ([attributeType isEqualToString: @"NUMBER"]) {
                                                                        for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                                            NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                                            //NSLog(@"Number attribute variant element type: %@", attributeVariantElement);
                                                                            if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                                                journey.journeyNumber = [journeyAttributeVariantElement stringValue];
                                                                                
                                                                                #ifdef SBBAPILogLevelFull
                                                                                NSLog(@"Number attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                                                #endif
                                                                            }
                                                                        }
                                                                        
                                                                    } else if ([attributeType isEqualToString: @"ADMINISTRATION"]) {
                                                                        for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                                            NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                                            //NSLog(@"Administration attribute variant element type: %@", attributeVariantElement);
                                                                            if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                                                journey.journeyAdministration = [journeyAttributeVariantElement stringValue];
                                                                                
                                                                                #ifdef SBBAPILogLevelFull
                                                                                NSLog(@"Administration attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                                                #endif
                                                                            }
                                                                        }
                                                                        
                                                                    } else if ([attributeType isEqualToString: @"OPERATOR"]) {
                                                                        for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                                            NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                                            //NSLog(@"Operator attribute variant element type: %@", attributeVariantElement);
                                                                            if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                                                journey.journeyOperator = [journeyAttributeVariantElement stringValue];
                                                                                
                                                                                #ifdef SBBAPILogLevelFull
                                                                                NSLog(@"Operator attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                                                #endif
                                                                            }
                                                                        }
                                                                        
                                                                    } else if ([attributeType isEqualToString: @"DIRECTION"]) {
                                                                        for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                                            NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                                            //NSLog(@"Operator attribute variant element type: %@", attributeVariantElement);
                                                                            if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                                                journey.journeyDirection = [self fromISOLatinToUTF8: [journeyAttributeVariantElement stringValue]];
                                                                                
                                                                                #ifdef SBBAPILogLevelFull
                                                                                NSLog(@"Direction attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                                                #endif
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            } else if ([[currentJourneyElement name] isEqualToString: @"PassList"]) {
                                                                for (CXMLElement *journeyPasslistElement in [currentJourneyElement children]) {
                                                                    //NSLog(@"Consection detail element pass list element: %@", journeyPasslistElement);
                                                                    
                                                                    BasicStop *basicStop = [[BasicStop alloc] init];
                                                                    basicStop.basicStopType = arrivalType;
                                                                    Dep *dep = [[Dep alloc] init];
                                                                    Arr *arr = [[Arr alloc] init];
                                                                    basicStop.dep = dep;
                                                                    basicStop.arr = arr;
                                                                    
                                                                    //CXMLNode *arrivalElements = [currentConSectionDetailElement childAtIndex: 0];
                                                                    
                                                                    for (CXMLElement *basicStopElement in [journeyPasslistElement children]) {
                                                                        
                                                                        #ifdef SBBAPILogLevelFull
                                                                        NSLog(@"Consection detail element arrival: %@", [basicStopElement name]);
                                                                        #endif
                                                                        
                                                                        if ([[basicStopElement name] isEqualToString: @"Station"]) {
                                                                            Station *station = [[Station alloc] init];
                                                                            station.stationName = [self fromISOLatinToUTF8: [[basicStopElement attributeForName: @"name"] stringValue]];
                                                                            station.stationId = [self fromISOLatinToUTF8: [[basicStopElement attributeForName: @"externalId"] stringValue]];
                                                                            double latitude = [[[basicStopElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                                            double longitude = [[[basicStopElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                                            station.latitude = [NSNumber numberWithFloat: latitude];
                                                                            station.longitude = [NSNumber numberWithFloat: longitude];
                                                                            basicStop.station = station;
                                                                        } else if ([[basicStopElement name] isEqualToString: @"Arr"]) {
                                                                            //Arr *arr = [[Arr alloc] init];
                                                                            for (CXMLElement *currentArrElement in [basicStopElement children]) {
                                                                                if ([[currentArrElement name] isEqualToString: @"Time"]) {
                                                                                    basicStop.arr.timeString = [currentArrElement stringValue];
                                                                                    //basicStop.arr = arr;
                                                                                } else if ([[currentArrElement name] isEqualToString: @"Platform"]) {
                                                                                    CXMLNode *platformElements = [currentArrElement childAtIndex: 0];
                                                                                    NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                                    basicStop.arr.platform = platformString;
                                                                                }
                                                                            }
                                                                        } else if ([[basicStopElement name] isEqualToString: @"Dep"]) {
                                                                            //Dep *dep = [[Dep alloc] init];
                                                                            for (CXMLElement *currentDepElement in [basicStopElement children]) {
                                                                                if ([[currentDepElement name] isEqualToString: @"Time"]) {
                                                                                    basicStop.dep.timeString = [currentDepElement stringValue];
                                                                                    //basicStop.dep = dep;
                                                                                } else if ([[currentDepElement name] isEqualToString: @"Platform"]) {
                                                                                    CXMLNode *platformElements = [currentDepElement childAtIndex: 0];
                                                                                    NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                                    basicStop.dep.platform = platformString;
                                                                                }
                                                                            }
                                                                        } else if ([[basicStopElement name] isEqualToString: @"StopPrognosis"]) {
                                                                            for (CXMLElement *currentDepElement in [basicStopElement children]) {
                                                                                if ([[currentDepElement name] isEqualToString: @"Capacity1st"]) {
                                                                                    NSString *capstring = [currentDepElement stringValue];
                                                                                    basicStop.capacity1st = [NSNumber numberWithInt: [capstring integerValue]];
                                                                                } else if ([[currentDepElement name] isEqualToString: @"Capacity2nd"]) {
                                                                                    NSString *capstring = [currentDepElement stringValue];
                                                                                    basicStop.capacity2nd = [NSNumber numberWithInt: [capstring integerValue]];
                                                                                } else if ([[currentDepElement name] isEqualToString: @"Status"]) {
                                                                                    NSString *statusstring = [currentDepElement stringValue];
                                                                                    basicStop.scheduled = statusstring;
                                                                                } else if ([[currentDepElement name] isEqualToString: @"Dep"]) {
                                                                                    for (CXMLElement *currentDepProgElement in [currentDepElement children]) {
                                                                                        if ([[currentDepProgElement name] isEqualToString: @"Time"]) {
                                                                                            // To implement time changes
                                                                                            NSString *depTimeChange = [currentDepProgElement stringValue];
                                                                                            basicStop.dep.expectedTimeString = depTimeChange;
                                                                                        } else if ([[currentDepProgElement name] isEqualToString: @"Platform"]) {
                                                                                            // To implement track changes
                                                                                            NSString *depTrackChange = [currentDepProgElement stringValue];
                                                                                            basicStop.dep.expectedPlatform = depTrackChange;
                                                                                        }
                                                                                    }
                                                                                } else if ([[currentDepElement name] isEqualToString: @"Arr"]) {
                                                                                    for (CXMLElement *currentArrProgElement in [currentDepElement children]) {
                                                                                        if ([[currentArrProgElement name] isEqualToString: @"Time"]) {
                                                                                            // To implement time changes
                                                                                            NSString *arrTimeChange = [currentArrProgElement stringValue];
                                                                                            basicStop.arr.expectedTimeString = arrTimeChange;
                                                                                        } else if ([[currentArrProgElement name] isEqualToString: @"Platform"]) {
                                                                                            // To implement track changes
                                                                                            NSString *arrTrackChange = [currentArrProgElement stringValue];
                                                                                            basicStop.arr.expectedPlatform = arrTrackChange;
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    [journey.passList addObject: basicStop];
                                                                }
                                                            } else if ([[currentJourneyElement name] isEqualToString: @"JProg"]) {
                                                                // To implement
                                                                BOOL journeyOnTime = YES;
                                                                for (CXMLElement *currentJourneyProgElement in [currentJourneyElement children]) {
                                                                    if ([[currentJourneyProgElement name] isEqualToString: @"JStatus"]) {
                                                                        NSString *journeyStatus = [currentJourneyProgElement stringValue];
                                                                        if ([journeyStatus isEqualToString: @"SCHEDULED"]) {
                                                                            
                                                                            #ifdef SBBAPILogLevelFull
                                                                            NSLog(@"Journey is on schedule");
                                                                            #endif
                                                                            
                                                                            journeyOnTime = YES;
                                                                        } else if ([journeyStatus isEqualToString: @"DELAY"]) {
                                                                            
                                                                            #ifdef SBBAPILogLevelFull
                                                                            NSLog(@"Journey is delayed");
                                                                            #endif
                                                                            
                                                                            journeyOnTime = NO;
                                                                        }
                                                                    }
                                                                }
                                                                journey.journeyIsDelayed = !journeyOnTime;
                                                            }
                                                        }
                                                        conSection.journey = journey;
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Stations is passlist of journey: %d", conSection.journey.passList.count);
                                                        #endif
                                                        
                                                    } else if ([[currentConSectionDetailElement name] isEqualToString: @"Walk"]) {
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Consection passing though walk type");
                                                        #endif
                                                        
                                                        conSection.conSectionType = walkType;
                                                        Walk *walk = [[Walk alloc] init];
                                                        NSString *walkDistance = [[(CXMLElement *)currentConSectionDetailElement attributeForName: @"length"] stringValue];
                                                        walk.distance = walkDistance;
                                                        //NSLog(@"Consection detail element walk distance: %@", walkDistance);
                                                        for (CXMLElement *currentWalkElement in [currentConSectionDetailElement children]) {
                                                            if ([[currentWalkElement name] isEqualToString: @"Duration"]) {
                                                                CXMLNode *durationTimeElement = [currentWalkElement childAtIndex: 0];
                                                                NSString *timeString = [(CXMLElement *)durationTimeElement stringValue];
                                                                walk.duration = timeString;
                                                                //NSLog(@"Consection detail element walk duration: %@", timeString);
                                                            }
                                                        }
                                                        conSection.walk = walk;
                                                    } else if ([[currentConSectionDetailElement name] isEqualToString: @"GisRoute"]) {      // Current implement as WALK
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Consection passing though gisroute type");
                                                        #endif
                                                        
                                                        conSection.conSectionType = walkType;
                                                        Walk *walk = [[Walk alloc] init];
                                                        //NSString *walkDistance = [[(CXMLElement *)currentConSectionDetailElement attributeForName: @"length"] stringValue];
                                                        //walk.distance = walkDistance;
                                                        //NSLog(@"Consection detail element walk distance: %@", walkDistance);
                                                        for (CXMLElement *currentGisRouteElement in [currentConSectionDetailElement children]) {
                                                            if ([[currentGisRouteElement name] isEqualToString: @"Duration"]) {
                                                                CXMLNode *durationTimeElement = [currentGisRouteElement childAtIndex: 0];
                                                                NSString *timeString = [(CXMLElement *)durationTimeElement stringValue];
                                                                walk.duration = timeString;
                                                                //NSLog(@"Consection detail element gisroute duration: %@", timeString);
                                                            } else if ([[currentGisRouteElement name] isEqualToString: @"Distance"]) {
                                                                NSString *walkDistance = [currentGisRouteElement stringValue];
                                                                walk.distance = walkDistance;
                                                                //NSLog(@"Consection detail element gisroute distance: %@", walkDistance);
                                                            }
                                                        }
                                                        conSection.walk = walk;
                                                    }
                                                }
                                                [conSectionList.conSections addObject: conSection];
                                            }
                                            conResult.conSectionList = conSectionList;
                                        } else if ([[currentConnectionElement name] isEqualToString: @"IList"]) {
                                            // To implement
                                            for (CXMLElement *currentInfoElement in [currentConnectionElement children]) {
                                                
                                                if ([self isCancelled]) {
                                                    #ifdef SBBAPILogLevelCancel
                                                    NSLog(@"Conreq cancelled. Con queue block. For each 7");
                                                    #endif
                                                    
                                                    if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                            _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                                                        }];
                                                    }
                                                    return;
                                                }
                                                
                                                NSString *headerText = [[currentInfoElement attributeForName: @"header"] stringValue];
                                                NSString *leadText = [[currentInfoElement attributeForName: @"lead"] stringValue];
                                                NSString *textText = [[currentInfoElement attributeForName: @"text"] stringValue];
                                                ConnectionInfo *currentConnectionInfo = [[ConnectionInfo alloc] init];
                                                currentConnectionInfo.header = [self fromISOLatinToUTF8: headerText];
                                                currentConnectionInfo.lead = [self fromISOLatinToUTF8: leadText];
                                                currentConnectionInfo.text = [self fromISOLatinToUTF8: textText];
                                                
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Connection info: %@, %@, %@", headerText, leadText, textText);
                                                #endif
                                                
                                                [conResult.connectionInfoList addObject: currentConnectionInfo];
                                            }
                                        }
                                        
                                        // Test
                                        /*
                                         ConnectionInfo *currentConnectionInfo = [[ConnectionInfo alloc] init];
                                         NSString *headerText = @"Verspätung: IC 285 Stuttgart Hbf - Zürich HB";
                                         NSString *leadText = @"Verspätung: IC 285 Stuttgart Hbf - Zürich HB";
                                         NSString *textText = @"Verspätung: IC 285 von Stuttgart Hbf ab 19:56 über Horb 20:41 - Rottweil 21:10 - Tuttlingen 21:28 - Singen (Hohentwiel) 21:57 - Schaffhausen 22:18 nach Zürich HB an 22:55 hat 15 Minuten Verspätung.";
                                         
                                         NSString *cleanedHeader = [[headerText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                                         NSString *cleanedLead = [[leadText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                                         NSString *cleanedText = [[textText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                                         
                                         NSLog(@"Connection info: %@, %@, %@", cleanedHeader, cleanedLead, cleanedText);
                                         
                                         currentConnectionInfo.header = cleanedHeader;
                                         currentConnectionInfo.lead = cleanedLead;
                                         currentConnectionInfo.text = cleanedText;
                                         
                                         [conResult.connectionInfoList addObject: currentConnectionInfo];
                                         */
                                        // End test
                                        
                                    }
                                    
                                    //if (!conResult) NSLog(@"ConResult is nil");
                                    
                                    if (conResult) {
                                        if (_startstation.stationName) {
                                            
                                            #ifdef SBBAPILogLevelFull
                                            NSLog(@"Setting better startstation name: %@", startStation.stationName);
                                            #endif
                                            
                                            conResult.knownBetterStartLocationName = _startstation.stationName;
                                            tempConnections.knownBetterStartLocationName = _startstation.stationName;
                                            if ([conResult conSectionList] && [[conResult conSectionList] conSections] && ([[[conResult conSectionList] conSections] count]>0)) {
                                                ConSection *startSection = [[[conResult conSectionList] conSections] objectAtIndex: 0];
                                                if ([startSection departure] && [[startSection departure] station]) {
                                                    Station *departureStation = [[startSection departure] station];
                                                    departureStation.stationName = _startstation.stationName;
                                                }
                                            }
                                        } else {
                                            conResult.knownBetterStartLocationName = nil;
                                        }
                                        if (_endstation.stationName) {
                                            
                                            #ifdef SBBAPILogLevelFull
                                            NSLog(@"Setting better endstation name: %@", endStation.stationName);
                                            #endif
                                            
                                            conResult.knownBetterEndLocationName = _endstation.stationName;
                                            tempConnections.knownBetterEndLocationName = _endstation.stationName;
                                            if ([conResult conSectionList] && [[conResult conSectionList] conSections] && ([[[conResult conSectionList] conSections] count]>0)) {
                                                ConSection *endSection = [[[conResult conSectionList] conSections] lastObject];
                                                if ([endSection departure] && [[endSection arrival] station]) {
                                                    Station *arrivalStation = [[endSection arrival] station];
                                                    arrivalStation.stationName = _endstation.stationName;
                                                }
                                            }
                                        } else {
                                            conResult.knownBetterEndLocationName = nil;
                                        }
                                    }
                                    
                                    [tempConnections.conResults addObject: conResult];
                                    
                                    #ifdef SBBAPILogLevelXMLReqRes
                                    NSLog(@"ConRes: %@", conResult);
                                    NSLog(@"ConRes #: %d", tempConnections.conResults.count);
                                    #endif
                                }
                            }
                        }
                    }
                } else {
                    #ifdef SBBAPILogLevelFull
                    NSLog(@"Empty response string!!!");
                    #endif
                }
                
                //NSLog(@"XML Response: %@", xmlResponse);
                
                #ifdef SBBAPILogLevelTimeStamp
                [self logTimeStampWithText:@"Conreq decoding xml"];
                #endif
                                
                #ifdef SBBAPILogLevelCancel
                if (!weakConreqDecodingXMLOperation) {
                    NSLog(@"Weak reference not set");
                } else {
                    if ([weakConreqDecodingXMLOperation isConcurrent]) {
                        NSLog(@"Conreq op is concurrent");
                    }
                    if ([weakConreqDecodingXMLOperation isExecuting]) {
                        NSLog(@"Conreq op is executing");
                    }
                    if ([weakConreqDecodingXMLOperation isFinished]) {
                        NSLog(@"Conreq op is finished");
                    }
                }
                #endif
                
                if ([self isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Conreq cancelled. Con queue block. End. MainQueue call");
                    #endif
                    
                    if (_sbbAPIConreqRequestFailureCompletionBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                        }];
                    }
                    return;
                } else {
                    if (_sbbAPIConreqRequestSuccessCompletionBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            if (tempConnections && tempConnections.conResults.count > 0) {
                                                                
                                #ifdef SBBAPILogLevelXMLReqRes
                                NSLog(@"Connections result: %@", tempConnections);
                                #endif
                                                                
                                _sbbAPIConreqRequestSuccessCompletionBlock(tempConnections);
                                
                            } else {
                                if (_sbbAPIConreqRequestFailureCompletionBlock) {
                                    _sbbAPIConreqRequestFailureCompletionBlock(kConRegRequestFailureNoNewResults);
                                }
                            }
                        }];
                    }
                }
            //}];
        
            //CHECK
            //[_conreqBackgroundOpQueue addOperation: conreqDecodingXMLOperation];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request failed: %@", error);
            
            NSString *responseString = [operation responseString];
            if (responseString) {
                NSLog(@"Request failed response: %@", responseString);
            }
            
            //NSUInteger kConReqRequestFailureConnectionFailed = 85;
            
            if (_sbbAPIConreqRequestFailureCompletionBlock) {
                _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureConnectionFailed);
            }
        }];
        
        #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Conreq start operation"];
        #endif
        
        [operation start];
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"XML request send");
        #endif

        if (self.isCancelled) {
            NSLog(@"SBB API conreq operation is cancelled");
            if (_sbbAPIConreqRequestFailureCompletionBlock) {
                _sbbAPIConreqRequestFailureCompletionBlock(kConReqRequestFailureCancelled);
                return;
            }
        }
        
        Connections *connections = nil;
        
        if (connections && connections.conResults.count > 0) {
            if (_sbbAPIConreqRequestSuccessCompletionBlock) {
                _sbbAPIConreqRequestSuccessCompletionBlock(connections);
            }
        } else {
            if (_sbbAPIConreqRequestFailureCompletionBlock) {
                _sbbAPIConreqRequestFailureCompletionBlock(kConRegRequestFailureNoNewResults);
                return;
            }
        }
    }
}

@end
