//
//  SBBAPIOperationsDefinitions.h
//  Swiss Trains
//
//  Created by Alain on 24.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#ifndef Swiss_Trains_SBBAPIOperationsDefinitions_h
#define Swiss_Trains_SBBAPIOperationsDefinitions_h

#import "Connections.h"
#import "ConResult.h"
#import "ConSection.h"
#import "Journey.h"

#import "Station.h"

#import "ConnectionInfo.h"

#define kConRegRequestFailureNoNewResults 8568
#define kConReqRequestFailureConnectionFailed 85
#define kConReqRequestFailureCancelled 8599

#define kSbbReqStationsNotDefined 112

#define SBBAPIREQUESTCONREQSTANDARDTIMEOUT 60

typedef void (^SBBAPIConreqRequestSuccessCompletionBlock)(Connections *);
typedef void (^SBBAPIConreqRequestFailureCompletionBlock)(NSUInteger);
typedef void (^SBBAPIConreqRequestErrorReportingBlock)(NSString *);

typedef void (^SBBAPIConscrRequestSuccessCompletionBlock)(NSArray *);
typedef void (^SBBAPIConscrRequestFailureCompletionBlock)(NSUInteger);

typedef void (^SBBAPIStbreqRequestSuccessCompletionBlock)(NSArray *);
typedef void (^SBBAPIStbscrRequestFailureCompletionBlock)(NSUInteger);

typedef void (^SBBAPIJrnreqRequestSuccessCompletionBlock)(Journey *);
typedef void (^SBBAPIJrnreqRequestFailureCompletionBlock)(NSUInteger);

enum sbbrequestLanguageCodes {
    reqEnglish = 1,
    reqGerman = 2,
    reqFrench = 3,
    reqItalian = 4
};

#define kConReq_XML_SOURCE                  @"<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC lang=\"APILOCALE\" prod=\"iPhone3.1\" ver=\"2.3\" accessId=\"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1\"><ConReq>STARTXMLENDXMLCONVIAXML<ReqT a=\"ARRDEPCODE\" date=\"CONDATE\" time=\"CONTIME\" /><RFlags b=\"0\" f=\"NUMBEROFREQUESTS\" sMode=\"N\"/></ConReq></ReqC>"


#define kConReq_XML_VIA_SOURCE              @"<Via><Station name=\"VIASTATIONNAME\" externalId=\"VIASTATIONID\"/><Prod prod=\"VIAPRODUCTCODE\"/></Via>"

#define kConReq_XML_START_STATION_SOURCE    @"<Start><Station name=\"STARTSTATIONNAME\" externalId=\"STARTSTATIONID\"/><Prod prod=\"PRODUCTCODE\"/></Start>"
#define kConReq_XML_START_POI_SOURCE        @"<Start><Coord type=\"WGS84\" z=\"\" y=\"LATITUDE\" x=\"LONGITUDE\"/><Prod  prod=\"PRODUCTCODE\"/></Start>"

#define kConReq_XML_END_STATION_SOURCE      @"<Dest><Station name=\"ENDSTATIONNAME\" externalId=\"ENDSTATIONID\"/></Dest>"
#define kConReq_XML_END_POI_SOURCE          @"<Dest><Coord type=\"WGS84\" z=\"\" y=\"LATITUDE\" x=\"LONGITUDE\"/></Dest>"



#define kPRODUCT_CODE_ALL                   @"1111111111000000"
#define kPRODUCT_CODE_LONGDISTANCETRAIN     @"1110000000000000"
#define kPRODUCT_CODE_REGIOTRAIN            @"0001110000000000"
#define kPRODUCT_CODE_TRAM_BUS              @"0000001111000000"

#define kSBBXMLAPI_BASE_URL                 @"http://fahrplan.sbb.ch/"
#define kSBBXMLAPI_URL_PATH                 @"bin/extxml.exe"
#define kSBBXMLAPI_KEY                      @"YJpyuPISerpXNNRTo50fNMP0yVu7L6IMuOaBgS0Xz89l3f6I3WhAjnto4kS9oz1"

#define kERROR_REPORTING_URL_PATH           @"swisstransit/servers/errorlogserver/registerlogentry.php"

#endif
