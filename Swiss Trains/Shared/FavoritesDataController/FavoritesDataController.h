//
//  FavoritesDataController.h
//  Swiss Trains
//
//  Created by Alain on 21.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Station.h"

@interface FavoritesDataController : NSObject

+ (FavoritesDataController *) sharedFavoritesDataController;

@property (nonatomic, strong) NSMutableArray *favoritesArray;
@property (nonatomic, strong) NSArray *fetchedFilteredArray;

- (void) addStationToFavoritesList:(Station *)station;
- (void) fetchFavoritesListForStationStartingWithName:(NSString *)name onlystations:(BOOL)onlystations;
- (void) deleteFavoritesList;

- (NSArray *)getFavoritesStations;
- (NSUInteger)getNumberOfFavoritesStations;
- (Station *)getFavoritesStationWithIndex:(NSUInteger)index;


@end
