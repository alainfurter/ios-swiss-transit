//
//  ConnectionsDetailViewController.h
//  Swiss Trains
//
//  Created by Alain on 06.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"
//#import "UIView+Origami.h"

#import "ConnectionsDetailviewCelliPad.h"
//#import "ConnectionInfoCell.h"
#import "ConnectionInfoTableviewCell.h"

#import "SBBAPIController.h"

#import "UIApplication+AppDimension.h"

@class ConnectionsDetailViewControlleriPad;

@protocol ConnectionsDetailViewControlleriPadDelegate <NSObject>
- (void)didSelectDetailviewCellWithIndex:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index;
- (void)didTriggerDetailviewCellWithIndexLongPress:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index viewrect:(CGRect)viewrect;
@end


@interface ConnectionsDetailViewControlleriPad : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *detailViewTableView;

@property (weak) id <ConnectionsDetailViewControlleriPadDelegate> delegate;

@property (assign) NSInteger selectedIndex;

@property (assign) BOOL tableViewCellsAreSelectable;

@property (strong, nonatomic) NSString *knowBetterStartLocation;
@property (strong, nonatomic) NSString *knowBetterEndLocation;

- (id)initWithFrame:(CGRect)viewFrame;
- (void) updateDetailviewTableViewWithOverviewIndex:(NSUInteger)index;

- (void) setSelectableStateOfTableViewAndReload:(BOOL)selectable;
- (void) setSelectableStateOfTableView:(BOOL)selectable;

- (void) adjustTableViewHeightWithRect:(CGRect)rect reload:(BOOL)reload;

@property (assign) BOOL trackNumberInCellsAreVisible;
//- (void) toggleTrackNumberVisibleState:(BOOL)visible;

@end
