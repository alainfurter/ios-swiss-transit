//
//  NSManagedObjectContext+Blocks.h
//  Swiss Trains
//
//  Created by Alain on 21.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

typedef void (^NSManagedObjectContextFetchCompleteBlock)(NSArray* results);
typedef void (^NSManagedObjectContextFetchFailBlock)(NSError *error);

@interface NSManagedObjectContext (Blocks)

-(void)executeFetchRequestInBackground:(NSFetchRequest*) aRequest
							onComplete:(NSManagedObjectContextFetchCompleteBlock) completeBlock
							   onError:(NSManagedObjectContextFetchFailBlock) failBlock;

-(void)performFetchInBackground: (NSFetchedResultsController*) fetchedResultsController
                     onComplete:(NSManagedObjectContextFetchCompleteBlock) completeBlock
                        onError:(NSManagedObjectContextFetchFailBlock) failBlock;

@end

