//
//  AppDelegate.h
//  Swiss Trains
//
//  Created by Alain on 20.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

//iPhone
#import "SelectStationsViewController.h"

//iPad
#import "JBTabBarController.h"
#import "ConnectionsContainerViewControlleriPad.h"
#import "StationboardContainerViewControlleriPad.h"
#import "RSSTransportNewContainerViewControlleriPad.h"

//Shared
#import "Config.h"
#import "Station.h"
#import "Stations.h"
#import "IASKSettingsReader.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "NSString+MD5Addition.h"

//@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
@interface AppDelegate : UIResponder <UIApplicationDelegate, JBTabBarControllerDelegate> {
    SystemSoundID _notificationSound;
}

@property (strong, nonatomic) UIWindow *window;

//iPhone
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) SelectStationsViewController *selectStationsViewController;

//iPad
//@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) JBTabBarController* tabBarController;
@property (strong, nonatomic) ConnectionsContainerViewControlleriPad *connectionsContainerViewControlleriPad;
@property (strong, nonatomic) StationboardContainerViewControlleriPad *stationboardContainerViewControlleriPad;
@property (strong, nonatomic) RSSTransportNewContainerViewControlleriPad *rssTransportNewContainerViewControlleriPad;

//Shared
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIAlertView *notificationAlert;

- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

@end
