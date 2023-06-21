//
//  TrainlineTestOperation.h
//  Swiss Trains
//
//  Created by Alain on 23.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MTDirectionsKit/MTDirectionsKit.h>

#import "ConResult.h"
#import "ConSection.h"
#import "Journey.h"

typedef void (^TrainlineTestOperationCompletionBlock)(void);
typedef void (^TrainlineOperationCompletionSuccessBlock)(NSArray *);
typedef void (^TrainlineOperationCompletionFailureBlock)(NSUInteger);

@interface TrainlineTestOperation : NSOperation

@property (strong, nonatomic) NSError *error;

@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) MTDRoute *route;

@property (strong, nonatomic) ConResult *conresult;
@property (strong, nonatomic) ConSection *consection;
@property (strong, nonatomic) Journey *journey;

@property (strong, nonatomic) TrainlineOperationCompletionSuccessBlock trainlineOperationCompletionSuccessBlock;
@property (strong, nonatomic) TrainlineOperationCompletionFailureBlock trainlineOperationCompletionFailureBlock;

- (void)setCompletionBlockWithSuccess:(TrainlineOperationCompletionSuccessBlock)successblock
                              failure:(TrainlineOperationCompletionFailureBlock)failureblock;

@end
