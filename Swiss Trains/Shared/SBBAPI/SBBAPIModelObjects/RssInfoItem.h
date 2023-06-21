//
//  RssInfoItem.h
//  Swiss Trains
//
//  Created by Alain on 21.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssInfoItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *pubdate;
@property (strong, nonatomic) NSString *pubdatestring;

@end
