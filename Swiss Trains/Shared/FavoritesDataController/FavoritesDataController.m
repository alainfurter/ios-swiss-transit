//
//  FavoritesDataController.m
//  Swiss Trains
//
//  Created by Alain on 21.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "FavoritesDataController.h"

@implementation FavoritesDataController

+ (FavoritesDataController *)sharedFavoritesDataController
{
    static FavoritesDataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FavoritesDataController alloc] init];
        // Do any other initialisation stuff here
        
        
    });
    return sharedInstance;
}

- (NSString *)documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) defaultFavoritesInit {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *storePath = [documentsDirectory stringByAppendingPathComponent: @"favstations.plist"];
        
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:storePath]) {
        
        #ifdef LOGOUTPUTON
		NSLog(@"Copy favorites from bundle");
        #endif
		
		NSString *defaultStorePath;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //NSLog(@"Use favorites init iPad");
            //storePath = [documentsDirectory stringByAppendingPathComponent: @"favstationsipad.plist"];
            defaultStorePath = [[NSBundle mainBundle] pathForResource:@"favstationsipad" ofType:@"plist"];
        } else {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            if (screenBounds.size.height == 568) {
                //NSLog(@"Use favorites init iPhone 5");
                //storePath = [documentsDirectory stringByAppendingPathComponent: @"favstationsiphone5.plist"];
                defaultStorePath = [[NSBundle mainBundle] pathForResource:@"favstationsiphone5" ofType:@"plist"];
            } else {
                //NSLog(@"Use favorites init iPhone 4");
                //storePath = [documentsDirectory stringByAppendingPathComponent: @"favstationsiphone4.plist"];
                defaultStorePath = [[NSBundle mainBundle] pathForResource:@"favstationsiphone4" ofType:@"plist"];
            }
        }
        
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
		else {
			NSLog(@"Unresolved error: standard favorites in bundle not found!");
		}
	}
}

- (void) addStationToFavoritesList:(Station *)station {
    NSString *favoritesStationsFileNameString = [[self documentsDirectory] stringByAppendingPathComponent: @"favstations.plist"];

    [self defaultFavoritesInit];
    
    //NSLog(@"Add favorite station");
    
    if (station) {
        if (station.stationName) {
            NSMutableArray *stationNames;
            NSMutableArray *stationIds;
            NSMutableArray *stationLatitudes;
            NSMutableArray *stationLongitudes;
            
            if ([[NSFileManager defaultManager] fileExistsAtPath: favoritesStationsFileNameString]) {
                //NSLog(@"Add favorite station. file exits, load file");
                NSArray *stationFileArray = [NSMutableArray arrayWithContentsOfFile: favoritesStationsFileNameString];
                stationNames = [stationFileArray objectAtIndex: 0];
                stationIds = [stationFileArray objectAtIndex: 1];
                stationLatitudes = [stationFileArray objectAtIndex: 2];
                stationLongitudes = [stationFileArray objectAtIndex: 3];
            } else {
                //NSLog(@"Add favorite station. file does not exits");
                stationNames = [NSMutableArray arrayWithCapacity:1];
                stationIds = [NSMutableArray arrayWithCapacity:1];
                stationLatitudes = [NSMutableArray arrayWithCapacity:1];
                stationLongitudes = [NSMutableArray arrayWithCapacity:1];
            }
            
            NSArray *matchArray = [stationNames filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", station.stationName]];
            BOOL exactStringMatch = NO;
            if (matchArray && matchArray.count > 0) {
                //NSUInteger index = [stationNames indexOfObject:@"Bear"];
                //NSLog(@"Add favorite station. Check for exact string match");
                
                if([matchArray containsObject: station.stationName]){
                    //NSLog(@"Add favorite station. Exact match found");
                    exactStringMatch = YES;
                }
            }
            if (!exactStringMatch) {
                if (stationNames.count >=20) {
                    //NSLog(@"Add favorite station. More than 20 station.");
                    [stationNames removeObjectAtIndex: 0];
                    [stationIds removeObjectAtIndex: 0];
                    [stationLatitudes removeObjectAtIndex: 0];
                    [stationLongitudes removeObjectAtIndex: 0];
                }
                //NSLog(@"Add favorite station. Less than 20 stations");
                if (station.stationName && ([station.stationName length] > 0)) {
                    
                    //NSLog(@"Add favorite station. Station name not set");
                    
                    [stationNames addObject: station.stationName];
                    
                    if (station.stationId && ([station.stationId length] > 0)) {
                        //NSLog(@"Add favorite station. Station id set");
                        [stationIds addObject: station.stationId];
                    } else {
                        //NSLog(@"Add favorite station. Station id not set");
                        [stationIds addObject: @"NIL"];
                    }
                    if (station.latitude) {
                        //NSLog(@"Add favorite station. Station latitude set");
                        [stationLatitudes addObject: station.latitude];
                    } else {
                        //NSLog(@"Add favorite station. Station latitude not set");
                        [stationLatitudes addObject: [NSNumber numberWithInt: 0]];
                    }
                    if (station.longitude) {
                        //NSLog(@"Add favorite station. Station longitude set");
                        [stationLongitudes addObject: station.longitude];
                    } else {
                        //NSLog(@"Add favorite station. Station longitude not set");
                        [stationLongitudes addObject: [NSNumber numberWithInt: 0]];
                    }
                    
                    NSMutableArray *fileArray = [NSMutableArray arrayWithCapacity: 4];
                    [fileArray addObjectsFromArray: [NSArray arrayWithObjects: stationNames, stationIds, stationLatitudes, stationLongitudes, nil]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath: favoritesStationsFileNameString]) {
                        //NSLog(@"Add favorite station. file exits, delete and write new file");
                        [[NSFileManager defaultManager] removeItemAtPath: favoritesStationsFileNameString error: NULL];
                    }
                    [fileArray writeToFile: favoritesStationsFileNameString atomically: YES];
                    //NSLog(@"Fav stations path: %@", favoritesStationsFileNameString);
                    if (self.favoritesArray) {
                        self.favoritesArray = nil;
                    }
                    
                    self.favoritesArray = fileArray;
                }
            }
        }
    }
}

- (void) fetchFavoritesListForStationStartingWithName:(NSString *)name onlystations:(BOOL)onlystations {

    //NSLog(@"Fetch favorites: %@", name);
    
    NSString *favoritesStationsFileNameString = [[self documentsDirectory] stringByAppendingPathComponent: @"favstations.plist"];
    
    //NSLog(@"Fetch favorites. Path: %@", favoritesStationsFileNameString);
    
    [self defaultFavoritesInit];
    
    if (name && name.length > 0) {
        NSMutableArray *stationNames;
        NSMutableArray *stationIds;
        NSMutableArray *stationLatitudes;
        NSMutableArray *stationLongitudes;
        
        if (!self.favoritesArray) {
            if ([[NSFileManager defaultManager] fileExistsAtPath: favoritesStationsFileNameString]) {
                NSMutableArray *stationFileArray = [NSMutableArray arrayWithContentsOfFile: favoritesStationsFileNameString];
                self.favoritesArray = stationFileArray;
            } else {
                if (self.fetchedFilteredArray) {
                    self.fetchedFilteredArray = nil;
                }
                return;
            }
        }
        stationNames = [self.favoritesArray objectAtIndex:0];
        stationIds = [self.favoritesArray objectAtIndex:1];
        stationLatitudes = [self.favoritesArray objectAtIndex:2];
        stationLongitudes = [self.favoritesArray objectAtIndex:3];
    
        NSArray *matchArray = [stationNames filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", name]];
        if (matchArray && matchArray.count > 0) {
            NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity: 1];
            for (NSString *currentStationName in matchArray) {
                NSUInteger index = [stationNames indexOfObject:currentStationName];
                Station *currentStation = [[Station alloc] init];
                NSString *stName = [stationNames objectAtIndex: index];
                NSString *stId = [stationIds objectAtIndex: index];
                NSNumber *stLat = [stationLatitudes objectAtIndex: index];
                NSNumber *stLng = [stationLongitudes objectAtIndex: index];
                
                currentStation.stationName = stName;
                
                if (![stId isEqualToString: @"NIL"]) {
                    currentStation.stationId = stId;
                } else {
                    currentStation.stationId = nil;
                }
                if ([stLat integerValue] != 0) {
                    currentStation.latitude = stLat;
                } else {
                    currentStation.latitude = nil;
                }
                if ([stLng integerValue] != 0) {
                    currentStation.longitude = stLng;
                } else {
                    currentStation.longitude = nil;
                }
                
                if (!(onlystations && !currentStation.stationId)) {
                    [stationsArray insertObject: currentStation atIndex: 0];
                }
            }
            //NSLog(@"Fave match found");
            
            if (stationsArray && stationsArray.count > 0) {
                self.fetchedFilteredArray = stationsArray;
            } else {
                self.fetchedFilteredArray = nil;
            }
    
        } else {
            //NSLog(@"No Fave match found");
            if (self.fetchedFilteredArray) {
                //NSLog(@"No Fave match found. Reset array");
                self.fetchedFilteredArray = nil;
            }
        }
        
    } else {
        //NSLog(@"Station is nil or name empty");
        if (self.fetchedFilteredArray) {
            self.fetchedFilteredArray = nil;
        }
        if (!self.favoritesArray) {
            //NSLog(@"Station is nil or name empty. favorites is nil. load favorites");
            if ([[NSFileManager defaultManager] fileExistsAtPath: favoritesStationsFileNameString]) {
                //NSLog(@"Station is nil or name empty. favorites is nil. load favorites. file exists");
                NSMutableArray *stationFileArray = [NSMutableArray arrayWithContentsOfFile: favoritesStationsFileNameString];
                self.favoritesArray = stationFileArray;
            } else {
                //NSLog(@"Station is nil or name empty. favorites is nil. load favorites. file does not exist");
                if (self.fetchedFilteredArray) {
                    self.fetchedFilteredArray = nil;
                }
                return;
            }
        }
        if (self.favoritesArray && self.favoritesArray.count > 0) {
            //NSLog(@"Station is nil or name empty. favorites is there. Count: %d", self.favoritesArray.count);
            NSMutableArray *stationNames;
            NSMutableArray *stationIds;
            NSMutableArray *stationLatitudes;
            NSMutableArray *stationLongitudes;
            stationNames = [self.favoritesArray objectAtIndex:0];
            stationIds = [self.favoritesArray objectAtIndex:1];
            stationLatitudes = [self.favoritesArray objectAtIndex:2];
            stationLongitudes = [self.favoritesArray objectAtIndex:3];
            NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity: 1];
            //NSLog(@"Station is nil or name empty. favorites is there. Go trough station names");
            for (int i = 0; i< stationNames.count; i++) {
                Station *currentStation = [[Station alloc] init];
                NSString *stName = [stationNames objectAtIndex: i];
                NSString *stId = [stationIds objectAtIndex: i];
                NSNumber *stLat = [stationLatitudes objectAtIndex: i];
                NSNumber *stLng = [stationLongitudes objectAtIndex: i];
                
                currentStation.stationName = stName;
                
                if (![stId isEqualToString: @"NIL"]) {
                    currentStation.stationId = stId;
                } else {
                    currentStation.stationId = nil;
                }
                if ([stLat integerValue] != 0) {
                    currentStation.latitude = stLat;
                } else {
                    currentStation.latitude = nil;
                }
                if ([stLng integerValue] != 0) {
                    currentStation.longitude = stLng;
                } else {
                    currentStation.longitude = nil;
                }
                
                if (!(onlystations && !currentStation.stationId)) {
                    [stationsArray insertObject: currentStation atIndex: 0];
                }
                
            }
            
            if (stationsArray && stationsArray.count > 0) {
                self.fetchedFilteredArray = stationsArray;
            } else {
                self.fetchedFilteredArray = nil;
            }
        }
        
    }
    /*
    if (self.fetchedFilteredArray) {
        NSLog(@"Fetched favorites: %d", self.fetchedFilteredArray.count);
    }
    */ 
}

- (NSArray *)getFavoritesStations {
    if (self.fetchedFilteredArray) {
        return self.fetchedFilteredArray;
    }
    return  nil;
}

- (NSUInteger)getNumberOfFavoritesStations {
    //NSLog(@"Get number of fetched stations");
    if (self.fetchedFilteredArray) {
        int arrayCount = [self.fetchedFilteredArray count];
        //NSLog(@"Get number of fetched stations: %d", arrayCount);
        return arrayCount;
    }
    return  0;
}

- (Station *)getFavoritesStationWithIndex:(NSUInteger)index {
    if (self.fetchedFilteredArray) {
        if (self.fetchedFilteredArray.count > index) {
            return  [self.fetchedFilteredArray objectAtIndex: index];
        }
    }
    return  nil;
}

- (void) deleteFavoritesList {
    NSString *favoritesStationsFileNameString = [[self documentsDirectory] stringByAppendingPathComponent: @"favstations.plist"];
    
    if (self.favoritesArray) {
        self.favoritesArray = nil;
    }
    if (self.fetchedFilteredArray) {
        self.fetchedFilteredArray = nil;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath: favoritesStationsFileNameString]) {
        [[NSFileManager defaultManager] removeItemAtPath: favoritesStationsFileNameString error: NULL];
    }
}

@end
