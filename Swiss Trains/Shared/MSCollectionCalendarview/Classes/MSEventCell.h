//
//  MSEventCell.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ConSection.h"

#import "SBBAPIController.h"

@class MSEvent;

@interface MSEventCell : UICollectionViewCell

@property (nonatomic, weak) MSEvent *event;

@property (nonatomic, weak) ConSection *consection;

@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;

@end
