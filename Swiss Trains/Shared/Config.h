//
//  Config.h
//  Swiss Trains
//
//  Created by Alain on 21.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#ifndef Swiss_Trains_Config_h
#define Swiss_Trains_Config_h

#define IncludeDetailedTrainlinesiPad     1
#define IncludeDetailedTrainlinesiPhone   1

#define IncludeAddressStationSearch       1
#define IncludeAlarmAndAddToCalendar      1

#define DeviceAlreadyRegisteredForRemoteNotificationFlagfile @"rnff.plist" 

//--------------------------------------------------------------------------
// Swiss Transit Pro for iPhone and iPad

#define AppIDIPAD                   @"7"
#define AppVersionIPAD              @"2.2"
#define AppStoreIDIPAD              591894604
#define AppStoreURLAPIPAD           @"swiss-transit-for-ipad"
#define AppIdentifieriPad           @"ch.fasoft.swisstransitipad"

#define AppIDIPHONE                 @"6"
#define AppVersionIPHONE            @"2.2"
#define AppStoreIDIPHONE            591891637
#define AppStoreURLAPIPHONE         @"swiss-transit"
#define AppIdentifieriPhone         @"ch.fasoft.swisstransitiphone"

#define kAppCategory                @"Travel"
#define kAppNameiPhone              @"Swiss Transit"
#define kAppNameiPad                @"Swiss Transit (for iPad)"
#define kAppSeller                  @"Alain Furter"
#define kAppStoreCountry            @"CH"
#define kBundleIconImage            @"icon.png"

#define kUTControllerAppNameiPhone  @"STRANSIPHONE2.2"
#define kUTControllerAppNameiPad    @"STRANSIPAD2.2"

#define kITellAFriendImageURLBig    @"http://www.zonezeroapps.com/swisstransit/icons/itellafriendiconB.png"
#define kITellAFriendImageURLMedium @"http://www.zonezeroapps.com/swisstransit/icons/itellafriendiconM.png"
#define kITellAFriendImageURLSmall  @"http://www.zonezeroapps.com/swisstransit/icons/itellafriendiconS.png"

// Twitter settings
#define kTwitterUsername            @"swisstransit"

// Facebook settings
#define kFacebookAppID              @"XXXXXXXXXXXXX"

// Support
#define kSupportEmail               @"support@zonezeroapps.com"

//#define LOGOUTPUTON 1

#define REQSEGCONTROLHEIGHT            36.0
#define REQSEGCONTROLWIDTH            320.0
#define SCALEFACTORREQSEQCONTROLINFO    0.6
#define SCALEFACTORREQSEQCONTROLGO      1.0


#define TOOLBARHEIGHT                  34.0
#define TOOLBARWIDTH                  320.0
#define SCALEFACTORTOOLBARBUTTON        1.0

#define CONJRNTOPINFOBARHEIGHT         46.0
#define CONJRNBOTTOMINFOBARHEIGHT      35.0

#define BUTTONHEIGHT                   36.0
#define TEXTFIELDHEIGHT                30.0
#define SEGMENTHEIGHT                  18.0

#define INTROSHOWNFLAGFILE             @"introshown.plist"

//#define kCreateDBNew 1

//#define kTestXMLWithoutInet 1

#define kJourneyStationsListFile       @"JStationsListFile"

//iPad
#define TABBARICONIMAGESCALEFACTOR      2.0
#define TABBARICONIMAGEHEIGHT          18.0
#define TOOLBARHEIGHTIPAD              34.0
#define SPLITVIEWDIVIDERWIDTH           2.0
#define SPLITVIEWMAINVIEWWIDTH        320.0
#define STATUSBARHEIGHT                20.0
#define TABBARHEIGHT                   49.0
#define STATIONPICKERSEARCHVIEWWIDTHP 250.0
#define STATIONPICKERMAPVIEWWIDTHP    320.0
#define STATIONPICKERLISTVIEWWIDTHP   250.0
#define STATIONPICKERSEARCHVIEWWIDTHL 250.0
#define STATIONPICKERMAPVIEWWIDTHL    320.0
#define STATIONPICKERLISTVIEWWIDTHL   250.0
#define LISTVIEWCONTROLLERHEIGHTPAD    50.0

#define KEYBOARDHEIGHTPORTRAIT        264.0
#define KEYBOARDHEIGHTLANDSCAPE       352.0

#define IPADMOVIEWIDTH                480.0
#define IPADMOVIEHEIGHT               360.0
#define IPADMOVIESCALEFACTOR            1.1


#define IPHONEMOVIEWIDTH              480.0
#define IPHONEMOVIEHEIGHT             360.0
#define IPHONEMOVIESCALEFACTOR          0.8

//#define FORCESHOWINTRO                  1.0

enum connectionJourneyConsectionTypeiPad {
    consectionWalkTypeiPad = 1,
    conSectionJourneyTypeiPad = 2,
    consectionAllTypeiPad = 3
};

enum selectedRequestType {
    conreqRequestType = 1,
    stbRequestType = 2,
    delayinfoRequestType = 3
};

enum currentlyPushedViewControllerCode {
    noViewController = 0,
    connectionsViewController = 1,
    stationboardViewController = 2,
    settingsViewController = 3,
    rssdetailViewController = 4,
    stationsPickerViewController = 5,
    dateAndTimePickerViewController = 6
};

enum currentlyPushedViewControllerConnectionsContainerCodeiPad {
    noViewControllerConnectionsContaineriPad = 0,
    stationsPickerViewControllerConnectionsContaineriPad = 1,
    connectionsViewControllerConnectionsContaineriPad = 2,
    dateAndTimePickerViewControllerConnectionsContaineriPad = 3,
    connectionsListViewControllerConnectionsContaineriPad = 4,
    appSettingsViewControllerConnectionsContaineriPad = 5,
    stationboardResultViewControllerStationboardContaineriPad = 6,
    stationboardListViewControllerStationboardContaineriPad = 7,
    noViewControllerStationboardContaineriPad = 8,
    introViewControllerConnectionsContaineriPad = 9
};

enum stationTypeIndexesiPad {
    startStationTypeiPad = 1,
    endStationTypeiPad = 2,
    viaStationTypeiPad = 3
};

enum stationpickerType {
    connectionsStationpickerType = 1,
    stationboardStationpickerType = 2
};

#define AnnotationDelayiPad 2.0
#define searchSpaniPad  0.00719942
#define mapSpaniPad  1600

#define SECS_OLD_MAX 5.0f
#define MIN_OLD_MAX  300.0f

#define AnnotationDelay  2.0
#define searchSpan  0.00719942
#define mapSpan  1600

#endif
