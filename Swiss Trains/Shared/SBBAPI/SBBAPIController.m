//
//  SBBAPIController.m
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "SBBAPIController.h"

//--------------------------------------------------------------------------------

#define kSBBXMLAPI_BASE_URL                 @"http://fahrplan.sbb.ch/"
#define kSBBXMLAPI_URL_PATH                 @"bin/extxml.exe"
#define kSBBXMLAPI_KEY_OLD                  @"MJXZ841ZfsmqqmSymWhBPy5dMNoqoGsHInHbWJQ5PTUZOJ1rLTkn8vVZOZDFfSe"
#define kSBBXMLAPI_KEY                      @"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1"

#define kSBBXMLINFOAPI_URL_PATH_EN          @"bin/help.exe/enl?tpl=rss_basic_feed"
#define kSBBXMLINFOAPI_URL_PATH_DE          @"bin/help.exe/dnl?tpl=rss_basic_feed"
#define kSBBXMLINFOAPI_URL_PATH_FR          @"bin/help.exe/fnl?tpl=rss_basic_feed"
#define kSBBXMLINFOAPI_URL_PATH_IT          @"bin/help.exe/inl?tpl=rss_basic_feed"

#define kERROR_REPORTING_URL_PATH           @"swisstransit/servers/errorlogserver/registerlogentry.php"

//--------------------------------------------------------------------------------

//Error codes: <ConRes dir="O"><Err code="XXX" text="XXXX" level="W"/></ConRes>

#define kErrorWritingSpoolfile              @"Error writing the spoolfile"
#define kErrorInvalidValueInRequest         @"Invalid value"
#define kErrorNoTrainsInResult              @"No trains in result"
#define kErrorNoMessageAvailable            @"No message available"
#define kErrorStationDoesNotExist           @"station does not exist"
#define kErrorStationsToClose               @"Departure/Arrival are too near" //Code K895
#define kErrorStationNotDefined             @"No connections found; at least one station doesn't exist in the requested timetable pool" //Code K899

//--------------------------------------------------------------------------------

#define kConReq_XML_SOURCE_EX               @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"DE\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"MJXZ841ZfsmqqmSymWhBPy5dMNoqoGsHInHbWJQ5PTUZOJ1rLTkn8vVZOZDFfSe\"><ConReq><Start><Station name=\"Glattbrugg\" externalId=\"008503310#95\"/><Prod  prod=\"1111111111000000\"/></Start><Dest><Station name=\"Z�rich, Milchbuck\" externalId=\"000101643#95\"/></Dest><Via><Station name=\"Z%FCrich%20Oerlikon\" externalId=\"008503006#95\"/><Prod  prod=\"1111111111000000\"/></Via><ReqT a=\"0\" date=\"20110620\" time=\"18:06\" /><RFlags b=\"0\" f=\"4\" sMode=\"N\"/></ConReq></ReqC>"
#define kConReq_XML_VIA_SOURCE_EX           @"Via><Station name=\"Z%FCrich%20Oerlikon\" externalId=\"008503006#95\"/><Prod  prod=\"1111111111000000\"/></Via>"
#define kConReq_XML_START_POI_SOURCE_EX     @"<Start><Coord type=\"WGS84\" z=\"\" y=\"47395037\" x=\"8541234\"/><Prod  prod=\"PRODUCTCODE\"/></Start>"

#define kConReq_XML_SOURCE_OLD              @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"DE\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"MJXZ841ZfsmqqmSymWhBPy5dMNoqoGsHInHbWJQ5PTUZOJ1rLTkn8vVZOZDFfSe\"><ConReq><Start><Station name=\"STARTSTATIONNAME\" externalId=\"STARTSTATIONID\"/><Prod prod=\"PRODUCTCODE\"/></Start><Dest><Station name=\"ENDSTATIONNAME\" externalId=\"ENDSTATIONID\"/></Dest>CONVIAXML<ReqT a=\"ARRDEPCODE\" date=\"CONDATE\" time=\"CONTIME\" /><RFlags b=\"0\" f=\"4\" sMode=\"N\"/></ConReq></ReqC>"

#define kConReq_XML_SOURCE                  @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"APILOCALE\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><ConReq>STARTXMLENDXMLCONVIAXML<ReqT a=\"ARRDEPCODE\" date=\"CONDATE\" time=\"CONTIME\" /><RFlags b=\"0\" f=\"NUMBEROFREQUESTS\" sMode=\"N\"/></ConReq></ReqC>"


#define kConReq_XML_VIA_SOURCE              @"<Via><Station name=\"VIASTATIONNAME\" externalId=\"VIASTATIONID\"/><Prod prod=\"VIAPRODUCTCODE\"/></Via>"

#define kConReq_XML_START_STATION_SOURCE    @"<Start><Station name=\"STARTSTATIONNAME\" externalId=\"STARTSTATIONID\"/><Prod prod=\"PRODUCTCODE\"/></Start>"
#define kConReq_XML_START_POI_SOURCE        @"<Start><Coord type=\"WGS84\" z=\"\" y=\"LATITUDE\" x=\"LONGITUDE\"/><Prod  prod=\"PRODUCTCODE\"/></Start>"

#define kConReq_XML_END_STATION_SOURCE      @"<Dest><Station name=\"ENDSTATIONNAME\" externalId=\"ENDSTATIONID\"/></Dest>"
#define kConReq_XML_END_POI_SOURCE          @"<Dest><Coord type=\"WGS84\" z=\"\" y=\"LATITUDE\" x=\"LONGITUDE\"/></Dest>"

#define kConScr_XML_SOURCE_EX               @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"EN\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><ConScrReq scrDir=\"B\" nrCons=\"4\"><ConResCtxt>94.05538189.1355692915#1</ConResCtxt></ConScrReq></ReqC>"
#define kConScr_XML_SOURCE               @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"APILOCALE\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><ConScrReq scrDir=\"CONSCRDIRFLAG\" nrCons=\"NUMBEROFREQUESTS\"><ConResCtxt>CONSCRREQUESTID</ConResCtxt></ConScrReq></ReqC>"

//--------------------------------------------------------------------------------

#define kStbReq_XML_SOURCE_EX               @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC ver=\"1.7\" prod=\"testsystem\" lang=\"DE\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><STBReq boardType=\"DEP\" maxJourneys=\"40\"><Time>22:13</Time><Period><DateBegin><Date>20121216</Date></DateBegin><DateEnd><Date>20121216</Date></DateEnd></Period><TableStation externalId=\"008503000#95\"/><ProductFilter>1111111111000000</ProductFilter><DirectionFilter externalId=\"008500218#95\"/></STBReq></ReqC>"

#define kStbReq_XML_SOURCE                  @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC ver=\"1.7\" prod=\"testsystem\" lang=\"APILOCALE\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><STBReq boardType=\"STBREQTYPE\" maxJourneys=\"STBREQNUM\"><Time>STBTIME</Time><Period><DateBegin><Date>STBDATE</Date></DateBegin><DateEnd><Date>STBDATE</Date></DateEnd></Period><TableStation externalId=\"STBSTATIONID\"/><ProductFilter>PRODUCTCODE</ProductFilter>DIRECTIONFILTER</STBReq></ReqC>"

#define kStbReq_XML_DIR_SOURCE              @"<DirectionFilter externalId=\"DIRSTATIONID\"/>"

//--------------------------------------------------------------------------------

#define kJourneyReq_XML_SOURCE_EX           @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"EN\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><JourneyReq date=\"20121216\" externalId=\"8503000#95\" time=\"21:09\" type=\"DEP\"><JHandle tNr=\"82\" cycle=\"00\" puic=\"095\"/></JourneyReq></ReqC>"

#define kJourneyReq_XML_SOURCE              @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"APILOCALE\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><JourneyReq date=\"JRNDATE\" externalId=\"STATIONID\" time=\"JRNTIME\" type=\"JRNREQTYPE\"><JHandle tNr=\"JRNTNR\" cycle=\"JRNCYCLE\" puic=\"JRNPUIC\"/></JourneyReq></ReqC>"

//--------------------------------------------------------------------------------

#define kValidationReq_XML_SOURCE           @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"APILOCALE\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><LocValReq id=\"INPUTID\" sMode=\"1\"><ReqLoc match=\"STATIONNAME\" type=\"ALLTYPE\"/></LocValReq></ReqC>"

#define kClosestStationsReq_XML_SOURCE      @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC ver=\"1.1\" prod=\"JP\" lang=\"APILOCALE\" clientVersion=\"2.1.7\"><LocValReq id=\"INPUTID\" sMode=\"1\"><Coord x=\"LONGITUDE\" y=\"LATITUDE\" type=\"ST\"></Coord></LocValReq></ReqC>"

//--------------------------------------------------------------------------------

#define kPRODUCT_CODE_ALL                   @"1111111111000000"
#define kPRODUCT_CODE_LONGDISTANCETRAIN     @"1110000000000000"
#define kPRODUCT_CODE_REGIOTRAIN            @"0001110000000000"
//#define kPRODUCT_CODE_TRAM_BUS            @"0000001001000000"
#define kPRODUCT_CODE_TRAM_BUS              @"0000001111000000"

@implementation SBBAPIController

+ (SBBAPIController *)sharedSBBAPIController
{
    static SBBAPIController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SBBAPIController alloc] init];
        // Do any other initialisation stuff here
        sharedInstance.conreqRequestInProgress = NO;
        sharedInstance.stbreqRequestInProgress = NO;
        sharedInstance.rssreqRequestInProgress = NO;
        sharedInstance.valreqRequestInProgress = NO;
        sharedInstance.stareqRequestInProgress = NO;
        //sharedInstance.conreqRequestCancelledFlag = NO;
        //sharedInstance.stbreqRequestCancelledFlag = NO;
        //sharedInstance.rssreqRequestCancelledFlag = NO;
        sharedInstance.sbbApiLanguageLocale = reqEnglish;
        sharedInstance.sbbConReqNumberOfConnectionsForRequest = 4;
        sharedInstance.sbbConScrNumberOfConnectionsForRequest = 4;
        sharedInstance.sbbStbReqNumberOfConnectionsForRequest = 40;
        sharedInstance.sbbStbScrNumberOfConnectionsForRequest = 40;
        
        sharedInstance.sbbApiConreqTimeout = SBBAPIREQUESTCONREQSTANDARDTIMEOUT;
        sharedInstance.sbbApiStbreqTimeout = SBBAPIREQUESTSTBREQSTANDARDTIMEOUT;
        sharedInstance.sbbApiRssreqTimeout = SBBAPIREQUESTRSSREQSTANDARDTIMEOUT;
        sharedInstance.sbbApiValreqTimeout = SBBAPIREQUESTVALREQSTANDARDTIMEOUT;
        sharedInstance.sbbApiStareqTimeout = SBBAPIREQUESTVALREQSTANDARDTIMEOUT;
        
        //sharedInstance.conreqBackgroundQueue  = dispatch_queue_create("ch.fasoft.swisstransit.conreqqueue", NULL);
        //sharedInstance.stbreqBackgroundQueue  = dispatch_queue_create("ch.fasoft.swisstransit.stbreqqueue", NULL);
        //sharedInstance.rssreqBackgroundQueue  = dispatch_queue_create("ch.fasoft.swisstransit.rssreqqueue", NULL);
        
        sharedInstance.conreqBackgroundOpQueue = [[NSOperationQueue alloc] init];
        sharedInstance.stbreqBackgroundOpQueue = [[NSOperationQueue alloc] init];
        sharedInstance.rssreqBackgroundOpQueue = [[NSOperationQueue alloc] init];
        sharedInstance.valreqBackgroundOpQueue = [[NSOperationQueue alloc] init];
        sharedInstance.stareqBackgroundOpQueue = [[NSOperationQueue alloc] init];
                
        //#ifdef IncludeDetailedTrainlines
        //sharedInstance.trainLinesController = [[TrainLinesController alloc] init];
        //#endif
    });
    
    return sharedInstance;
}

- (void) setSBBAPIErrorReportingBaseUrl:(NSString *)baseurl {
    if (baseurl) {
        self.errorReportingBaseURL = baseurl;
    }
}

- (NSString *) getUniqueId {
    return [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString *) machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
	
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *) iPhoneDevice
{
	NSString *deviceType = [NSString stringWithString: [self machineName]];
	
	//NSLog(@"Device: %@", deviceType);
    
    if ([deviceType isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([deviceType isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceType isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceType isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceType isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([deviceType isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceType isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM/LTE US&CA)";
    if ([deviceType isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (CDMA/LTE or GSM/LTE Int)";
    if ([deviceType isEqualToString:@"iPhone5,3"]) return @"iPhone 5 (CDMA/LTE or GSM/LTE Int)";
    if ([deviceType isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceType isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceType isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceType isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceType isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceType isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceType isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceType isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceType isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMAV)";
    if ([deviceType isEqualToString:@"iPad2,4"])      return @"iPad 2 (CDMAS)";
    if ([deviceType isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceType isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceType isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceType isEqualToString:@"iPad3,1"])      return @"iPad-3G (WiFi)";
    if ([deviceType isEqualToString:@"iPad3,2"])      return @"iPad-3G (4G GSM)";
    if ([deviceType isEqualToString:@"iPad3,3"])      return @"iPad-3G (4G CDMA)";
    if ([deviceType isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceType isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceType isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceType isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceType isEqualToString:@"x86_64"])       return @"Simulator";
    
    return (@"Unknown device");
}

- (NSString *) systemVersion
{
    return ([[UIDevice currentDevice] systemVersion]);
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


- (void) setSBBAPILanguageLocale:(NSUInteger)languagelocale {
    if (languagelocale == reqEnglish || languagelocale == reqGerman || languagelocale == reqFrench || languagelocale == reqItalian) {
        self.sbbApiLanguageLocale = languagelocale;
    }
}

- (void) setSBBAPIConreqTimeout:(NSUInteger)timeout {
    self.sbbApiConreqTimeout = timeout;
}

- (void) setSBBAPIStbreqTimeout:(NSUInteger)timeout {
    self.sbbApiStbreqTimeout = timeout;
}

- (void) setSBBAPIRssreqTimeout:(NSUInteger)timeout {
    self.sbbApiRssreqTimeout = timeout;
}

- (void) setSBBConReqNumberOfConnectionsForRequest:(NSUInteger)numberofconnections {
    if (numberofconnections > 4) {
        self.sbbConReqNumberOfConnectionsForRequest = numberofconnections;
    }
}

- (void) setSBBConScrNumberOfConnectionsForRequest:(NSUInteger)numberofconnections {
    if (numberofconnections > 4) {
        self.sbbConScrNumberOfConnectionsForRequest = numberofconnections;
    }
}

- (void) setSBBStbReqNumberOfConnectionsForRequest:(NSUInteger)numberofconnections {
    if (numberofconnections > 4) {
        self.sbbStbReqNumberOfConnectionsForRequest = numberofconnections;
    }
}

- (void) setSBBStbScrNumberOfConnectionsForRequest:(NSUInteger)numberofconnections {
    if (numberofconnections > 4) {
        self.sbbStbScrNumberOfConnectionsForRequest = numberofconnections;
    }
}

- (void) setSBBAPIStationsManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self.stationsDatabaseManagedObjectContext = managedObjectContext;
}

- (void) logTimeStampWithText:(NSString *)text {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"HH:mm:ss:SS yyyyMMdd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    NSLog(@"%@, %@", text, dateString);
}

- (void) sendConReqXMLConnectionRequest:(Station *)startStation endStation:(Station *)endStation viaStation:(Station *)viaStation conDate:(NSDate *)condate departureTime:(BOOL)departureTime successBlock:(void(^)(NSUInteger))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {

    if (!startStation || !endStation || !condate) {
        return;
    }
            
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: condate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: condate];
    
    NSString *xmlString = kConReq_XML_SOURCE;
    NSString *xmlStartString;
    NSString *xmlEndString;
        
    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
    if (startStation.stationName && startStation.stationId) {
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"Start station set");
        #endif
        
        xmlStartString = kConReq_XML_START_STATION_SOURCE;
        xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"STARTSTATIONNAME" withString: [startStation stationName]];
        xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"STARTSTATIONID" withString: [startStation stationId]];
        xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
    } else {
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"Start poi set: %.6f, %.6f", [[startStation latitude] floatValue], [[startStation longitude] floatValue]);
        #endif        
        
        xmlStartString = kConReq_XML_START_POI_SOURCE;
        int latitude = (int)([[startStation latitude] floatValue] * 1000000);
        int longitude = (int)([[startStation longitude] floatValue] * 1000000);
        
        xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"LATITUDE" withString: [NSString stringWithFormat: @"%d", latitude]];
        xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"LONGITUDE" withString: [NSString stringWithFormat: @"%d", longitude]];
        xmlStartString = [xmlStartString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
    }
    
    if (endStation.stationName && endStation.stationId) {
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"End station set");
        #endif
        
        xmlEndString = kConReq_XML_END_STATION_SOURCE;
        xmlEndString = [xmlEndString stringByReplacingOccurrencesOfString: @"ENDSTATIONNAME" withString: [endStation stationName]];
        xmlEndString = [xmlEndString stringByReplacingOccurrencesOfString: @"ENDSTATIONID" withString: [endStation stationId]];
    } else {
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"End poi set: %.6f, %.6f", [[endStation latitude] floatValue], [[endStation longitude] floatValue]);
        #endif
        
        int latitude = (int)([[endStation latitude] floatValue] * 1000000);
        int longitude = (int)([[endStation longitude] floatValue] * 1000000);
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
    
    if (viaStation) {
        NSString *xmlViaString = kConReq_XML_VIA_SOURCE;
        xmlViaString = [xmlViaString stringByReplacingOccurrencesOfString: @"VIASTATIONNAME" withString: [viaStation stationName]];
        xmlViaString = [xmlViaString stringByReplacingOccurrencesOfString: @"VIASTATIONID" withString: [viaStation stationId]];
        xmlViaString = [xmlViaString stringByReplacingOccurrencesOfString: @"VIAPRODUCTCODE" withString: kPRODUCT_CODE_ALL];
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONVIAXML" withString: xmlViaString];
        
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONVIAXML" withString: @""];
        //xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STARTSTATIONID" withString: [startStation stationId]];
    }
    
    if (departureTime) {
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
        
    self.conreqRequestInProgress = YES;
    
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
            
            if (failureBlock) {
                failureBlock(kConReqRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *conreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakConreqDecodingXMLOperation = conreqDecodingXMLOperation;
        
        [conreqDecodingXMLOperation addExecutionBlock: ^(void) {
            
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
                
                
                if ([weakConreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Conreq cancelled. Con queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kConReqRequestFailureCancelled);
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
                        tempConnections.searchdate = condate;
                        tempConnections.searchdateisdeparturedate = departureTime;
                        //NSLog(@"ConRes direction: %@", tempConnections.direction);
                        
                        for (CXMLElement *conResElement in [conResNode children]) {
                            
                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                #ifdef SBBAPILogLevelCancel
                                NSLog(@"Conreq cancelled. Con queue block. For each 1");
                                #endif
                                
                                if (failureBlock) {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                        failureBlock(kConReqRequestFailureCancelled);
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
                                
                                NSString *errorcodestring = [NSString stringWithFormat:@"Conreq:%@", errorcode];
                                
                                if (self.errorreportingHttpClient) {
                                    self.errorreportingHttpClient = nil;
                                }
                                if (self.errorReportingBaseURL) {
                                    self.errorreportingHttpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString: self.errorReportingBaseURL]];
                                    [self.errorreportingHttpClient defaultValueForHeader:@"Accept"];
                                    
                                    NSString *requesturlpath = [self createErrorReportingUrlString: errorcodestring errortext: errortext startname: startStation.stationName startid:startStation.stationId endname:endStation.stationName endid:endStation.stationId];
                                    
                                    #ifdef SBBAPILogLevelCancel
                                    //NSLog(@"Error url: %@", requesturlpath);
                                    #endif
                                    
                                    NSMutableURLRequest *errorrequest = [self.errorreportingHttpClient requestWithMethod:@"POST" path: requesturlpath parameters:nil];
                                    //[errorrequest setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
                                    [errorrequest setTimeoutInterval: SBBAPIREQUESTERRREQSTANDARDTIMEOUT];
                                    AFHTTPRequestOperation *erroroperation = [[AFHTTPRequestOperation alloc] initWithRequest:errorrequest];
                                    
                                    /*
                                    [erroroperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSLog(@"%@", [operation responseString]);
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"%@", [operation responseString]);
                                    }];
                                    */
                                    
                                    [erroroperation start];
                                }
                            }
                        }
                        
                        CXMLNode *connections = [xmlResponse nodeForXPath: @"//ConnectionList" error: nil];
                        if (connections) {
                            for (CXMLElement *currentConnection in [connections children]) {
                                
                                if ([weakConreqDecodingXMLOperation isCancelled]) {
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Conreq cancelled. Con queue block. For each 2");
                                    #endif
                                    
                                    if (failureBlock) {
                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                            failureBlock(kConReqRequestFailureCancelled);
                                        }];
                                    }
                                    return;
                                }
                                
                                ConResult *conResult = [[ConResult alloc] init];
                                NSString *connectionId = [[currentConnection attributeForName: @"id"] stringValue];
                                conResult.conResId = connectionId;
                                conResult.searchdate = condate;
                                conResult.searchdateisdeparturedate = departureTime;
                                
                                #ifdef SBBAPILogLevelFull
                                NSLog(@"Connection id: %@", conResult.conResId);
                                #endif
                                
                                for (CXMLElement *currentConnectionElement in [currentConnection children]) {
                                    
                                    if ([weakConreqDecodingXMLOperation isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Conreq cancelled. Con queue block. For each 3");
                                        #endif
                                        
                                        if (failureBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                failureBlock(kConReqRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
                                    if ([[currentConnectionElement name] isEqualToString: @"Overview"]) {
                                        //NSLog(@"Overview: %@", currentConnectionElement);
                                        ConOverview *conOverView = [[ConOverview alloc] init];
                                        for (CXMLElement *currentOverviewElement in [currentConnectionElement children]) {
                                            
                                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Conreq cancelled. Con queue block. For each 4");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kConReqRequestFailureCancelled);
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
                                            
                                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Conreq cancelled. Con queue block. For each 5");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kConReqRequestFailureCancelled);
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
                                                        
                                                        if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                            #ifdef SBBAPILogLevelCancel
                                                            NSLog(@"Conreq cancelled. Con queue block. For each 6");
                                                            #endif
                                                            
                                                            if (failureBlock) {
                                                                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                                    failureBlock(kConReqRequestFailureCancelled);
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
                                                                            NSString *journeyName = [[journeyAttributeVariantElement stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                            journey.journeyName = journeyName;
                                                                            
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
                                                                                //NSLog(@"Arr platform: %@", [currentArrElement stringValue]);
                                                                                CXMLNode *platformElements = [currentArrElement childAtIndex: 0];
                                                                                //NSLog(@"Arr platform: %@", [platformElements stringValue]);
                                                                                NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                                //NSLog(@"Arr platform: %@", platformString);
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
                                                                                //NSLog(@"Dep platform: %@", [currentDepElement stringValue]);
                                                                                CXMLNode *platformElements = [currentDepElement childAtIndex: 0];
                                                                                //NSLog(@"Dep platform: %@", [platformElements stringValue]);
                                                                                NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                                //NSLog(@"Dep platform: %@", platformString);
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
                                                } else if ([[currentConSectionDetailElement name] isEqualToString: @"Transfer"]) {
                                                    
                                                    #ifdef SBBAPILogLevelFull
                                                    NSLog(@"Consection passing though transfer type");
                                                    #endif
                                                    
                                                    conSection.conSectionType = journeyType;
                                                    //conSection.conSectionSubType = transferType;
                                                    Journey *journey = [[Journey alloc] init];
                                                    journey.journeyDirection = @"-";
                                                    journey.journeyAdministration = nil;
                                                    journey.journeyCategoryName = @"TRANS.";
                                                    journey.journeyCategoryCode = @"9";
                                                    journey.journeyHandle = nil;
                                                    journey.journeyIsDelayed = NO;
                                                    journey.journeyName = @"TRANS.";
                                                    journey.journeyNumber = @"0";
                                                    journey.journeyOperator = @"-";
                                                    
                                                    conResult.hasTransferInConSections = YES;
                                                    
                                                    conSection.journey = journey;
                                                }
                                            }
                                            [conSectionList.conSections addObject: conSection];
                                        }
                                        conResult.conSectionList = conSectionList;
                                    } else if ([[currentConnectionElement name] isEqualToString: @"IList"]) {
                                        // To implement
                                        for (CXMLElement *currentInfoElement in [currentConnectionElement children]) {
                                            
                                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Conreq cancelled. Con queue block. For each 7");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kConReqRequestFailureCancelled);
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
                                    if (startStation.stationName) {
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Setting better startstation name: %@", startStation.stationName);
                                        #endif
                                        
                                        conResult.knownBetterStartLocationName = startStation.stationName;
                                        tempConnections.knownBetterStartLocationName = startStation.stationName;
                                        if ([conResult conSectionList] && [[conResult conSectionList] conSections] && ([[[conResult conSectionList] conSections] count]>0)) {
                                            ConSection *startSection = [[[conResult conSectionList] conSections] objectAtIndex: 0];
                                            if ([startSection departure] && [[startSection departure] station]) {
                                                Station *departureStation = [[startSection departure] station];
                                                departureStation.stationName = startStation.stationName;
                                            }
                                        }
                                    } else {
                                        conResult.knownBetterStartLocationName = nil;
                                    }
                                    if (endStation.stationName) {
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Setting better endstation name: %@", endStation.stationName);
                                        #endif
                                        
                                        conResult.knownBetterEndLocationName = endStation.stationName;
                                        tempConnections.knownBetterEndLocationName = endStation.stationName;
                                        if ([conResult conSectionList] && [[conResult conSectionList] conSections] && ([[[conResult conSectionList] conSections] count]>0)) {
                                            ConSection *endSection = [[[conResult conSectionList] conSections] lastObject];
                                            if ([endSection departure] && [[endSection arrival] station]) {
                                                Station *arrivalStation = [[endSection arrival] station];
                                                arrivalStation.stationName = endStation.stationName;
                                            }
                                        }
                                    } else {
                                        conResult.knownBetterEndLocationName = nil;
                                    }
                                    
                                    if (conResult.hasTransferInConSections) {
                                        for (ConSection *currentConSection in conResult.conSectionList.conSections) {
                                            if ([[currentConSection.journey journeyCategoryName] isEqualToString: @"TRANS."]) {
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Transfer type add passlist stations");
                                                #endif
                                                [currentConSection.journey.passList addObject: currentConSection.departure];
                                                [currentConSection.journey.passList addObject: currentConSection.arrival];
                                            }
                                        }
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
            
            self.conreqRequestInProgress = NO;
            
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
            
            if ([weakConreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Conreq cancelled. Con queue block. End. MainQueue call");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kConReqRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (tempConnections && tempConnections.conResults.count > 0) {
                
                            self.connectionsResult = tempConnections;
                            
                            #ifdef SBBAPILogLevelXMLReqRes
                            NSLog(@"Connections result: %@", self.connectionsResult);
                            #endif
                            
                            NSUInteger numberofnewresults = 0;
                            numberofnewresults = self.connectionsResult.conResults.count;

                            successBlock(numberofnewresults);
                            
                        } else {
                            if (failureBlock) {
                                failureBlock(kConRegRequestFailureNoNewResults);
                            }
                        }
                    }];
                }
            }
        }];
        [_conreqBackgroundOpQueue addOperation: conreqDecodingXMLOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        self.conreqRequestInProgress = NO;
        
        //NSUInteger kConReqRequestFailureConnectionFailed = 85;
        
        if (failureBlock) {
            failureBlock(kConReqRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
    [self logTimeStampWithText:@"Conreq start operation"];
    #endif
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

- (void) sendConScrXMLConnectionRequest:(NSUInteger)directionflag successBlock:(void(^)(NSUInteger))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
            
    NSString *xmlString = kConScr_XML_SOURCE;

    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
    
    if (!self.connectionsResult)  {
        NSUInteger kConScrRequestFailureNoConnectionResult = 41;
        if (failureBlock) {
            failureBlock(kConScrRequestFailureNoConnectionResult);
        }
    }
    if (!self.connectionsResult.direction || !self.connectionsResult.conId)  {
        NSUInteger kConScrRequestFailureNoConnectionId = 42;
        if (failureBlock) {
            failureBlock(kConScrRequestFailureNoConnectionId);
        }
    }
    if (!self.connectionsResult.conIdexconscrid || !self.connectionsResult.conscridbackwards || !self.connectionsResult.conscridforward)  {
        NSUInteger kConScrRequestFailureNoIdExOrBackFwdNumber = 43;
        if (failureBlock) {
            failureBlock(kConScrRequestFailureNoIdExOrBackFwdNumber);
        }
    }
    
    int conIdNumber = 0;
    if (directionflag == conscrBackward) {
          xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONSCRDIRFLAG" withString: @"B"];
          conIdNumber = [self.connectionsResult.conscridbackwards integerValue];
    } else if (directionflag == conscrForward) {
         xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONSCRDIRFLAG" withString: @"F"];
         conIdNumber = [self.connectionsResult.conscridforward integerValue];
    }
    
    NSString *connectionId = [NSString stringWithFormat: @"%@#%d", self.connectionsResult.conIdexconscrid, conIdNumber];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"Connectionindex id: %@", connectionId);
    #endif 
    
    NSDate *connectiondate = self.connectionsResult.searchdate;
    BOOL connectiondateisdeparture = self.connectionsResult.searchdateisdeparturedate;
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"CONSCRREQUESTID" withString: connectionId];
    
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
        
    #ifdef SBBAPILogLevelXMLReqRes
    NSLog(@"XML String: %@", xmlString);
    #endif
    
    //return;
    
    self.conreqRequestInProgress = YES;
 
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
            [self logTimeStampWithText:@"Conscr end operation"];
        #endif
        
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Conscr cancelled. Op success block start");
            #endif
            
            if (failureBlock) {
                failureBlock(kConScrRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *conreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakConreqDecodingXMLOperation = conreqDecodingXMLOperation;
        
        [conreqDecodingXMLOperation addExecutionBlock: ^(void) {
            
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
                
                if ([weakConreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Conscr cancelled. Con queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kConScrRequestFailureCancelled);
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
                        tempConnections.searchdate = connectiondate;
                        tempConnections.searchdateisdeparturedate = connectiondateisdeparture;
                        
                        #ifdef SBBAPILogLevelFull
                        NSLog(@"ConRes direction: %@", tempConnections.direction);
                        #endif
                        
                        for (CXMLElement *conResElement in [conResNode children]) {
                            
                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                #ifdef SBBAPILogLevelCancel
                                NSLog(@"Conscr cancelled. Con queue block. For each 1");
                                #endif
                                
                                if (failureBlock) {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                        failureBlock(kConScrRequestFailureCancelled);
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
                                    if (directionflag == conscrBackward) {
                                        tempConnections.conscridbackwards = [NSNumber numberWithInt: [[conIdSplit objectAtIndex: 1] integerValue]];
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Conidex: %@, conidback %d", [conIdSplit objectAtIndex: 0], [[conIdSplit objectAtIndex: 1] integerValue]);
                                        #endif
                                    } else if (directionflag == conscrForward) {
                                        tempConnections.conscridforward = [NSNumber numberWithInt: [[conIdSplit objectAtIndex: 1] integerValue]];
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Conidex: %@, conidfwd: %d", [conIdSplit objectAtIndex: 0], [[conIdSplit objectAtIndex: 1] integerValue]);
                                        #endif
                                    }
                                }
                                tempConnections.conId = [conResElement stringValue];
                                
                                #ifdef SBBAPILogLevelFull
                                NSLog(@"ConRes id: %@",tempConnections.conId);
                                #endif
                            } else if ([[conResElement name] isEqualToString: @"Err"]) {
                                NSString *errorcode = [[(CXMLElement *)conResElement attributeForName: @"code"] stringValue];
                                NSString *errortext = [[(CXMLElement *)conResElement attributeForName: @"text"] stringValue];
                                #ifdef SBBAPILogLevelCancel
                                NSLog(@"Conreq: error received: %@, %@", errorcode, errortext);
                                #endif
                                
                                NSString *errorcodestring = [NSString stringWithFormat:@"Conscr:%@", errorcode];
                                
                                if (self.errorreportingHttpClient) {
                                    self.errorreportingHttpClient = nil;
                                }
                                if (self.errorReportingBaseURL) {
                                    self.errorreportingHttpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString: self.errorReportingBaseURL]];
                                    [self.errorreportingHttpClient defaultValueForHeader:@"Accept"];
                                    
                                    NSString *requesturlpath = [self createErrorReportingUrlString: errorcodestring errortext: errortext startname: @"NA" startid:@"NA" endname:@"NA" endid:@"NA"];
                                    
                                    #ifdef SBBAPILogLevelCancel
                                    //NSLog(@"Error url: %@", requesturlpath);
                                    #endif
                                    
                                    NSMutableURLRequest *errorrequest = [self.errorreportingHttpClient requestWithMethod:@"POST" path: requesturlpath parameters:nil];
                                    //[errorrequest setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
                                    [errorrequest setTimeoutInterval: SBBAPIREQUESTERRREQSTANDARDTIMEOUT];
                                    AFHTTPRequestOperation *erroroperation = [[AFHTTPRequestOperation alloc] initWithRequest:errorrequest];
                                    
                                    /*
                                     [erroroperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"%@", [operation responseString]);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"%@", [operation responseString]);
                                     }];
                                     */
                                    
                                    [erroroperation start];
                                }
                            }
                        }
                        
                        CXMLNode *connections = [xmlResponse nodeForXPath: @"//ConnectionList" error: nil];
                        if (connections) {
                            for (CXMLElement *currentConnection in [connections children]) {
                                
                                if ([weakConreqDecodingXMLOperation isCancelled]) {
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Conscr cancelled. Con queue block. For each 2");
                                    #endif
                                    
                                    if (failureBlock) {
                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                            failureBlock(kConScrRequestFailureCancelled);
                                        }];
                                    }
                                    return;
                                }
                                
                                ConResult *conResult = [[ConResult alloc] init];
                                NSString *connectionId = [[currentConnection attributeForName: @"id"] stringValue];
                                conResult.conResId = connectionId;
                                conResult.searchdate = connectiondate;
                                conResult.searchdateisdeparturedate = connectiondateisdeparture;
                                
                                #ifdef SBBAPILogLevelFull
                                NSLog(@"Connection id: %@", conResult.conResId);
                                #endif
                                
                                for (CXMLElement *currentConnectionElement in [currentConnection children]) {
                                    
                                    if ([weakConreqDecodingXMLOperation isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Conscr cancelled. Con queue block. For each 3");
                                        #endif
                                        
                                        if (failureBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                failureBlock(kConScrRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
                                    if ([[currentConnectionElement name] isEqualToString: @"Overview"]) {
                                        //NSLog(@"Overview: %@", currentConnectionElement);
                                        ConOverview *conOverView = [[ConOverview alloc] init];
                                        for (CXMLElement *currentOverviewElement in [currentConnectionElement children]) {
                                            
                                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Conscr cancelled. Con queue block. For each 4");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kConScrRequestFailureCancelled);
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
                                            
                                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Conscr cancelled. Con queue block. For each 5");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kConScrRequestFailureCancelled);
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
                                                
                                                if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                    #ifdef SBBAPILogLevelCancel
                                                    NSLog(@"Conscr cancelled. Con queue block. For each 6");
                                                    #endif
                                                    
                                                    if (failureBlock) {
                                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                            failureBlock(kConScrRequestFailureCancelled);
                                                        }];
                                                    }
                                                    return;
                                                }
                                                
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
                                                                            NSString *journeyName = [[journeyAttributeVariantElement stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                                            journey.journeyName = journeyName;
                                                                            
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
                                                } else if ([[currentConSectionDetailElement name] isEqualToString: @"Transfer"]) {
                                                    
                                                    #ifdef SBBAPILogLevelFull
                                                    NSLog(@"Consection passing though transfer type");
                                                    #endif
                                                    
                                                    conSection.conSectionType = journeyType;
                                                    //conSection.conSectionSubType = transferType;
                                                    Journey *journey = [[Journey alloc] init];
                                                    journey.journeyDirection = @"-";
                                                    journey.journeyAdministration = nil;
                                                    journey.journeyCategoryName = @"TRANS.";
                                                    journey.journeyCategoryCode = @"9";
                                                    journey.journeyHandle = nil;
                                                    journey.journeyIsDelayed = NO;
                                                    journey.journeyName = @"TRANS.";
                                                    journey.journeyNumber = @"0";
                                                    journey.journeyOperator = @"-";
                                                    
                                                    conResult.hasTransferInConSections = YES;
                                                    
                                                    conSection.journey = journey;
                                                }
                                            }
                                            [conSectionList.conSections addObject: conSection];
                                        }
                                        conResult.conSectionList = conSectionList;
                                    } else if ([[currentConnectionElement name] isEqualToString: @"IList"]) {
                                        // To implement
                                        for (CXMLElement *currentInfoElement in [currentConnectionElement children]) {
                                            
                                            if ([weakConreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Conscr cancelled. Con queue block. For each 7");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kConScrRequestFailureCancelled);
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
                                
                                //if (!conResult) NSLog(@"ConScrResult is nil");
                                
                                if (conResult) {
                                    if (self.connectionsResult.knownBetterStartLocationName) {
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Setting better startstation name: %@", self.connectionsResult.knownBetterStartLocationName);
                                        #endif
                                        
                                        conResult.knownBetterStartLocationName = self.connectionsResult.knownBetterStartLocationName;
                                        if ([conResult conSectionList] && [[conResult conSectionList] conSections] && ([[[conResult conSectionList] conSections] count]>0)) {
                                            ConSection *startSection = [[[conResult conSectionList] conSections] objectAtIndex: 0];
                                            if ([startSection departure] && [[startSection departure] station]) {
                                                Station *departureStation = [[startSection departure] station];
                                                departureStation.stationName = self.connectionsResult.knownBetterStartLocationName;
                                            }
                                        }
                                    } else {
                                        conResult.knownBetterStartLocationName = nil;
                                    }
                                    if (self.connectionsResult.knownBetterEndLocationName) {
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Setting better endstation name: %@", self.connectionsResult.knownBetterEndLocationName);
                                        #endif
                                        
                                        conResult.knownBetterEndLocationName = self.connectionsResult.knownBetterEndLocationName;
                                        if ([conResult conSectionList] && [[conResult conSectionList] conSections] && ([[[conResult conSectionList] conSections] count]>0)) {
                                            ConSection *endSection = [[[conResult conSectionList] conSections] lastObject];
                                            if ([endSection departure] && [[endSection arrival] station]) {
                                                Station *arrivalStation = [[endSection arrival] station];
                                                arrivalStation.stationName = self.connectionsResult.knownBetterEndLocationName;
                                            }
                                        }
                                    } else {
                                        conResult.knownBetterEndLocationName = nil;
                                    }
                                    
                                    if (conResult.hasTransferInConSections) {
                                        for (ConSection *currentConSection in conResult.conSectionList.conSections) {
                                            if ([[currentConSection.journey journeyCategoryName] isEqualToString: @"TRANS."]) {
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Transfer type add passlist stations");
                                                #endif
                                                [currentConSection.journey.passList addObject: currentConSection.departure];
                                                [currentConSection.journey.passList addObject: currentConSection.arrival];
                                            }
                                        }
                                    }
                                }
                                
                                [tempConnections.conResults addObject: conResult];
                                
                                #ifdef SBBAPILogLevelXMLReqRes
                                NSLog(@"ConScrRes: %@", conResult);
                                NSLog(@"ConScrRes #: %d", tempConnections.conResults.count);
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
            [self logTimeStampWithText:@"Conscr end decoding xml"];
            #endif
            
            self.conreqRequestInProgress = NO;
            
            if ([weakConreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Conscr cancelled. Con queue block. End. MainQueue call");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kConScrRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (tempConnections && tempConnections.conResults.count > 0) {
                                                        
                            NSUInteger numberofnewresults = self.connectionsResult.conResults.count;
                            
                            #ifdef SBBAPILogLevelXMLReqRes
                            NSLog(@"ConScrRes before #: %d", self.connectionsResult.conResults.count);
                            #endif
                            
                            if (directionflag == conscrBackward) {
                                for (ConResult *currentconResult in [tempConnections.conResults reverseObjectEnumerator]) {
                                    [self.connectionsResult.conResults insertObject: currentconResult atIndex: 0];
                                }
                                self.connectionsResult.conscridbackwards = tempConnections.conscridbackwards;
                            } else if (directionflag == conscrForward) {
                                for (ConResult *currentconResult in tempConnections.conResults) {
                                    [self.connectionsResult.conResults addObject: currentconResult];
                                }
                                self.connectionsResult.conscridforward = tempConnections.conscridforward;
                            }
                            
                            #ifdef SBBAPILogLevelXMLReqRes
                            NSLog(@"ConScrRes after #: %d", self.connectionsResult.conResults.count);
                            #endif
                            
                            numberofnewresults = self.connectionsResult.conResults.count - numberofnewresults;
                            
                            successBlock(numberofnewresults);
                            
                        } else {
                            if (tempConnections && tempConnections.conResults.count == 0) {
                                if (failureBlock) {
                                    failureBlock(kConScrRequestFailureNoNewResults);
                                }
                            } else {
                                if (failureBlock) {
                                    failureBlock(kConScrRequestFailureCancelled);
                                }
                            }
                        }

                    }];
                }
            }
        }];
        [_conreqBackgroundOpQueue addOperation: conreqDecodingXMLOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        self.conreqRequestInProgress = NO;
        
        //NSUInteger kConScrRequestFailureConnectionFailed = 45;
        if (failureBlock) {
            failureBlock(kConScrRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Conscr start operation"];
    #endif
    
    if (self.conscrRequestCancelledFlag) {
        self.conscrRequestCancelledFlag = NO;
        if (failureBlock) {
            failureBlock(kConScrRequestFailureCancelled);
        }
    }
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

- (BOOL) isRequestInProgress {
    
#ifdef SBBAPILogLevelCancel
    NSString *conreqstr = self.conreqRequestInProgress?@"Y":@"N";
    NSString *stbreqstr = self.stbreqRequestInProgress?@"Y":@"N";
    NSString *rssreqstr = self.rssreqRequestInProgress?@"Y":@"N";    
    NSLog(@"Check if sbb api request in progress. Conreq: %@, Stbreq: %@, Rssreq: %@", conreqstr, stbreqstr, rssreqstr);

#endif
    
    return (self.conreqRequestInProgress || self.stbreqRequestInProgress || self.rssreqRequestInProgress);
}

- (void) cancelAllSBBAPIOperations {
    #ifdef SBBAPILogLevelCancel
    NSLog(@"SBB API cancel ALL operations request");
    #endif
    [_conreqBackgroundOpQueue cancelAllOperations];
    self.conreqRequestInProgress = NO;
    
    if (self.conreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations conreq. kill http client");
        #endif
        [[self.conreqHttpClient operationQueue] cancelAllOperations];
        //self.conreqHttpClient = nil;
    }
    
    [_stbreqBackgroundOpQueue cancelAllOperations];
    self.stbreqRequestInProgress = NO;
    if (self.stbreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations stbreq. kill http client");
        #endif
        [[self.stbreqHttpClient operationQueue] cancelAllOperations];
        //self.stbreqHttpClient = nil;
    }
    
    [_rssreqBackgroundOpQueue cancelAllOperations];
    self.rssreqRequestInProgress = NO;
    if (self.rssreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations rssreq. kill http client");
        #endif
        [[self.rssreqHttpClient operationQueue] cancelAllOperations];
        //self.rssreqHttpClient = nil;
    }
    [_valreqBackgroundOpQueue cancelAllOperations];
    self.valreqRequestInProgress = NO;
    if (self.valreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations valreq. kill http client");
        #endif
        [[self.valreqHttpClient operationQueue] cancelAllOperations];
        //self.valreqHttpClient = nil;
    }
    [_stareqBackgroundOpQueue cancelAllOperations];
    self.stareqRequestInProgress = NO;
    if (self.stareqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations stareq. kill http client");
        #endif
        [[self.stareqHttpClient operationQueue] cancelAllOperations];
        //self.valreqHttpClient = nil;
    }
}

- (void) cancelAllSBBAPIConreqOperations {
    #ifdef SBBAPILogLevelCancel
    NSLog(@"SBB API cancel Conreq operations request");
    #endif
    
    [_conreqBackgroundOpQueue cancelAllOperations];
    self.conreqRequestInProgress = NO;
    if (self.conreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations conreq. kill http client");
        #endif
        [[self.conreqHttpClient operationQueue] cancelAllOperations];
        //self.conreqHttpClient = nil;
    }
}

- (void) cancelAllSBBAPIStbreqOperations {
    #ifdef SBBAPILogLevelCancel
    NSLog(@"SBB API cancel Stbreq operations request");
    #endif
    
    [_stbreqBackgroundOpQueue cancelAllOperations];
    self.stbreqRequestInProgress = NO;
    if (self.stbreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations stbreq. kill http client");
        #endif
        [[self.stbreqHttpClient operationQueue] cancelAllOperations];
        //self.stbreqHttpClient = nil;
    }
}

- (void) cancelAllSBBAPIRSSOperations {
    #ifdef SBBAPILogLevelCancel
    NSLog(@"SBB API cancel RSS operations request");
    #endif
    
    [_rssreqBackgroundOpQueue cancelAllOperations];
    self.rssreqRequestInProgress = NO;
    if (self.rssreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations rssreq. kill http client");
        #endif
        [[self.rssreqHttpClient operationQueue] cancelAllOperations];
        //self.rssreqHttpClient = nil;
    }
}

- (void) cancelAllSBBAPIValOperations {
    #ifdef SBBAPILogLevelCancel
    NSLog(@"SBB API cancel Val operations request");
    #endif
    
    [_valreqBackgroundOpQueue cancelAllOperations];
    self.valreqRequestInProgress = NO;
    if (self.valreqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations valreq. kill http client");
        #endif
        [[self.valreqHttpClient operationQueue] cancelAllOperations];
        //self.rssreqHttpClient = nil;
    }
}

- (void) cancelAllSBBAPIStaOperations {
    #ifdef SBBAPILogLevelCancel
    NSLog(@"SBB API cancel Sta operations request");
    #endif
    
    [_stareqBackgroundOpQueue cancelAllOperations];
    self.stareqRequestInProgress = NO;
    if (self.stareqHttpClient) {
        #ifdef SBBAPILogLevelCancel
        NSLog(@"SBB API cancel operations valreq. kill http client");
        #endif
        [[self.stareqHttpClient operationQueue] cancelAllOperations];
        //self.rssreqHttpClient = nil;
    }
}

- (NSString *) fromISOLatinToUTF8: (NSString *) input
{
	if (!input) return (nil);
	NSData *tempData = [input dataUsingEncoding: NSISOLatin1StringEncoding];
	NSString *utfString = [[NSString alloc] initWithData: tempData encoding:NSUTF8StringEncoding];
	return (utfString);
}

- (Connections *)getConnectionsresults {
    return self.connectionsResult;
}

- (NSArray *) getConnectionResults {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            if ([[self.connectionsResult conResults] count] > 0) {
                 return [[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults];
            }
        }
    }
    return  nil;
}

- (NSUInteger) getNumberOfConnectionResults {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            if ([[self.connectionsResult conResults] count] > 0) {
                return [[self.connectionsResult conResults] count];
            }
        }
    }
    return  0;
}

- (ConResult *) getConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    return [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index];
                }
            }
        }
    }
    return  nil;
}

- (NSDate *) getConnectionDateForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        return [self.connectionsResult searchdate];
    }
    return  nil;
}

- (BOOL) getConnectionDateIsDepartureFlagForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        return [self.connectionsResult searchdateisdeparturedate];
    }
    return  YES;
}

- (ConOverview *) getOverviewForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    return [[[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index] overView];
                }
            }
        }
    }
    return  nil;
}

- (NSString *) getBetterDepartureStationNameForConnectionResultWithIndex:(NSUInteger)index {
    //NSLog(@"getBetterDepartureStationNameForConnectionResultWithIndex: %d", index);
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    NSString *stationName = [[[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index] knownBetterStartLocationName];
                    //NSLog(@"getBetterDepartureStationNameForConnectionResultWithIndex: %@", stationName);
                    if (stationName && ([stationName length]>0)) {
                        return stationName;
                    }
                    return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");

                    ConOverview *overView = [self getOverviewForConnectionResultWithIndex: index];
                    NSString *overViewStationName = [self getDepartureStationNameForOverview: overView];
                    return overViewStationName;
                }
            }
        }
    }
    return  nil;
}

- (NSString *) getBetterArrivalStationNameForConnectionResultWithIndex:(NSUInteger)index {
    //NSLog(@"getBetterArrivalStationNameForConnectionResultWithIndex: %d", index);
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    NSString *stationName = [[[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index] knownBetterEndLocationName];
                    //NSLog(@"getBetterArrivalStationNameForConnectionResultWithIndex: %@", stationName);
                    if (stationName && ([stationName length]>0)) {
                        return stationName;
                    }
                    return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");
                    
                    ConOverview *overView = [self getOverviewForConnectionResultWithIndex: index];
                    NSString *overViewStationName = [self getArrivalStationNameForOverview: overView];
                    return overViewStationName;

                }
            }
        }
    }
    return  nil;
}

-  (NSDate *) getConnectionDateForOverview:(ConOverview *)overview {
    if (overview) {
        return [overview getDateFromDateString];
    }
    return  nil;
}

-  (NSString *) getConnectionDateStringForOverview:(ConOverview *)overview {
    if (overview) {
        return [overview getDateStringFromDateString];
    }
    return  nil;
}

-  (NSString *) getArrivalTimeForOverview:(ConOverview *)overview {
    if (overview) {
        return [[[overview arrival] arr] getFormattedTimeStringFromTime];
    }
    return  nil;
}

-  (NSString *) getDepartureTimeForOverview:(ConOverview *)overview {
    if (overview) {
        return [[[overview departure] dep] getFormattedTimeStringFromTime];
    }
    return  nil;
}

-  (NSString *) getArrivalStationNameForOverview:(ConOverview *)overview {
    //NSString *resultString = nil;
    if (overview) {
        if ([[[[overview arrival] station] stationName] isEqualToString: @"unknown"]) {
            return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");
        }
        return [[[overview arrival] station] stationName];
    }
    return nil;
}

-  (NSString *) getDepartureStationNameForOverview:(ConOverview *)overview {
    //NSString *resultString = nil;
    if (overview) {
        if ([[[[overview departure] station] stationName] isEqualToString: @"unknown"]) {
            return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");
        }
        return [[[overview departure] station] stationName];
    }
    return nil;
}

-  (NSNumber *) getCapacity1stForOverview:(ConOverview *)overview {
    if (overview) {
        return [[overview departure] capacity1st];
    }
    return nil;
}

-  (NSNumber *) getCapacity2ndForOverview:(ConOverview *)overview {
    if (overview) {
        return [[overview departure] capacity2nd];
    }
    return nil;
}

- (NSArray *) getConsectionsForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index];
                    return [[conResult conSectionList] conSections];
                }
            }
        }
    }
    return  nil;
}

- (NSUInteger) getNumberOfConsectionsForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index];
                    if ([[[conResult conSectionList] conSections] count] > 0) {
                        return [[[conResult conSectionList] conSections] count];
                    }
                }
            }
        }
    }
    return  0;
}

- (ConSection *) getConsectionForConnectionResultWithIndexAndConsectionIndex:(NSUInteger)index consectionIndex:(NSUInteger)consectionIndex {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index];
                    int consectionsCount = [[[conResult conSectionList] conSections] count];
                    if (consectionIndex < consectionsCount) {
                        return [[[conResult conSectionList] conSections] objectAtIndex: consectionIndex];
                    }
                }
            }
        }
    }
    return  nil;
}

- (ConSection *) getLastConsectionForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: index];
                    int consectionsCount = [[[conResult conSectionList] conSections] count];
                    if (consectionsCount > 0) {
                        return [[[conResult conSectionList] conSections] lastObject];
                    }
                }
            }
        }
    }
    return  nil;
}

- (BOOL) ConnectionResultWithIndexHasInfos:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    if ([[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList]) {
                        if ([[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] count] > 0) {
                            return YES;
                        }
                    }
                }
            }
        }
    }
    return  NO;
}

- (NSUInteger) getNumberOfConnectionInfosForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    if ([[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList]) {
                        if ([[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] count] > 0) {
                            return [[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] count];
                        }
                    }
                }
            }
        }
    }
    return  0;
}

- (ConnectionInfo *) getConnectioninfoForConnectionResultWithIndexAndConnectioninfoIndex:(NSUInteger)index infoIndex:(NSUInteger)infoIndex {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    if ([[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList]) {
                        if ([[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] count] > 0) {
                            if ([[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] count] > infoIndex) {
                                return [[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] objectAtIndex: infoIndex];
                            }
                        }
                    }
                }
            }
        }
    }
    return  nil;
}

- (NSString *) getPlaintextSharetextOfOverviewForConnectionResultWithIndex:(NSUInteger)index {
    //NSLog(@"getPlaintextSharetextForOverview: %d", index);
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    ConOverview *overView = [[[self.connectionsResult conResults] objectAtIndex: index] overView];
                    ConSection *conSection = [self getConsectionForConnectionResultWithIndexAndConsectionIndex: index consectionIndex: 0];
                    if (overView && conSection) {
                        NSString *departureTime = [self getDepartureTimeForConsection: conSection];
                        NSString *arrivalTime = [self getArrivalTimeForOverview: overView];
                        NSString *transfers = [overView transfers];
                        NSString *startStationName = [self getDepartureStationNameForOverview: overView];
                        NSString *endStationName = [self getArrivalStationNameForOverview: overView];
                        NSString *overViewText = [NSString stringWithFormat: @"-----------------------------------------\n%@ %@ %@\n%@ %@ %@\n\n%@ %@\n-----------------------------------------\n", NSLocalizedString(@"From:", @"SBBAPIController from station text"), departureTime, startStationName, NSLocalizedString(@"To:", @"SBBAPIController to station text"), arrivalTime, endStationName, NSLocalizedString(@"Transfers:", @"SBBAPIController transfers text"), transfers];
                        return overViewText;
                    }
                }
            }
        }
    }
    return  nil;
}

- (NSString *) getPlaintextSharetextForConsection:(ConSection *)conSection {
    //NSLog(@"getPlaintextSharetextForConsection");
    if (conSection) {
        NSString *startStationName = [self getDepartureStationNameForConsection: conSection];
        NSString *endStationName = [self getArrivalStationNameForConsection: conSection];
        NSString *departureTime = [self getDepartureTimeForConsection: conSection];
        NSString *arrivalTime = [self getArrivalTimeForConsection: conSection];
        
        NSUInteger journeyTypeFlag = [conSection conSectionType];
        
        if (journeyTypeFlag == walkType) {
            //detailViewCell.consectionImageType = walkType;
            NSString *walkDurationInfo = [[conSection walk] getFormattedDurationStringFromDuration];
            NSString *walkDistanceInfo = [NSString stringWithFormat:@"%@", [[conSection walk] getFormattedMetresStringFromDistance]];
            NSString *walkInfo = [NSString stringWithFormat:@"%@ / %@", walkDurationInfo, walkDistanceInfo];
            
            NSString *walkJourneyText = [NSString stringWithFormat: @"--------\n%@ %@\n\n%@ %@ %@\n\n%@ %@ %@\n", NSLocalizedString(@"Walk:", @"SBBAPIController walk journey text"), walkInfo,NSLocalizedString(@"From:", @"SBBAPIController from station text"), departureTime, startStationName, NSLocalizedString(@"To:", @"SBBAPIController to station text"), arrivalTime, endStationName];
            
            return walkJourneyText;
        } else if ([conSection conSectionType] == journeyType) {
            NSString *transportName = [self getTransportNameWithConsection: conSection];
            NSString *journeyDirectionString = [[conSection journey] journeyDirection];
            
            NSString *journeyDirectionInfo = @"";
            if (journeyDirectionString) {
                journeyDirectionInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Direction:", @"SBBAPIController direction text"), journeyDirectionString];
            }
            
            NSString *startTrack = [self getDeparturePlatformForConsection: conSection];
            NSString *endTrack = [self getArrivalPlatformForConsection: conSection];
            
            
            NSString *startTrackInfo = @"";
            NSString *endTrackInfo = @"";
            if (startTrack && ([startTrack length] > 0)) {
                startTrackInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Track:", @"SBBAPIController track text"), startTrack];
            }
            if (endTrack && ([endTrack length] > 0)) {
                endTrackInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Track:", @"SBBAPIController track text"), endTrack];
            }
            
            //BOOL journeyIsDelayed = [self isJourneyDelayedForConsection: conSection];
            
            NSString *expectedStartTime = [self getExpectedDepartureTimeForConsection: conSection];
            NSString *expectedEndTime = [self getExpectedArrivalTimeForConsection: conSection];
            NSString *expectedDepPlatform = [self getExpectedDeparturePlatformForConsection: conSection];
            NSString *expectedArrPlatform = [self getExpectedArrivalPlatformForConsection: conSection];
            
            NSString *expectedStartInfo = @"";
            NSString *expectedEndInfo = @"";
            
            if (expectedStartTime) {
                expectedStartInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Expected:", @"SBBAPIController expected text"), expectedStartTime];
            }
            
            if (expectedEndTime) {
                expectedEndInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Expected:", @"SBBAPIController expected text"), expectedEndTime];
            }
            
            if (expectedDepPlatform) {
                expectedStartInfo = [NSString stringWithFormat: @"\n%@ / %@ %@", expectedStartInfo,  NSLocalizedString(@"Track:", @"SBBAPIController track text"), expectedDepPlatform];
            }
            
            if (expectedArrPlatform) {
                expectedEndInfo = [NSString stringWithFormat: @"\n%@ / %@ %@", expectedEndInfo,  NSLocalizedString(@"Track:", @"SBBAPIController track text"), expectedArrPlatform];
            }
            
            NSNumber *capacity1st = [self getCapacity1stForConsection: conSection];
            NSNumber *capacity2nd = [self getCapacity2ndForConsection: conSection];
            
            NSString *capacityInfo = @"";
            if (capacity1st && capacity2nd) {
                capacityInfo = [NSString stringWithFormat: @"\n\n%@ 1. %d / 2. %d", NSLocalizedString(@"Capacity:", @"SBBAPIController capacity text"), [capacity1st integerValue], [capacity2nd integerValue]];
            }
            
            NSString *journeyText = [NSString stringWithFormat: @"--------\n%@%@\n\n%@ %@ %@%@%@\n\n%@ %@ %@ %@%@%@\n", transportName, journeyDirectionInfo, NSLocalizedString(@"From:", @"SBBAPIController from station text"), departureTime, startStationName, startTrackInfo, expectedStartInfo, NSLocalizedString(@"To:", @"SBBAPIController to station text"), arrivalTime, endStationName, endTrackInfo, expectedEndInfo, capacityInfo];
            
            return journeyText;
        }
    }
    return nil;
}

- (NSString *) getPlaintextSharetextOfConnectionInfosForConnectionResultWithIndex:(NSUInteger)index {
    //NSLog(@"getPlaintextSharetextOfConnectionInfosForConnectionResultWithIndex: %d", index);
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    if ([[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList]) {
                        if ([[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] count] > 0) {
                            
                            //NSLog(@"getPlaintextSharetextOfConnectionInfosForConnectionResultWithIndex. 0");
                            
                            NSMutableString *connectionInfoText = [NSMutableString stringWithCapacity:1];
                            
                            //NSLog(@"getPlaintextSharetextOfConnectionInfosForConnectionResultWithIndex. 1");
                            
                            [connectionInfoText appendString: @"-----------------------------------------\n"];
                            
                            //NSLog(@"getPlaintextSharetextOfConnectionInfosForConnectionResultWithIndex. 2");
                            
                            for (ConnectionInfo *currentConnectionInfo in [[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList]) {
                                NSString *connectionInfoString = [NSString stringWithFormat: @"%@\n-----\n", currentConnectionInfo.text];
                                
                                //NSLog(@"getPlaintextSharetextOfConnectionInfosForConnectionResultWithIndex. 3");
                                
                                if (connectionInfoString) {
                                    [connectionInfoText appendString: connectionInfoString];
                                }
                            }
                            [connectionInfoText appendString: @"-----------------------------------------\n"];
                            return connectionInfoText;
                        }
                    }
                }
            }
        }
    }
    return  nil;
}

- (NSString *) getShortPlaintextTitleForConnectionResultWithIndex:(NSUInteger)index {
    //NSLog(@"getShortPlaintextTitleForConnectionResultWithIndex: %d", index);
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    ConOverview *overView = [[[self.connectionsResult conResults] objectAtIndex: index] overView];
                    NSString *startStationName = [self getDepartureStationNameForOverview: overView];
                    NSString *endStationName = [self getArrivalStationNameForOverview: overView];
                    NSString *titleText = [NSString stringWithFormat: @"%@ - %@", startStationName, endStationName];
                    return titleText;
                }
            }
        }
    }
    return  nil;

}

- (NSString *) getPlaintextSharetextForConnectionResultWithIndex:(NSUInteger)index {
    //NSLog(@"getPlaintextSharetextForConnectionResultWithIndex: %d", index);
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    NSMutableString *connectionInfoText = [NSMutableString stringWithCapacity:1];
                    NSString *overviewText = [self getPlaintextSharetextOfOverviewForConnectionResultWithIndex: index];
                    
                    //NSLog(@"getPlaintextSharetextForConnectionResultWithIndex. Overview done. %@", overviewText);
                    
                    [connectionInfoText appendString: NSLocalizedString(@"Overview:\n", @"SBBAPIController overview title")];
                    [connectionInfoText appendString: overviewText];
                    
                    [connectionInfoText appendString: NSLocalizedString(@"\n\nDetails:\n---------------------------------", @"SBBAPIController details title")];
                    for (ConSection *currentConSection in [[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList] conSections]) {
                        NSString *currentConSectionString = [self getPlaintextSharetextForConsection: currentConSection];
                        
                        //NSLog(@"getPlaintextSharetextForConnectionResultWithIndex. Consections done. %@", currentConSectionString);
                        
                        [connectionInfoText appendString: currentConSectionString];
                    }
                    
                    //NSLog(@"getPlaintextSharetextForConnectionResultWithIndex. Consections done.");
                    
                    NSString *connectionInfoString = [self getPlaintextSharetextOfConnectionInfosForConnectionResultWithIndex: index];
                    
                    //NSLog(@"ConnectionInfoText: %@", connectionInfoString);
                    
                    if (connectionInfoString) {
                        [connectionInfoText appendString: connectionInfoString];
                    }
                    
                    [connectionInfoText appendString: @"\n-----------------------------------------"];
                    return connectionInfoText;
                }
            }
        }
    }
    return  nil;
}

- (NSString *) getHtmlTransportImageNameWithConsection:(ConSection *)conSection {
    
    NSString *transportImageName = nil;
    if ([conSection conSectionType] == walkType) {
        transportImageName = @"transportimagewalk";
        return transportImageName;
    } else if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        NSString *transportName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportName];
        if (transportType == transportUnknown) {
            transportImageName = @"transportimagetrain";
        } else if (transportType == transportFastTrain) {
            transportImageName = @"transportimagetrainfast";
        } else if (transportType == transportSlowTrain) {
            transportImageName = @"transportimagetrain";
        } else if (transportType == transportTram) {
            transportImageName = @"transportimagetram";
        } else if (transportType == transportBus) {
            transportImageName = @"transportimagebus";
        } else if (transportType == transportShip) {
            transportImageName = @"transportimageship";
        } else if (transportType == transportFuni) {
            transportImageName = @"transportimagefuni";
        }
        return transportImageName;
    }
    return @"transportimagetrain";
}

- (NSString *) getHtmlSharetextForConsection:(ConSection *)conSection {
    //NSLog(@"getPlaintextSharetextForConsection");
    if (conSection) {
        NSString *startStationName = [self getDepartureStationNameForConsection: conSection];
        NSString *endStationName = [self getArrivalStationNameForConsection: conSection];
        NSString *departureTime = [self getDepartureTimeForConsection: conSection];
        NSString *arrivalTime = [self getArrivalTimeForConsection: conSection];
        
        NSString *journey_html_file = [[NSBundle mainBundle] pathForResource:@"Consec_jrn_html" ofType:@"html"];
        NSString *walk_html_file = [[NSBundle mainBundle] pathForResource:@"Consec_wal_html" ofType:@"html"];
        NSString *journey_html_block = [NSString stringWithContentsOfFile:journey_html_file encoding:NSUTF8StringEncoding error: NULL];
        NSString *walk_html_block = [NSString stringWithContentsOfFile:walk_html_file encoding:NSUTF8StringEncoding error: NULL];
        
        NSUInteger journeyTypeFlag = [conSection conSectionType];
        
        if (journeyTypeFlag == walkType) {
            NSString *walkDurationInfo = [[conSection walk] getFormattedDurationStringFromDuration];
            NSString *walkDistanceInfo = [NSString stringWithFormat:@"%@", [[conSection walk] getFormattedMetresStringFromDistance]];
            NSString *walkInfo = [NSString stringWithFormat:@"%@ / %@", walkDurationInfo, walkDistanceInfo];
            
            NSString *walkstringtitle = NSLocalizedString(@"Walk:", @"SBBAPIController walk journey text");
            walkstringtitle = [walkstringtitle substringToIndex:[walkstringtitle length] - 1];
            walk_html_block = [walk_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTNAME" withString:[walkstringtitle uppercaseString]];
            
            walk_html_block = [walk_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORT_WALK_TIME_DIST" withString:walkInfo];
            
            walk_html_block = [walk_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_START_STATION" withString:startStationName];
            walk_html_block = [walk_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_END_STATION" withString:endStationName];
            
            walk_html_block = [walk_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_START_TIME" withString:departureTime];
            walk_html_block = [walk_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_END_TIME" withString:arrivalTime];
            
            return walk_html_block;
        } else if ([conSection conSectionType] == journeyType) {
            NSString *transportName = [self getTransportNameWithConsection: conSection];
            NSString *journeyDirectionString = [[conSection journey] journeyDirection];
            
            NSString *journeyDirectionInfo = @"";
            if (journeyDirectionString) {
                journeyDirectionInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Direction:", @"SBBAPIController direction text"), journeyDirectionString];
            }
            
            NSString *startTrack = [self getDeparturePlatformForConsection: conSection];
            NSString *endTrack = [self getArrivalPlatformForConsection: conSection];
            
            
            NSString *startTrackInfo = @"";
            NSString *endTrackInfo = @"";
            if (startTrack && ([startTrack length] > 0)) {
                startTrackInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Track:", @"SBBAPIController track text"), startTrack];
            }
            if (endTrack && ([endTrack length] > 0)) {
                endTrackInfo = [NSString stringWithFormat: @"\n%@ %@", NSLocalizedString(@"Track:", @"SBBAPIController track text"), endTrack];
            }
            
            //BOOL journeyIsDelayed = [self isJourneyDelayedForConsection: conSection];
            
            NSString *expectedStartTime = [self getExpectedDepartureTimeForConsection: conSection];
            NSString *expectedEndTime = [self getExpectedArrivalTimeForConsection: conSection];
            NSString *expectedDepPlatform = [self getExpectedDeparturePlatformForConsection: conSection];
            NSString *expectedArrPlatform = [self getExpectedArrivalPlatformForConsection: conSection];
            
            //NSString *expectedStartInfo = @"";
            //NSString *expectedEndInfo = @"";
            
            if (!expectedStartTime || [expectedStartTime isEqualToString:@"(null)"]) {
                expectedStartTime = @"";
            } else {
                expectedStartTime = [NSString stringWithFormat: @"(%@)", expectedStartTime];
            }
            
            if (!expectedEndTime || [expectedEndTime isEqualToString:@"(null)"]) {
                expectedEndTime = @"";
            } else {
                expectedEndTime = [NSString stringWithFormat: @"(%@)", expectedEndTime];
            }
            
            if (!expectedDepPlatform || [expectedDepPlatform isEqualToString:@"(null)"]) {
                expectedDepPlatform = @"";
            } else {
                expectedDepPlatform = [NSString stringWithFormat: @"(%@)", expectedDepPlatform];
            }
            
            if (!expectedArrPlatform || [expectedArrPlatform isEqualToString:@"(null)"]) {
                expectedArrPlatform = @"";
            } else {
                expectedArrPlatform = [NSString stringWithFormat: @"(%@)", expectedArrPlatform];
            }
            
            NSNumber *capacity1st = [self getCapacity1stForConsection: conSection];
            NSNumber *capacity2nd = [self getCapacity2ndForConsection: conSection];
            
            NSString *htmltansportimage = [self getHtmlTransportImageNameWithConsection:conSection];
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTIMAGE_TYPE" withString:htmltansportimage];
            
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTNAME" withString:transportName];
            
            if (capacity1st && capacity2nd) {                
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY1_TEXT" withString:@"1."];
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY2_TEXT" withString:@"2."];
                
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY1_TYPE" withString:[NSString stringWithFormat:@"capacityimage%@", capacity1st]];
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY2_TYPE" withString:[NSString stringWithFormat:@"capacityimage%@", capacity2nd]];
            } else {
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY1_TEXT" withString:@""];
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY2_TEXT" withString:@""];
                
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY1_TYPE" withString:@""];
                journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY2_TYPE" withString:@""];
            }
            
            
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY1_TYPE" withString:[NSString stringWithFormat:@"capacityimage%@", capacity1st]];
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTCAPACITY2_TYPE" withString:[NSString stringWithFormat:@"capacityimage%@", capacity2nd]];
            
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_TRANSPORTDIRECTION" withString:journeyDirectionInfo];

            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_START_STATION" withString:startStationName];
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_END_STATION" withString:endStationName];
            
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_START_TIME" withString:departureTime];
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_END_TIME" withString:arrivalTime];
            
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_START_TRACK" withString:startTrack];
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_END_TRACK" withString:endTrack];
            
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_EXP_START_TIME" withString:expectedStartTime];
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_EXP_END_TIME" withString:expectedEndTime];
            
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_EXP_START_TRACK" withString:expectedDepPlatform];
            journey_html_block = [journey_html_block stringByReplacingOccurrencesOfString: @"CONSECTION_EXP_END_TRACK" withString:expectedArrPlatform];
                        
            return journey_html_block;
        }
    }
    return nil;
}

- (NSString *) getHtmlSharetextForConnectionResultWithIndex:(NSUInteger)index {
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            int conResultsCount = [[self.connectionsResult conResults] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    
                    NSString *body_html_file = [[NSBundle mainBundle] pathForResource:@"Conres_html_body" ofType:@"html"];
                    NSString *body_html_block = [NSString stringWithContentsOfFile:body_html_file encoding:NSUTF8StringEncoding error: NULL];
                    
                    NSString *titleText = [self getShortPlaintextTitleForConnectionResultWithIndex:index];
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"OVERVIEW_TITLE_TEXT" withString:titleText];
                    
                    ConOverview *overView = [[[self.connectionsResult conResults] objectAtIndex: index] overView];
                    ConSection *conSection = [self getConsectionForConnectionResultWithIndexAndConsectionIndex: index consectionIndex: 0];
                    NSString *departureTime = [self getDepartureTimeForConsection: conSection];
                    NSString *arrivalTime = [self getArrivalTimeForOverview: overView];
                    NSString *transfers = [overView transfers];
                    NSString *startStationName = [self getDepartureStationNameForOverview: overView];
                    NSString *endStationName = [self getArrivalStationNameForOverview: overView];
                    
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"OVERVIEW_START_STATION" withString:startStationName];
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"OVERVIEW_END_STATION" withString:endStationName];
                    
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"OVERVIEW_START_TIME" withString:departureTime];
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"OVERVIEW_END_TIME" withString:arrivalTime];
                    
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"OVERVIEW_CHANGES" withString:transfers];
                            
                    //NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overView];
                    NSDate *connectionDate = [[SBBAPIController sharedSBBAPIController] getConnectionDateForConnectionResultWithIndex: index];
                    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
                    [timeFormatter setDateFormat:@"dd/MM/yyyy"];
                    NSString *overviewConnectionDateString = [timeFormatter stringFromDate: connectionDate];
                    
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"OVERVIEW_DATE" withString:overviewConnectionDateString];
                    
                    NSMutableString *consectionsText = [NSMutableString stringWithCapacity:1];
                    for (ConSection *currentConSection in [[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList] conSections]) {
                        NSString *currentConSectionString = [self getHtmlSharetextForConsection: currentConSection];
                        [consectionsText appendString: currentConSectionString];
                    }
                    
                    body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"CONSECTIONS_HTML" withString:consectionsText];

                    if ([[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList]) {
                                                
                        if ([[[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList] count] > 0) {
                                                        
                            NSMutableString *connectionInfoText = [NSMutableString stringWithCapacity:1];
                        
                            for (ConnectionInfo *currentConnectionInfo in [[[self.connectionsResult conResults] objectAtIndex: index] connectionInfoList]) {
                                NSString *connectionInfoString = [NSString stringWithFormat: @"<p>%@</p>", currentConnectionInfo.text];
                                                                
                                if (connectionInfoString) {
                                    [connectionInfoText appendString: connectionInfoString];
                                }
                            }
                            body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"DESCRIPTION_HTML" withString:connectionInfoText];
                        } else {
                            body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"DESCRIPTION_HTML" withString:@""];
                        }
                    } else {
                         body_html_block = [body_html_block stringByReplacingOccurrencesOfString: @"DESCRIPTION_HTML" withString:@""];
                    }
                    return body_html_block;
                }
            }
        }
    }
    return  nil;
}


-  (NSString *) getArrivalTimeForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection arrival] arr] getFormattedTimeStringFromTime];
    }
    return nil;
}

-  (NSString *) getDepartureTimeForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection departure] dep] getFormattedTimeStringFromTime];
    }
    return nil;
}

-  (NSString *) getExpectedArrivalTimeForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection arrival] arr] getFormattedExpectedTimeStringFromTime];
    }
    return nil;
}

-  (NSString *) getExpectedDepartureTimeForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection departure] dep] getFormattedExpectedTimeStringFromTime];
    }
    return nil;
}

-  (NSString *) getArrivalStationNameForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        //NSLog(@"getArrivalStationNameForConsection: %@", [[[conSection arrival] station] stationName]);
        if ([[[[conSection arrival] station] stationName] isEqualToString: @"unknown"]) {
            return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");
        }
        return [[[conSection arrival] station] stationName];
    }
    return nil;
}

-  (NSString *) getDepartureStationNameForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        //NSLog(@"getDepartureStationNameForConsection: %@", [[[conSection departure] station] stationName]);
        if ([[[[conSection departure] station] stationName] isEqualToString: @"unknown"]) {
            return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");
        }
        return [[[conSection departure] station] stationName];
    }
    return nil;
}

-  (NSString *) getArrivalPlatformForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection arrival] arr] platform];
    }
    return nil;
}

-  (NSString *) getDeparturePlatformForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection departure] dep] platform];
    }
    return nil;
}

-  (NSString *) getExpectedArrivalPlatformForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection arrival] arr] expectedPlatform];
    }
    return nil;
}

-  (NSString *) getExpectedDeparturePlatformForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        return [[[conSection departure] dep] expectedPlatform];
    }
    return nil;
}

-  (BOOL) isJourneyDelayedForConsection:(ConSection *)conSection {
    //NSString *resultString = nil;
    if (conSection) {
        if ([conSection conSectionType] == journeyType) {
            if ([conSection journey]) {
                return [[conSection journey] journeyIsDelayed];
            }
        }
    }
    return NO;
}

-  (MKMapItem *) getArrivalMapItemForConsection:(ConSection *)conSection {
    if (conSection) {
        Station *arrivalStation = [[conSection arrival] station];
        if (arrivalStation) {
            NSDictionary *addressDict = @{
            (NSString *) kABPersonAddressCountryKey : @"CH"
            };
            CLLocationCoordinate2D arrivalCoordinate;
            arrivalCoordinate.latitude = [arrivalStation.latitude floatValue];
            arrivalCoordinate.longitude = [arrivalStation.longitude floatValue];
            
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:arrivalCoordinate addressDictionary:addressDict];
            
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            mapItem.name = [arrivalStation stationName];
            return mapItem;
        }
    }
    return nil;
}

-  (MKMapItem *) getDepartureMapItemNameForConsection:(ConSection *)conSection {
    if (conSection) {
        Station *departureStation = [[conSection departure] station];
        if (departureStation) {
            NSDictionary *addressDict = @{
            (NSString *) kABPersonAddressCountryKey : @"CH"
            };
            CLLocationCoordinate2D departureCoordinate;
            departureCoordinate.latitude = [departureStation.latitude floatValue];
            departureCoordinate.longitude = [departureStation.longitude floatValue];
            
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:departureCoordinate addressDictionary:addressDict];
            
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            mapItem.name = [departureStation stationName];
            return mapItem;
        }
    }
    return nil;
}

-  (NSNumber *) getCapacity1stForConsection:(ConSection *)conSection {
    if (conSection) {
        return [[conSection departure] capacity1st];
    }
    return nil;
}

-  (NSNumber *) getCapacity2ndForConsection:(ConSection *)conSection {
    if (conSection) {
        return [[conSection departure] capacity2nd];
    }
    return nil;
}

- (NSUInteger) getTransportTypeCodeForTransportCategoryType:(NSString *)transportCategoryType {
    if ([transportCategoryType isEqualToString: @"IR"]) {           // Fast trains...
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"ICE"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"IC"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"ICN"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"EC"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"RJ"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"TGV"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"EN"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"CNL"]) {
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"EXT"]) {   // Extra train
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"ARZ"]) {   // ???
        return transportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"S"]) {
        return transportSlowTrain;
    } else if ([transportCategoryType isEqualToString: @"RE"]) {    // Regional trains...
        return transportSlowTrain;
    } else if ([transportCategoryType isEqualToString: @"R"]) {
        return transportSlowTrain;
    } else if ([transportCategoryType isEqualToString: @"BAT"]) {   // Ship...
        return transportShip;
    } else if ([transportCategoryType isEqualToString: @"BUS"]) {   // Bus...
        return transportBus;
    } else if ([transportCategoryType isEqualToString: @"TRAM"]) {  // Tram...
        return transportTram;
    } else if ([transportCategoryType isEqualToString: @"FUN"]) {   //Funiculaire...
        return transportFuni;
    } else if ([transportCategoryType isEqualToString: @"TRO"]) {   //Trolley
        return transportBus;
    } else if ([transportCategoryType isEqualToString: @"MET"]) {   //Metro
        return transportTram;
    } else if ([transportCategoryType isEqualToString: @"T"]) {   //Metro
        return transportTram;
    } else if ([transportCategoryType isEqualToString: @"NFT"]) {   //Metro
        return transportTram;
    } else if ([transportCategoryType isEqualToString: @"NFB"]) {   //Metro
        return transportBus;
    } else if ([transportCategoryType isEqualToString: @"NFO"]) {   //Metro
        return transportBus;
    }
    
    return transportUnknown;
}

/*
- (UIColor *) colorForSBBTransportCategoryType:(NSString *)transportCategoryType {
    NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportCategoryType];
    if (transportType == transportUnknown) {
        return [UIColor darkGrayColor];
    } else if (transportType == transportFastTrain) {
        return [UIColor colorWithHexString: @"EE1D23"];
    } else if (transportType == transportSlowTrain) {
        return [UIColor whiteColor];
    } else if (transportType == transportTram) {
        return [UIColor whiteColor];
    } else if (transportType == transportBus) {
        return [UIColor whiteColor];
    } else if (transportType == transportShip) {
        return [UIColor whiteColor];
    }
    return [UIColor darkGrayColor];
}
*/

- (UIColor *) colorForSBBTransportCategoryType:(NSString *)transportCategoryType {
    NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportCategoryType];
    if (transportType == transportUnknown) {
        return [UIColor darkGrayColor];
    } else if (transportType == transportFastTrain) {
        return [UIColor colorWithHexString: @"EE1D23"];
    } else if (transportType == transportSlowTrain) {
        return [UIColor darkGrayColor];
    } else if (transportType == transportTram) {
        return [UIColor darkGrayColor];
    } else if (transportType == transportBus) {
        return [UIColor darkGrayColor];
    } else if (transportType == transportShip) {
        return [UIColor darkGrayColor];
    } else if (transportType == transportFuni) {
        return [UIColor darkGrayColor];
    }
    return [UIColor darkGrayColor];
}

- (UIColor *) colorForBVBLineNumber:(NSUInteger)lineNumber {
    NSString *hexColorCode = @"C7C8CA";
    switch (lineNumber) {
        case 2:
            hexColorCode = @"A68352";
            break;
        case 3:
            hexColorCode = @"344EA1";
            break;
        case 6:
            hexColorCode = @"0072BC";
            break;
        case 8:
            hexColorCode = @"F172AC";
            break;
        case 10:
            hexColorCode = @"FECA0A";
            break;
        case 11:
            hexColorCode = @"EE1D23";
            break;
        case 14:
            hexColorCode = @"F58220";
            break;
        case 15:
            hexColorCode = @"00A54F";
            break;
        case 16:
            hexColorCode = @"A6CE39";
            break;
        case 17:
            hexColorCode = @"00AEEF";
            break;
        case 21:
            hexColorCode = @"00AE9D";
            break;
        case 1:
            hexColorCode = @"835237";
            break;
        default:
            hexColorCode = @"C7C8CA";
    }
    
    return [UIColor colorWithHexString:hexColorCode];
}

- (UIColor *) colorForVBLLineNumber:(NSUInteger)lineNumber {
    NSString *hexColorCode = @"C8D1DC";
    switch (lineNumber) {
        case 6:
        case 10:
        case 16:
            hexColorCode = @"C95632";
            break;
        case 8:
        case 11:
        case 19:
            hexColorCode = @"FDCA31";
            break;
        case 20:
        case 21:
        case 22:
        case 23:
        case 24:
            hexColorCode = @"679ACF";
            break;
        case 2:
        case 7:
        case 18:
        case 25:
        case 26:
            hexColorCode = @"EB212D";
            break;
        case 1:
        case 4:
        case 9:
        case 12:
        case 14:
        case 15:
        case 27:
        case 31:
            hexColorCode = @"17A453";
            break;
        default:
            hexColorCode = @"ACCADD";
    }
    
    return [UIColor colorWithHexString:hexColorCode];
}

- (UIColor *) colorForBLTLineNumber:(NSUInteger)lineNumber {
    return [UIColor whiteColor];
}

- (UIColor *) colorForVBZLineNumber:(NSUInteger)lineNumber {
    NSString *hexColorCode = @"ACCADD";
    switch (lineNumber) {
        case 5:
            hexColorCode = @"946237";
            break;
        case 6:
            hexColorCode = @"D99E4E";
            break;
        case 7:
            hexColorCode = @"231F20";
            break;
        case 8:
            hexColorCode = @"A6CE39";
            break;
        case 4:
        case 9:
            hexColorCode = @"48479D";
            break;
        case 10:
           hexColorCode = @"D04186";
            break;
        case 3:
        case 11:
            hexColorCode = @"00AB4D";
            break;
        case 12:
            hexColorCode = @"78D0E2";
            break;
        case 13:
            hexColorCode = @"FED304";
            break;
        case 14:
            hexColorCode = @"00AEEF";
            break;
        case 17:
            hexColorCode = @"A1276F";
            break;
        case 2:
        case 15:
            hexColorCode = @"EE1D23";
            break;
        default:
            hexColorCode = @"ACCADD";
    }

    return [UIColor colorWithHexString:hexColorCode];
}

- (NSString *)getTransportOperatorForConsection:(ConSection *)conSection {
    
    if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        NSString *transportOperator = [[[journey journeyOperator] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        if (transportOperator && [transportOperator length] > 0) {
            return transportOperator;
        } else {
            NSString *transportAdministration = [[[journey journeyAdministration] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if (transportAdministration && [transportAdministration length] > 0) {
                if ([transportAdministration isEqualToString:@"000849"] || [transportAdministration isEqualToString:@"000773"]) {
                    return @"VBZ";
                }
                if ([transportAdministration isEqualToString:@"000820"] || [transportAdministration isEqualToString:@"000812"] || [transportAdministration isEqualToString:@"000819"]) {
                    return @"VBL";
                }
                if ([transportAdministration isEqualToString:@"000823"] || [transportAdministration isEqualToString:@"000037"]) {
                    return @"BVB";
                }
                /*
                if ([transportAdministration isEqualToString:@"000011"]) {
                    return @"SBB";
                }
                */
            }
            
        }
    }
    return nil;
}

- (UIColor *) getTransportColorWithConsection:(ConSection *)conSection {
    
    NSString *stringColorCode = nil;
    if ([conSection conSectionType] == walkType) {
        stringColorCode = @"Walking.png";
        
        //NSLog(@"SBBAPIController getTransportImageNameWithConsection: WALKTYPE");
        
        return [UIColor lightGrayColor];
    } else if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        
        //NSString *transportCategoryCode = [journey journeyCategoryCode];
        NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *transportOperator = [self getTransportOperatorForConsection: conSection];
        //NSString *transportAdministration = [[[journey journeyAdministration] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        //NSString *transportName = [[[journey journeyName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *transportNumber = [[[journey journeyNumber] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"SBBAPIController getTransportImageNameWithConsection:%@,%@,%@,%@,%@,%@.", transportName, transportCategoryCode, transportCategoryName, transportOperator, transportAdministration, transportNumber);
        //NSLog(@"SBBAPIController getTransportImageNameWithConsection:%@,%@,%@,%@,%@.", transportName, transportCategoryCode, transportCategoryName, transportOperator, transportNumber);
        
        if (transportOperator) {
            if ([transportOperator isEqualToString: @"VBZ"]) {
                if (transportNumber) {
                    NSUInteger lineNumber = [transportNumber integerValue];
                    if (lineNumber > 0) {
                        UIColor *vbzColor = [self colorForVBZLineNumber: lineNumber];
                        return vbzColor;
                    }
                }
            } else if ([transportOperator isEqualToString: @"VBL"]) {
                if (transportNumber) {
                    NSUInteger lineNumber = [transportNumber integerValue];
                    if (lineNumber > 0) {
                        UIColor *vblColor = [self colorForVBLLineNumber: lineNumber];
                        return vblColor;
                    }
                }
            } else if ([transportOperator isEqualToString: @"BVB"]) {
                if (transportNumber) {
                    NSUInteger lineNumber = [transportNumber integerValue];
                    if (lineNumber > 0) {
                        UIColor *bvbColor = [self colorForBVBLineNumber: lineNumber];
                        return bvbColor;
                    }
                }
            }
        } else {
            if (transportCategoryName) {
                return [self colorForSBBTransportCategoryType: transportCategoryName];
            }
        }
    }
    
    //NSLog(@"Color: %@", [[UIColor blueColor] hexStringFromColor]);
    
    return [UIColor darkGrayColor];
}

- (NSString *) getTransportNameWithConsection:(ConSection *)conSection {
    NSString *transportName = nil;
    if ([conSection conSectionType] == walkType) {
        transportName = @"WALK";
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection: WALKTYPE");
        
        return transportName;
    } else if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        NSString *transportName = [journey journeyName];
        
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        //NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"Journey name codes: %@, %@", categoryCode, transportCategoryName);
        
        if ([categoryCode integerValue] == 6 || [categoryCode integerValue] == 9) {
            if (transportName && [transportName length] >= 2) {
                NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if (splitname && splitname.count > 1) {
                    NSString *shortname = [splitname objectAtIndex: 0];
                    if ([shortname isEqualToString: @"T"]) {
                        shortname = @"Tram";
                    }
                    if ([shortname isEqualToString: @"NFT"]) {
                        shortname = @"Tram";
                    }
                    if ([shortname isEqualToString: @"TRO"]) {
                        shortname = @"Bus";
                    }
                    if ([shortname isEqualToString: @"NFB"]) {
                        shortname = @"Bus";
                    }
                    if ([shortname isEqualToString: @"NFO"]) {
                        shortname = @"Bus";
                    }
                    NSString *transportnamenew = [NSString stringWithFormat:@"%@ %@", shortname, [splitname objectAtIndex: 1]];
                    return transportnamenew;
                }
            }
        }
                
        // T, NFT, NFB, NFO, TRO,
        // Tram, Niederflurtram, Niederflurbus, X, Trolley
        
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection:%@.", transportName);
        
        return transportName;
    }
    return nil;
}

- (NSString *) getSimplifiedTransportNameWithConsection:(ConSection *)conSection {
    NSString *transportName = nil;
    if ([conSection conSectionType] == walkType) {
        transportName = @"WALK";
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection: WALKTYPE");
        
        return transportName;
    } else if ([conSection conSectionType] == journeyType) {
        //Journey *journey = [conSection journey];
        //NSString *transportName = [[journey journeyName] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *transportName = [[self getTransportNameWithConsection: conSection] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection:%@.", transportName);
        
        if (transportName && [transportName length] >= 2) {
            NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if (splitname && splitname.count > 1) {
                return [splitname objectAtIndex: 0];
            }
            return [transportName substringToIndex: 2];
        }
        return transportName;
    }
    return nil;
}

- (NSString *) getTransportImageNameWithConsection:(ConSection *)conSection {
    
    NSString *transportImageName = nil;
    if ([conSection conSectionType] == walkType) {
        transportImageName = @"Walking.png";
        
        //NSLog(@"SBBAPIController getTransportImageNameWithConsection: WALKTYPE");
        
        return transportImageName;
    } else if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        //NSString *transportCode = [journey journeyCategoryCode];
        NSString *transportName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"SBBAPIController getTransportImageNameWithConsection:%@,%@.", transportCode, transportName);
        
        NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportName];
        if (transportType == transportUnknown) {
            transportImageName = @"Train.png";
        } else if (transportType == transportFastTrain) {
            transportImageName = @"TrainFast.png";
        } else if (transportType == transportSlowTrain) {
            transportImageName = @"Train.png";
        } else if (transportType == transportTram) {
            transportImageName = @"Tram.png";
        } else if (transportType == transportBus) {
            transportImageName = @"Bus.png";
        } else if (transportType == transportShip) {
            transportImageName = @"Ship.png";
        } else if (transportType == transportFuni) {
            transportImageName = @"Funi.png";
        }
        return transportImageName;
    }
    return @"Train.png";
}


- (UIImage *) getImageWithTrainImageForConsectionWithFrame:(ConSection *)conSection {
    
    UIImage *transportTypeImage = nil;
    if ([conSection conSectionType] == walkType) {
        
        //NSLog(@"SBBAPIController getImageWithTrainImageForConsectionWithFrame: WALKTYPE");
        
        return [UIImage journeyTransportWalkImage];
    } else if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        //NSString *transportCode = [journey journeyCategoryCode];
        NSString *transportName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"SBBAPIController getImageWithTrainImageForConsectionWithFramen:%@,%@.", transportCode, transportName);
        
        NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportName];
        if (transportType == transportUnknown) {
            transportTypeImage = [UIImage journeyTransportTrainImage];
        } else if (transportType == transportFastTrain) {
            transportTypeImage = [UIImage journeyTransportTrainFastImage];
        } else if (transportType == transportSlowTrain) {
            transportTypeImage = [UIImage journeyTransportTrainImage];
        } else if (transportType == transportTram) {
            transportTypeImage = [UIImage journeyTransportTramImage];
        } else if (transportType == transportBus) {
            transportTypeImage = [UIImage journeyTransportBusImage];
        } else if (transportType == transportShip) {
            transportTypeImage = [UIImage journeyTransportShipImage];
        } else if (transportType == transportFuni) {
            transportTypeImage = [UIImage journeyTransportFuniImage];
        }
        return transportTypeImage;
    }
    return [UIImage journeyTransportTrainImage];
}

- (UIImage *) renderTransportTypeImageForConsection:(ConSection *)conSection {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(30, 30);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    CGSize typeImageSize = CGSizeMake(imageSize.width * scaleFactor, imageSize.height * scaleFactor);
    
    UIImage *transportTypeImage = [self getImageWithTrainImageForConsectionWithFrame: conSection];
    UIImage *transportTypeImageResized = [transportTypeImage resizedImage: typeImageSize interpolationQuality: kCGInterpolationDefault];
    UIImage *transportTypeImageColored = [UIImage newImageFromMaskImage: transportTypeImageResized inColor: [UIColor detailTableViewCellJourneyInfoImageColor]];
    
    CGContextSaveGState(ctx);
    
    CGRect circleRect = CGRectMake(0, 0,
                                   imageSize.width,
                                   imageSize.height);
    
    
    
    CGContextSetFillColorWithColor(ctx, [UIColor detailTableViewCellJourneyInfoImageBackgroundColor].CGColor);
    CGContextFillEllipseInRect(ctx, circleRect);
    
    CGPoint imageStartingPoint = CGPointMake(5, 5);
    
    CGContextDrawImage(ctx, CGRectMake(imageStartingPoint.x, imageStartingPoint.y, imageSize.width - 10, imageSize.height - 10), [transportTypeImageColored CGImage]);
    /*
    UIGraphicsPushContext(ctx);
    CGContextTranslateCTM(ctx, 0.0f, imageSize.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
	[transportTypeImageColored drawAtPoint:imageStartingPoint];
    UIGraphicsPopContext();
    */    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
    
    /*
    
    
    
    
    CGSize imageSize = CGSizeMake(90, 90);
    
	UIGraphicsBeginImageContext(imageSize);
    
    UIImage *transportTypeImage = [self getImageWithTrainImageForConsectionWithFrame: conSection];
    UIImage *transportTypeImageColored = [UIImage newImageFromMaskImage: transportTypeImage inColor: [UIColor detailTableViewCellJourneyInfoImageColor]];
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	CGRect circleRect = CGRectMake(0, 0,
                                   imageSize.width,
                                   imageSize.height);

    CGContextSetFillColorWithColor(ctx, [UIColor detailTableViewCellJourneyInfoImageBackgroundColor].CGColor);    
    CGContextFillEllipseInRect(ctx, circleRect);
    
    CGPoint imageStartingPoint = CGPointMake(15, 15);
	[transportTypeImageColored drawAtPoint:imageStartingPoint];
    
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return retImage;
    */ 
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *) renderTransportNameImageForConsection:(ConSection *)conSection {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(80, 20);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                                 imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                                 8, imageSize.width * scaleFactor * 4, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
 
    
    CGRect bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIColor *transportColor = [self getTransportColorWithConsection: conSection];
    NSString *transportName = [self getTransportNameWithConsection: conSection];
    
    //NSLog(@"Name image color: %@", [transportColor hexStringFromColor]);
        
    CGContextSaveGState(ctx);
    
    addRoundedRectToPath(ctx, bounds, 5, 5);
    CGContextClip(ctx);
    
    CGContextSetFillColorWithColor(ctx, transportColor.CGColor);
    CGContextFillRect(ctx, bounds);
    
    UIColor *textColor;
    if ([transportColor isEqualToColor: [UIColor whiteColor]]) {
        textColor = [UIColor blackColor];
    } else {
        textColor = [UIColor whiteColor];
    }
    
    CGContextSetFillColorWithColor(ctx, textColor.CGColor);
    CGPoint textStartingPoint = CGPointMake(4, 1);
    
    UIGraphicsPushContext(ctx);
    
    CGContextSaveGState(ctx);
    CGAffineTransform save = CGContextGetTextMatrix(ctx);
    CGContextTranslateCTM(ctx, 0.0f, bounds.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    [transportName drawAtPoint: textStartingPoint withFont: [UIFont boldSystemFontOfSize: 15]];
    CGContextSetTextMatrix(ctx, save);
    CGContextRestoreGState(ctx);
    
    UIGraphicsPopContext();
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

- (UIImage *) renderTransportConnectionImageForConsection:(ConSection *)conSection size:(CGSize)size topLine:(BOOL)topLine bottomLine:(BOOL)bottomLine {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(size.width, size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
        
    UIColor *circleColor;
    UIColor *lineColor;
    UIColor *dashedLineColor = [UIColor lightGrayColor];
    if ([conSection conSectionType] == walkType) {
        circleColor = [UIColor detailTableViewCellChangeLineColor];
        lineColor = [UIColor detailTableViewCellChangeLineColor];
    } else {
        UIColor *transportColor = [self getTransportColorWithConsection: conSection];
        circleColor = transportColor;
        lineColor = transportColor;
        
        //circleColor = [UIColor detailTableViewCellJourneyLineColor];
        //lineColor = [UIColor detailTableViewCellJourneyLineColor];
    }
    
    CGFloat dotRadius = 2;
    CGFloat lengths[2];
    lengths[0] = 0;
    lengths[1] = dotRadius*4;
    
    if (bottomLine) {
        CGContextSaveGState(ctx);
        CGPoint startPointTop = CGPointMake(17.5, -10);
        CGPoint endPointTop = CGPointMake(17.5, 15);
        CGContextMoveToPoint(ctx, startPointTop.x, startPointTop.y);
        CGContextAddLineToPoint(ctx, endPointTop.x, endPointTop.y);
        CGContextSetStrokeColorWithColor(ctx, dashedLineColor.CGColor);
        CGContextSetLineWidth(ctx, 4.0f);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetLineDash(ctx, 0.0f, lengths, 2);
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    if (topLine) {
        CGContextSaveGState(ctx);
        CGPoint startPointBotton = CGPointMake(17.5, imageSize.height - 15);
        CGPoint endPointBottom = CGPointMake(17.5, imageSize.height + 10);
        CGContextMoveToPoint(ctx, startPointBotton.x, startPointBotton.y);
        CGContextAddLineToPoint(ctx, endPointBottom.x, endPointBottom.y);
        CGContextSetStrokeColorWithColor(ctx, dashedLineColor.CGColor);
        CGContextSetLineWidth(ctx, 4.0f);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetLineDash(ctx, 0.0f, lengths, 2);
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    CGContextSaveGState(ctx);
    CGPoint startPointMiddle = CGPointMake(17.5, 15 + 25);
    CGPoint endPointMiddle = CGPointMake(17.5, imageSize.height - 15 - 25);
    CGContextMoveToPoint(ctx, startPointMiddle.x, startPointMiddle.y);
    CGContextAddLineToPoint(ctx, endPointMiddle.x, endPointMiddle.y);
    CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
    CGContextSetLineWidth(ctx, 4.0f);
    if ([conSection conSectionType] == walkType) {
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetLineDash(ctx, 0.0f, lengths, 2);
    }
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    
    
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    CGRect outerTopCircle = {5, 15, 25, 25};
    CGRect outerTopMaskCircle  = CGRectInset(outerTopCircle, 4, 4);
    CGRect innerTopCircle = CGRectInset(outerTopCircle, 6, 6);
    
    UIBezierPath *outerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerTopCircle];
    
    [outerTopCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerTopMaskCircle]];
    outerTopCirclePath.usesEvenOddFillRule = YES;
    
    [circleColor set];
    [outerTopCirclePath fill];
    
    UIBezierPath *innerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerTopCircle];
    [[UIColor blackColor] set];
    [innerTopCirclePath fill];

    
    CGRect outerBottomCircle = {5, imageSize.height - 25 - 15, 25, 25};
    CGRect outerBottomMaskCircle  = CGRectInset(outerBottomCircle, 4, 4);
    CGRect innerBottomCircle = CGRectInset(outerBottomCircle, 6, 6);
    
    UIBezierPath *outerBottomCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerBottomCircle];
    
    [outerBottomCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerBottomMaskCircle]];
    outerBottomCirclePath.usesEvenOddFillRule = YES;
    
    [circleColor set];
    [outerBottomCirclePath fill];
    
    UIBezierPath *innerBottomCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerBottomCircle];
    [[UIColor blackColor] set];
    [innerBottomCirclePath fill];
    
    UIGraphicsPopContext();
    
    CGContextRestoreGState(ctx);
        
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

- (UIImage *) renderPasslistImageWithSize:(CGSize)size topLine:(BOOL)topLine bottomLine:(BOOL)bottomLine {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(size.width, size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    UIColor *circleColor;
    UIColor *lineColor;
    
    circleColor = [UIColor detailTableViewCellChangeLineColor];
    lineColor = [UIColor detailTableViewCellChangeLineColor];
    
    if (bottomLine) {
        CGContextSaveGState(ctx);
        CGPoint startPointTop = CGPointMake(imageSize.width/2, -5);
        CGPoint endPointTop = CGPointMake(imageSize.width/2, imageSize.height/2-25/2);
        CGContextMoveToPoint(ctx, startPointTop.x, startPointTop.y);
        CGContextAddLineToPoint(ctx, endPointTop.x, endPointTop.y);
        CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
        CGContextSetLineWidth(ctx, 4.0f);
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    if (topLine) {
        CGContextSaveGState(ctx);
        CGPoint startPointBotton = CGPointMake(imageSize.width/2, imageSize.height/2+25/2);
        CGPoint endPointBottom = CGPointMake(imageSize.width/2, imageSize.height + 5);
        CGContextMoveToPoint(ctx, startPointBotton.x, startPointBotton.y);
        CGContextAddLineToPoint(ctx, endPointBottom.x, endPointBottom.y);
        CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
        CGContextSetLineWidth(ctx, 4.0f);
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }

    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    CGRect outerTopCircle = {imageSize.width/2 - 25/2, imageSize.height/2-25/2, 25, 25};
    CGRect outerTopMaskCircle  = CGRectInset(outerTopCircle, 4, 4);
    CGRect innerTopCircle = CGRectInset(outerTopCircle, 6, 6);
    
    UIBezierPath *outerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerTopCircle];
    
    [outerTopCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerTopMaskCircle]];
    outerTopCirclePath.usesEvenOddFillRule = YES;
    
    [circleColor set];
    [outerTopCirclePath fill];
    
    UIBezierPath *innerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerTopCircle];
    [[UIColor blackColor] set];
    [innerTopCirclePath fill];
    
    UIGraphicsPopContext();
    
    CGContextRestoreGState(ctx);
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

- (NSArray *) getStationsForConsection:(ConSection *)conSection {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    if ([conSection conSectionType] == walkType) {
        Station *departureStation = [[Station alloc] init];
        Station *arrivalStation = [[Station alloc] init];
        departureStation.stationName = [[[conSection departure] station] stationName];
        departureStation.stationId = [[[conSection departure] station] stationId];
        departureStation.latitude = [[[conSection departure] station] latitude];
        departureStation.longitude = [[[conSection departure] station] longitude];
        [stationsArray addObject: departureStation];
        arrivalStation.stationName = [[[conSection arrival] station] stationName];
        arrivalStation.stationId = [[[conSection arrival] station] stationId];
        arrivalStation.latitude = [[[conSection arrival] station] latitude];
        arrivalStation.longitude = [[[conSection arrival] station] longitude];
        [stationsArray addObject: arrivalStation];
        return stationsArray;
    } else if ([conSection conSectionType] == journeyType) {
        NSArray *passlist = [[conSection journey] passList];
        for (int i = 0;  i < [passlist count];  i++) {
            BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
            [stationsArray addObject: [currentBasicStop station]];
        }
        return stationsArray;
    }
    return nil;
}

- (NSArray *) getBasicStopsForConsection:(ConSection *)conSection {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    if ([conSection conSectionType] == walkType) {
        BasicStop *departureStation = [[BasicStop alloc] init];
        BasicStop *arrivalStation = [[BasicStop alloc] init];
        
        departureStation.arr = [[conSection arrival] arr];
        departureStation.dep = [[conSection departure] dep];
        departureStation.station = [[conSection departure] station];
        departureStation.basicStopType = departureType;
        departureStation.platform = [[conSection departure] platform];
        
        arrivalStation.arr = [[conSection arrival] arr];
        arrivalStation.dep = [[conSection departure] dep];
        arrivalStation.station = [[conSection arrival] station];
        arrivalStation.basicStopType = arrivalType;
        arrivalStation.platform = [[conSection arrival] platform];
        
        [stationsArray addObject: departureStation];
        [stationsArray addObject: arrivalStation];
        return stationsArray;
    } else if ([conSection conSectionType] == journeyType) {
        NSArray *passlist = [[conSection journey] passList];
        for (int i = 0;  i < [passlist count];  i++) {
            BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
            [stationsArray addObject: currentBasicStop];
        }
        return stationsArray;
    }
    return nil;
}

- (NSArray *) getAllBasicStopsForConnectionResultWithIndex:(NSUInteger)index {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    
    //NSLog(@"getAllBasicStopsForConnectionResultWithIndex: %d", index);
    
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            if ([[self.connectionsResult conResults] count] > 0) {
                if ([[self.connectionsResult conResults] count] > index) {
                    if ([[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList] conSections]) {
                        if ([[[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList] conSections] count] > 0) {
                            for (ConSection *currentConsection in [[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList]  conSections]) {
                                if ([currentConsection conSectionType] == walkType) {
                                    BasicStop *departureStation = [[BasicStop alloc] init];
                                    BasicStop *arrivalStation = [[BasicStop alloc] init];
                                    
                                    departureStation.arr = [[currentConsection arrival] arr];
                                    departureStation.dep = [[currentConsection departure] dep];
                                    departureStation.station = [[currentConsection departure] station];
                                    departureStation.basicStopType = departureType;
                                    departureStation.platform = [[currentConsection departure] platform];
                                    
                                    arrivalStation.arr = [[currentConsection arrival] arr];
                                    arrivalStation.dep = [[currentConsection departure] dep];
                                    arrivalStation.station = [[currentConsection arrival] station];
                                    arrivalStation.basicStopType = arrivalType;
                                    arrivalStation.platform = [[currentConsection arrival] platform];
                                    
                                    [stationsArray addObject: departureStation];
                                    [stationsArray addObject: arrivalStation];
                                } else if ([currentConsection conSectionType] == journeyType) {
                                    NSArray *passlist = [[currentConsection journey] passList];
                                    for (int i = 0;  i < [passlist count];  i++) {
                                        BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
                                        [stationsArray addObject: currentBasicStop];
                                    }
                                }
                            }
                            
                            //NSLog(@"All stations array elements: %d", stationsArray.count);
                            
                            return stationsArray;
                        }
                    }
                }
            }
        }
    }
    return nil;
}

- (BOOL) isTrainportTypeEqualToTrainForConsection:(ConSection *)conSection {
    
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    //           7       6      6          9      9
    //> 5
    
    // NEU 7 MAERZ 2013 FOUND:
    // EXT (f.e. EXT30337)
    // Category Code: 8
    // Type Fast Train.... f.e. Geneve Biel/Bienne, stops Yverdon, Neuchatel only
    // Maybe extra train to Geneve, Autosalon
    // According to SBB: ARZ/EXT => Extra train
    
    if (conSection) {
        if ([conSection conSectionType] == walkType) {
            return NO;
        }
        
        Journey *journey = [conSection journey];
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        
        if ([categoryCode integerValue] <= 5 || [categoryCode integerValue] == 8) {
            return YES;
        }
        
    }
    return NO;
}

-  (CLLocationCoordinate2D) getCoordinatesForStation:(Station *)station {
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(0.0, 0.0);
    if (station) {
        if ([station isKindOfClass: [Station class]]) {
            coordinates.latitude = [[station latitude] floatValue];
            coordinates.longitude = [[station longitude] floatValue];
        }
    }
    return coordinates;
}

-  (NSString *) getStationameForStation:(Station *)station {
    //NSLog(@"Stationname: %@", [station stationName]);
    if (station) {
        if ([station isKindOfClass: [Station class]]) {
            if ([[station stationName] isEqualToString: @"unknown"]) {
                return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");
            }
            return [station stationName];
        }
    }
    return nil;
}

-  (NSString *) getArrivalTimeForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Stationname: %@", [station stationName]);
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            NSString *arrivalTimeHoursString = [[basicStop arr] getHoursStringFromTime];
            NSString *arrivalTimeMinutesString = [[basicStop arr] getMinutesStringFromTime];
            
            NSString *timeString = [NSString stringWithFormat: @"%@:%@", arrivalTimeHoursString, arrivalTimeMinutesString];
            NSString *time1 = [timeString substringToIndex: 1];

            if ([time1 isEqualToString: @"("]) {
                return  nil;
            }
            return timeString;
        }
    }
    return nil;
}

-  (NSString *) getDepartureTimeForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Get departure time for basic stop");
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            //NSLog(@"Get departure time for basic stop. Is basicstop class");
            NSString *departureTimeHoursString = [[basicStop dep] getHoursStringFromTime];
            NSString *departureTimeMinutesString = [[basicStop dep] getMinutesStringFromTime];
            
            //NSLog(@"Get departure time for basic stop. hrs, min: %@, %@", departureTimeHoursString, departureTimeMinutesString);
            
            NSString *timeString = [NSString stringWithFormat: @"%@:%@", departureTimeHoursString, departureTimeMinutesString];
            NSString *time1 = [timeString substringToIndex: 1];
            
            if ([time1 isEqualToString: @"("]) {
                return  nil;
            }
            return timeString;
        }
    }
    return nil;
}

-  (NSString *) getDepartureDaysForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Get departure time for basic stop");
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            //NSLog(@"Get departure time for basic stop. Is basicstop class");
            NSString *departureTimeDaysString = [[basicStop dep] getDaysStringFromTime];
            
            //NSLog(@"Get departure time for basic stop. hrs, min: %@, %@", departureTimeHoursString, departureTimeMinutesString);
            
            return departureTimeDaysString;
        }
    }
    return nil;
}

-  (NSString *) getExpectedArrivalTimeForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Stationname: %@", [station stationName]);
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            NSString *arrivalTimeHoursString = [[basicStop arr] getExpectedHoursStringFromTime];
            NSString *arrivalTimeMinutesString = [[basicStop arr] getExpectedMinutesStringFromTime];
            
            NSString *timeString = [NSString stringWithFormat: @"%@:%@", arrivalTimeHoursString, arrivalTimeMinutesString];
            NSString *time1 = [timeString substringToIndex: 1];
            
            if ([time1 isEqualToString: @"("]) {
                return  nil;
            }
            return timeString;
        }
    }
    return nil;
}

-  (NSString *) getExpectedDepartureTimeForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Get departure time for basic stop");
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            //NSLog(@"Get departure time for basic stop. Is basicstop class");
            NSString *departureTimeHoursString = [[basicStop dep] getExpectedHoursStringFromTime];
            NSString *departureTimeMinutesString = [[basicStop dep] getExpectedMinutesStringFromTime];
            
            //NSLog(@"Get departure time for basic stop. hrs, min: %@, %@", departureTimeHoursString, departureTimeMinutesString);
            
            NSString *timeString = [NSString stringWithFormat: @"%@:%@", departureTimeHoursString, departureTimeMinutesString];
            NSString *time1 = [timeString substringToIndex: 1];
            
            if ([time1 isEqualToString: @"("]) {
                return  nil;
            }
            return timeString;
        }
    }
    return nil;
}

-  (NSString *) getStationNameForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Stationname: %@", [station stationName]);
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            if ([[[basicStop station] stationName] isEqualToString: @"unknown"]) {
                return NSLocalizedString(@"GPS location", @"SBBAPIController unknown station text replacement");
            }
            return [[basicStop station] stationName];
        }
    }
    return nil;
}


-  (NSString *) getPlatformForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Stationname: %@", [station stationName]);
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            //NSLog(@"Get platform for basicstop: %@", [basicStop platform]);
            if ([basicStop dep]) {
                //NSLog(@"Basicstop dep: %@", [[basicStop dep] platform]);
                return [[basicStop dep] platform];
            } else if ([basicStop arr]) {
                //NSLog(@"Basicstop arr: %@", [[basicStop arr] platform]);
                return [[basicStop arr] platform];
            }
            return nil;
        }
    }
    return nil;
}

-  (NSString *) getExpectedPlatformForBasicStop:(BasicStop *)basicStop {
    //NSLog(@"Stationname: %@", [station stationName]);
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            //NSLog(@"Get platform for basicstop: %@", [basicStop platform]);
            if ([basicStop dep]) {
                return [[basicStop dep] expectedPlatform];
            } else if ([basicStop arr]) {
                return [[basicStop arr] expectedPlatform];
            }
            return nil;
        }
    }
    return nil;
}

-  (Station *) getStationForBasicStop:(BasicStop *)basicStop {
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            return [basicStop station];
        }
    }
    return nil;
}

-  (NSNumber *) getCapacity1stForBasicStop:(BasicStop *)basicStop {
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            return [basicStop capacity1st];
        }
    }
    return nil;
}

-  (NSNumber *) getCapacity2ndForBasicStop:(BasicStop *)basicStop {
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            return [basicStop capacity2nd];
        }
    }
    return nil;
}

-  (NSNumber *) getLatitudeForStation:(Station *)station {
    if (station) {
        if ([station isKindOfClass: [Station class]]) {
            return [station latitude];
        }
    }
    return 0;
}

-  (NSNumber *) getLongitudeForStation:(Station *)station {
    if (station) {
        if ([station isKindOfClass: [Station class]]) {
            return [station longitude];
        }
    }
    return nil;
}

//--------------------------------------------------------------------------------
 
- (void) sendStbReqXMLStationboardRequestWithProductType:(Station *)station destination:(Station *)destination stbDate:(NSDate *)stbdate departureTime:(BOOL)departureTime productType:(NSUInteger)productType successBlock:(void(^)(NSUInteger))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    if (!station.stationName || ! station.stationId || !stbdate) {
        return;
    }
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: stbdate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: stbdate];
    
    NSString *xmlString = kStbReq_XML_SOURCE;
    
    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
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
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBSTATIONID" withString: [station stationId]];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBDATE" withString: dateString];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBTIME" withString: timeString];
    
    NSString *numberofrequestsstring = [NSString stringWithFormat: @"%d", self.sbbStbReqNumberOfConnectionsForRequest];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQNUM" withString: numberofrequestsstring];
    //xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQNUM" withString: @"40"];
    
    if (departureTime) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQTYPE" withString: @"DEP"];
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQTYPE" withString: @"ARR"];
    }
    
    if (productType == stbOnlyFastTrain) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_LONGDISTANCETRAIN];
    } else if (productType == stbOnlyRegioTrain) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_REGIOTRAIN];
    } else if (productType == stbOnlyTramBus) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_TRAM_BUS];
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
    }
    
    //xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
    
    //#define kPRODUCT_CODE_ALL                   @"1111111111000000"
    //#define kPRODUCT_CODE_LONGDISTANCETRAIN     @"1110000000000000"
    //#define kPRODUCT_CODE_REGIOTRAIN            @"0001110000000000"
    //#define kPRODUCT_CODE_TRAM_BUS_BAT          @"0000001101000000"
    
    
    if (destination.stationName && destination.stationId) {
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"Destination station set");
        #endif
        
        NSString *xmlDirString = kStbReq_XML_DIR_SOURCE;
        xmlDirString = [xmlDirString stringByReplacingOccurrencesOfString: @"DIRSTATIONID" withString: [destination stationId]];
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"DIRECTIONFILTER" withString: xmlDirString];
        
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"DIRECTIONFILTER" withString: @""];
    }
    
    #ifdef SBBAPILogLevelXMLReqRes
    NSLog(@"XML String: %@", xmlString);
    #endif
    
    self.stbreqRequestInProgress = YES;
    
    NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
    
    if (self.stbreqHttpClient) {
        [self.stbreqHttpClient cancelAllHTTPOperationsWithMethod: @"POST" path:kSBBXMLAPI_URL_PATH];
        self.stbreqHttpClient = nil;
    }
    
    self.stbreqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [self.stbreqHttpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [self.stbreqHttpClient requestWithMethod:@"POST" path: kSBBXMLAPI_URL_PATH parameters:nil];
    [request setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
    
    [request setTimeoutInterval: self.sbbApiStbreqTimeout];
        
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SUCCESS");
        
        #ifdef SBBAPILogLevelTimeStamp
            [self logTimeStampWithText:@"Stbreq end operation"];
        #endif
        
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Stbreq cancelled. Op success block start");
            #endif
            
            if (failureBlock) {
                failureBlock(kStbReqRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *stbreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakStbreqDecodingXMLOperation = stbreqDecodingXMLOperation;
        
        [stbreqDecodingXMLOperation addExecutionBlock: ^(void) {
        //dispatch_async(_stbreqBackgroundQueue, ^(void) {
            
            #ifdef SBBAPILogLevelXMLReqEndRes
            NSLog(@"Result:\n%@",responseString);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"Output directory: %@", documentsDirectory);
            NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_stb_response.txt"];
            [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
            #endif
            
            //return;
            
            StationboardResults *tempStbResults = nil;
            tempStbResults = [[StationboardResults alloc] init];
            
            if (responseString)
            {
                NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                
                if ([weakStbreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Stbreq cancelled. Stb queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kStbReqRequestFailureCancelled);
                        }];
                    }
                    return;
                }
                
                CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                if (xmlResponse)
                {
                    //NSLog(@"XML Response: %@", xmlResponse);
                    CXMLNode *stbResNode = [xmlResponse nodeForXPath: @"//STBRes" error: nil];
                    if (stbResNode) {
                        CXMLNode *stbresults = [xmlResponse nodeForXPath: @"//JourneyList" error: nil];
                        if (stbresults) {
                            for (CXMLElement *currentStbResult in [stbresults children]) {
                                
                                if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Stbreq cancelled. Stb queue block. For each 1");
                                    #endif
                                    
                                    if (failureBlock) {
                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                            failureBlock(kStbReqRequestFailureCancelled);
                                        }];
                                    }
                                    return;
                                }
                                
                                Journey *stbResult = [[Journey alloc] init];
                                for (CXMLElement *currentStbResultElement in [currentStbResult children]) {
                                    
                                    if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Stbreq cancelled. Stb queue block. For each 2");
                                        #endif
                                        
                                        if (failureBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                failureBlock(kStbReqRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
                                    if ([[currentStbResultElement name] isEqualToString: @"JHandle"]) {
                                        NSString *journeytnr = [[currentStbResultElement attributeForName: @"tNr"] stringValue];
                                        NSString *journeypuic = [[currentStbResultElement attributeForName: @"puic"] stringValue];
                                        NSString *journeycycle = [[currentStbResultElement attributeForName: @"cycle"] stringValue];
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Current journey code: %@, %@, %@", journeytnr, journeypuic, journeycycle);
                                        #endif
                                        
                                        JourneyHandle *journeyhandle = [[JourneyHandle alloc] init];
                                        journeyhandle.tnr = journeytnr;
                                        journeyhandle.puic = journeypuic;
                                        journeyhandle.cycle = journeycycle;
                                        stbResult.journeyHandle = journeyhandle;
                                    } else if ([[currentStbResultElement name] isEqualToString: @"MainStop"]) {
                                        BasicStop *mainstop = [[BasicStop alloc] init];
                                        mainstop.basicStopType = arrivalType;
                                        CXMLNode *mainstopElements = [currentStbResultElement childAtIndex: 0];
                                        
                                        for (CXMLElement *mainstopElement in [mainstopElements children]) {
                                            
                                            #ifdef SBBAPILogLevelFull
                                            NSLog(@"main stop element name: %@", [mainstopElement name]);
                                            #endif
                                            
                                            if ([[mainstopElement name] isEqualToString: @"Station"]) {
                                                Station *mainstopStation = [[Station alloc] init];
                                                mainstopStation.stationName = [self fromISOLatinToUTF8: [[mainstopElement attributeForName: @"name"] stringValue]];
                                                mainstopStation.stationId = [self fromISOLatinToUTF8: [[mainstopElement attributeForName: @"externalId"] stringValue]];
                                                double latitude = [[[mainstopElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                double longitude = [[[mainstopElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                mainstopStation.latitude = [NSNumber numberWithFloat: latitude];
                                                mainstopStation.longitude = [NSNumber numberWithFloat: longitude];
                                                mainstop.station = mainstopStation;
                                            } else if ([[mainstopElement name] isEqualToString: @"Dep"]) {
                                                Dep *dep = [[Dep alloc] init];
                                                for (CXMLElement *currentDepElement in [mainstopElement children]) {
                                                    if ([[currentDepElement name] isEqualToString: @"Time"]) {
                                                        dep.timeString = [currentDepElement stringValue];
                                                        mainstop.dep = dep;
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"STB dep time: %@", dep.timeString);
                                                        #endif
                                                        
                                                    } else if ([[currentDepElement name] isEqualToString: @"Platform"]) {
                                                        CXMLNode *platformElements = [currentDepElement childAtIndex: 0];
                                                        NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"STB dep platform: %@", platformString);
                                                        #endif
                                                        
                                                        dep.platform = platformString;
                                                    }
                                                }
                                            } else if ([[mainstopElement name] isEqualToString: @"Arr"]) {
                                                Arr *arr = [[Arr alloc] init];
                                                for (CXMLElement *currentArrElement in [mainstopElement children]) {
                                                    if ([[currentArrElement name] isEqualToString: @"Time"]) {
                                                        arr.timeString = [currentArrElement stringValue];
                                                        mainstop.arr = arr;
                                                    } else if ([[currentArrElement name] isEqualToString: @"Platform"]) {
                                                        CXMLNode *platformElements = [currentArrElement childAtIndex: 0];
                                                        NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"STB arr platform: %@", platformString);
                                                        #endif
                                                        
                                                        arr.platform = platformString;
                                                    }
                                                }
                                            } else if ([[mainstopElement name] isEqualToString: @"StopPrognosis"]) {
                                                for (CXMLElement *currentDepElement in [mainstopElement children]) {
                                                    if ([[currentDepElement name] isEqualToString: @"Capacity1st"]) {
                                                        NSString *capstring = [currentDepElement stringValue];
                                                        mainstop.capacity1st = [NSNumber numberWithInt: [capstring integerValue]];
                                                    } else if ([[currentDepElement name] isEqualToString: @"Capacity2nd"]) {
                                                        NSString *capstring = [currentDepElement stringValue];
                                                        mainstop.capacity2nd = [NSNumber numberWithInt: [capstring integerValue]];
                                                    } else if ([[currentDepElement name] isEqualToString: @"Status"]) {
                                                        NSString *statusstring = [currentDepElement stringValue];
                                                        mainstop.scheduled = statusstring;
                                                    }
                                                }
                                            }
                                        }
                                        stbResult.mainstop = mainstop;
                                    } else if ([[currentStbResultElement name] isEqualToString: @"JourneyAttributeList"]) {
                                        for (CXMLElement *journeyAttributeElement in [currentStbResultElement children]) {
                                            //NSLog(@"Stbresult detail element journey attribute element: %@", journeyAttributeElement);
                                            
                                            //for (CXMLElement *journeyAttributeElementDetail in [journeyAttributeElement children]) {
                                            //    NSLog(@"Element: %@", journeyAttributeElementDetail);
                                            //    NSLog(@"Element: %@", [journeyAttributeElementDetail stringValue]);
                                            //}
                                            
                                            CXMLNode *journeyAttributeElementDetail = [journeyAttributeElement childAtIndex: 0];
                                            
                                            //NSLog(@"Array: %@", journeyAttributeElementDetail);
                                            //NSLog(@"Array: %@", [journeyAttributeElementDetail stringValue]);
                                            
                                            NSString *attributeType = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"type"] stringValue];
                                            
                                            #ifdef SBBAPILogLevelFull
                                            NSLog(@"Stb detail element journey attribute element type: %@", attributeType);
                                            #endif
                                            
                                            if ([attributeType isEqualToString: @"NAME"]) {
                                                for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                    NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                    //NSLog(@"Name attribute variant element type: %@", attributeVariantElement);
                                                    if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                        NSString *journeyName = [[journeyAttributeVariantElement stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                        stbResult.journeyName = journeyName;
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Name attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                        #endif
                                                        
                                                    }
                                                }
                                                
                                            } else if ([attributeType isEqualToString: @"CATEGORY"]) {
                                                NSString *categoryCode = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"code"] stringValue];
                                                stbResult.journeyCategoryCode = categoryCode;
                                                
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Category attribute variant element code: %@", categoryCode);
                                                #endif
                                                
                                                
                                                for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                    NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                    //NSLog(@"Category attribute variant element type: %@", attributeVariantElement);
                                                    if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                        stbResult.journeyCategoryName = [journeyAttributeVariantElement stringValue];
                                                        
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
                                                        stbResult.journeyNumber = [journeyAttributeVariantElement stringValue];
                                                        
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
                                                        stbResult.journeyAdministration = [journeyAttributeVariantElement stringValue];
                                                        
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
                                                        stbResult.journeyOperator = [journeyAttributeVariantElement stringValue];
                                                        
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
                                                        stbResult.journeyDirection = [self fromISOLatinToUTF8: [journeyAttributeVariantElement stringValue]];
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Direction attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                        #endif
                                                    }
                                                }
                                            } 
                                        }
                                    }
                                }
                                if (stbResult) {
                                    
                                    #ifdef SBBAPILogLevelXMLReqRes
                                    NSLog(@"StbRes: %@", stbResult);
                                    #endif
                                    
                                    [tempStbResults.stbJourneys addObject: stbResult];
                                }
                                
                                #ifdef SBBAPILogLevelXMLReqRes
                                NSLog(@"StbRes #: %d", tempStbResults.stbJourneys.count);
                                #endif
                            }
                        } else {
                            for (CXMLElement *currentStbresElement in [stbResNode children]) {
                                if ([[currentStbresElement name] isEqualToString: @"Err"]) {
                                    NSString *errorcode = [[(CXMLElement *)currentStbresElement attributeForName: @"code"] stringValue];
                                    NSString *errortext = [[(CXMLElement *)currentStbresElement attributeForName: @"text"] stringValue];
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Conreq: error received: %@, %@", errorcode, errortext);
                                    #endif
                                    
                                    NSString *errorcodestring = [NSString stringWithFormat:@"Stbreq:%@", errorcode];
                                    
                                    if (self.errorreportingHttpClient) {
                                        self.errorreportingHttpClient = nil;
                                    }
                                    if (self.errorReportingBaseURL) {
                                        self.errorreportingHttpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString: self.errorReportingBaseURL]];
                                        [self.errorreportingHttpClient defaultValueForHeader:@"Accept"];
                                        
                                        NSString *requesturlpath = [self createErrorReportingUrlString: errorcodestring errortext: errortext startname: station.stationName startid:station.stationId endname:destination.stationName endid:destination.stationId];
                                        
                                        #ifdef SBBAPILogLevelCancel
                                        //NSLog(@"Error url: %@", requesturlpath);
                                        #endif
                                        
                                        NSMutableURLRequest *errorrequest = [self.errorreportingHttpClient requestWithMethod:@"POST" path: requesturlpath parameters:nil];
                                        //[errorrequest setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
                                        [errorrequest setTimeoutInterval: SBBAPIREQUESTERRREQSTANDARDTIMEOUT];
                                        AFHTTPRequestOperation *erroroperation = [[AFHTTPRequestOperation alloc] initWithRequest:errorrequest];
                                        
                                        /*
                                         [erroroperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"%@", [operation responseString]);
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", [operation responseString]);
                                         }];
                                         */
                                        
                                        [erroroperation start];
                                    }
                                }
                            }
                        }
                        
                        //tempStbResults.stbscridbackwards = [NSNumber numberWithInt: 1];
                        //tempStbResults.stbscridforward = [NSNumber numberWithInt: 1];
                    }
                }
                
            } else {
                #ifdef SBBAPILogLevelFull
                NSLog(@"Empty response string!!!");
                #endif
            }
            
            //NSLog(@"XML Response: %@", xmlResponse);
            
            #ifdef SBBAPILogLevelTimeStamp
            [self logTimeStampWithText:@"Stbreq end decoding xml"];
            #endif
            self.stbreqRequestInProgress = NO;
            
            if ([weakStbreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Stbreq cancelled. Stb queue block. End. MainQueue call");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kStbReqRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (tempStbResults && tempStbResults.stbJourneys.count > 0) {
                            if (productType == stbOnlyFastTrain) {
                                self.stationboardResultFastTrainOnly = tempStbResults;
                            } else if (productType == stbOnlyRegioTrain) {
                                self.stationboardResultRegioTrainOnly = tempStbResults;
                            } else if (productType == stbOnlyTramBus) {
                                self.stationboardResultTramBusOnly = tempStbResults;
                            } else {
                                self.stationboardResult = tempStbResults;
                            }
                            
                            NSUInteger numberofnewresults = 0;
                            
                            if (productType == stbOnlyFastTrain) {
                                numberofnewresults = self.stationboardResultFastTrainOnly.stbJourneys.count;
                            } else if (productType == stbOnlyRegioTrain) {
                                numberofnewresults = self.stationboardResultRegioTrainOnly.stbJourneys.count;
                            } else if (productType == stbOnlyTramBus) {
                                numberofnewresults = self.stationboardResultTramBusOnly.stbJourneys.count;
                            } else {
                                numberofnewresults = self.stationboardResult.stbJourneys.count;
                            }
                            
                            successBlock(numberofnewresults);
                            
                        } else {
                            if (failureBlock) {
                                failureBlock(kStbRegRequestFailureNoNewResults);
                            }
                        }
                    }];
                }
            }
        }];
        [_stbreqBackgroundOpQueue addOperation: stbreqDecodingXMLOperation];
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        
        self.stbreqRequestInProgress = NO;
        
        //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
        if (failureBlock) {
            failureBlock(kStbReqRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Stbreq start operation"];
    #endif
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}


- (void) getProductTypesWithQuickCheckStbReqXMLStationboardRequestWithProductCode:(Station *)station destination:(Station *)destination stbDate:(NSDate *)stbdate departureTime:(BOOL)departureTime gotProductTypesBlock:(void(^)(NSUInteger))gotProductTypesBlock failedToGetProductTypesBlock:(void(^)(NSUInteger))failedToGetProductTypesBlock {
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: stbdate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: stbdate];
    
    NSString *xmlString = kStbReq_XML_SOURCE;
        
    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
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
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBSTATIONID" withString: [station stationId]];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBDATE" withString: dateString];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBTIME" withString: timeString];
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQNUM" withString: @"120"];
    
    if (departureTime) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQTYPE" withString: @"DEP"];
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQTYPE" withString: @"ARR"];
    }
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
    
    
    if (destination.stationName && destination.stationId) {
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"Destination station set");
        #endif
        
        NSString *xmlDirString = kStbReq_XML_DIR_SOURCE;
        xmlDirString = [xmlDirString stringByReplacingOccurrencesOfString: @"DIRSTATIONID" withString: [destination stationId]];
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"DIRECTIONFILTER" withString: xmlDirString];
        
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"DIRECTIONFILTER" withString: @""];
    }
    
    #ifdef SBBAPILogLevelXMLReqRes
    NSLog(@"XML String: %@", xmlString);
    #endif
    
    self.stbreqRequestInProgress = YES;
    
    NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
    
    if (self.stbreqHttpClient) {
        [self.stbreqHttpClient cancelAllHTTPOperationsWithMethod: @"POST" path:kSBBXMLAPI_URL_PATH];
        self.stbreqHttpClient = nil;
    }
    
    self.stbreqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [self.stbreqHttpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [self.stbreqHttpClient requestWithMethod:@"POST" path: kSBBXMLAPI_URL_PATH parameters:nil];
    [request setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
    
    [request setTimeoutInterval: self.sbbApiStbreqTimeout];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SUCCESS");
        
        #ifdef SBBAPILogLevelTimeStamp
            [self logTimeStampWithText:@"Stbcheck end operation"];
        #endif
        
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Stbreqcheck cancelled. Op success block start");
            #endif
            
            if (failedToGetProductTypesBlock) {
                failedToGetProductTypesBlock(kStbReqRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *stbreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakStbreqDecodingXMLOperation = stbreqDecodingXMLOperation;
        
        [stbreqDecodingXMLOperation addExecutionBlock: ^(void) {
                
            #ifdef SBBAPILogLevelXMLReqEndRes
            NSLog(@"Result:\n%@",responseString);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"Output directory: %@", documentsDirectory);
            NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_stb_response.txt"];
            [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
            #endif
            
            //return;

            StationboardResults *tempStbResults = nil;
            tempStbResults = [[StationboardResults alloc] init];
            
            if (responseString)
            {
                NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                
                if ([weakStbreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Stbreqcheck cancelled. Stb queue block. cleanedstring");
                    #endif
                    
                    if (failedToGetProductTypesBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failedToGetProductTypesBlock(kStbReqRequestFailureCancelled);
                        }];
                    }
                    return;
                }

                CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                if (xmlResponse)
                {
                    //NSLog(@"XML Response: %@", xmlResponse);
                    
                    
                    CXMLNode *stbResNode = [xmlResponse nodeForXPath: @"//STBRes" error: nil];
                    if (stbResNode) {
                        CXMLNode *stbresults = [xmlResponse nodeForXPath: @"//JourneyList" error: nil];
                        if (stbresults) {
                            for (CXMLElement *currentStbResult in [stbresults children]) {
                                
                                if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Stbreq cancelled. Stb queue block. For each 1");
                                    #endif
                                    
                                    if (failedToGetProductTypesBlock) {
                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                            failedToGetProductTypesBlock(kStbReqRequestFailureCancelled);
                                        }];
                                    }
                                    return;
                                }
                    
                                Journey *stbResult = [[Journey alloc] init];
                                for (CXMLElement *currentStbResultElement in [currentStbResult children]) {
                                    
                                    if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Stbreq cancelled. Stb queue block. For each 2");
                                        #endif
                                        
                                        if (failedToGetProductTypesBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                failedToGetProductTypesBlock(kStbReqRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
                                    if ([[currentStbResultElement name] isEqualToString: @"JourneyAttributeList"]) {
                                        for (CXMLElement *journeyAttributeElement in [currentStbResultElement children]) {
                                            CXMLNode *journeyAttributeElementDetail = [journeyAttributeElement childAtIndex: 0];
                                            NSString *attributeType = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"type"] stringValue];
                                            
                                            #ifdef SBBAPILogLevelFull
                                            NSLog(@"Stb detail element journey attribute element type: %@", attributeType);
                                            #endif
                                            
                                            if ([attributeType isEqualToString: @"CATEGORY"]) {
                                                NSString *categoryCode = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"code"] stringValue];
                                                stbResult.journeyCategoryCode = categoryCode;
                                                
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Category attribute variant element code: %@", categoryCode);
                                                #endif
                                            }
                                        }
                                    }
                                }
                                if (stbResult) {
                                    
                                    #ifdef SBBAPILogLevelXMLReqRes
                                    NSLog(@"StbRes: %@", stbResult);
                                    #endif
                                    
                                    [tempStbResults.stbJourneys addObject: stbResult];
                                }
                                
                                #ifdef SBBAPILogLevelXMLReqRes
                                NSLog(@"StbRes #: %d", tempStbResults.stbJourneys.count);
                                #endif
                                
                            }
                        } else {
                            for (CXMLElement *currentStbresElement in [stbResNode children]) {
                                if ([[currentStbresElement name] isEqualToString: @"Err"]) {
                                    NSString *errorcode = [[(CXMLElement *)currentStbresElement attributeForName: @"code"] stringValue];
                                    NSString *errortext = [[(CXMLElement *)currentStbresElement attributeForName: @"text"] stringValue];
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Stbreqcheck: error received: %@, %@", errorcode, errortext);
                                    #endif
                                    
                                    NSString *errorcodestring = [NSString stringWithFormat:@"Stbreqcheck:%@", errorcode];
                                    
                                    if (self.errorreportingHttpClient) {
                                        self.errorreportingHttpClient = nil;
                                    }
                                    if (self.errorReportingBaseURL) {
                                        self.errorreportingHttpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString: self.errorReportingBaseURL]];
                                        [self.errorreportingHttpClient defaultValueForHeader:@"Accept"];
                                        
                                        NSString *requesturlpath = [self createErrorReportingUrlString: errorcodestring errortext: errortext startname: station.stationName startid:station.stationId endname:destination.stationName endid:destination.stationId];
                                        
                                        #ifdef SBBAPILogLevelCancel
                                        //NSLog(@"Error url: %@", requesturlpath);
                                        #endif
                                        
                                        NSMutableURLRequest *errorrequest = [self.errorreportingHttpClient requestWithMethod:@"POST" path: requesturlpath parameters:nil];
                                        //[errorrequest setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
                                        [errorrequest setTimeoutInterval: SBBAPIREQUESTERRREQSTANDARDTIMEOUT];
                                        AFHTTPRequestOperation *erroroperation = [[AFHTTPRequestOperation alloc] initWithRequest:errorrequest];
                                        
                                        /*
                                         [erroroperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"%@", [operation responseString]);
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", [operation responseString]);
                                         }];
                                         */
                                        
                                        [erroroperation start];
                                    }
                                }
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
            [self logTimeStampWithText:@"Stbcheck end decoding xml"];
            #endif
            
            self.stbreqRequestInProgress = NO;
            
            if ([weakStbreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Stbreq cancelled. Stb queue block. End. MainQueue call");
                #endif
                
                if (failedToGetProductTypesBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failedToGetProductTypesBlock(kStbReqRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (gotProductTypesBlock) {
                    
                    StationboardResults *fastTrainResult = [[StationboardResults alloc] init];
                    StationboardResults *regioTrainResult = [[StationboardResults alloc] init];
                    StationboardResults *trambusResult = [[StationboardResults alloc] init];
                    
                    for (Journey *currentJourney in tempStbResults.stbJourneys) {
                        NSString *categoryCodeString = [currentJourney journeyCategoryCode];
                        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
                        if (([categoryCode integerValue] < 3) || ([categoryCode integerValue] == 8)) {
                            [fastTrainResult.stbJourneys addObject: currentJourney];
                        } else if (([categoryCode integerValue] >= 3) && ([categoryCode integerValue] <= 5)) {
                            [regioTrainResult.stbJourneys addObject: currentJourney];
                        } else if (([categoryCode integerValue] > 5) && ([categoryCode integerValue] != 8)) {
                            [trambusResult.stbJourneys addObject: currentJourney];
                        }
                    }
                    
                    
                    NSUInteger fastTrainCount = 0;
                    NSUInteger regioTrainCount = 0;
                    NSUInteger trambusCount = 0;
                    
                    if (fastTrainResult) {
                        if (fastTrainResult.stbJourneys) {
                            fastTrainCount = fastTrainResult.stbJourneys.count;
                        }
                    }
                    if (regioTrainResult) {
                        if (regioTrainResult.stbJourneys) {
                            regioTrainCount = regioTrainResult.stbJourneys.count;
                        }
                    }
                    if (trambusResult) {
                        if (trambusResult.stbJourneys) {
                            trambusCount = trambusResult.stbJourneys.count;
                        }
                    }

                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (tempStbResults && tempStbResults.stbJourneys.count > 0) {
                            
                            if ((fastTrainCount > 0) && (regioTrainCount == 0) && (trambusCount == 0)) {
                                gotProductTypesBlock(stbOnlyFastTrain);
                            } else if ((fastTrainCount == 0) && (regioTrainCount > 0) && (trambusCount == 0)) {
                                gotProductTypesBlock(stbOnlyRegioTrain);
                            } else if ((fastTrainCount == 0) && (regioTrainCount == 0) && (trambusCount > 0)) {
                                gotProductTypesBlock(stbOnlyTramBus);
                            } else if ((fastTrainCount > 0) && (regioTrainCount > 0) && (trambusCount == 0)) {
                                gotProductTypesBlock(stbFastAndRegioTrain);
                            } else if ((fastTrainCount > 0) && (regioTrainCount == 0) && (trambusCount > 0)) {
                                gotProductTypesBlock(stbFastTrainAndTramBus);
                            } else if ((fastTrainCount == 0) && (regioTrainCount > 0) && (trambusCount > 0)) {
                                gotProductTypesBlock(stbRegioTrainAndTramBus);
                            } else if ((fastTrainCount > 0) && (regioTrainCount > 0) && (trambusCount > 0)) {
                                gotProductTypesBlock(stbAll);
                            } else {
                                gotProductTypesBlock(stbNone);
                            }
                            
                        } else {
                            if (failedToGetProductTypesBlock) {
                                failedToGetProductTypesBlock(kStbRegRequestFailureNoNewResults);
                            }
                        }
                    }];
                }
            }
        }];
        [_stbreqBackgroundOpQueue addOperation: stbreqDecodingXMLOperation];
             
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        
        self.stbreqRequestInProgress = NO;
        
        //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
        if (failedToGetProductTypesBlock) {
            failedToGetProductTypesBlock(kStbReqRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Stbcheck start operation"];
    #endif
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

#define STBSCRTIMEDIFFINTERVAL 60*60
#define STBSCRMAXBACKANDFWD 10

- (void) sendStbScrXMLStationboardRequestWithProductType:(NSUInteger)directionflag station:(Station *)station destination:(Station *)destination stbDate:(NSDate *)stbdate departureTime:(BOOL)departureTime productType:(NSUInteger)productType successBlock:(void(^)(NSUInteger))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    if (!station.stationName || ! station.stationId || !stbdate) {
        return;
    }
    
    StationboardResults *currentStationboardResultForProductType;
    
    if (productType == stbOnlyFastTrain) {
        currentStationboardResultForProductType = self.stationboardResultFastTrainOnly;
    } else if (productType == stbOnlyRegioTrain) {
        currentStationboardResultForProductType = self.stationboardResultRegioTrainOnly;
    } else if (productType == stbOnlyTramBus) {
        currentStationboardResultForProductType = self.stationboardResultTramBusOnly;
    } else {
        currentStationboardResultForProductType = self.stationboardResult;
    }
    
    if (!currentStationboardResultForProductType)  {
        NSUInteger kStbScrRequestFailureNoStationboardResult = 52;
        if (failureBlock) {
            failureBlock(kStbScrRequestFailureNoStationboardResult);
        }
    }

    if (![currentStationboardResultForProductType stbJourneys] > 0)  {
        NSUInteger kStbScrRequestFailureNoJourneysInCurrentRequest = 55;
        if (failureBlock) {
            failureBlock(kStbScrRequestFailureNoJourneysInCurrentRequest);
        }
    }
    
    //NSNumber *stbScrId;
    NSDate *stbScrDate;
    
    if (directionflag == stbscrBackward) {
        //stbScrId = currentStationboardResultForProductType.stbscridbackwards;
        Journey *firstJourneyInCurrentResult = [[currentStationboardResultForProductType stbJourneys] objectAtIndex: 0];
        NSString *journeydatestring;
        if ([[firstJourneyInCurrentResult mainstop] dep]) {
            journeydatestring = [[[firstJourneyInCurrentResult mainstop] dep] timeString];
        } else if ([[firstJourneyInCurrentResult mainstop] arr]) {
            journeydatestring = [[[firstJourneyInCurrentResult mainstop] arr] timeString];
        }
        NSDateFormatter *toDateTimeFormatter = [[NSDateFormatter alloc] init];
        [toDateTimeFormatter setDateFormat:@"HH:mm"];
        //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSDate *firstTimeDate = [toDateTimeFormatter dateFromString: journeydatestring];
        stbScrDate = [firstTimeDate dateByAddingTimeInterval: - STBSCRTIMEDIFFINTERVAL];
    } else if (directionflag == stbscrForward) {
        //stbScrId = currentStationboardResultForProductType.stbscridforward;
        Journey *lastJourneyInCurrentResult = [[currentStationboardResultForProductType stbJourneys] lastObject];
        NSString *journeydatestring;
        if ([[lastJourneyInCurrentResult mainstop] dep]) {
            journeydatestring = [[[lastJourneyInCurrentResult mainstop] dep] timeString];
        } else if ([[lastJourneyInCurrentResult mainstop] arr]) {
            journeydatestring = [[[lastJourneyInCurrentResult mainstop] arr] timeString];
        }
        NSDateFormatter *toDateTimeFormatter = [[NSDateFormatter alloc] init];
        [toDateTimeFormatter setDateFormat:@"HH:mm"];
        //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSDate *firstTimeDate = [toDateTimeFormatter dateFromString: journeydatestring];
        stbScrDate = firstTimeDate;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: stbdate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: stbScrDate];
    
    NSString *xmlString = kStbReq_XML_SOURCE;
    
    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
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
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBSTATIONID" withString: [station stationId]];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBDATE" withString: dateString];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBTIME" withString: timeString];
    
    NSString *numberofrequestsstring = [NSString stringWithFormat: @"%d", self.sbbStbScrNumberOfConnectionsForRequest];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQNUM" withString: numberofrequestsstring];
    //xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQNUM" withString: @"40"];
    
    if (departureTime) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQTYPE" withString: @"DEP"];
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STBREQTYPE" withString: @"ARR"];
    }
    
    if (productType == stbOnlyFastTrain) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_LONGDISTANCETRAIN];
    } else if (productType == stbOnlyRegioTrain) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_REGIOTRAIN];
    } else if (productType == stbOnlyTramBus) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_TRAM_BUS];
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
    }
    
    //xmlString = [xmlString stringByReplacingOccurrencesOfString: @"PRODUCTCODE" withString: kPRODUCT_CODE_ALL];
    
    //#define kPRODUCT_CODE_ALL                   @"1111111111000000"
    //#define kPRODUCT_CODE_LONGDISTANCETRAIN     @"1110000000000000"
    //#define kPRODUCT_CODE_REGIOTRAIN            @"0001110000000000"
    //#define kPRODUCT_CODE_TRAM_BUS_BAT          @"0000001101000000"
    
    
    if (destination.stationName && destination.stationId) {
        
        #ifdef SBBAPILogLevelFull
        NSLog(@"Destination station set");
        #endif
        
        NSString *xmlDirString = kStbReq_XML_DIR_SOURCE;
        xmlDirString = [xmlDirString stringByReplacingOccurrencesOfString: @"DIRSTATIONID" withString: [destination stationId]];
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"DIRECTIONFILTER" withString: xmlDirString];
        
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"DIRECTIONFILTER" withString: @""];
    }
    
    #ifdef SBBAPILogLevelXMLReqRes
    NSLog(@"XML String: %@", xmlString);
    #endif
    
    self.stbreqRequestInProgress = YES;
    
    NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
    
    if (self.stbreqHttpClient) {
        [self.stbreqHttpClient cancelAllHTTPOperationsWithMethod: @"POST" path:kSBBXMLAPI_URL_PATH];
        self.stbreqHttpClient = nil;
    }
    
    self.stbreqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [self.stbreqHttpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [self.stbreqHttpClient requestWithMethod:@"POST" path: kSBBXMLAPI_URL_PATH parameters:nil];
    [request setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
    
    [request setTimeoutInterval: self.sbbApiStbreqTimeout];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SUCCESS Stb Scr");
                
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Stbscr cancelled. Op success block start");
            #endif
            
            if (failureBlock) {
                failureBlock(kStbScrRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *stbreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakStbreqDecodingXMLOperation = stbreqDecodingXMLOperation;
        
        [stbreqDecodingXMLOperation addExecutionBlock: ^(void) {
                        
            #ifdef SBBAPILogLevelXMLReqEndRes
            NSLog(@"Result:\n%@",responseString);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"Output directory: %@", documentsDirectory);
            NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_stbscr_response.txt"];
            [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
            #endif
            
            //return;
            
            StationboardResults *tempStbResults = nil;
            tempStbResults = [[StationboardResults alloc] init];
            
            if (responseString)
            {
                NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                
                if ([weakStbreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Stbscr cancelled. Stb queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kStbScrRequestFailureCancelled);
                        }];
                    }
                    return;
                }
                
                CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                if (xmlResponse)
                {
                    //NSLog(@"XML Response: %@", xmlResponse);
                    CXMLNode *stbResNode = [xmlResponse nodeForXPath: @"//STBRes" error: nil];
                    if (stbResNode) {
                        CXMLNode *stbresults = [xmlResponse nodeForXPath: @"//JourneyList" error: nil];
                        if (stbresults) {
                            for (CXMLElement *currentStbResult in [stbresults children]) {
                                
                                if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Stbscr cancelled. Stb queue block. For each 1");
                                    #endif
                                    
                                    if (failureBlock) {
                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                            failureBlock(kStbScrRequestFailureCancelled);
                                        }];
                                    }
                                    return;
                                }
                                
                                Journey *stbResult = [[Journey alloc] init];
                                for (CXMLElement *currentStbResultElement in [currentStbResult children]) {
                                    
                                    if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Stbscr cancelled. Stb queue block. For each 2");
                                        #endif
                                        
                                        if (failureBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                failureBlock(kStbScrRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
                                    if ([[currentStbResultElement name] isEqualToString: @"JHandle"]) {
                                        NSString *journeytnr = [[currentStbResultElement attributeForName: @"tNr"] stringValue];
                                        NSString *journeypuic = [[currentStbResultElement attributeForName: @"puic"] stringValue];
                                        NSString *journeycycle = [[currentStbResultElement attributeForName: @"cycle"] stringValue];
                                        
                                        #ifdef SBBAPILogLevelFull
                                        NSLog(@"Current journey code: %@, %@, %@", journeytnr, journeypuic, journeycycle);
                                        #endif
                                        
                                        JourneyHandle *journeyhandle = [[JourneyHandle alloc] init];
                                        journeyhandle.tnr = journeytnr;
                                        journeyhandle.puic = journeypuic;
                                        journeyhandle.cycle = journeycycle;
                                        stbResult.journeyHandle = journeyhandle;
                                    } else if ([[currentStbResultElement name] isEqualToString: @"MainStop"]) {
                                        BasicStop *mainstop = [[BasicStop alloc] init];
                                        mainstop.basicStopType = arrivalType;
                                        CXMLNode *mainstopElements = [currentStbResultElement childAtIndex: 0];
                                        
                                        for (CXMLElement *mainstopElement in [mainstopElements children]) {
                                            
                                            if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Stbscr cancelled. Stb queue block. For each 3");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kStbScrRequestFailureCancelled);
                                                    }];
                                                }
                                                return;
                                            }
                                            
                                            #ifdef SBBAPILogLevelFull
                                            NSLog(@"main stop element name: %@", [mainstopElement name]);
                                            #endif
                                            
                                            if ([[mainstopElement name] isEqualToString: @"Station"]) {
                                                Station *mainstopStation = [[Station alloc] init];
                                                mainstopStation.stationName = [self fromISOLatinToUTF8: [[mainstopElement attributeForName: @"name"] stringValue]];
                                                mainstopStation.stationId = [self fromISOLatinToUTF8: [[mainstopElement attributeForName: @"externalId"] stringValue]];
                                                double latitude = [[[mainstopElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                                double longitude = [[[mainstopElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                                mainstopStation.latitude = [NSNumber numberWithFloat: latitude];
                                                mainstopStation.longitude = [NSNumber numberWithFloat: longitude];
                                                mainstop.station = mainstopStation;
                                            } else if ([[mainstopElement name] isEqualToString: @"Dep"]) {
                                                Dep *dep = [[Dep alloc] init];
                                                for (CXMLElement *currentDepElement in [mainstopElement children]) {
                                                    if ([[currentDepElement name] isEqualToString: @"Time"]) {
                                                        dep.timeString = [currentDepElement stringValue];
                                                        mainstop.dep = dep;
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"STB dep time: %@", dep.timeString);
                                                        #endif
                                                        
                                                    } else if ([[currentDepElement name] isEqualToString: @"Platform"]) {
                                                        CXMLNode *platformElements = [currentDepElement childAtIndex: 0];
                                                        NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"STB dep platform: %@", platformString);
                                                        #endif
                                                        
                                                        dep.platform = platformString;
                                                    }
                                                }
                                            } else if ([[mainstopElement name] isEqualToString: @"Arr"]) {
                                                Arr *arr = [[Arr alloc] init];
                                                for (CXMLElement *currentArrElement in [mainstopElement children]) {
                                                    if ([[currentArrElement name] isEqualToString: @"Time"]) {
                                                        arr.timeString = [currentArrElement stringValue];
                                                        mainstop.arr = arr;
                                                    } else if ([[currentArrElement name] isEqualToString: @"Platform"]) {
                                                        CXMLNode *platformElements = [currentArrElement childAtIndex: 0];
                                                        NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"STB arr platform: %@", platformString);
                                                        #endif
                                                        
                                                        arr.platform = platformString;
                                                    }
                                                }
                                            } else if ([[mainstopElement name] isEqualToString: @"StopPrognosis"]) {
                                                for (CXMLElement *currentDepElement in [mainstopElement children]) {
                                                    if ([[currentDepElement name] isEqualToString: @"Capacity1st"]) {
                                                        NSString *capstring = [currentDepElement stringValue];
                                                        mainstop.capacity1st = [NSNumber numberWithInt: [capstring integerValue]];
                                                    } else if ([[currentDepElement name] isEqualToString: @"Capacity2nd"]) {
                                                        NSString *capstring = [currentDepElement stringValue];
                                                        mainstop.capacity2nd = [NSNumber numberWithInt: [capstring integerValue]];
                                                    } else if ([[currentDepElement name] isEqualToString: @"Status"]) {
                                                        NSString *statusstring = [currentDepElement stringValue];
                                                        mainstop.scheduled = statusstring;
                                                    }
                                                }
                                            }
                                        }
                                        stbResult.mainstop = mainstop;
                                    } else if ([[currentStbResultElement name] isEqualToString: @"JourneyAttributeList"]) {
                                        for (CXMLElement *journeyAttributeElement in [currentStbResultElement children]) {
                                            
                                            if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                                #ifdef SBBAPILogLevelCancel
                                                NSLog(@"Stbscr cancelled. Stb queue block. For each 3");
                                                #endif
                                                
                                                if (failureBlock) {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                        failureBlock(kStbScrRequestFailureCancelled);
                                                    }];
                                                }
                                                return;
                                            }
                                            
                                            //NSLog(@"Stbresult detail element journey attribute element: %@", journeyAttributeElement);
                                            
                                            //for (CXMLElement *journeyAttributeElementDetail in [journeyAttributeElement children]) {
                                            //    NSLog(@"Element: %@", journeyAttributeElementDetail);
                                            //    NSLog(@"Element: %@", [journeyAttributeElementDetail stringValue]);
                                            //}
                                            
                                            CXMLNode *journeyAttributeElementDetail = [journeyAttributeElement childAtIndex: 0];
                                            
                                            //NSLog(@"Array: %@", journeyAttributeElementDetail);
                                            //NSLog(@"Array: %@", [journeyAttributeElementDetail stringValue]);
                                            
                                            NSString *attributeType = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"type"] stringValue];
                                            
                                            #ifdef SBBAPILogLevelFull
                                            NSLog(@"Stb detail element journey attribute element type: %@", attributeType);
                                            #endif
                                            
                                            if ([attributeType isEqualToString: @"NAME"]) {
                                                for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                    NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                    //NSLog(@"Name attribute variant element type: %@", attributeVariantElement);
                                                    if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                        NSString *journeyName = [[journeyAttributeVariantElement stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                        stbResult.journeyName = journeyName;
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Name attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                        #endif
                                                    }
                                                }
                                                
                                            } else if ([attributeType isEqualToString: @"CATEGORY"]) {
                                                NSString *categoryCode = [[(CXMLElement *)journeyAttributeElementDetail attributeForName: @"code"] stringValue];
                                                stbResult.journeyCategoryCode = categoryCode;
                                                
                                                #ifdef SBBAPILogLevelFull
                                                NSLog(@"Category attribute variant element code: %@", categoryCode);
                                                #endif
                                                
                                                for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                    NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                    //NSLog(@"Category attribute variant element type: %@", attributeVariantElement);
                                                    if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                        stbResult.journeyCategoryName = [journeyAttributeVariantElement stringValue];
                                                        
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
                                                        stbResult.journeyNumber = [journeyAttributeVariantElement stringValue];
                                                        
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
                                                        stbResult.journeyAdministration = [journeyAttributeVariantElement stringValue];
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Administration attribute variant element text: %@", [journeyAttributeVariantElement
                                                                                                                     stringValue]);
                                                        #endif
                                                    }
                                                }
                                                
                                            } else if ([attributeType isEqualToString: @"OPERATOR"]) {
                                                for (CXMLElement *journeyAttributeVariantElement in [journeyAttributeElementDetail children]) {
                                                    NSString *attributeVariantElement = [[(CXMLElement *)journeyAttributeVariantElement attributeForName: @"type"] stringValue];
                                                    //NSLog(@"Operator attribute variant element type: %@", attributeVariantElement);
                                                    if ([attributeVariantElement isEqualToString: @"NORMAL"]) {
                                                        stbResult.journeyOperator = [journeyAttributeVariantElement stringValue];
                                                        
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
                                                        stbResult.journeyDirection = [self fromISOLatinToUTF8: [journeyAttributeVariantElement stringValue]];
                                                        
                                                        #ifdef SBBAPILogLevelFull
                                                        NSLog(@"Direction attribute variant element text: %@", [journeyAttributeVariantElement stringValue]);
                                                        #endif
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if (stbResult) {
                                    
                                    #ifdef SBBAPILogLevelXMLReqRes
                                    NSLog(@"StbScrRes: %@", stbResult);
                                    #endif
                                    
                                    [tempStbResults.stbJourneys addObject: stbResult];
                                }
                                
                                #ifdef SBBAPILogLevelXMLReqRes
                                NSLog(@"StbScrRes #: %d", tempStbResults.stbJourneys.count);
                                #endif
                            }
                        } else {
                            for (CXMLElement *currentStbresElement in [stbResNode children]) {
                                if ([[currentStbresElement name] isEqualToString: @"Err"]) {
                                    NSString *errorcode = [[(CXMLElement *)currentStbresElement attributeForName: @"code"] stringValue];
                                    NSString *errortext = [[(CXMLElement *)currentStbresElement attributeForName: @"text"] stringValue];
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Stbscr: error received: %@, %@", errorcode, errortext);
                                    #endif
                                    
                                    NSString *errorcodestring = [NSString stringWithFormat:@"Stbscr:%@", errorcode];
                                    
                                    if (self.errorreportingHttpClient) {
                                        self.errorreportingHttpClient = nil;
                                    }
                                    if (self.errorReportingBaseURL) {
                                        self.errorreportingHttpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString: self.errorReportingBaseURL]];
                                        [self.errorreportingHttpClient defaultValueForHeader:@"Accept"];
                                        
                                        NSString *requesturlpath = [self createErrorReportingUrlString: errorcodestring errortext: errortext startname: station.stationName startid:station.stationId endname:destination.stationName endid:destination.stationId];
                                        
                                        #ifdef SBBAPILogLevelCancel
                                        //NSLog(@"Error url: %@", requesturlpath);
                                        #endif
                                        
                                        NSMutableURLRequest *errorrequest = [self.errorreportingHttpClient requestWithMethod:@"POST" path: requesturlpath parameters:nil];
                                        //[errorrequest setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
                                        [errorrequest setTimeoutInterval: SBBAPIREQUESTERRREQSTANDARDTIMEOUT];
                                        AFHTTPRequestOperation *erroroperation = [[AFHTTPRequestOperation alloc] initWithRequest:errorrequest];
                                        
                                        /*
                                         [erroroperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"%@", [operation responseString]);
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", [operation responseString]);
                                         }];
                                         */
                                        
                                        [erroroperation start];
                                    }
                                }
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
            [self logTimeStampWithText:@"Stbscr end decoding xml"];
            #endif
            
            self.stbreqRequestInProgress = NO;
            
            if ([weakStbreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Stbscr cancelled. Stb queue block. End. MainQueue call");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kStbScrRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    
                    NSMutableArray *currentStationboardResultKeyArrays = [NSMutableArray arrayWithCapacity:1];
                    
                    StationboardResults *currentStationboardResultForProductType;
                    
                    if (productType == stbOnlyFastTrain) {
                        currentStationboardResultForProductType = self.stationboardResultFastTrainOnly;
                    } else if (productType == stbOnlyRegioTrain) {
                        currentStationboardResultForProductType = self.stationboardResultRegioTrainOnly;
                    } else if (productType == stbOnlyTramBus) {
                        currentStationboardResultForProductType = self.stationboardResultTramBusOnly;
                    } else {
                        currentStationboardResultForProductType = self.stationboardResult;
                    }
                    
                    #ifdef SBBAPILogLevelXMLReqRes
                    NSLog(@"StbScrRes before new journeys #: %d", currentStationboardResultForProductType.stbJourneys.count);
                    #endif
                    
                    for (Journey *currentJourney in currentStationboardResultForProductType.stbJourneys) {
                        NSString *timeString;
                        if ([[currentJourney mainstop] arr]) {
                            timeString = [[[currentJourney mainstop] arr] timeString];
                        } else if ([[currentJourney mainstop] dep]) {
                            timeString = [[[currentJourney mainstop] dep] timeString];
                        }
                        NSString *journeyName = [currentJourney journeyName];
                        NSString *key = [NSString stringWithFormat: @"%@%@", journeyName, timeString];
                        [currentStationboardResultKeyArrays addObject: key];
                    }
                    
                    NSMutableArray *filteredStbResult = [NSMutableArray arrayWithCapacity:1];
                    
                    #ifdef SBBAPILogLevelXMLReqRes
                    NSLog(@"StbScrRes got with request #: %d", tempStbResults.stbJourneys.count);
                    #endif

                    if (tempStbResults.stbJourneys.count > 0) {
                        for (Journey *currentResJourney in tempStbResults.stbJourneys) {
                            NSString *timeString;
                            if ([[currentResJourney mainstop] arr]) {
                                timeString = [[[currentResJourney mainstop] arr] timeString];
                            } else if ([[currentResJourney mainstop] dep]) {
                                timeString = [[[currentResJourney mainstop] dep] timeString];
                            }
                            NSString *journeyName = [currentResJourney journeyName];
                            NSString *key = [NSString stringWithFormat: @"%@%@", journeyName, timeString];
                            if (![currentStationboardResultKeyArrays containsObject: key]) {
                                [filteredStbResult addObject: currentResJourney];
                            }
                        }
                        
                        #ifdef SBBAPILogLevelXMLReqRes
                        NSLog(@"StbScrRes after filtering #: %d", filteredStbResult.count);
                        #endif
                    }
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                
                        if (tempStbResults && tempStbResults.stbJourneys.count > 0 && filteredStbResult.count > 0) {
                            
                            NSUInteger numberofnewresults = currentStationboardResultForProductType.stbJourneys.count;
                            
                            #ifdef SBBAPILogLevelXMLReqRes
                            NSLog(@"StbScrRes before new journeys #: %d", currentStationboardResultForProductType.stbJourneys.count);
                            #endif
                  
                            if (directionflag == stbscrBackward) {
                                for (Journey *currentjrnResult in [filteredStbResult reverseObjectEnumerator]) {
                                    [currentStationboardResultForProductType.stbJourneys insertObject: currentjrnResult atIndex: 0];
                                }
                            } else if (directionflag == stbscrForward) {
                                for (ConResult *currentjrnResult in filteredStbResult) {
                                    [currentStationboardResultForProductType.stbJourneys addObject: currentjrnResult];
                                }
                            }
                            
                            #ifdef SBBAPILogLevelXMLReqRes
                            NSLog(@"StbScrRes after new journeys #: %d", currentStationboardResultForProductType.stbJourneys.count);
                            #endif
                            
                            numberofnewresults = currentStationboardResultForProductType.stbJourneys.count - numberofnewresults;
                            
                            successBlock(numberofnewresults);
                            
                        } else {
                            if (filteredStbResult.count == 0) {
                                if (failureBlock) {
                                    failureBlock(kStbScrRequestFailureNoNewResults);
                                }
                            } else {
                                if (failureBlock) {
                                    failureBlock(kStbScrRequestFailureCancelled);
                                }
                            }
                        }
                    }];
                }
            }
        }];
        [_stbreqBackgroundOpQueue addOperation: stbreqDecodingXMLOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        
        self.stbreqRequestInProgress = NO;
        
        //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
        if (failureBlock) {
            failureBlock(kStbScrRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Stbscr start operation"];
    #endif
    
    if (self.stbscrRequestCancelledFlag) {
        self.stbscrRequestCancelledFlag = NO;
        if (failureBlock) {
            failureBlock(kStbScrRequestFailureCancelled);
        }
    }
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

- (void) resetStationboardResults {
    self.stationboardResult = nil;
    self.stationboardResultFastTrainOnly = nil;
    self.stationboardResultRegioTrainOnly = nil;
    self.stationboardResultTramBusOnly = nil;
}

- (StationboardResults *)getStationboardresultsWithProducttype:(NSUInteger)producttype {
    if (producttype == stbOnlyFastTrain) {
        return self.stationboardResultFastTrainOnly;
    }
    if (producttype == stbOnlyRegioTrain) {
        return self.stationboardResultRegioTrainOnly;
    }
    if (producttype == stbOnlyTramBus) {
        return self.stationboardResultTramBusOnly;
    }
    return nil;
}

- (NSArray *) getStationboardResults {
    if (self.stationboardResult) {
        if ([self.stationboardResult stbJourneys]) {
            if ([[self.stationboardResult stbJourneys] count] > 0) {
                return [[[SBBAPIController sharedSBBAPIController] stationboardResult] stbJourneys];
            }
        }
    }
    return  nil;
}

- (NSUInteger) getNumberOfStationboardResults {
    if (self.stationboardResult) {
        if ([self.stationboardResult stbJourneys]) {
            if ([[self.stationboardResult stbJourneys] count] > 0) {
                return [[self.stationboardResult stbJourneys] count];
            }
        }
    }
    return  0;
}

- (Journey *) getJourneyForStationboardResultWithIndex:(NSUInteger)index {
    if (self.stationboardResult) {
        if ([self.stationboardResult stbJourneys]) {
            int conResultsCount = [[self.stationboardResult stbJourneys] count];
            if (conResultsCount > 0) {
                if (index < conResultsCount) {
                    return [[[[SBBAPIController sharedSBBAPIController] stationboardResult] stbJourneys] objectAtIndex: index];
                }
            }
        }
    }
    return  nil;
}

- (NSUInteger) getStationboardResultsAvailableProductTypes {
    if (self.stationboardResultFastTrainOnly && !self.stationboardResultRegioTrainOnly && !self.stationboardResultTramBusOnly) {
        return stbOnlyFastTrain;
    } else if (!self.stationboardResultFastTrainOnly && self.stationboardResultRegioTrainOnly && !self.stationboardResultTramBusOnly) {
        return stbOnlyRegioTrain;
    } else if (!self.stationboardResultFastTrainOnly && !self.stationboardResultRegioTrainOnly && self.stationboardResultTramBusOnly) {
        return stbOnlyTramBus;
    } else if (self.stationboardResultFastTrainOnly && self.stationboardResultRegioTrainOnly && !self.stationboardResultTramBusOnly) {
        return stbFastAndRegioTrain;
    } else if (self.stationboardResultFastTrainOnly && !self.stationboardResultRegioTrainOnly && self.stationboardResultTramBusOnly) {
        return stbFastTrainAndTramBus;
    } else if (!self.stationboardResultFastTrainOnly && self.stationboardResultRegioTrainOnly && self.stationboardResultTramBusOnly) {
        return stbRegioTrainAndTramBus;
    } else if (self.stationboardResultFastTrainOnly && self.stationboardResultRegioTrainOnly && self.stationboardResultTramBusOnly) {
        return stbAll;
    }
    return stbAll;
}


- (NSArray *) getStationboardResultsWithProductType:(NSUInteger)producttype {
    if (producttype == stbOnlyFastTrain) {
        return  [self.stationboardResultFastTrainOnly stbJourneys];
    } else if (producttype == stbOnlyRegioTrain) {
        return  [self.stationboardResultRegioTrainOnly stbJourneys];
    } else if (producttype == stbOnlyTramBus) {
        return  [self.stationboardResultTramBusOnly stbJourneys];
    }
    return  nil;
}

- (NSUInteger) getNumberOfStationboardResultsWithProductType:(NSUInteger)producttype {
    if (producttype == stbOnlyFastTrain) {
        return  [[self.stationboardResultFastTrainOnly stbJourneys] count];
    } else if (producttype == stbOnlyRegioTrain) {
        return  [[self.stationboardResultRegioTrainOnly stbJourneys] count];
    } else if (producttype == stbOnlyTramBus) {
        return  [[self.stationboardResultTramBusOnly stbJourneys] count];
    }
    return  0;
}

- (Journey *) getJourneyForStationboardResultFWithProductTypeWithIndex:(NSUInteger)producttype index:(NSUInteger)index {
    if (producttype == stbOnlyFastTrain) {
        if ([[self.stationboardResultFastTrainOnly stbJourneys] count] > index) {
            return  [[self.stationboardResultFastTrainOnly stbJourneys] objectAtIndex: index];
        }
        return nil;
    } else if (producttype == stbOnlyRegioTrain) {
        if ([[self.stationboardResultRegioTrainOnly stbJourneys] count] > index) {
            return  [[self.stationboardResultRegioTrainOnly stbJourneys] objectAtIndex: index];
        }
        return nil;
    } else if (producttype == stbOnlyTramBus) {
        if ([[self.stationboardResultTramBusOnly stbJourneys] count] > index) {
            return  [[self.stationboardResultTramBusOnly stbJourneys] objectAtIndex: index];
        }
        return nil;
    }
    return  nil;
}


- (void) splitStationboardResultsIntoProductTypeCategories {
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    //           7       6      6          9      9
    //> 5
    
    StationboardResults *fastTrainResult = [[StationboardResults alloc] init];
    StationboardResults *regioTrainResult = [[StationboardResults alloc] init];
    StationboardResults *trambusTrainResult = [[StationboardResults alloc] init];

    NSArray *stbResult = [self getStationboardResults];
    for (Journey *currentJourney in stbResult) {
        NSString *categoryCodeString = [currentJourney journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        if (([categoryCode integerValue] < 3) || ([categoryCode integerValue] == 8)) {
            [fastTrainResult.stbJourneys addObject: currentJourney];
        } else if (([categoryCode integerValue] >= 3) && ([categoryCode integerValue] <= 5)) {
            [regioTrainResult.stbJourneys addObject: currentJourney];
        } else if (([categoryCode integerValue] > 5) && ([categoryCode integerValue] != 8)) {
            [trambusTrainResult.stbJourneys addObject: currentJourney];
        }
    }
    
    self.stationboardResultFastTrainOnly = fastTrainResult;
    self.stationboardResultRegioTrainOnly = regioTrainResult;
    self.stationboardResultTramBusOnly = trambusTrainResult;
}

- (NSArray *) getStationboardResultsFilteredWithTransportTypeFilter:(NSUInteger)transportTypeFilter {    
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    //           7       6      6          9      9
    //> 5
    
    NSMutableArray *filterStbResult = [NSMutableArray arrayWithCapacity:2];
    NSArray *stbResult = [self getStationboardResults];
    for (Journey *currentJourney in stbResult) {
        NSString *categoryCodeString = [currentJourney journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        if (transportTypeFilter == stbLongdistanceTrains) {
            if (([categoryCode integerValue] < 3) || ([categoryCode integerValue] == 8)) {
                [filterStbResult addObject: currentJourney];
            }
        } else if (transportTypeFilter == stbRegioTrains) {
            if (([categoryCode integerValue] >= 3) && ([categoryCode integerValue] <= 5)) {
                [filterStbResult addObject: currentJourney];
            }
        } else if (transportTypeFilter == stbTramBus) {
            if (([categoryCode integerValue] > 5) && ([categoryCode integerValue] != 8)) {
                [filterStbResult addObject: currentJourney];
            }
        }
    }
    return filterStbResult;
}

- (NSUInteger) getNumberOfStationboardResultsFilteredWithTransportTypeFilter:(NSUInteger)transportTypeFilter {
    NSMutableArray *filterStbResult = [NSMutableArray arrayWithCapacity:2];
    NSArray *stbResult = [self getStationboardResults];
    for (Journey *currentJourney in stbResult) {
        NSString *categoryCodeString = [currentJourney journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        if (transportTypeFilter == stbLongdistanceTrains) {
            if (([categoryCode integerValue] < 3) || ([categoryCode integerValue] == 8)) {
                [filterStbResult addObject: currentJourney];
            }
        } else if (transportTypeFilter == stbRegioTrains) {
            if (([categoryCode integerValue] >= 3) && ([categoryCode integerValue] <= 5)) {
                [filterStbResult addObject: currentJourney];
            }
        } else if (transportTypeFilter == stbTramBus) {
            if (([categoryCode integerValue] > 5) && ([categoryCode integerValue] != 8)) {
                [filterStbResult addObject: currentJourney];
            }
        }
    }
    return [filterStbResult count];
}

- (Journey *) getJourneyForStationboardResultFilteredWithTransportTypeFilterWithIndex:(NSUInteger)transportTypeFilter index:(NSUInteger)index {
    NSMutableArray *filterStbResult = [NSMutableArray arrayWithCapacity:2];
    NSArray *stbResult = [self getStationboardResults];
    for (Journey *currentJourney in stbResult) {
        NSString *categoryCodeString = [currentJourney journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        if (transportTypeFilter == stbLongdistanceTrains) {
            if (([categoryCode integerValue] < 3) || ([categoryCode integerValue] == 8)) {
                [filterStbResult addObject: currentJourney];
            }
        } else if (transportTypeFilter == stbRegioTrains) {
            if (([categoryCode integerValue] >= 3) && ([categoryCode integerValue] <= 5)) {
                [filterStbResult addObject: currentJourney];
            }
        } else if (transportTypeFilter == stbTramBus) {
            if (([categoryCode integerValue] > 5) && ([categoryCode integerValue] != 8)) {
                [filterStbResult addObject: currentJourney];
            }
        }
    }
    
    if (index < [filterStbResult count]) {
        return [filterStbResult objectAtIndex: index];
    }
    return nil;
}


- (BasicStop *) getMainBasicStopForStationboardJourney:(Journey *)journey {
    if (journey) {
        return [journey mainstop];
    }
    return nil;
}

- (JourneyHandle *) getJourneyhandleForStationboardJourney:(Journey *)journey {
    if (journey) {
        return [journey journeyHandle];
    }
    return nil;
}

- (NSString *) getDirectionNameForStationboardJourney:(Journey *)journey {
    if (journey) {
        return [journey journeyDirection];
    }
    return nil;
}

-  (NSString *) getDepartureTimeForStationboardJourney:(Journey *)journey {
    if (journey) {
        return [[[journey mainstop] dep] timeString];
    }
    return nil;
}

- (NSString *) getArrivalTimeForStationboardJourney:(Journey *)journey {
    if (journey) {
        return [[[journey mainstop] arr] timeString];
    }
    return nil;
}

- (NSUInteger ) getStationboardJourneyDepartureArrivalForWithStationboardJourney:(Journey *)journey {
    if (journey) {
        if ([[journey mainstop] dep]) {
            return stbDepartureType;
        } else if ([[journey mainstop] arr]) {
            return stbArrivalType;
        }
    }
    return stbDepartureType;
}

- (BOOL) stringContainsObjectFromStringArray:(NSString *)string stringarray:(NSArray *)stringarray {
            
    __block NSString *result = nil;
    [stringarray indexOfObjectWithOptions:NSEnumerationConcurrent
                                 passingTest:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         if ([string rangeOfString:obj].location != NSNotFound)
         {
             result = obj;
             *stop = YES;
             return YES;
         }
         return NO;
     }];
    if (!result) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)getTransportOperatorForJourney:(Journey *)journey {
    
    NSString *transportOperator = [[[journey journeyOperator] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (transportOperator && [transportOperator length] > 0) {
        return transportOperator;
    } else {
        NSString *transportAdministration = [[[journey journeyAdministration] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        if (transportAdministration && [transportAdministration length] > 0) {
            if ([transportAdministration isEqualToString:@"000849"] || [transportAdministration isEqualToString:@"000773"]) {      // 000773
                return @"VBZ";
            }
            if ([transportAdministration isEqualToString:@"000820"] || [transportAdministration isEqualToString:@"000812"] || [transportAdministration isEqualToString:@"000819"]) {  // 000812, 000819
                return @"VBL";
            }
            if ([transportAdministration isEqualToString:@"000823"] || [transportAdministration isEqualToString:@"000037"]) {      // 000037
                return @"BVB";
            }
            /*
            if ([transportAdministration isEqualToString:@"000011"]) {
                return @"SBB";
            }
            */
        } else {
            NSString *journeydirection = [[journey journeyDirection] uppercaseString];
            NSString *categoryCodeString = [journey journeyCategoryCode];
            NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
            //NSString *transportName = [[[journey journeyName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

            if ([categoryCode integerValue] == 6 || [categoryCode integerValue] == 9) {
                if ([self stringContainsObjectFromStringArray: journeydirection stringarray:@[@"ZÜRICH", @"STETTBACH",
                                                                                              @"SCHLIEREN", @"ITSCHNACH",
                                                                                              @"REGENSDORF", @"GLATTBRUGG",
                                                                                              @"WALLISELLEN", @"DÜBENDORF",
                                                                                              @"KÜSNACHT", @"ZOLLIKERBERG",
                                                                                              @"OPFIKON", @"ALTSTETTEN",
                                                                                              @"RÜMLANG", @"UITIKON"]]) {
                    return @"VBZ";
                }
                
                if ([self stringContainsObjectFromStringArray: journeydirection stringarray:@[@"BASEL", @"BINNINGEN",
                                                                                              @"AESCH BL", @"ETTINGEN",
                                                                                              @"FLÜH", @"ETTINGEN",
                                                                                              @"RODERSDORF", @"BIRSFELDEN",
                                                                                              @"PRATTELN", @"RIEHEN",
                                                                                              @"ALLSCHWIL", @"BOTTMINGEN",
                                                                                              @"SCHÖNENBUCH", @"NEUWEG, PARC SOLEIL",
                                                                                              @"DORNACH-ARLESHEIM", @"ST-LOUIS"]]) {
                    return @"BVB";
                }
                
                if ([self stringContainsObjectFromStringArray: journeydirection stringarray:@[@"LUZERN", @"EMMENBRÜCKE",
                                                                                              @"LITTAU", @"OBERNAU",
                                                                                              @"GISIKON-ROOT", @"MEGGEN",
                                                                                              @"KRIENS", @"INWIL",
                                                                                              @"MENZIKEN", @"ROTKREUZ",
                                                                                              @"EIGENTHAL", @"NEUENKIRCH",
                                                                                              @"EMMEN", @"ETTISWIL",
                                                                                              @"RICKENBACK LU", @"UDLIGENSWIL",
                                                                                              @"ADLIGENSWIL", @"UDLIGENSWIL",
                                                                                              @"EBIKON", @"ROTHENBURG",
                                                                                              @"PERLEN", @"HORW"]]) {
                    return @"VBL";
                }
                
            }
            
        }

    }
    return nil;
}

- (UIColor *) getTransportColorWithStationboardJourney:(Journey *)journey {
    //NSString *transportCategoryCode = [journey journeyCategoryCode];
    NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSString *transportOperator = [self getTransportOperatorForJourney: journey];
    
    //NSString *transportAdministration = [[[journey journeyAdministration] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    //NSString *transportName = [[[journey journeyName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *transportNumber = [[[journey journeyNumber] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    
    //NSLog(@"SBBAPIController getTransportImageNameWithConsection:%@,%@,%@,%@,%@,%@.", transportName, transportCategoryCode, transportCategoryName, transportOperator, transportAdministration, transportNumber);
    
    if (transportOperator) {
        if ([transportOperator isEqualToString: @"VBZ"]) {
            if (transportNumber) {
                NSUInteger lineNumber = [transportNumber integerValue];
                if (lineNumber > 0) {
                    UIColor *vbzColor = [self colorForVBZLineNumber: lineNumber];
                    return vbzColor;
                }
            }
        } else if ([transportOperator isEqualToString: @"VBL"]) {
            if (transportNumber) {
                NSUInteger lineNumber = [transportNumber integerValue];
                if (lineNumber > 0) {
                    UIColor *vblColor = [self colorForVBLLineNumber: lineNumber];
                    return vblColor;
                }
            }
        } else if ([transportOperator isEqualToString: @"BVB"]) {
            if (transportNumber) {
                NSUInteger lineNumber = [transportNumber integerValue];
                if (lineNumber > 0) {
                    UIColor *bvbColor = [self colorForBVBLineNumber: lineNumber];
                    return bvbColor;
                }
            }
        }
    } else {
        if (transportCategoryName) {
            return [self colorForSBBTransportCategoryType: transportCategoryName];
        }
    }
    
    //NSLog(@"Color: %@", [[UIColor blueColor] hexStringFromColor]);
    
    return [UIColor darkGrayColor];
}

- (NSString *) getTransportNameWithStationboardJourney:(Journey *)journey {
    NSString *transportName = [journey journeyName];
    
    //NSLog(@"SBBAPIController getTransportNameWithConsection:%@.", transportName);
    
    NSString *categoryCodeString = [journey journeyCategoryCode];
    NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
    //NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    //NSLog(@"Journey name codes: %@, %@", categoryCode, transportCategoryName);
    
    if ([categoryCode integerValue] == 6 || [categoryCode integerValue] == 9) {
        if (transportName && [transportName length] >= 2) {
            NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if (splitname && splitname.count > 1) {
                NSString *shortname = [splitname objectAtIndex: 0];
                if ([shortname isEqualToString: @"T"]) {
                    shortname = @"Tram";
                }
                if ([shortname isEqualToString: @"NFT"]) {
                    shortname = @"Tram";
                }
                if ([shortname isEqualToString: @"TRO"]) {
                    shortname = @"Bus";
                }
                if ([shortname isEqualToString: @"NFB"]) {
                    shortname = @"Bus";
                }
                if ([shortname isEqualToString: @"NFO"]) {
                    shortname = @"Bus";
                }
                NSString *transportnamenew = [NSString stringWithFormat:@"%@ %@", shortname, [splitname objectAtIndex: 1]];
                return transportnamenew;
            }
        }
    }
    
    // T, NFT, NFB, NFO, TRO,
    // Tram, Niederflurtram, Niederflurbus, X, Trolley
    
    
    
    return transportName;
}

- (NSString *) getSimplifiedTransportNameWithStationboardJourney:(Journey *)journey {
    //NSString *transportName = [[journey journeyName] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *transportName = [[self getTransportNameWithStationboardJourney: journey] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (transportName && [transportName length] >= 2) {
        NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        if (splitname && splitname.count > 1) {
            return [splitname objectAtIndex: 0];
        }
        return [transportName substringToIndex: 2];
    }

    return transportName;
}

- (UIImage *) getImageWithTrainImageForStationboardJourney:(Journey *)journey {
    
    UIImage *transportTypeImage = nil;
    
    //NSString *transportCode = [journey journeyCategoryCode];
    NSString *transportName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    //NSLog(@"SBBAPIController getImageWithTrainImageForConsectionWithFramen:%@,%@.", transportCode, transportName);
    
    NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportName];
    if (transportType == transportUnknown) {
        transportTypeImage = [UIImage journeyTransportTrainImage];
    } else if (transportType == transportFastTrain) {
        transportTypeImage = [UIImage journeyTransportTrainFastImage];
    } else if (transportType == transportSlowTrain) {
        transportTypeImage = [UIImage journeyTransportTrainImage];
    } else if (transportType == transportTram) {
        transportTypeImage = [UIImage journeyTransportTramImage];
    } else if (transportType == transportBus) {
        transportTypeImage = [UIImage journeyTransportBusImage];
    } else if (transportType == transportShip) {
        transportTypeImage = [UIImage journeyTransportShipImage];
    } else if (transportType == transportFuni) {
        transportTypeImage = [UIImage journeyTransportFuniImage];
    }
    return transportTypeImage;
}

- (UIImage *) renderTransportNameImageForStationboardJourney:(Journey *)journey {
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(80, 20);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    
    CGRect bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIColor *transportColor = [self getTransportColorWithStationboardJourney:journey];
    NSString *transportName = [self getTransportNameWithStationboardJourney: journey];
    
    CGContextSaveGState(ctx);
    
    addRoundedRectToPath(ctx, bounds, 5, 5);
    CGContextClip(ctx);
    
    CGContextSetFillColorWithColor(ctx, transportColor.CGColor);
    CGContextFillRect(ctx, bounds);
    
    UIColor *textColor;
    if ([transportColor isEqualToColor: [UIColor whiteColor]]) {
        textColor = [UIColor blackColor];
    } else {
        textColor = [UIColor whiteColor];
    }
    
    CGContextSetFillColorWithColor(ctx, textColor.CGColor);
    CGPoint textStartingPoint = CGPointMake(4, 1);
    
    UIGraphicsPushContext(ctx);
    
    CGContextSaveGState(ctx);
    CGAffineTransform save = CGContextGetTextMatrix(ctx);
    CGContextTranslateCTM(ctx, 0.0f, bounds.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    [transportName drawAtPoint: textStartingPoint withFont: [UIFont boldSystemFontOfSize: 15]];
    CGContextSetTextMatrix(ctx, save);
    CGContextRestoreGState(ctx);
    
    UIGraphicsPopContext();
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
    
}

- (UIImage *) renderTransportTypeImageForStationboardJourney:(Journey *)journey {
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(30, 30);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    CGSize typeImageSize = CGSizeMake(imageSize.width * scaleFactor, imageSize.height * scaleFactor);
    
    UIImage *transportTypeImage = [self getImageWithTrainImageForStationboardJourney: journey];
    UIImage *transportTypeImageResized = [transportTypeImage resizedImage: typeImageSize interpolationQuality: kCGInterpolationDefault];
    UIImage *transportTypeImageColored = [UIImage newImageFromMaskImage: transportTypeImageResized inColor: [UIColor detailTableViewCellJourneyInfoImageColor]];
    
    CGContextSaveGState(ctx);
    
    CGRect circleRect = CGRectMake(0, 0,
                                   imageSize.width,
                                   imageSize.height);
    
    
    
    CGContextSetFillColorWithColor(ctx, [UIColor detailTableViewCellJourneyInfoImageBackgroundColor].CGColor);
    CGContextFillEllipseInRect(ctx, circleRect);
    
    CGPoint imageStartingPoint = CGPointMake(5, 5);
    
    CGContextDrawImage(ctx, CGRectMake(imageStartingPoint.x, imageStartingPoint.y, imageSize.width - 10, imageSize.height - 10), [transportTypeImageColored CGImage]);
    /*
     UIGraphicsPushContext(ctx);
     CGContextTranslateCTM(ctx, 0.0f, imageSize.height);
     CGContextScaleCTM(ctx, 1.0f, -1.0f);
     [transportTypeImageColored drawAtPoint:imageStartingPoint];
     UIGraphicsPopContext();
     */
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

- (BOOL) isTrainportTypeEqualToTrainForStationboardJourney:(Journey *)journey {
    
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    //           7       6      6          9      9
    //> 5
    
    if (journey) {
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        
        if ([categoryCode integerValue] <= 5 || [categoryCode integerValue] == 8) {
            return YES;
        }
        
    }
    return NO;
}

/*
- (NSArray *) getDetailedRouteWaypointsForStationboardJourney:(Journey *)journey {
    
    if (!self.stationsDatabaseManagedObjectContext && !self.trainLinesController) {
        return nil;
    }
    
    self.trainLinesController.managedObjectContext = self.stationsDatabaseManagedObjectContext;
    
    if (journey) {
        //NSLog(@"SBBAPIController: getDetailedRouteWaypointsForStationboardJourney. Journey set");
        NSArray *basicStopList = [self getBasicStopsForStationboardJourneyRequestResult: journey];
        if (basicStopList && basicStopList.count >= 2) {
            //NSLog(@"SBBAPIController: getDetailedRouteWaypointsForStationboardJourney. Got basicstoplist");
            NSMutableArray *waypointsResult = [NSMutableArray arrayWithCapacity: 2];
            NSUInteger maxStation = [basicStopList count] - 1;
            if (maxStation > 2) {
                //maxStation = 2;
            }
            for (int i = 0; i < maxStation; i++) {
                Station *startStation = [self getStationForBasicStop: [basicStopList objectAtIndex: i]];
                Station *endStation = [self getStationForBasicStop: [basicStopList objectAtIndex: i+1]];
                //NSLog(@"SBBAPIController: getDetailedRouteWaypointsForStationboardJourney. Get detailedwaypoints");
                NSArray *waypoints = [self.trainLinesController getDetailedRouteWaypointsForStations: startStation end: endStation];
                if (waypoints && waypoints.count >=2) {
                    //NSLog(@"SBBAPIController: getDetailedRouteWaypointsForStationboardJourney. Got waypoints");
                    [waypointsResult addObjectsFromArray: waypoints];
                }
            }
            if (waypointsResult && waypointsResult.count >= 2) {
                return waypointsResult;
            }
        }
    }
    return nil;
}
*/

//--------------------------------------------------------------------------------


- (void) sendJourneyReqXMLJourneyRequest:(Station *)station journeyhandle:(JourneyHandle *)journeyhandle jrnDate:(NSDate *)jrndate departureTime:(BOOL)departureTime successBlock:(void(^)(NSUInteger))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
        
    if (!station.stationName || ! station.stationId || !jrndate || !journeyhandle) {
        return;
    }
    if (!journeyhandle.tnr || ! journeyhandle.cycle || ! journeyhandle.puic) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: jrndate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: jrndate];
    
    NSString *xmlString = kJourneyReq_XML_SOURCE;
    
    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
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
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STATIONID" withString: [station stationId]];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"JRNDATE" withString: dateString];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"JRNTIME" withString: timeString];
    
    if (departureTime) {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"JRNREQTYPE" withString: @"DEP"];
    } else {
        xmlString = [xmlString stringByReplacingOccurrencesOfString: @"JRNREQTYPE" withString: @"ARR"];
    }
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"JRNTNR" withString: journeyhandle.tnr];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"JRNCYCLE" withString: journeyhandle.cycle];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"JRNPUIC" withString: journeyhandle.puic];
    
    #ifdef SBBAPILogLevelXMLReqRes
    NSLog(@"XML String: %@", xmlString);
    #endif
    
    self.stbreqRequestInProgress = YES;
    
    NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
    
    if (self.stbreqHttpClient) {
        [self.stbreqHttpClient cancelAllHTTPOperationsWithMethod: @"POST" path:kSBBXMLAPI_URL_PATH];
        self.stbreqHttpClient = nil;
    }
    
    self.stbreqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [self.stbreqHttpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [self.stbreqHttpClient requestWithMethod:@"POST" path: kSBBXMLAPI_URL_PATH parameters:nil];
    [request setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
    
    [request setTimeoutInterval: self.sbbApiStbreqTimeout];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SUCCESS");
        
        #ifdef SBBAPILogLevelTimeStamp
            [self logTimeStampWithText:@"Jrnreq end operation"];
        #endif
        
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Jrnreq cancelled. Op success block start");
            #endif
            
            if (failureBlock) {
                failureBlock(kJrnReqRequestFailureCancelled);
            }
            return;
        }

        NSBlockOperation *stbreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakStbreqDecodingXMLOperation = stbreqDecodingXMLOperation;
        
        [stbreqDecodingXMLOperation addExecutionBlock: ^(void) {
            
            #ifdef SBBAPILogLevelXMLReqEndRes
            NSLog(@"Result:\n%@",responseString);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"Output directory: %@", documentsDirectory);
            NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_jrn_response.txt"];
            [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
            #endif
            
            //return;
            
            Journey *journey = nil;
            journey = [[Journey alloc] init];
            
            if (responseString)
            {
                NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                
                if ([weakStbreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Jrnreq cancelled. Jrn queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kJrnReqRequestFailureCancelled);
                        }];
                    }
                    return;
                }

                CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                if (xmlResponse)
                {
                    //NSLog(@"XML Response: %@", xmlResponse);
                    CXMLNode *jrnResNode = [xmlResponse nodeForXPath: @"//JourneyRes" error: nil];
                    if (jrnResNode) {
                        for (CXMLElement *currentJourneyResElement in [jrnResNode children]) {
                            
                            if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                #ifdef SBBAPILogLevelCancel
                                NSLog(@"Jrnreq cancelled. Jrn queue block. For each 1");
                                #endif
                                
                                if (failureBlock) {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                        failureBlock(kJrnReqRequestFailureCancelled);
                                    }];
                                }
                                return;
                            }
                            
                            if ([[currentJourneyResElement name] isEqualToString: @"Journey"]) {
                                for (CXMLElement *currentJourneyElement in [currentJourneyResElement children]) {
                                    
                                    if ([weakStbreqDecodingXMLOperation isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Jrnreq cancelled. Jrn queue block. For each 2");
                                        #endif
                                        
                                        if (failureBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                failureBlock(kJrnReqRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
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
                                                        NSString *journeyName = [[journeyAttributeVariantElement stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                        journey.journeyName = journeyName;
                                                        
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
                                                    Arr *arr = [[Arr alloc] init];
                                                    for (CXMLElement *currentArrElement in [basicStopElement children]) {
                                                        if ([[currentArrElement name] isEqualToString: @"Time"]) {
                                                            arr.timeString = [currentArrElement stringValue];
                                                            basicStop.arr = arr;
                                                        } else if ([[currentArrElement name] isEqualToString: @"Platform"]) {
                                                            CXMLNode *platformElements = [currentArrElement childAtIndex: 0];
                                                            NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                            
                                                            #ifdef SBBAPILogLevelFull
                                                            NSLog(@"STB arr platform: %@", platformString);
                                                            #endif
                                                            
                                                            arr.platform = platformString;
                                                        }
                                                    }
                                                } else if ([[basicStopElement name] isEqualToString: @"Dep"]) {
                                                    Dep *dep = [[Dep alloc] init];
                                                    for (CXMLElement *currentDepElement in [basicStopElement children]) {
                                                        if ([[currentDepElement name] isEqualToString: @"Time"]) {
                                                            dep.timeString = [currentDepElement stringValue];
                                                            basicStop.dep = dep;
                                                        } else if ([[currentDepElement name] isEqualToString: @"Platform"]) {
                                                            CXMLNode *platformElements = [currentDepElement childAtIndex: 0];
                                                            NSString *platformString = [[platformElements stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                            
                                                            #ifdef SBBAPILogLevelFull
                                                            NSLog(@"STB dep platform: %@", platformString);
                                                            #endif
                                                            
                                                            dep.platform = platformString;
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
                                                        }
                                                    }
                                                }
                                            }
                                            [journey.passList addObject: basicStop];
                                        }
                                    } else if ([[currentJourneyElement name] isEqualToString: @"JProg"]) {
                                        // To implement
                                    }
                                }
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
            [self logTimeStampWithText:@"Jrnreq end decoding xml"];
            #endif
            
            self.stbreqRequestInProgress = NO;
            
            #ifdef SBBAPILogLevelXMLReqRes
            NSLog(@"Journey pass list stops before filter: %d", journey.passList.count);
            #endif
            
            NSArray *oldPassList = journey.passList;
            NSMutableArray *newPassList =  [NSMutableArray arrayWithArray:  [self filterBasicStopsForStationboardJourneyRequestBasicstopListWithStation: oldPassList station: station deparr: departureTime]];
            journey.passList = newPassList;
            
            #ifdef SBBAPILogLevelXMLReqRes
            NSLog(@"Journey pass list stops after filter: %d", journey.passList.count);
            #endif
            
            if ([weakStbreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Stbreq cancelled. Stb queue block. End. MainQueue call");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kJrnReqRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (journey) {
                            self.journeyResult = journey;
                            NSUInteger numberofnewresults = 0;
                            if (self.journeyResult) {
                                numberofnewresults = 1;
                            }
                            successBlock(numberofnewresults);
                            
                        } else {
                            if (failureBlock) {
                                failureBlock(kStbScrRequestFailureCancelled);
                            }
                        }
                    }];
                }
            }

            
            /*
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (successBlock && !self.stbreqRequestCancelledFlag && (numberofnewresults > 0)) {
                    self.stbreqRequestCancelledFlag = NO;
                    successBlock(numberofnewresults);
                } else {
                    self.stbreqRequestCancelledFlag = NO;
                    
                    //NSUInteger kJrnReqRequestFailureCancelled = 6599;
                    
                    if (failureBlock) {
                        failureBlock(kJrnReqRequestFailureCancelled);
                    }
                }
            });
            */
                        
        }];
        [_stbreqBackgroundOpQueue addOperation: stbreqDecodingXMLOperation];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        self.stbreqRequestInProgress = NO;
        
        //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
        if (failureBlock) {
            failureBlock(kJrnReqRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Jrnreq start operation"];
    #endif
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

- (BOOL) setStationboardJourneyResultWithJourney:(Journey *)journey {
    if (journey && journey.passList && journey.passList.count >= 2) {
        self.journeyResult = journey;
        return YES;
    }
    return NO;
}

- (BOOL) stationboardJourneyHasValidPasslist:(Journey *)journey {
    if (journey && journey.passList && journey.passList.count >= 2) {
        return YES;
    }
    return NO;
}

- (Journey *) getJourneyRequestResult {
    if (self.journeyResult) {
        return self.journeyResult;
    }
    return  nil;
}

- (NSArray *) getBasicStopsForStationboardJourneyRequestResult:(Journey *)journey {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    if (journey) {
        NSArray *passlist = [journey passList];
        for (int i = 0;  i < [passlist count];  i++) {
            BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
            [stationsArray addObject: currentBasicStop];
        }
        return stationsArray;
    }
    return nil;
}

- (NSArray *) filterBasicStopsForStationboardJourneyRequestBasicstopListWithStation:(NSArray *)basicstoplist station:(Station *)station deparr:(BOOL)deparr {
    NSMutableArray *filteredList = [NSMutableArray arrayWithCapacity: 2];
    if (basicstoplist && station) {
        //NSLog(@"Basic stop list and station set");
        if ([basicstoplist count]> 0) {
            //NSLog(@"Basic stop list count bigger 0");
            BOOL stationReached = NO;
            if (deparr) {
                for (BasicStop *currentBasicStop in basicstoplist) {
                    Station *currentStation = [self getStationForBasicStop: currentBasicStop];
                    if (stationReached) {
                        //NSLog(@"Station reached");
                        [filteredList addObject: currentBasicStop];
                    } else {
                        //NSLog(@"Looking for station");
                        //NSLog(@"%@, %@ vs %@, %@", station.stationName, station.stationId, currentStation.stationName, currentStation.stationId);
                        if ([currentStation.stationName isEqualToString: station.stationName]) {
                            [filteredList addObject: currentBasicStop];
                            stationReached = YES;
                        }
                    }
                }
            } else {
                for (BasicStop *currentBasicStop in [basicstoplist reverseObjectEnumerator]) {
                    Station *currentStation = [self getStationForBasicStop: currentBasicStop];
                    if (stationReached) {
                        //NSLog(@"Station reached");
                        [filteredList insertObject: currentBasicStop atIndex: 0];
                    } else {
                        //NSLog(@"Looking for station");
                        //NSLog(@"%@, %@ vs %@, %@", station.stationName, station.stationId, currentStation.stationName, currentStation.stationId);
                        if ([currentStation.stationName isEqualToString: station.stationName]) {
                            [filteredList insertObject: currentBasicStop atIndex: 0];
                            stationReached = YES;
                        }
                    }
                }
            }
            return filteredList;
        }
    }
    return  nil;
}

//--------------------------------------------------------------------------------

- (void) getSbbRssXMLInfoRequest:(NSUInteger)languageCode successBlock:(void(^)(NSUInteger))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    //[self getSbbRssXMLInfoRequestTest:languageCode successBlock:successBlock failureBlock:failureBlock];
    //return;
        
    NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
    
    NSString *detailPath; NSString *locale;
    if (languageCode == reqEnglish) {
        detailPath = kSBBXMLINFOAPI_URL_PATH_EN;
        locale = @"en-us";
    } else if (languageCode == reqGerman) {
        detailPath = kSBBXMLINFOAPI_URL_PATH_DE;
        locale = @"de-de";
    } else if (languageCode == reqFrench) {
        detailPath = kSBBXMLINFOAPI_URL_PATH_FR;
        locale = @"fr-fr";
    } else if (languageCode == reqItalian) {
        detailPath = kSBBXMLINFOAPI_URL_PATH_IT;
        locale = @"it-it";
    } else {
        detailPath = kSBBXMLINFOAPI_URL_PATH_EN;
        locale = @"en-us";
    }
    
    //NSLog(@"Detailpath: %@, %@", detailPath, locale);
        
    if (self.rssreqHttpClient) {
        [self.rssreqHttpClient cancelAllHTTPOperationsWithMethod: @"GET" path:detailPath];
        self.rssreqHttpClient = nil;
    }
    
    self.rssreqRequestInProgress = YES;
    
    self.rssreqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [self.rssreqHttpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [self.rssreqHttpClient requestWithMethod:@"GET" path: detailPath parameters:nil];
    
    [self.rssreqHttpClient setDefaultHeader:@"Accept-Language" value: locale];
    
    [request setTimeoutInterval: self.sbbApiRssreqTimeout];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SUCCESS");
        
        #ifdef SBBAPILogLevelTimeStamp
            [self logTimeStampWithText:@"Rssreq end operation"];
        #endif
        
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Rssreq cancelled. Op success block start");
            #endif
            
            if (failureBlock) {
                failureBlock(kRssReqRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *rssreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakRssreqDecodingXMLOperation = rssreqDecodingXMLOperation;
        
        [rssreqDecodingXMLOperation addExecutionBlock: ^(void) {
            
            #ifdef SBBAPILogLevelXMLReqEndRes
            NSLog(@"RSS Result:\n%@",responseString);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"Output directory: %@", documentsDirectory);
            NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_rss_response.txt"];
            [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
            #endif
            
            //return;
            
            NSMutableArray *tempInfoResults = nil;
            tempInfoResults = [NSMutableArray arrayWithCapacity: 2];
            
            if (responseString)
            {
                NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                
                if ([weakRssreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Rssreq cancelled. Stb queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kRssReqRequestFailureCancelled);
                        }];
                    }
                    return;
                }
                
                CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                if (xmlResponse)
                {
                    //NSLog(@"XML Response: %@", xmlResponse);
                    CXMLNode *infoResNode = [xmlResponse nodeForXPath: @"//channel" error: nil];
                    if (infoResNode) {
                        //NSLog(@"Got channel node");
                        for (CXMLElement *currentInfoResult in [infoResNode children]) {
                            
                            if ([weakRssreqDecodingXMLOperation isCancelled]) {
                                #ifdef SBBAPILogLevelCancel
                                NSLog(@"Rssreq cancelled. Stb queue block. For each 1");
                                #endif
                                
                                if (failureBlock) {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                        failureBlock(kRssReqRequestFailureCancelled);
                                    }];
                                }
                                return;
                            }
                            
                            //NSLog(@"Current channel child: %@", [currentInfoResult name]);
                            if ([[currentInfoResult name] isEqualToString: @"item"]) {
                                RssInfoItem *currentRssInfoResult = [[RssInfoItem alloc] init];
                                for (CXMLElement *currentInfoResultDetail in [currentInfoResult children]) {
                                    
                                    if ([weakRssreqDecodingXMLOperation isCancelled]) {
                                        #ifdef SBBAPILogLevelCancel
                                        NSLog(@"Rssreq cancelled. Stb queue block. For each 2");
                                        #endif
                                        
                                        if (failureBlock) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                failureBlock(kRssReqRequestFailureCancelled);
                                            }];
                                        }
                                        return;
                                    }
                                    
                                    if ([[currentInfoResultDetail name] isEqualToString: @"title"]) {
                                        NSString *titleString = [currentInfoResultDetail stringValue];
                                        titleString = [titleString stringByReplacingOccurrencesOfString: @"![CDATA[" withString: @""];
                                        titleString = [titleString stringByReplacingOccurrencesOfString: @"]]" withString: @""];
                                        currentRssInfoResult.title = titleString;
                                    } else if ([[currentInfoResultDetail name] isEqualToString: @"description"]) {
                                        NSString *descString = [currentInfoResultDetail stringValue];
                                        descString = [descString stringByReplacingOccurrencesOfString: @"![CDATA[" withString: @""];
                                        descString = [descString stringByReplacingOccurrencesOfString: @"]]" withString: @""];
                                        currentRssInfoResult.description = descString;
                                    } else if ([[currentInfoResultDetail name] isEqualToString: @"pubDate"]) {
                                        NSString *pubdateString = [[currentInfoResultDetail stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                                                                
                                        //NSLog(@"Pubdate: %@", pubdateString);
                                        
                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                        //NSLocale *locale = [[[NSLocale alloc]
                                        //                     initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
                                        //[formatter setLocale:locale];
                                        //[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                                        //NSLocale *enLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease];
                                        //[inputFormatter setLocale:enLocale];
                                        //[inputFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZZZ"];
                                        
                                        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ch_DE"];
                                        [dateFormatter setLocale:locale];
                                        
                                        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                                        
                                        NSDate *pubDate = [dateFormatter dateFromString:pubdateString];
                                        
                                        //NSLog(@"Date: %@", pubDate);
                                        
                                        NSDateFormatter *dateFormatterTrans = [[NSDateFormatter alloc] init];
                                        [dateFormatterTrans setDateFormat:@"HH:mm dd/MM/YYYY"];
                                        NSString *dateString = [dateFormatterTrans stringFromDate: pubDate];
                                        
                                        //NSLog(@"PDate: %@", dateString);
                                        
                                        currentRssInfoResult.pubdate = pubDate;
                                        currentRssInfoResult.pubdatestring = dateString;
                                    }
                                }
                                [tempInfoResults addObject: currentRssInfoResult];
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
            [self logTimeStampWithText:@"Rssreq end decoding json"];
            #endif
            
            self.rssreqRequestInProgress = NO;
            
            if ([weakRssreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Rssreq cancelled. Rss queue block. End. MainQueue call");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kRssReqRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (tempInfoResults && tempInfoResults.count > 0) {

                            self.sbbrssinfoResult = tempInfoResults;
                            
                            NSUInteger numberofnewresults = 0;
                            numberofnewresults = self.sbbrssinfoResult.count;
                                                        
                            #ifdef SBBAPILogLevelXMLReqRes
                            NSLog(@"Rss info news: %d", self.sbbrssinfoResult.count);
                            #endif
                            
                            successBlock(numberofnewresults);
                            
                        } else {
                            if (failureBlock) {
                                failureBlock(kRssReqRequestFailureCancelled);
                            }
                        }
                    }];
                }
            }
        }];
        [_rssreqBackgroundOpQueue addOperation: rssreqDecodingXMLOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        self.rssreqRequestInProgress = NO;
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        
        //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
        if (failureBlock) {
            failureBlock(kRssReqRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Rssreq start operation"];
    #endif
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

- (void) getSbbRssXMLInfoRequestTest:(NSUInteger)languageCode successBlock:(void(^)(NSUInteger))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    self.rssreqRequestInProgress = YES;
    
    NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [paths stringByAppendingPathComponent:@"xml_rss_response.txt"];
    NSString *responseString = [NSString stringWithContentsOfFile: htmlPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSBlockOperation *rssreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakRssreqDecodingXMLOperation = rssreqDecodingXMLOperation;
    
    [rssreqDecodingXMLOperation addExecutionBlock: ^(void) {
        
        //#ifdef SBBAPILogLevelXMLReqEndRes
        //NSLog(@"RSS Result:\n%@",responseString);
        
        NSMutableArray *tempInfoResults = nil;
        tempInfoResults = [NSMutableArray arrayWithCapacity: 2];
        
        if (responseString)
        {
            NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
            cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
            
            if ([weakRssreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Rssreq cancelled. Stb queue block. cleanedstring");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kRssReqRequestFailureCancelled);
                    }];
                }
                return;
            }
            
            CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
            if (xmlResponse)
            {
                //NSLog(@"XML Response: %@", xmlResponse);
                CXMLNode *infoResNode = [xmlResponse nodeForXPath: @"//channel" error: nil];
                if (infoResNode) {
                    //NSLog(@"Got channel node");
                    for (CXMLElement *currentInfoResult in [infoResNode children]) {
                        
                        if ([weakRssreqDecodingXMLOperation isCancelled]) {
                            #ifdef SBBAPILogLevelCancel
                            NSLog(@"Rssreq cancelled. Stb queue block. For each 1");
                            #endif
                            
                            if (failureBlock) {
                                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                    failureBlock(kRssReqRequestFailureCancelled);
                                }];
                            }
                            return;
                        }
                        
                        //NSLog(@"Current channel child: %@", [currentInfoResult name]);
                        if ([[currentInfoResult name] isEqualToString: @"item"]) {
                            RssInfoItem *currentRssInfoResult = [[RssInfoItem alloc] init];
                            for (CXMLElement *currentInfoResultDetail in [currentInfoResult children]) {
                                
                                if ([weakRssreqDecodingXMLOperation isCancelled]) {
                                    #ifdef SBBAPILogLevelCancel
                                    NSLog(@"Rssreq cancelled. Stb queue block. For each 2");
                                    #endif
                                    
                                    if (failureBlock) {
                                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                            failureBlock(kRssReqRequestFailureCancelled);
                                        }];
                                    }
                                    return;
                                }
                                
                                if ([[currentInfoResultDetail name] isEqualToString: @"title"]) {
                                    NSString *titleString = [currentInfoResultDetail stringValue];
                                    titleString = [titleString stringByReplacingOccurrencesOfString: @"![CDATA[" withString: @""];
                                    titleString = [titleString stringByReplacingOccurrencesOfString: @"]]" withString: @""];
                                    currentRssInfoResult.title = titleString;
                                } else if ([[currentInfoResultDetail name] isEqualToString: @"description"]) {
                                    NSString *descString = [currentInfoResultDetail stringValue];
                                    descString = [descString stringByReplacingOccurrencesOfString: @"![CDATA[" withString: @""];
                                    descString = [descString stringByReplacingOccurrencesOfString: @"]]" withString: @""];
                                    currentRssInfoResult.description = descString;
                                } else if ([[currentInfoResultDetail name] isEqualToString: @"pubDate"]) {
                                    NSString *pubdateString = [currentInfoResultDetail stringValue];
                                    
                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                    //NSLocale *locale = [[[NSLocale alloc]
                                    //                     initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
                                    //[formatter setLocale:locale];
                                    //[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                                    //NSLocale *enLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease];
                                    //[inputFormatter setLocale:enLocale];
                                    //[inputFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZZZ"];
                                    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                                    
                                    NSDate *pubDate = [dateFormatter dateFromString:pubdateString];
                                    
                                    NSDateFormatter *dateFormatterTrans = [[NSDateFormatter alloc] init];
                                    [dateFormatterTrans setDateFormat:@"HH:mm dd/MM/YYYY"];
                                    NSString *dateString = [dateFormatterTrans stringFromDate: pubDate];
                                    
                                    currentRssInfoResult.pubdate = pubDate;
                                    currentRssInfoResult.pubdatestring = dateString;
                                }
                            }
                            [tempInfoResults addObject: currentRssInfoResult];
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
        [self logTimeStampWithText:@"Rssreq end decoding json"];
        #endif
        
        self.rssreqRequestInProgress = NO;
        
        if ([weakRssreqDecodingXMLOperation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Rssreq cancelled. Rss queue block. End. MainQueue call");
            #endif
            
            if (failureBlock) {
                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                    failureBlock(kRssReqRequestFailureCancelled);
                }];
            }
            return;
        } else {
            if (successBlock) {
                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                    if (tempInfoResults && tempInfoResults.count > 0) {
                        
                        self.sbbrssinfoResult = tempInfoResults;
                        
                        NSUInteger numberofnewresults = 0;
                        numberofnewresults = self.sbbrssinfoResult.count;
                        
                        #ifdef SBBAPILogLevelXMLReqRes
                        NSLog(@"Rss info news: %d", self.sbbrssinfoResult.count);
                        #endif
                        
                        successBlock(numberofnewresults);
                        
                    } else {
                        if (failureBlock) {
                            failureBlock(kRssReqRequestFailureCancelled);
                        }
                    }
                }];

            }
        }
    }];
    [_rssreqBackgroundOpQueue addOperation: rssreqDecodingXMLOperation];
}

- (NSArray *) getSbbRssInfoResults {
    if (self.sbbrssinfoResult) {
        return self.sbbrssinfoResult;
    }
    return  nil;
}

- (NSUInteger) getNumberOfSbbRssInfoResults {
    if (self.sbbrssinfoResult) {
        return self.sbbrssinfoResult.count;
    }
    return 0;
}

- (RssInfoItem *) getSbbRssInfoResultWithIndex:(NSUInteger)index {
    if (self.sbbrssinfoResult) {
        if (self.sbbrssinfoResult.count > 0) {
            if (self.sbbrssinfoResult.count > index) {
                return [self.sbbrssinfoResult objectAtIndex: index];
            }
        }
    }
    return nil;
}

//--------------------------------------------------------------------------------

- (MTDRoute *)getMTDRouteForConsection:(ConSection *)consection {
    if (consection) {
        NSUInteger journeyTypeFlag = [consection conSectionType];
        if (journeyTypeFlag == walkType) {
            NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:consection];
            
            if ([basicStopList count] >= 2) {
                BasicStop *startStop = [basicStopList objectAtIndex: 0];
                BasicStop *endStop = [basicStopList lastObject];
                Station *startStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: startStop];
                Station *endStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: endStop];
                
                CLLocationCoordinate2D from = [[SBBAPIController sharedSBBAPIController] getCoordinatesForStation: startStation];
                CLLocationCoordinate2D to = [[SBBAPIController sharedSBBAPIController] getCoordinatesForStation: endStation];
                NSString *startStationName = [[SBBAPIController sharedSBBAPIController] getStationameForStation:startStation];
                NSString *endStationName = [[SBBAPIController sharedSBBAPIController] getStationameForStation:endStation];
                NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: endStop];
                NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: startStop];
                if (from.latitude != 0 && from.longitude != 0 && to.latitude != 0 && to.longitude != 0) {
                    MTDWaypoint *frompoint = [[MTDWaypoint alloc] initWithCoordinateAndName:from name:startStationName];
                    frompoint.departuretime = departureTime;
                    MTDWaypoint *topoint = [[MTDWaypoint alloc] initWithCoordinateAndName:to name: endStationName];
                    topoint.arrivaltime = arrivalTime;
                    NSArray *walkpoints = [[NSArray alloc] initWithObjects: frompoint, topoint, nil];
                    
                    UIColor *transportColor = [self getTransportColorWithConsection: consection];
                    NSString *transportName = [self getTransportNameWithConsection: consection];
                    
                    MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:walkpoints
                                                                maneuvers:nil
                                                                 distance:[MTDDistance distanceWithMeters:150866.3]
                                                            timeInSeconds:7915
                                                                     name:transportName
                                                                routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                              journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                               routeColor:transportColor
                                                           additionalInfo:nil];
                    return route;
                }
            }
            
        } else if (journeyTypeFlag == journeyType) {
            NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:consection];
            
            if ([basicStopList count] >= 2) {
                NSMutableArray *waypointsArray = [NSMutableArray arrayWithCapacity: 2];
                
                for (int i = 0; i<[basicStopList count]; i++) {
                    Station *currentStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: [basicStopList objectAtIndex: i]];
                    NSNumber *stationLat = [[SBBAPIController sharedSBBAPIController] getLatitudeForStation: currentStation];
                    NSNumber *stationLng = [[SBBAPIController sharedSBBAPIController] getLongitudeForStation: currentStation];
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([stationLat doubleValue], [stationLng doubleValue]);
                    NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationameForStation:currentStation];
                    NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: i]];
                    NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: i]];
                    MTDWaypoint *waypoint = [[MTDWaypoint alloc] initWithCoordinateAndName:coordinate name:stationName];
                    waypoint.departuretime = departureTime;
                    waypoint.arrivaltime = arrivalTime;
                    [waypointsArray addObject: waypoint];
                }
                
                UIColor *transportColor = [self getTransportColorWithConsection: consection];
                NSString *transportName = [self getTransportNameWithConsection: consection];
                
                MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypointsArray
                                                            maneuvers:nil
                                                             distance:[MTDDistance distanceWithMeters:150866.3]
                                                        timeInSeconds:7915
                                                                 name:transportName
                                                            routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                          journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                           routeColor:transportColor
                                                       additionalInfo:nil];
                return route;
            }
        }
    }
    
    return nil;
}

- (NSArray *) getMTDRoutesForConnectionResultWithIndex:(NSUInteger)index {
    NSMutableArray *routesArray = [NSMutableArray arrayWithCapacity:2];
    
    //NSLog(@"getAllBasicStopsForConnectionResultWithIndex: %d", index);
    
    if (self.connectionsResult) {
        if ([self.connectionsResult conResults]) {
            if ([[self.connectionsResult conResults] count] > 0) {
                if ([[self.connectionsResult conResults] count] > index) {
                    if ([[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList] conSections]) {
                        if ([[[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList] conSections] count] > 0) {
                            for (ConSection *currentConsection in [[[[self.connectionsResult conResults] objectAtIndex: index] conSectionList]  conSections]) {
                                
                                MTDRoute *currentRoute = [self getMTDRouteForConsection: currentConsection];
                                [routesArray addObject: currentRoute];
                            }
                                                    
                            return routesArray;
                        }
                    }
                }
            }
        }
    }
    return nil;
}

- (MTDRoute *)getMTDRouteForJourney:(Journey *)journey {
    if (journey) {
        
        //NSLog(@"Journey: %@", journey?@"Y":@"N");
        //NSLog(@"Journey: %@", [journey mainstop]?@"Y":@"N");
        //NSLog(@"Journey: %@", [journey passList]?@"Y":@"N");
        //NSLog(@"Journey: %d", [[journey passList] count]);
        
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
        
        if ([basicStopList count] >= 2) {
            NSMutableArray *waypointsArray = [NSMutableArray arrayWithCapacity: 2];
            
            for (int i = 0; i<[basicStopList count]; i++) {
                Station *currentStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: [basicStopList objectAtIndex: i]];
                NSNumber *stationLat = [[SBBAPIController sharedSBBAPIController] getLatitudeForStation: currentStation];
                NSNumber *stationLng = [[SBBAPIController sharedSBBAPIController] getLongitudeForStation: currentStation];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([stationLat doubleValue], [stationLng doubleValue]);
                NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationameForStation:currentStation];
                NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: i]];
                NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: i]];
                MTDWaypoint *waypoint = [[MTDWaypoint alloc] initWithCoordinateAndName:coordinate name:stationName];
                waypoint.departuretime = departureTime;
                waypoint.arrivaltime = arrivalTime;
                [waypointsArray addObject: waypoint];
            }
            
            UIColor *transportColor = [self getTransportColorWithStationboardJourney: journey];
            NSString *transportName = [self getTransportNameWithStationboardJourney: journey];
            
            MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypointsArray
                                                        maneuvers:nil
                                                         distance:[MTDDistance distanceWithMeters:150866.3]
                                                    timeInSeconds:7915
                                                             name:transportName
                                                        routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                      journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                       routeColor:transportColor
                                                   additionalInfo:nil];
            return route;
        }
    }
    
    return nil;
}


- (BOOL) coordinatesAreSet:(CLLocationCoordinate2D)coordinates {
    return (coordinates.latitude != 0 && coordinates.longitude != 0);
}

- (MTDRoute *)getMTDWalkingRouteForConsection:(ConSection *)consection {
    if (consection) {
        NSUInteger journeyTypeFlag = [consection conSectionType];
        if (journeyTypeFlag == walkType) {
            NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:consection];
            
            if ([basicStopList count] >= 2) {
                BasicStop *startStop = [basicStopList objectAtIndex: 0];
                BasicStop *endStop = [basicStopList lastObject];
                Station *startStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: startStop];
                Station *endStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: endStop];
                
                CLLocationCoordinate2D from = [[SBBAPIController sharedSBBAPIController] getCoordinatesForStation: startStation];
                CLLocationCoordinate2D to = [[SBBAPIController sharedSBBAPIController] getCoordinatesForStation: endStation];
                NSString *startStationName = [[SBBAPIController sharedSBBAPIController] getStationameForStation:startStation];
                NSString *endStationName = [[SBBAPIController sharedSBBAPIController] getStationameForStation:endStation];
                NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: endStop];
                NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: startStop];
                if (from.latitude != 0 && from.longitude != 0 && to.latitude != 0 && to.longitude != 0) {
                    MTDWaypoint *frompoint = [[MTDWaypoint alloc] initWithCoordinateAndName:from name:startStationName];
                    frompoint.departuretime = departureTime;
                    MTDWaypoint *topoint = [[MTDWaypoint alloc] initWithCoordinateAndName:to name: endStationName];
                    topoint.arrivaltime = arrivalTime;
                    NSArray *walkpoints = [[NSArray alloc] initWithObjects: frompoint, topoint, nil];
                    
                    UIColor *transportColor = [self getTransportColorWithConsection: consection];
                    NSString *transportName = [self getTransportNameWithConsection: consection];
                    
                    MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:walkpoints
                                                                maneuvers:nil
                                                                 distance:[MTDDistance distanceWithMeters:150866.3]
                                                            timeInSeconds:7915
                                                                     name:transportName
                                                                routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                              journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                               routeColor:transportColor
                                                           additionalInfo:nil];
                    return route;
                }
            }
            
        }
    
    }
    return nil;
}

- (void)sendMTDDetailedWalkingDirectionsRouteForConsection:(ConSection *)consection successBlock:(void(^)(NSArray *routes))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    [self.mtdDirectionsRequest cancel];
    
    if (consection) {
        
        if (consection.routes && consection.routes.count > 0) {
            if (successBlock) {
                successBlock(consection.routes);
            }
            return;
        }
        
        NSArray *stationsList = [[SBBAPIController sharedSBBAPIController] getStationsForConsection: consection];
        
        CLLocationCoordinate2D from = [[SBBAPIController sharedSBBAPIController] getCoordinatesForStation: [stationsList objectAtIndex: 0]];
        CLLocationCoordinate2D to = [[SBBAPIController sharedSBBAPIController] getCoordinatesForStation: [stationsList lastObject]];
        
        if ([self coordinatesAreSet: from] && [self coordinatesAreSet: to]) {
            
            if (MTDDirectionsSupportsAppleMaps()) {
                
                MTDDirectionsSetActiveAPI(MTDDirectionsAPIMapQuest);
                                
                NSLocale *mapApiLocale;
                NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
                
                #ifdef LOGOUTPUTON
                NSLog(@"Language code for map api locale: %@", languageCode);
                #endif
                
                if ([languageCode isEqualToString:@"en"]) {
                    mapApiLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
                } else if ([languageCode isEqualToString:@"de"]) {
                    mapApiLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"de_DE"];
                } else if ([languageCode isEqualToString:@"fr"]) {
                    mapApiLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"fr_FR"];
                } else if ([languageCode isEqualToString:@"it"]) {
                    mapApiLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"it_IT"];
                } else {
                    mapApiLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
                }
                
                if (mapApiLocale) {
                    //NSLog(@"Could create maps api local with identifier");
                    MTDDirectionsSetLocale(mapApiLocale);
                }
                
                //__weak SBBAPIController *weakSelf = self;
                
                [self.mtdDirectionsRequest cancel];
                
                self.mtdDirectionsRequest = [MTDDirectionsRequest requestDirectionsAPI:MTDDirectionsGetActiveAPI()
                                                                                  from:[MTDWaypoint waypointWithCoordinate:from]
                                                                                    to:[MTDWaypoint waypointWithCoordinate:to]
                                                                     intermediateGoals:nil
                                                                             routeType:MTDDirectionsRouteTypePedestrian
                                                                               options:MTDDirectionsRequestOptionNone
                                                                            completion:^(MTDDirectionsOverlay *overlay, NSError *error) {
                                                                                //__strong SBBAPIController *strongSelf = weakSelf;
                                                                                if (overlay != nil) {
                                                                                    if (overlay.routes && [overlay.routes count] > 0) {
                                                                                        if (successBlock) {
                                                                                            
                                                                                            if (overlay && overlay.routes.count > 0) {
                                                                                                consection.routes = [overlay.routes copy];
                                                                                            }
                                                                                            
                                                                                            MTDRoute *walkingroute = [overlay.routes objectAtIndex:0];
                                                                                            walkingroute.routeColor = [UIColor lightGrayColor];
                                                                                            walkingroute.name = @"WALK";
                                                                                            
                                                                                            NSArray *routes = [NSArray arrayWithObject: walkingroute];
                                                                                            successBlock(routes);
                                                                                        }
                                                                                    } else {
                                                                                        if (failureBlock) {
                                                                                            failureBlock(kMTDWalkingDirectionsRequestNoResult);
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }];
                
                [self.mtdDirectionsRequest start];
                
            }
        }
    }
}
    
- (void) cancelSBBAPIWalkingDirectionsOperations {
    if (self.mtdDirectionsRequest) {
        [self.mtdDirectionsRequest cancel];
    }
}

//--------------------------------------------------------------------------------

- (void) sendValidationReqXMLValidationRequest:(NSString *)stationname successBlock:(void(^)(NSArray *))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    if (!stationname) {
        return;
    }
    
    NSString *xmlString = kValidationReq_XML_SOURCE;
    
    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
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
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"STATIONNAME" withString: stationname];
        
    #ifdef SBBAPILogLevelXMLReqRes
    NSLog(@"XML String: %@", xmlString);
    #endif
    
    self.valreqRequestInProgress = YES;
    
    NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
    
    if (self.valreqHttpClient) {
        [self.valreqHttpClient cancelAllHTTPOperationsWithMethod: @"POST" path:kSBBXMLAPI_URL_PATH];
        self.valreqHttpClient = nil;
    }
    
    self.valreqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [self.valreqHttpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [self.valreqHttpClient requestWithMethod:@"POST" path: kSBBXMLAPI_URL_PATH parameters:nil];
    [request setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
    
    [request setTimeoutInterval: self.sbbApiValreqTimeout];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SUCCESS");
        
        #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Valreq end operation"];
        #endif
        
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Valreq cancelled. Op success block start");
            #endif
            
            if (failureBlock) {
                failureBlock(kValReqRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *valreqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakValreqDecodingXMLOperation = valreqDecodingXMLOperation;
        
        NSMutableArray *tempvalidatedstations = [NSMutableArray array];
        
        [valreqDecodingXMLOperation addExecutionBlock: ^(void) {
            
            #ifdef SBBAPILogLevelXMLReqEndRes
            NSLog(@"Result:\n%@",responseString);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"Output directory: %@", documentsDirectory);
            NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_val_response.txt"];
            [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
            #endif
            
            //return;
                        
            if (responseString)
            {
                NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                
                if ([weakValreqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Valreq cancelled. Val queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kValReqRequestFailureCancelled);
                        }];
                    }
                    return;
                }
                
                CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                if (xmlResponse)
                {
                    //NSLog(@"XML Response: %@", xmlResponse);
                    CXMLNode *valResNode = [xmlResponse nodeForXPath: @"//LocValRes" error: nil];
                    if (valResNode) {
                        for (CXMLElement *currentValidationResElement in [valResNode children]) {
                            
                            //NSLog(@"Result: %@", [currentValidationResElement name]);
                            
                            if ([weakValreqDecodingXMLOperation isCancelled]) {
                                #ifdef SBBAPILogLevelCancel
                                NSLog(@"Valreq cancelled. Val queue block. cleanedstring");
                                #endif
                                
                                if (failureBlock) {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                        failureBlock(kValReqRequestFailureCancelled);
                                    }];
                                }
                                return;
                            }
                            
                            if ([[currentValidationResElement name] isEqualToString: @"Station"]) {
                                Station *station = [[Station alloc] init];
                                station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"name"] stringValue]];
                                station.stationId = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"externalId"] stringValue]];
                                double latitude = [[[currentValidationResElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                double longitude = [[[currentValidationResElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                station.latitude = [NSNumber numberWithFloat: latitude];
                                station.longitude = [NSNumber numberWithFloat: longitude];
                                [tempvalidatedstations addObject: station];
                                
                                //NSLog(@"Station: %@, %@, %.6f, %.6f", station.stationName, station.stationId, [station.latitude doubleValue], [station.longitude doubleValue]);
                            }
                            
                            if ([[currentValidationResElement name] isEqualToString: @"ReqLoc"]) {
                                //NSString *refine = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"refine"] stringValue]];
                                //NSString *type = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"type"] stringValue]];
                                //NSString *output = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"output"] stringValue]];
                                
                                Station *station = [[Station alloc] init];
                                station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"output"] stringValue]];
                                [tempvalidatedstations addObject: station];
                                
                                //NSLog(@"Reqloc: %@, %@, %@", refine, type, output);
                            }
                            
                            if ([[currentValidationResElement name] isEqualToString: @"Poi"]) {
                                Station *station = [[Station alloc] init];
                                station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"name"] stringValue]];
                                double latitude = [[[currentValidationResElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                double longitude = [[[currentValidationResElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                station.latitude = [NSNumber numberWithFloat: latitude];
                                station.longitude = [NSNumber numberWithFloat: longitude];
                                [tempvalidatedstations addObject: station];
                                
                                //NSLog(@"Poi: %@, %.6f, %.6f", station.stationName, [station.latitude doubleValue], [station.longitude doubleValue]);
                            }
                            
                            if ([[currentValidationResElement name] isEqualToString: @"Address"]) {
                                
                                Station *station = [[Station alloc] init];
                                station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"name"] stringValue]];
                                double latitude = [[[currentValidationResElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                double longitude = [[[currentValidationResElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                station.latitude = [NSNumber numberWithFloat: latitude];
                                station.longitude = [NSNumber numberWithFloat: longitude];
                                [tempvalidatedstations addObject: station];
                                
                                //NSLog(@"Address: %@, %.6f, %.6f", station.stationName, [station.latitude doubleValue], [station.longitude doubleValue]);
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
            [self logTimeStampWithText:@"Valreq end decoding xml"];
            #endif
            
            self.valreqRequestInProgress = NO;
            
            if ([weakValreqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Valreq cancelled. Val queue block. cleanedstring");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kValReqRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (tempvalidatedstations && tempvalidatedstations.count > 0) {
                            NSArray *stationsarray = [NSArray arrayWithArray: tempvalidatedstations];
                            successBlock(stationsarray);
                        } else {
                            if (failureBlock) {
                                failureBlock(kValReqRequestFailureNoNewResults);
                            }
                        }
                    }];
                }
            }
            
            
            /*
             dispatch_async(dispatch_get_main_queue(), ^(void) {
             if (successBlock && !self.stbreqRequestCancelledFlag && (numberofnewresults > 0)) {
             self.stbreqRequestCancelledFlag = NO;
             successBlock(numberofnewresults);
             } else {
             self.stbreqRequestCancelledFlag = NO;
             
             //NSUInteger kJrnReqRequestFailureCancelled = 6599;
             
             if (failureBlock) {
             failureBlock(kJrnReqRequestFailureCancelled);
             }
             }
             });
             */
            
        }];
        [_valreqBackgroundOpQueue addOperation: valreqDecodingXMLOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        self.valreqRequestInProgress = NO;
        
        //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
        if (failureBlock) {
            failureBlock(kValReqRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
    [self logTimeStampWithText:@"Valreq start operation"];
    #endif
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

//--------------------------------------------------------------------------------

- (void) sendClosestStationsReqXMLValidationRequest:(CLLocationCoordinate2D)stationcoordinate successBlock:(void(^)(NSArray *))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    NSString *xmlString = kClosestStationsReq_XML_SOURCE;
    
    #ifdef SBBAPILogLevelReqEnterExit
    NSLog(@"Put together XML request");
    #endif
    
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
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"End poi set: %.6f, %.6f", stationcoordinate.latitude , stationcoordinate.longitude);
    #endif
    
    int latitude = (int)(stationcoordinate.latitude * 1000000);
    int longitude = (int)(stationcoordinate.longitude * 1000000);
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"LATITUDE" withString: [NSString stringWithFormat: @"%d", latitude]];
    xmlString = [xmlString stringByReplacingOccurrencesOfString: @"LONGITUDE" withString: [NSString stringWithFormat: @"%d", longitude]];
    
    #ifdef SBBAPILogLevelXMLReqRes
    NSLog(@"XML String: %@", xmlString);
    #endif
    
    self.stareqRequestInProgress = YES;
    
    NSURL *baseURL = [NSURL URLWithString: kSBBXMLAPI_BASE_URL];
    
    if (self.stareqHttpClient) {
        [self.stareqHttpClient cancelAllHTTPOperationsWithMethod: @"POST" path:kSBBXMLAPI_URL_PATH];
        self.stareqHttpClient = nil;
    }
    
    self.stareqHttpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [self.stareqHttpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [self.stareqHttpClient requestWithMethod:@"POST" path: kSBBXMLAPI_URL_PATH parameters:nil];
    [request setHTTPBody: [xmlString dataUsingEncoding: NSISOLatin1StringEncoding]];
    
    [request setTimeoutInterval: self.sbbApiStareqTimeout];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SUCCESS");
        
        #ifdef SBBAPILogLevelTimeStamp
        [self logTimeStampWithText:@"Valreq end operation"];
        #endif
        
        NSString *responseString = [operation responseString];
        
        if ([operation isCancelled]) {
            #ifdef SBBAPILogLevelCancel
            NSLog(@"Valreq cancelled. Op success block start");
            #endif
            
            if (failureBlock) {
                failureBlock(kValReqRequestFailureCancelled);
            }
            return;
        }
        
        NSBlockOperation *stareqDecodingXMLOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakStareqDecodingXMLOperation = stareqDecodingXMLOperation;
        
        NSMutableArray *tempvalidatedstations = [NSMutableArray array];
        
        [stareqDecodingXMLOperation addExecutionBlock: ^(void) {
            
            #ifdef SBBAPILogLevelXMLReqEndRes
            NSLog(@"Result:\n%@",responseString);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"Output directory: %@", documentsDirectory);
            NSString *outputFile =  [documentsDirectory stringByAppendingPathComponent: @"xml_val_response.txt"];
            [responseString writeToFile: outputFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
            #endif
            
            //return;
            
            if (responseString)
            {
                NSString *cleanedString = [responseString stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
                cleanedString = [cleanedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                
                if ([weakStareqDecodingXMLOperation isCancelled]) {
                    #ifdef SBBAPILogLevelCancel
                    NSLog(@"Valreq cancelled. Val queue block. cleanedstring");
                    #endif
                    
                    if (failureBlock) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            failureBlock(kValReqRequestFailureCancelled);
                        }];
                    }
                    return;
                }
                
                CXMLDocument *xmlResponse = [[CXMLDocument alloc] initWithXMLString: cleanedString options:0 error:nil];
                if (xmlResponse)
                {
                    //NSLog(@"XML Response: %@", xmlResponse);
                    CXMLNode *valResNode = [xmlResponse nodeForXPath: @"//LocValRes" error: nil];
                    if (valResNode) {
                        for (CXMLElement *currentValidationResElement in [valResNode children]) {
                            
                            //NSLog(@"Result: %@", [currentValidationResElement name]);
                            
                            if ([weakStareqDecodingXMLOperation isCancelled]) {
                                #ifdef SBBAPILogLevelCancel
                                NSLog(@"Valreq cancelled. Val queue block. cleanedstring");
                                #endif
                                
                                if (failureBlock) {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                        failureBlock(kValReqRequestFailureCancelled);
                                    }];
                                }
                                return;
                            }
                            
                            if ([[currentValidationResElement name] isEqualToString: @"Station"]) {
                                Station *station = [[Station alloc] init];
                                station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"name"] stringValue]];
                                station.stationId = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"externalId"] stringValue]];
                                double latitude = [[[currentValidationResElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                                double longitude = [[[currentValidationResElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                                station.latitude = [NSNumber numberWithFloat: latitude];
                                station.longitude = [NSNumber numberWithFloat: longitude];
                                [tempvalidatedstations addObject: station];
                                
                                //NSLog(@"Station: %@, %@, %.6f, %.6f", station.stationName, station.stationId, [station.latitude doubleValue], [station.longitude doubleValue]);
                            }
                            /*
                             if ([[currentValidationResElement name] isEqualToString: @"ReqLoc"]) {
                             //NSString *refine = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"refine"] stringValue]];
                             //NSString *type = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"type"] stringValue]];
                             //NSString *output = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"output"] stringValue]];
                             
                             Station *station = [[Station alloc] init];
                             station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"output"] stringValue]];
                             [tempvalidatedstations addObject: station];
                             
                             //NSLog(@"Reqloc: %@, %@, %@", refine, type, output);
                             }
                             
                             if ([[currentValidationResElement name] isEqualToString: @"Poi"]) {
                             Station *station = [[Station alloc] init];
                             station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"name"] stringValue]];
                             double latitude = [[[currentValidationResElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                             double longitude = [[[currentValidationResElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                             station.latitude = [NSNumber numberWithFloat: latitude];
                             station.longitude = [NSNumber numberWithFloat: longitude];
                             [tempvalidatedstations addObject: station];
                             
                             //NSLog(@"Poi: %@, %.6f, %.6f", station.stationName, [station.latitude doubleValue], [station.longitude doubleValue]);
                             }
                             
                             if ([[currentValidationResElement name] isEqualToString: @"Address"]) {
                             
                             Station *station = [[Station alloc] init];
                             station.stationName = [self fromISOLatinToUTF8: [[currentValidationResElement attributeForName: @"name"] stringValue]];
                             double latitude = [[[currentValidationResElement attributeForName: @"y"] stringValue] doubleValue] / 1000000;
                             double longitude = [[[currentValidationResElement attributeForName: @"x"] stringValue] doubleValue] / 1000000;
                             station.latitude = [NSNumber numberWithFloat: latitude];
                             station.longitude = [NSNumber numberWithFloat: longitude];
                             [tempvalidatedstations addObject: station];
                             
                             //NSLog(@"Address: %@, %.6f, %.6f", station.stationName, [station.latitude doubleValue], [station.longitude doubleValue]);
                             }
                             */
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
            [self logTimeStampWithText:@"Valreq end decoding xml"];
            #endif
            
            self.stareqRequestInProgress = NO;
            
            if ([weakStareqDecodingXMLOperation isCancelled]) {
                #ifdef SBBAPILogLevelCancel
                NSLog(@"Valreq cancelled. Val queue block. cleanedstring");
                #endif
                
                if (failureBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        failureBlock(kValReqRequestFailureCancelled);
                    }];
                }
                return;
            } else {
                if (successBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                        if (tempvalidatedstations && tempvalidatedstations.count > 0) {
                            NSArray *stationsarray = [NSArray arrayWithArray: tempvalidatedstations];
                            successBlock(stationsarray);
                        } else {
                            if (failureBlock) {
                                failureBlock(kValReqRequestFailureNoNewResults);
                            }
                        }
                    }];
                }
            }
            
            
            /*
             dispatch_async(dispatch_get_main_queue(), ^(void) {
             if (successBlock && !self.stbreqRequestCancelledFlag && (numberofnewresults > 0)) {
             self.stbreqRequestCancelledFlag = NO;
             successBlock(numberofnewresults);
             } else {
             self.stbreqRequestCancelledFlag = NO;
             
             //NSUInteger kJrnReqRequestFailureCancelled = 6599;
             
             if (failureBlock) {
             failureBlock(kJrnReqRequestFailureCancelled);
             }
             }
             });
             */
            
        }];
        [_stareqBackgroundOpQueue addOperation: stareqDecodingXMLOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
        self.stareqRequestInProgress = NO;
        
        //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
        if (failureBlock) {
            failureBlock(kValReqRequestFailureConnectionFailed);
        }
    }];
    
    #ifdef SBBAPILogLevelTimeStamp
    [self logTimeStampWithText:@"Valreq start operation"];
    #endif
    
    [operation start];
    
    #ifdef SBBAPILogLevelFull
    NSLog(@"XML request send");
    #endif
}

@end
