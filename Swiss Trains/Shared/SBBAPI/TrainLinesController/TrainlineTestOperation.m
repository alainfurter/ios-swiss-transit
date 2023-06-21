//
//  TrainlineTestOperation.m
//  Swiss Trains
//
//  Created by Alain on 23.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "TrainlineTestOperation.h"

@implementation TrainlineTestOperation



- (void)setCompletionBlockWithSuccess:(TrainlineOperationCompletionSuccessBlock)successblock
                              failure:(TrainlineOperationCompletionFailureBlock)failureblock
{
    // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-retain-cycles"
    //__weak __typeof(&*self)weakSelf = self;
    
    //__block id blockSelf = self;
    
    //super.completionBlock = ^{};
    
    if (successblock) {
        
        self.trainlineOperationCompletionSuccessBlock = ^(NSArray *routes){
            dispatch_async(dispatch_get_main_queue(), ^{
                successblock(routes);
            });
        };
    }
    
    if (failureblock) {
        self.trainlineOperationCompletionFailureBlock = ^(NSUInteger errorcode){
            dispatch_async(dispatch_get_main_queue(), ^{
                failureblock(errorcode);
            });
        };
    }
    
    
    self.trainlineOperationCompletionFailureBlock = failureblock;
    
    /*
    self.trainlineTestOperationCompletionBlock = ^{
        if ([weakSelf isCancelled]) {
            return;
        }
        
        if (self.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(weakSelf, self.error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.conresult && self.routes) {
                        success(weakSelf, self.route);
                    } else if ((self.journey && self.route) || (self.consection && self.route)) {
                        success(weakSelf, self.route);
                    } else if (self.routes) {
                        success(weakSelf, self.routes);
                    } else if (self.route) {
                        success(weakSelf, self.route);
                    }
                });
            }
        }
    };
    */
}

- (void)main {
    
    NSLog(@"Executing operation");
    
    if (self.completionBlock) {
        
    }
    
}

@end
