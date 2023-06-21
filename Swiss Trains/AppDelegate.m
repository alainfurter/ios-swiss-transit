//
//  AppDelegate.m
//  Swiss Trains
//
//  Created by Alain on 20.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSString *)documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void) createStationsDB {
    NSError *error = nil;
 
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Swiss_Trains" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    NSManagedObjectModel *model  = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
 
    if (!model)NSLog(@"Model error");

 
    NSString *pathString = [[self documentsDirectory] stringByAppendingPathComponent: @"Stations.sqlite"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath: pathString]) {
        [[NSFileManager defaultManager] removeItemAtPath: pathString error: NULL];
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: pathString];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
 
    if (!coordinator) NSLog(@"Coordinator error");

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
 
    NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [paths stringByAppendingPathComponent:@"stations.txt"];
    NSLog(@"Path: %@", bundlePath);
    NSString *dataFile = [[NSString alloc] initWithContentsOfFile: bundlePath encoding: NSUTF8StringEncoding error:NULL];
 
    NSArray *dataRows = [dataFile componentsSeparatedByString:@"\n"];
 
    //Stations *station;
 
    for (int i = 0 ; i < [dataRows count] ; i++) {
        NSArray *dataElements = [[dataRows objectAtIndex:i] componentsSeparatedByString:@"|"];
        if ([dataElements count] == 12) {
            
            NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@","];
            NSCharacterSet *ws = [NSCharacterSet whitespaceCharacterSet];
            //NSCharacterSet *invertedS = [s invertedSet];
            NSRange r = [[dataElements objectAtIndex:0] rangeOfCharacterFromSet:s];
            NSRange wr = [[dataElements objectAtIndex:0] rangeOfCharacterFromSet:ws];
            NSArray *splitStationname = nil;
            NSArray *splitStationnameW = nil;
            if (r.location != NSNotFound) {
                splitStationname = [[dataElements objectAtIndex:0] componentsSeparatedByCharactersInSet:s];
                if ([splitStationname count] != 2) {
                    NSLog(@"Name with more than two commas found");
                }
            } else if (wr.location != NSNotFound) {
                splitStationnameW = [[dataElements objectAtIndex:0] componentsSeparatedByCharactersInSet:ws];
            }
            
            NSString *splitNameString = nil;
            NSString *stringStart = nil;
            NSString *firstName = nil;
            NSString *firstStart = nil;
            NSString *secondName = nil;
            NSString *secondStart = nil;
            if (splitStationname && ([splitStationname count] == 2)) {
                firstName = [[splitStationname objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                secondName = [[splitStationname objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                firstStart = [firstName substringToIndex:1];
                secondStart = [secondName substringToIndex:1];
                splitNameString = [NSString stringWithFormat: @"%@|%@", firstName, secondName];
                stringStart = [NSString stringWithFormat: @"%@|%@", firstStart, secondStart];
            } else if (splitStationnameW && ([splitStationnameW count] >= 2)) {
                firstName = [[splitStationnameW objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
                for (int i = 1; i<[splitStationnameW count]; i++) {
                    [tempArray addObject: [splitStationnameW objectAtIndex: i]];
                }
                secondName = [[tempArray componentsJoinedByString: @" "] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                firstStart = [firstName substringToIndex:1];
                secondStart = [secondName substringToIndex:1];
                splitNameString = [NSString stringWithFormat: @"%@|%@", firstName, secondName];
                stringStart = [NSString stringWithFormat: @"%@|%@",firstStart, secondStart];
            } else {
                firstName = [dataElements objectAtIndex:0];
                firstStart = [[dataElements objectAtIndex:0] substringToIndex:1];
                splitNameString = [dataElements objectAtIndex:0];
                stringStart = [[dataElements objectAtIndex:0] substringToIndex: 1];
            }
            
            NSUInteger stationPriority = 1;
            if ([[dataElements objectAtIndex:5] isEqualToString:@"20"]) {
                stationPriority = 1; // Schiff
            }
            if ([[dataElements objectAtIndex:5] isEqualToString:@"30"]) {
                stationPriority = 2; // Tram, Bus, etc.
            }
            if ([[dataElements objectAtIndex:5] isEqualToString:@"10"]) {
                stationPriority = 3; // Zug
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Zürich HB"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Basel SBB"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Luzern"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Bern"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Lausanne"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Winterthur"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Zug"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Lugano"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Genève"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:0] isEqualToString:@"Olten"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            
            NSLog(@"CI New: %i, %@, %.6f, %.6f, %@, %@",i, [dataElements objectAtIndex:0], [[dataElements objectAtIndex:10] floatValue], [[dataElements objectAtIndex:11] floatValue], stringStart, splitNameString);
            NSLog(@"CI New: %i, %@,%@,%@,%@",i, firstName, firstStart, secondName, secondStart);
             
            //station = (Stations *)[NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:context];
            NSLog(@"Create main stations entity object");
            
             NSManagedObject *station = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:context];
            
            //[station setStationname: [dataElements objectAtIndex:0]];
            //[station setSearchstationname: [dataElements objectAtIndex:0]];
            
            //[station setCarrier: [dataElements objectAtIndex:1]];
            //[station setGemeindecode: [dataElements objectAtIndex:2]];
            //[station setGemeinde: [dataElements objectAtIndex:3]];
            //[station setEditable: [NSNumber numberWithInt: 0]];
            
            //[station setLongitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:11] floatValue]]];
            //[station setLatitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:10] floatValue]]];
            
            //[station setHeight: [NSNumber numberWithFloat: [[dataElements objectAtIndex:6] floatValue]]];
            //[station setPicname: [dataElements objectAtIndex:7]];
 
            //[station setIndex: [NSNumber numberWithInt: i + 1]];
            
            //NSString *firstName = [[splitStationname objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            //NSString *firstStart = [[splitStationname objectAtIndex:0] substringToIndex:1];
            
            //NSString *relationFrom = [NSString stringWithFormat: @"%@To", [firstStart lowercaseString]];
            
            if ([[firstStart uppercaseString] isEqualToString: @"Ä"]) {
                firstStart = @"A";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"Ö"]) {
                firstStart = @"O";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"Ü"]) {
                firstStart = @"U";
            }
            
            if ([[firstStart uppercaseString] isEqualToString: @"É"]) {
                firstStart = @"E";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"È"]) {
                firstStart = @"E";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"À"]) {
                firstStart = @"A";
            }
            
            
            
            if ([[secondStart uppercaseString] isEqualToString: @"Ä"]) {
                secondStart = @"A";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"Ö"]) {
                secondStart = @"O";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"Ü"]) {
                secondStart = @"U";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"É"]) {
                secondStart = @"E";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"È"]) {
                secondStart = @"E";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"À"]) {
                secondStart = @"A";
            }
            
            //NSString *relationTo = [NSString stringWithFormat: @"to%@", [firstStart uppercaseString]];
            NSString *relationFrom = [NSString stringWithFormat: @"%@To", [firstStart lowercaseString]];
            
            NSLog(@"Create short stations entity object 1: %@", [firstStart uppercaseString]);
            NSManagedObject *stationshort = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:[firstStart uppercaseString] inManagedObjectContext:context];
            
            //[station setValue: firstName forKey: @"searchstationname"];
            [station setValue: [dataElements objectAtIndex:0] forKey: @"stationname"];
            [stationshort setValue: firstName forKey: @"sn"];
            [stationshort setValue: [NSNumber numberWithInt: 1] forKey: @"snp"];
            //[stationshort setValue: secondName forKey: @"sn2"];
            
            NSNumber *sortKeyCode = [NSNumber numberWithChar: [firstStart characterAtIndex:(0)]];
            
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:10] floatValue]] forKey:@"latitude"];
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:11] floatValue]] forKey:@"longitude"];
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:9] floatValue]] forKey:@"elevation"];
            [station setValue: sortKeyCode forKey:@"firstlettercode"];
            [station setValue: [NSNumber numberWithInt: stationPriority] forKey:@"transportcode"];
            
            //[station setLongitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:11] floatValue]]];
            //[station setLatitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:10] floatValue]]];
            
            //NSMutableSet *relSet = [station mutableSetValueForKey:@"fromBundle"];
            //[mutableSet addObject:aBundle];
            
            NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
            NSRange ac = [secondStart rangeOfCharacterFromSet:charSet];
            if (ac.location == NSNotFound) {
                secondName = nil;
                secondStart = nil;
            }
            
            if (secondStart && secondName) {
                //NSString *secondName = [[splitStationname objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                //NSString *secondStart = [[splitStationname objectAtIndex:1] substringToIndex:1];
                
                
                
                NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                //NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
                //NSCharacterSet *invertedS = [s invertedSet];
                NSRange nr = [secondStart rangeOfCharacterFromSet:numberSet];
                NSString *relationTo2;
                NSString *relationFrom2;
                if (nr.location != NSNotFound) {
                    relationTo2 = [NSString stringWithFormat: @"toNums"];
                    relationFrom2 = [NSString stringWithFormat: @"numsTo"];
                    secondStart = @"NUMS";
                } else {
                    relationTo2 = [NSString stringWithFormat: @"to%@", [secondStart uppercaseString]];
                    relationFrom2 = [NSString stringWithFormat: @"%@To", [secondStart lowercaseString]];
                }
                
                //NSString *relationTo2 = [NSString stringWithFormat: @"to%@", [secondStart uppercaseString]];
                
                NSLog(@"Create short stations entity object 2: %@", [secondStart uppercaseString]);
                NSManagedObject *stationshort2 = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:[secondStart uppercaseString] inManagedObjectContext:context];
                
                [stationshort2 setValue: secondName forKey: @"sn"];
                [stationshort2 setValue: [NSNumber numberWithInt: 2] forKey: @"snp"];
                
                //[station setValue: secondName forKey: @"searchstationname2"];
                //[station setValue:stationshort2 forKey: relationTo2];
                [stationshort2 setValue:station forKey: relationFrom2];
            }
            
            [stationshort setValue:station forKey: relationFrom];
            //[station setValue:stationshort forKey: relationTo];
            //[station setValue:stationshort forKey: relationTo];
            
            if (![context save:&error]) {
                NSLog(@"Write error: %@", [error localizedDescription]);
            }
        }
    }
 
    if (![context save:&error]) {
        NSLog(@"Write error: %@", [error localizedDescription]);
    }
}


- (void) createUniqueStationsDB {
    NSError *error = nil;
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Swiss_Trains" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    NSManagedObjectModel *model  = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    if (!model)NSLog(@"Model error");
    
    
    NSString *pathString = [[self documentsDirectory] stringByAppendingPathComponent: @"Stations.sqlite"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath: pathString]) {
        [[NSFileManager defaultManager] removeItemAtPath: pathString error: NULL];
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: pathString];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    
    if (!coordinator) NSLog(@"Coordinator error");
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    
    NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [paths stringByAppendingPathComponent:@"stations_unique.txt"];
    NSLog(@"Path: %@", bundlePath);
    NSString *dataFile = [[NSString alloc] initWithContentsOfFile: bundlePath encoding: NSUTF8StringEncoding error:NULL];
    
    NSArray *dataRows = [dataFile componentsSeparatedByString:@"\n"];
    
    //Stations *station;
    
    for (int i = 0 ; i < [dataRows count] ; i++) {
        NSArray *dataElements = [[dataRows objectAtIndex:i] componentsSeparatedByString:@"|"];
        if ([dataElements count] == 21) {
            
            NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@","];
            NSCharacterSet *ws = [NSCharacterSet whitespaceCharacterSet];
            //NSCharacterSet *invertedS = [s invertedSet];
            NSRange r = [[dataElements objectAtIndex:2] rangeOfCharacterFromSet:s];
            NSRange wr = [[dataElements objectAtIndex:2] rangeOfCharacterFromSet:ws];
            NSArray *splitStationname = nil;
            NSArray *splitStationnameW = nil;
            if (r.location != NSNotFound) {
                splitStationname = [[dataElements objectAtIndex:2] componentsSeparatedByCharactersInSet:s];
                if ([splitStationname count] != 2) {
                    NSLog(@"Name with more than two commas found");
                }
            } else if (wr.location != NSNotFound) {
                splitStationnameW = [[dataElements objectAtIndex:2] componentsSeparatedByCharactersInSet:ws];
            }
            
            NSString *splitNameString = nil;
            NSString *stringStart = nil;
            NSString *firstName = nil;
            NSString *firstStart = nil;
            NSString *secondName = nil;
            NSString *secondStart = nil;
            if (splitStationname && ([splitStationname count] == 2)) {
                firstName = [[splitStationname objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                secondName = [[splitStationname objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                firstStart = [firstName substringToIndex:1];
                secondStart = [secondName substringToIndex:1];
                splitNameString = [NSString stringWithFormat: @"%@|%@", firstName, secondName];
                stringStart = [NSString stringWithFormat: @"%@|%@", firstStart, secondStart];
            } else if (splitStationnameW && ([splitStationnameW count] >= 2)) {
                firstName = [[splitStationnameW objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
                for (int i = 1; i<[splitStationnameW count]; i++) {
                    [tempArray addObject: [splitStationnameW objectAtIndex: i]];
                }
                secondName = [[tempArray componentsJoinedByString: @" "] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                firstStart = [firstName substringToIndex:1];
                secondStart = [secondName substringToIndex:1];
                splitNameString = [NSString stringWithFormat: @"%@|%@", firstName, secondName];
                stringStart = [NSString stringWithFormat: @"%@|%@",firstStart, secondStart];
            } else {
                firstName = [dataElements objectAtIndex:2];
                firstStart = [[dataElements objectAtIndex:2] substringToIndex:1];
                splitNameString = [dataElements objectAtIndex:2];
                stringStart = [[dataElements objectAtIndex:2] substringToIndex: 1];
            }
            
            NSUInteger stationPriority = 1;
            if ([[dataElements objectAtIndex:7] isEqualToString:@"UN"]) {
                stationPriority = 0; // Unknown.
            }
            if ([[dataElements objectAtIndex:7] isEqualToString:@"20"]) {
                stationPriority = 1; // Schiff
            }
            if ([[dataElements objectAtIndex:7] isEqualToString:@"30"]) {
                stationPriority = 2; // Tram, Bus, etc.
            }
            if ([[dataElements objectAtIndex:7] isEqualToString:@"10"]) {
                stationPriority = 3; // Zug
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Zürich HB"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Basel SBB, Bahnhof"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Luzern"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Bern"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Lausanne"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Winterthur"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Zug"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Lugano"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Genève"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Olten"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            
            NSUInteger dataQuality = 2;
            if ([[dataElements objectAtIndex:0] isEqualToString:@"S"]) {
                dataQuality = 1; // Unknown
            }
            
            // firstname clean & full
            NSString *tempFirstName = [dataElements objectAtIndex:2];
            tempFirstName = [tempFirstName stringByReplacingOccurrencesOfString: @"," withString: @""];
            tempFirstName = [tempFirstName stringByReplacingOccurrencesOfString: @"(" withString: @""];
            tempFirstName = [tempFirstName stringByReplacingOccurrencesOfString: @")" withString: @""];
            firstName = tempFirstName;
            
            NSLog(@"CI New: %i, %@, %.6f, %.6f, %@, %@",i, [dataElements objectAtIndex:2], [[dataElements objectAtIndex:12] floatValue], [[dataElements objectAtIndex:13] floatValue], stringStart, splitNameString);
            NSLog(@"CI New: %i, %@,%@,%@,%@",i, firstName, firstStart, secondName, secondStart);
            
            //station = (Stations *)[NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:context];
            NSLog(@"Create main stations entity object");
            
            NSManagedObject *station = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:context];
            
            //[station setStationname: [dataElements objectAtIndex:0]];
            //[station setSearchstationname: [dataElements objectAtIndex:0]];
            
            //[station setCarrier: [dataElements objectAtIndex:1]];
            //[station setGemeindecode: [dataElements objectAtIndex:2]];
            //[station setGemeinde: [dataElements objectAtIndex:3]];
            //[station setEditable: [NSNumber numberWithInt: 0]];
            
            //[station setLongitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:11] floatValue]]];
            //[station setLatitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:10] floatValue]]];
            
            //[station setHeight: [NSNumber numberWithFloat: [[dataElements objectAtIndex:6] floatValue]]];
            //[station setPicname: [dataElements objectAtIndex:7]];
            
            //[station setIndex: [NSNumber numberWithInt: i + 1]];
            
            //NSString *firstName = [[splitStationname objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            //NSString *firstStart = [[splitStationname objectAtIndex:0] substringToIndex:1];
            
            //NSString *relationFrom = [NSString stringWithFormat: @"%@To", [firstStart lowercaseString]];
            
            if ([[firstStart uppercaseString] isEqualToString: @"Ä"]) {
                firstStart = @"A";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"Ö"]) {
                firstStart = @"O";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"Ü"]) {
                firstStart = @"U";
            }
            
            if ([[firstStart uppercaseString] isEqualToString: @"É"]) {
                firstStart = @"E";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"È"]) {
                firstStart = @"E";
            }
            if ([[firstStart uppercaseString] isEqualToString: @"À"]) {
                firstStart = @"A";
            }
            
            
            
            if ([[secondStart uppercaseString] isEqualToString: @"Ä"]) {
                secondStart = @"A";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"Ö"]) {
                secondStart = @"O";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"Ü"]) {
                secondStart = @"U";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"É"]) {
                secondStart = @"E";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"È"]) {
                secondStart = @"E";
            }
            if ([[secondStart uppercaseString] isEqualToString: @"À"]) {
                secondStart = @"A";
            }
            
            //NSString *relationTo = [NSString stringWithFormat: @"to%@", [firstStart uppercaseString]];
            NSString *relationFrom = [NSString stringWithFormat: @"%@To", [firstStart lowercaseString]];
            
            NSLog(@"Create short stations entity object 1: %@", [firstStart uppercaseString]);
            NSManagedObject *stationshort = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:[firstStart uppercaseString] inManagedObjectContext:context];
            
            //[station setValue: firstName forKey: @"searchstationname"];
            [station setValue: [dataElements objectAtIndex:2] forKey: @"stationname"];
            [stationshort setValue: firstName forKey: @"sn"];
            [stationshort setValue: [NSNumber numberWithInt: 1] forKey: @"snp"];
            //[stationshort setValue: secondName forKey: @"sn2"];
            
            NSNumber *sortKeyCode = [NSNumber numberWithChar: [firstStart characterAtIndex:(0)]];
            
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:12] floatValue]] forKey:@"latitude"];
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:13] floatValue]] forKey:@"longitude"];
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:11] floatValue]] forKey:@"elevation"];
            [station setValue: sortKeyCode forKey:@"firstlettercode"];
            [station setValue: [NSNumber numberWithInt: stationPriority] forKey:@"transportcode"];
            
            [station setValue: [NSNumber numberWithInt: dataQuality] forKey:@"dataquality"];
            [station setValue: [dataElements objectAtIndex:14] forKey: @"externalid"];
            
            if ([[dataElements objectAtIndex:14] length] < 12) {
                NSLog(@"Strange external id: %d, %@", i, [dataElements objectAtIndex:14]);
            }
            
            //[station setLongitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:11] floatValue]]];
            //[station setLatitude: [NSNumber numberWithFloat: [[dataElements objectAtIndex:10] floatValue]]];
            
            //NSMutableSet *relSet = [station mutableSetValueForKey:@"fromBundle"];
            //[mutableSet addObject:aBundle];
            
            NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
            NSRange ac = [secondStart rangeOfCharacterFromSet:charSet];
            if (ac.location == NSNotFound) {
                secondName = nil;
                secondStart = nil;
            }
            
            if (secondStart && secondName) {
                //NSString *secondName = [[splitStationname objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                //NSString *secondStart = [[splitStationname objectAtIndex:1] substringToIndex:1];
                
                
                
                NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                //NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
                //NSCharacterSet *invertedS = [s invertedSet];
                NSRange nr = [secondStart rangeOfCharacterFromSet:numberSet];
                NSString *relationTo2;
                NSString *relationFrom2;
                if (nr.location != NSNotFound) {
                    relationTo2 = [NSString stringWithFormat: @"toNums"];
                    relationFrom2 = [NSString stringWithFormat: @"numsTo"];
                    secondStart = @"NUMS";
                } else {
                    relationTo2 = [NSString stringWithFormat: @"to%@", [secondStart uppercaseString]];
                    relationFrom2 = [NSString stringWithFormat: @"%@To", [secondStart lowercaseString]];
                }
                
                //NSString *relationTo2 = [NSString stringWithFormat: @"to%@", [secondStart uppercaseString]];
                
                NSLog(@"Create short stations entity object 2: %@", [secondStart uppercaseString]);
                NSManagedObject *stationshort2 = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:[secondStart uppercaseString] inManagedObjectContext:context];
                
                [stationshort2 setValue: secondName forKey: @"sn"];
                [stationshort2 setValue: [NSNumber numberWithInt: 2] forKey: @"snp"];
                
                //[station setValue: secondName forKey: @"searchstationname2"];
                //[station setValue:stationshort2 forKey: relationTo2];
                [stationshort2 setValue:station forKey: relationFrom2];
            }
            
            [stationshort setValue:station forKey: relationFrom];
            //[station setValue:stationshort forKey: relationTo];
            //[station setValue:stationshort forKey: relationTo];
            
            if (![context save:&error]) {
                NSLog(@"Write error: %@", [error localizedDescription]);
            }
        }
    }
    
    if (![context save:&error]) {
        NSLog(@"Write error: %@", [error localizedDescription]);
    }
}

- (NSString *)removeDoublespacesInStringAndLeadingWhitespaces:(NSString *)string {
    
    NSString *trimmedstring = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [trimmedstring componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
    
    /*
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *stringwithoutdoublespaces = [regex stringByReplacingMatchesInString:trimmedstring options:0 range:NSMakeRange(0, [trimmedstring length]) withTemplate:@" "];
    return stringwithoutdoublespaces;
    */
}

- (void) createUniqueStationsDBSecond {
    NSError *error = nil;
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Swiss_Trains" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    NSManagedObjectModel *model  = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    if (!model)NSLog(@"Model error");
    
    NSString *pathString = [[self documentsDirectory] stringByAppendingPathComponent: @"Stations.sqlite"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath: pathString]) {
        [[NSFileManager defaultManager] removeItemAtPath: pathString error: NULL];
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: pathString];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    
    if (!coordinator) NSLog(@"Coordinator error");
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    
    NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [paths stringByAppendingPathComponent:@"stations_matched_rank_end.txt"];
    NSLog(@"Path source: %@", bundlePath);
    NSLog(@"Path out: %@", pathString);
    NSString *dataFile = [[NSString alloc] initWithContentsOfFile: bundlePath encoding: NSUTF8StringEncoding error:NULL];
    
    NSArray *dataRows = [dataFile componentsSeparatedByString:@"\n"];
    
    NSLog(@"Number of entries: %d", dataRows.count);
    
    NSUInteger stationswithmorethantwodimensions = 0;
    NSUInteger additionaldimensionscreated = 0;
    NSUInteger maxdimenionsforanentity = 0;
        
    for (int i = 0 ; i < [dataRows count] ; i++) {
        NSArray *dataElements = [[dataRows objectAtIndex:i] componentsSeparatedByString:@"|"];
        if ([dataElements count] == 24) {
                        
            NSUInteger stationPriority = 1;
            if ([[dataElements objectAtIndex:7] isEqualToString:@"UN"]) {
                stationPriority = 0; // Unknown.
            }
            if ([[dataElements objectAtIndex:7] isEqualToString:@"20"]) {
                stationPriority = 1; // Schiff
            }
            if ([[dataElements objectAtIndex:7] isEqualToString:@"30"]) {
                stationPriority = 2; // Tram, Bus, etc.
            }
            if ([[dataElements objectAtIndex:7] isEqualToString:@"10"]) {
                stationPriority = 3; // Zug
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Zürich HB"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Basel SBB, Bahnhof"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Luzern"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Bern"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Lausanne"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Winterthur"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Zug"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Lugano"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Genève"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            if ([[dataElements objectAtIndex:2] isEqualToString:@"Olten"] && [[dataElements objectAtIndex:1] isEqualToString:@"SBB"]) {
                stationPriority = 5; // Hauptbahnhof
            }
            
            NSUInteger dataQuality = 2;
            if ([[dataElements objectAtIndex:0] isEqualToString:@"S"]) {
                dataQuality = 1; // Unknown
            }
            
            NSMutableCharacterSet *whitespaceset = [NSCharacterSet whitespaceCharacterSet];
            [whitespaceset formUnionWithCharacterSet: [NSCharacterSet characterSetWithCharactersInString:@","]];
            
            NSString *stationnameoriginal = [dataElements objectAtIndex:2];
            NSString *stationnamewithcommareplaced = [stationnameoriginal stringByReplacingOccurrencesOfString: @"," withString: @" "];
            NSString *stationnamewithdashreplaced = [stationnamewithcommareplaced stringByReplacingOccurrencesOfString: @"-" withString: @" "];
            NSString *stationnamewithapostrophreplaced = [stationnamewithdashreplaced stringByReplacingOccurrencesOfString: @"'" withString: @" "];
            NSString *stationnamewithbracketopenedcleaned = [stationnamewithapostrophreplaced stringByReplacingOccurrencesOfString: @"(" withString: @""];
            NSString *stationnamewithbracketclosedcleaned = [stationnamewithbracketopenedcleaned stringByReplacingOccurrencesOfString: @")" withString: @""];
            NSString *stationnamewithSlashcleaned = [stationnamewithbracketclosedcleaned stringByReplacingOccurrencesOfString: @"/" withString: @" "];
            NSString *stationnamewithMultiplycleaned = [stationnamewithSlashcleaned stringByReplacingOccurrencesOfString: @"×" withString: @" "];
            NSString *stationnamewithPluscleaned = [stationnamewithMultiplycleaned stringByReplacingOccurrencesOfString: @"+" withString: @" "];
            NSString *stationnamecleaned = [self removeDoublespacesInStringAndLeadingWhitespaces: stationnamewithPluscleaned];
            
            NSArray *stationnamesplit = [stationnamecleaned componentsSeparatedByString: @" "];
            //NSMutableArray *dimensionsnames = [NSMutableArray array];
            //NSMutableArray *firstletters = [NSMutableArray array];
            
            NSManagedObject *station = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:context];
            
            [station setValue: stationnameoriginal forKey: @"stationname"];
                    
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:12] floatValue]] forKey:@"latitude"];
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:13] floatValue]] forKey:@"longitude"];
            [station setValue: [NSNumber numberWithFloat: [[dataElements objectAtIndex:11] floatValue]] forKey:@"elevation"];
            [station setValue: [NSNumber numberWithInt: stationPriority] forKey:@"transportcode"];
            
            [station setValue: [NSNumber numberWithInt: dataQuality] forKey:@"dataquality"];
            [station setValue: [dataElements objectAtIndex:14] forKey: @"externalid"];
            
            int dimensionsforentity = 0;
            BOOL entityalreadyaddedwithmorethantwodimensions = NO;
            
            NSLog(@"Processing: %d, '%@' / Qual: %d, Prio: %d", i, stationnameoriginal, dataQuality, stationPriority);
            
            for (int y = 0; y < stationnamesplit.count; y++) {
                NSString *stationnamesplitpart = [stationnamesplit objectAtIndex: y];
                NSString *firstletteroriginal = [stationnamesplitpart substringToIndex: 1];
                NSString *cleanedfirstletter = firstletteroriginal;
                
                if ([[firstletteroriginal uppercaseString] isEqualToString: @"Ä"]) {
                    cleanedfirstletter = @"A";
                }
                if ([[firstletteroriginal uppercaseString] isEqualToString: @"Ö"]) {
                    cleanedfirstletter = @"O";
                }
                if ([[firstletteroriginal uppercaseString] isEqualToString: @"Ü"]) {
                    cleanedfirstletter = @"U";
                }
                if ([[firstletteroriginal uppercaseString] isEqualToString: @"É"]) {
                    cleanedfirstletter = @"E";
                }
                if ([[firstletteroriginal uppercaseString] isEqualToString: @"È"]) {
                    cleanedfirstletter = @"E";
                }
                if ([[firstletteroriginal uppercaseString] isEqualToString: @"À"]) {
                    cleanedfirstletter = @"A";
                }
                
                NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                NSRange numberrangeinstring = [cleanedfirstletter rangeOfCharacterFromSet:numberSet];

                NSString *relationFrom;
                if (numberrangeinstring.location != NSNotFound) {
                    relationFrom = [NSString stringWithFormat: @"numsTo"];
                    cleanedfirstletter = @"NUMS";
                } else {
                    relationFrom = [NSString stringWithFormat: @"%@To", [cleanedfirstletter lowercaseString]];
                }
                
                NSLog(@"Dimensions: %d, %d / '%@', '%@', '%@'", i, y, stationnamesplitpart, firstletteroriginal, cleanedfirstletter);
                
                NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
                s = [s invertedSet];
                
                NSRange r = [cleanedfirstletter rangeOfCharacterFromSet:s];
                if (r.location != NSNotFound) {
                    NSLog(@"SHORT STATION LETTER IS ILLEGAL CHARACTER: %d, '%@'", y, cleanedfirstletter);
                } else {
                    if (y != 0 && [stationnamesplitpart length] <= 2) {
                        NSLog(@"SHORT STATION NAME IS 2 CHARS OR LESS: %d, '%@'", y, stationnamesplitpart);
                    } else {
                        NSLog(@"Create short stations entity object : %@", [cleanedfirstletter uppercaseString]);
                        
                        if (YES) {
                            NSManagedObject *stationshort = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:[cleanedfirstletter uppercaseString] inManagedObjectContext:context];
                            
                            [stationshort setValue: stationnamesplitpart forKey: @"sn"];
                            [stationshort setValue: [NSNumber numberWithInt: y + 1] forKey: @"snp"];
                            
                            [stationshort setValue:station forKey: relationFrom];
                            
                            if (y == 0) {
                                NSNumber *sortKeyCode = [NSNumber numberWithChar: [cleanedfirstletter characterAtIndex:(0)]];
                                [station setValue: sortKeyCode forKey:@"firstlettercode"];
                            }
                        }
                        dimensionsforentity++;
                    }
                }
            }
            
            if (dimensionsforentity > maxdimenionsforanentity) {
                maxdimenionsforanentity = dimensionsforentity;
            }
            
            if (dimensionsforentity > 2) {
                NSLog(@"MORE THAN 2 DIMENSIONS: %d, '%@'", i, stationnameoriginal);
                
                if (!entityalreadyaddedwithmorethantwodimensions) {
                    stationswithmorethantwodimensions++;
                    entityalreadyaddedwithmorethantwodimensions = YES;
                }
                
                additionaldimensionscreated++;
            }
                        
            if (![context save:&error]) {
                NSLog(@"Write error: %@", [error localizedDescription]);
            }
        }
    }
    
    NSLog(@"Entities with more than to dimenstions: %d / additional dimensions: %d",stationswithmorethantwodimensions, additionaldimensionscreated);
    NSLog(@"Max dimensions in entity: %d", maxdimenionsforanentity);
    
    if (![context save:&error]) {
        NSLog(@"Write error: %@", [error localizedDescription]);
    }
}

- (void) convertSwissMapBounderiesToGeoJSON {
    //NSString *outstring = [[self documentsDirectory] stringByAppendingPathComponent: @"ch_bounderies.geojson"];
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"ch_bounderies_source" ofType:@"txt"];
    NSString *fileString = [NSString stringWithContentsOfFile: modelPath encoding: NSUTF8StringEncoding error: NULL];
    NSArray *mapPointsRaw = [fileString componentsSeparatedByString: @"\n"];
    
    NSString *start = @"{ \"type\": \"MultiPolygon\", \"coordinates\": [[[";
    NSString *end = @"]]]}";
    
    NSMutableArray *mapPointsArray = [NSMutableArray arrayWithCapacity: 1];
    
    for (NSString *currentMapPointString in mapPointsRaw) {
        NSString *mpclean = [currentMapPointString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        while ([mpclean rangeOfString:@"  "].location != NSNotFound) {
            mpclean = [mpclean stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        }
        //NSLog(@"Current point: %@", mpclean);
        NSArray *currentPointArray = [mpclean componentsSeparatedByString: @" "];
        if ([currentPointArray count] == 2) {
            NSString *lat; NSString *lng;
            if ([[currentPointArray objectAtIndex:1] length] > 9) {
                lat = [[currentPointArray objectAtIndex:1] substringToIndex: 9];
            } else {
                lat = [currentPointArray objectAtIndex:1];
                NSLog(@"lat with less length");
            }
            if ([[currentPointArray objectAtIndex:0] length] > 8) {
                lng = [[currentPointArray objectAtIndex:0] substringToIndex: 8];
            } else {
                lng = [currentPointArray objectAtIndex:0];
                NSLog(@"lng with less length");
            }
            NSString *currentLatLng = [NSString stringWithFormat: @"[%@, %@]", lng, lat];
            NSLog(@"Lat: %@, long: %@", lat, lng);
            [mapPointsArray addObject: currentLatLng];
        }
    }
    NSString *mapPointJoined = [mapPointsArray componentsJoinedByString: @","];
    NSString *finalString = [NSString stringWithFormat: @"%@%@%@", start, mapPointJoined, end];
    NSLog(@"Final JSON: %@", finalString);
}

- (NSString *) shortenTitleIfTooLong:(NSString *)stationName maxLenth:(NSUInteger)maxLength {
    if (!stationName) return  nil; if (maxLength == 0) return  nil;
    NSString *shortenStationName;
    if ([stationName length] > maxLength) {
        shortenStationName = [stationName substringToIndex: maxLength - 3];
        return [NSString stringWithFormat:@"%@...", shortenStationName];
    }
    return stationName;
}

- (void) appLaunchRegisterForRemoteNotifications {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void) appLaunchDeRegisterForRemoteNotifications {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    /*
     const char *data = [devToken bytes];
     NSMutableString* tokenString = [NSMutableString string];
     
     for (int i = 0; i < [devToken length]; i++)
     {
     [tokenString appendFormat:@"%02.2hhX", data[i]];
     }
     NSLog(@"Register with device token: %@",tokenString);
     */
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: [documentsDirectory stringByAppendingPathComponent: DeviceAlreadyRegisteredForRemoteNotificationFlagfile]])
	{        
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
        
        const char *data = [devToken bytes];
		NSMutableString* tokenString = [NSMutableString string];
		
		for (int i = 0; i < [devToken length]; i++)
		{
			[tokenString appendFormat:@"%02.2hhX", data[i]];
		}
		
        #ifdef  LOGOUTPUTON
        NSLog(@"Register with device token: %@",tokenString);
        #endif
        
        NSString *deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        
        NSString *countryCode = [NSString stringWithString: [[[NSLocale currentLocale] localeIdentifier] stringByEscapingURL]];
        NSString *languageCode = [NSString stringWithString: [[NSLocale preferredLanguages] objectAtIndex:0]];
        
        #ifdef LOGOUTPUTON
        NSLog(@"Country code: %@, language: %@", countryCode, languageCode);
        #endif
        
        NSString *appid = AppIDIPHONE;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                appid = AppIDIPAD;
        } else {
                appid = AppIDIPHONE;
        }
        
        AFHTTPClient *registertokenHttpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString: @"http://www.zonezeroapps.com/"]];
        [registertokenHttpClient defaultValueForHeader:@"Accept"];
        
        NSString *requesturlpath = [NSString stringWithFormat: @"servers/pushnotificationserver/registerDevice.php?appId=%@&deviceToken=%@&deviceId=%@&countryCode=%@&languageCode=%@", appid, tokenString, deviceID, countryCode, languageCode];
        
        #ifdef SBBAPILogLevelCancel
        //NSLog(@"Error url: %@", requesturlpath);
        #endif
        
        NSMutableURLRequest *errorrequest = [registertokenHttpClient requestWithMethod:@"POST" path: requesturlpath parameters:nil];
        [errorrequest setTimeoutInterval: SBBAPIREQUESTERRREQSTANDARDTIMEOUT];
        AFHTTPRequestOperation *erroroperation = [[AFHTTPRequestOperation alloc] initWithRequest:errorrequest];
        
         [erroroperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         
             NSLog(@"Register for push with token: %@", [operation responseString]);
             [@"DAR" writeToFile:[documentsDirectory stringByAppendingPathComponent: DeviceAlreadyRegisteredForRemoteNotificationFlagfile] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
             [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error registering for device notifications: %@", [operation responseString]);
             [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
         }];

        
        [erroroperation start];
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
	// Tja hier machen wir was immer wir wollen wenn die Registrierung fehlgeschlagen hat
    
    #ifdef  LOGOUTPUTON
    NSLog(@"Error in registration. Error: %@", err);
    #endif
    
    //NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	// und hier behandeln wir eine eigehende Notification. Dabei steht in der userInfo genau das was wir auf unserem Server in den $payload geschrieben haben.
	//[self handleUserInfo:userInfo];
}


- (void)initializeSettings
{
    // standard stored preference values
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    // settings files to process
    NSMutableArray *preferenceFiles = [[NSMutableArray alloc] init];
    
    // begin with Root file
    [preferenceFiles addObject:@"Root"];
    
    // as other settings files are discovered will be added to preferencesFiles
    while ([preferenceFiles count] > 0) {
        
        // init IASKSettingsReader for current settings file
        NSString *file = [preferenceFiles lastObject];
        [preferenceFiles removeLastObject];
        IASKSettingsReader *settingsReader = [[IASKSettingsReader alloc]
                                              initWithFile:file];
        
        // extract preference specifiers
        NSArray *preferenceSpecifiers = [[settingsReader settingsBundle]
                                         objectForKey:kIASKPreferenceSpecifiers];
        
        // process each specifier in the current settings file
        for (NSDictionary *specifier in preferenceSpecifiers) {
            
            // get type of current specifier
            NSString *type = [specifier objectForKey:kIASKType];
            
            // need to check child pane specifier for additional file
            if ([type isEqualToString:kIASKPSChildPaneSpecifier]) {
                [preferenceFiles addObject:[specifier objectForKey:kIASKFile]];
            }
            else {
                // check if current specifier has a default value
                id defaultValue = [specifier objectForKey:kIASKDefaultValue];
                
                if (defaultValue) {
                    // get key from specifier and current stored preference value
                    NSString *key = [specifier objectForKey:kIASKKey];
                    id value = [defaults objectForKey:key];
                    
                    // update preference value with default value if necessary
                    if (key && value == nil) {
                        [defaults setObject:defaultValue forKey:key];
                    }
                }
            }
            
        }
        
    }
    
    // synchronize stored preference values
    [defaults synchronize];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    #ifdef LOGOUTPUTON
    NSLog(@"App opened via URL: %@", [url absoluteString]);
    #endif
    
    if ([MKDirectionsRequest isDirectionsRequestURL:url]) {
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] initWithContentsOfURL:url];
        MKMapItem *startItem = request.source;
        MKMapItem *endItem = request.destination;
        
        CLLocationCoordinate2D startLocationCoordinate = startItem.placemark.location.coordinate;
        CLLocationCoordinate2D endLocationCoordinate = endItem.placemark.location.coordinate;
                
        #ifdef LOGOUTPUTON
        NSLog(@"App opened from map: start: %.6f, %.6f / end: %.6f, %.6f", startLocationCoordinate.latitude, startLocationCoordinate.longitude, endLocationCoordinate.latitude, endLocationCoordinate.longitude);
        NSLog(@"App opened from map: start: %@ / end: %@", startItem.name, endItem.name);
        NSLog(@"App opened from map: start: %@ / end: %@", startItem.placemark.name, endItem.placemark.name);
        NSLog(@"App opened from map: start: %@ / end: %@", startItem.placemark.title, endItem.placemark.title);
        #endif
        
        if ([startItem isCurrentLocation]) {
            #ifdef LOGOUTPUTON
            NSLog(@"App opened from map. start is current location");
            #endif
            
            Station *toStation = [[Station alloc] init];
            if (endItem.placemark.title) {
                toStation.stationName =  [self shortenTitleIfTooLong: endItem.placemark.title maxLenth: 22];
            } else {
                toStation.stationName = @"Maps location";
            }
            toStation.latitude = [NSNumber numberWithFloat: endLocationCoordinate.latitude];
            toStation.longitude = [NSNumber numberWithFloat: endLocationCoordinate.longitude];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                #ifdef LOGOUTPUTON
                NSLog(@"Device is iPad");
                #endif
                if (self.connectionsContainerViewControlleriPad) {
                    [self.connectionsContainerViewControlleriPad setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:nil to:toStation push:YES searchinit:NO];
                    if (self.tabBarController.selectedIndex !=0) {
                        [self.tabBarController setSelectedIndex: 0];
                    }
                    [self.connectionsContainerViewControlleriPad viewControllerSelectedFromTabbar];
                }
                            
            } else {
                #ifdef LOGOUTPUTON
                NSLog(@"Device is iPhone");
                #endif
                if (self.selectStationsViewController) {
                    [self.selectStationsViewController setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:nil to:toStation push:YES searchinit:NO];
                }
            }
        } else if ([endItem isCurrentLocation]) {
            #ifdef LOGOUTPUTON
            NSLog(@"App opened from map. end is current location");
            #endif
            
            Station *fromStation = [[Station alloc] init];
            if (startItem.placemark.title) {
                fromStation.stationName = [self shortenTitleIfTooLong: startItem.placemark.title maxLenth: 22];
            } else {
                fromStation.stationName = @"Maps location";
            }
            fromStation.latitude = [NSNumber numberWithFloat: startLocationCoordinate.latitude];
            fromStation.longitude = [NSNumber numberWithFloat: startLocationCoordinate.longitude];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                #ifdef LOGOUTPUTON
                NSLog(@"Device is iPad");
                #endif
                if (self.connectionsContainerViewControlleriPad) {
                    [self.connectionsContainerViewControlleriPad setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:fromStation to:nil push:YES searchinit:NO];
                    if (self.tabBarController.selectedIndex !=0) {
                        [self.tabBarController setSelectedIndex: 0];
                    }
                    [self.connectionsContainerViewControlleriPad viewControllerSelectedFromTabbar];
                }
                
            } else {
                #ifdef LOGOUTPUTON
                NSLog(@"Device is iPhone");
                #endif
                if (self.selectStationsViewController) {
                    [self.selectStationsViewController setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:fromStation to:nil push:YES searchinit:NO];
                }
            }
        } else {
            #ifdef LOGOUTPUTON
            NSLog(@"App opened from map. start and end are set current location");
            #endif
            
            Station *fromStation = [[Station alloc] init];
            if (startItem.placemark.title) {
                fromStation.stationName = [self shortenTitleIfTooLong: startItem.placemark.title maxLenth: 22];
            } else {
                fromStation.stationName = @"Maps location";
            }
            fromStation.latitude = [NSNumber numberWithFloat: startLocationCoordinate.latitude];
            fromStation.longitude = [NSNumber numberWithFloat: startLocationCoordinate.longitude];
            
            Station *toStation = [[Station alloc] init];
            if (endItem.placemark.title) {
                toStation.stationName = [self shortenTitleIfTooLong: endItem.placemark.title maxLenth: 22];
            } else {
                toStation.stationName = @"Maps location";
            }
            toStation.latitude = [NSNumber numberWithFloat: endLocationCoordinate.latitude];
            toStation.longitude = [NSNumber numberWithFloat: endLocationCoordinate.longitude];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                #ifdef LOGOUTPUTON
                NSLog(@"Device is iPad");
                #endif
                if (self.connectionsContainerViewControlleriPad) {
                    [self.connectionsContainerViewControlleriPad setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:fromStation to:toStation push:YES searchinit:NO];
                    if (self.tabBarController.selectedIndex !=0) {
                        [self.tabBarController setSelectedIndex: 0];
                    }
                    [self.connectionsContainerViewControlleriPad viewControllerSelectedFromTabbar];
                }
                
            } else {
                #ifdef LOGOUTPUTON
                NSLog(@"Device is iPhone");
                #endif
                
                if (self.selectStationsViewController) {
                    [self.selectStationsViewController setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:fromStation to:toStation push:YES searchinit:NO];
                }
            }
        }
        
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#ifdef kCreateDBNew
    NSLog(@"Init db...");
    //[self createStationsDB];
    //[self createUniqueStationsDB];
    [self createUniqueStationsDBSecond];
    return YES;
#else
    [self managedObjectContext];
    #ifdef LOGOUTPUTON
    NSLog(@"DB ready.");
    #endif
#endif
        
    //[self convertSwissMapBounderiesToGeoJSON];
    
    #ifdef LOGOUTPUTON
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Doc dir: %@", documentsDirectory);
    NSLog(@"App opened with options: %@", launchOptions);
    #endif
    
    //NSLocale *locale = [NSLocale currentLocale];
    //NSString *languageCode = [locale objectForKey: NSLocaleLanguageCode];
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    #ifdef LOGOUTPUTON
    NSLog(@"Language code: %@", languageCode);
    #endif
    
    NSUInteger apiLanguageCode = reqEnglish;
    if ([languageCode isEqualToString:@"en"]) {
        apiLanguageCode = reqEnglish;
    } else if ([languageCode isEqualToString:@"de"]) {
        apiLanguageCode = reqGerman;
    } else if ([languageCode isEqualToString:@"fr"]) {
        apiLanguageCode = reqFrench;
    } else if ([languageCode isEqualToString:@"it"]) {
        apiLanguageCode = reqItalian;
    }
    
    [[SBBAPIController sharedSBBAPIController] setSBBAPILanguageLocale: apiLanguageCode];
    
    //[[SBBAPIController sharedSBBAPIController] setSBBAPIStationsManagedObjectContext: self.managedObjectContext];
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
#ifndef kCreateDBNew 
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        #ifdef LOGOUTPUTON
        NSLog(@"Device is iPad");
        #endif
        
        [[SBBAPIController sharedSBBAPIController] setSBBConReqNumberOfConnectionsForRequest: 6];
        [[SBBAPIController sharedSBBAPIController] setSBBConScrNumberOfConnectionsForRequest: 4];
        [[SBBAPIController sharedSBBAPIController] setSbbStbReqNumberOfConnectionsForRequest: 40];
        [[SBBAPIController sharedSBBAPIController] setSbbStbScrNumberOfConnectionsForRequest: 40];
        
        self.connectionsContainerViewControlleriPad = [[ConnectionsContainerViewControlleriPad alloc] init];
        self.connectionsContainerViewControlleriPad.managedObjectContext = self.managedObjectContext;
                
        self.stationboardContainerViewControlleriPad = [[StationboardContainerViewControlleriPad alloc] init];
        self.stationboardContainerViewControlleriPad.managedObjectContext = self.managedObjectContext;
        self.stationboardContainerViewControlleriPad.tabbarControllerReference = self.tabBarController;
        
        self.rssTransportNewContainerViewControlleriPad = [[RSSTransportNewContainerViewControlleriPad alloc] init];
        
        NSMutableArray* controllers = [NSMutableArray arrayWithObjects: self.connectionsContainerViewControlleriPad, self.stationboardContainerViewControlleriPad, self.rssTransportNewContainerViewControlleriPad, nil];
        
        self.tabBarController = [[JBTabBarController alloc] init];
        self.tabBarController.viewControllers = controllers;
        
        self.tabBarController.tabBar.maximumTabWidth = 100.0f;
        self.tabBarController.delegate = self;
        
        self.tabBarController.tabBar.layoutStrategy = JBTabBarLayoutStrategyCenter;
        
        self.stationboardContainerViewControlleriPad.tabbarControllerReference = self.tabBarController;
        
        self.window.backgroundColor = [UIColor blackColor];
        self.window.rootViewController = self.tabBarController;

        [self.tabBarController setSelectedViewController: self.connectionsContainerViewControlleriPad];
        
    } else {
        #ifdef LOGOUTPUTON
        NSLog(@"Device is iPhone");
        #endif
        
        [[SBBAPIController sharedSBBAPIController] setSBBConReqNumberOfConnectionsForRequest: 4];
        [[SBBAPIController sharedSBBAPIController] setSBBConScrNumberOfConnectionsForRequest: 4];
        [[SBBAPIController sharedSBBAPIController] setSbbStbReqNumberOfConnectionsForRequest: 40];
        [[SBBAPIController sharedSBBAPIController] setSbbStbScrNumberOfConnectionsForRequest: 40];
        
        self.selectStationsViewController = [[SelectStationsViewController alloc] init];
        self.selectStationsViewController.managedObjectContext = self.managedObjectContext;
        self.selectStationsViewController.view.frame = self.window.bounds;
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController: self.selectStationsViewController];
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.backgroundColor = [UIColor darkGrayColor];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
        
        self.window.backgroundColor = [UIColor blackColor];
        self.window.rootViewController = self.navigationController;
    }
#endif
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)tabBarController:(JBTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    #ifdef LOGOUTPUTON
    int tabbarSelectedIndex = tabBarController.selectedIndex;
    NSLog(@"TabbarController did select view controller with index: %d", tabbarSelectedIndex);
    #endif
    
    if ([viewController respondsToSelector: @selector(viewControllerSelectedFromTabbar)]) {
        [viewController performSelector: @selector(viewControllerSelectedFromTabbar)];
    }
    
    [self.connectionsContainerViewControlleriPad viewControllerSelectedFromTabbar];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // Play a sound and show an alert only if the application is active, to avoid doubly notifiying the user.
    if ([application applicationState] == UIApplicationStateActive) {
        // Initialize the alert view.
        if (!_notificationAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [self setNotificationAlert:alert];
        }
        
        // Load the notification sound.
        if (!_notificationSound) {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Attack"
                                                                  ofType:@"caf"];
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_notificationSound);
        }
        
        // Set the title of the alert with the notification's body.
        [_notificationAlert setTitle:[notification alertBody]];
        
        // Play the sound and show the alert.
        AudioServicesPlaySystemSound(_notificationSound);
        [_notificationAlert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    if (_notificationSound) {
        AudioServicesDisposeSystemSoundID(_notificationSound);
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"App received memory warning");
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    //NSLog(@"Set managed object context");
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        //_managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    //NSLog(@"Managed object context set");
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Swiss_Trains" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    #ifdef LOGOUTPUTON
    NSLog(@"Add persistent store...");
    #endif
    
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *storePath = [documentsDirectory stringByAppendingPathComponent: @"Stations.sqlite"];
	//NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:storePath]) {
        NSDictionary *storePathAtts = [fileManager attributesOfItemAtPath: storePath error: nil];
        NSDate *storeDBdate = [storePathAtts objectForKey:NSFileCreationDate];
        
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Stations" ofType:@"sqlite"];
		if (defaultStorePath) 
		{
            NSDictionary *defaultPathAtts = [fileManager attributesOfItemAtPath: defaultStorePath error: nil];
            NSDate *defaultDBdate = [defaultPathAtts objectForKey:NSFileCreationDate];
            
            #ifdef LOGOUTPUTON
            NSLog(@"Store database date:  %@ / Defaut database date: %@", storeDBdate, defaultDBdate);
            #endif
            
            NSComparisonResult comparisonResult = [storeDBdate compare:defaultDBdate];
            
            if (comparisonResult == NSOrderedAscending) {
                
                #ifdef LOGOUTPUTON
                NSLog(@"Default database is newer. Delete current user db in document directory.");
                #endif
                
                [[NSFileManager defaultManager] removeItemAtPath: storePath error: nil];
                
            } //else NSLog(@"Default database is older or the same.");
        }
    }
    
	if (![fileManager fileExistsAtPath:storePath])
	{
		#ifdef LOGOUTPUTON
        NSLog(@"Copy DB from bundle");
        #endif
		
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Stations" ofType:@"sqlite"];
		if (defaultStorePath)
		{
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
		else
		{
			NSLog(@"Unresolved error: standard DB in bundle not found!");
			abort();
			
		}
	}
	else
	{
		//NSLog(@"Init DB from documents directory");
		
	}
    
    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Stations.sqlite"];
    */
    
    NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Stations" ofType:@"sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath: defaultStorePath];
    
    //NSLog(@"URL: %@", defaultStorePath);
    
    NSDictionary* store_options_dict = [NSDictionary
                                        dictionaryWithObject:[NSNumber numberWithBool:YES]
                                        forKey:NSReadOnlyPersistentStoreOption];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:store_options_dict error:&error]) {
       
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    #ifdef LOGOUTPUTON
    NSLog(@"Persistent store added.");
    #endif
    
    return _persistentStoreCoordinator;
}

/*
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
*/


@end
