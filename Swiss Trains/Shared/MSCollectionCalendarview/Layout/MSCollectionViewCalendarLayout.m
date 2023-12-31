//
//  MSCollectionViewCalendarLayout.m
//  MSCollectionViewCalendarLayout
//
//  Created by Eric Horacek on 2/18/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MSCollectionViewCalendarLayout.h"
#import "NSDate+CupertinoYankee.h"

NSString *const MSCollectionElementKindTimeRowHeader = @"MSCollectionElementKindTimeRow";
NSString *const MSCollectionElementKindDayColumnHeader = @"MSCollectionElementKindDayHeader";
NSString *const MSCollectionElementKindCurrentTimeIndicator = @"MSCollectionElementKindCurrentTimeIndicator";
NSString *const MSCollectionElementKindVerticalGridline = @"MSCollectionElementKindVerticalGridline";
NSString *const MSCollectionElementKindHorizontalGridline = @"MSCollectionElementKindHorizontalGridline";
NSString *const MSCollectionElementKindCurrentTimeHorizontalGridline = @"MSCollectionElementKindCurrentTimeHorizontalGridline";
NSString *const MSCollectionElementKindTimeRowHeaderBackground = @"MSCollectionElementKindTimeRowHeaderBackground";
NSString *const MSCollectionElementKindDayColumnHeaderBackground = @"MSCollectionElementKindDayColumnHeaderBackground";

@interface MSTimerWeakTarget : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
- (SEL)fireSelector;
@end

@implementation MSTimerWeakTarget
- (id)initWithTarget:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
    }
    return self;
}
- (void)fire:(NSTimer*)timer
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:timer];
#pragma clang diagnostic pop
}
- (SEL)fireSelector
{
    return @selector(fire:);
}
@end

@interface MSCollectionViewCalendarLayout ()

// Minute Timer
@property (nonatomic, strong) NSTimer *minuteTimer;

// Minute Height
@property (nonatomic, readonly) CGFloat minuteHeight;

// Caches
@property (nonatomic, assign) BOOL needsToPopulateAttributesForAllSections;
@property (nonatomic, strong) NSCache *cachedDayDateComponents;
@property (nonatomic, strong) NSCache *cachedStartTimeDateComponents;
@property (nonatomic, strong) NSCache *cachedEndTimeDateComponents;
@property (nonatomic, strong) NSCache *cachedCurrentDateComponents;
@property (nonatomic, assign) CGFloat cachedMaxColumnHeight;
@property (nonatomic, assign) NSInteger cachedEarliestHour;
@property (nonatomic, assign) NSInteger cachedLatestHour;
@property (nonatomic, strong) NSMutableDictionary *cachedColumnHeights;
@property (nonatomic, strong) NSMutableDictionary *cachedEarliestHours;
@property (nonatomic, strong) NSMutableDictionary *cachedLatestHours;

// Registered Decoration Classes
@property (nonatomic, strong) NSMutableDictionary *registeredDecorationClasses;

// Attributes
@property (nonatomic, strong) NSMutableArray *allAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayColumnHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayColumnHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *horizontalGridlineAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentTimeIndicatorAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentTimeHorizontalGridlineAttributes;

// Minute Updates
- (void)minuteTick:(id)sender;
// Layout
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache;
- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache;
// Scrolling
- (NSInteger)closestSectionToCurrentTime;
// Section Sizing
- (CGRect)rectForSection:(NSInteger)section;
- (CGFloat)maxSectionHeight;
- (CGFloat)stackedSectionHeight;
- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection;
- (CGFloat)sectionHeight:(NSInteger)section;
- (CGFloat)minuteHeight;
// Z Index
- (CGFloat)zIndexForElementKind:(NSString *)elementKind;
- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating;
// Hours
- (NSInteger)earliestHour;
- (NSInteger)latestHour;
- (NSInteger)earliestHourForSection:(NSInteger)section;
- (NSInteger)latestHourForSection:(NSInteger)section;
// Delegate Wrappers
- (NSDateComponents *)dayForSection:(NSInteger)section;
- (NSDateComponents *)startTimeForIndexPath:(NSIndexPath *)indexPath;
- (NSDateComponents *)endTimeForIndexPath:(NSIndexPath *)indexPath;
- (NSDateComponents *)currentTimeDateComponents;

@end

@implementation MSCollectionViewCalendarLayout

#pragma mark - NSObject

- (void)dealloc
{
    [self.minuteTimer invalidate];
    self.minuteTimer = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.needsToPopulateAttributesForAllSections = YES;
        self.cachedDayDateComponents = [NSCache new];
        self.cachedStartTimeDateComponents = [NSCache new];
        self.cachedEndTimeDateComponents = [NSCache new];
        self.cachedCurrentDateComponents = [NSCache new];
        self.cachedMaxColumnHeight = CGFLOAT_MIN;
        self.cachedEarliestHour = NSIntegerMax;
        self.cachedLatestHour = NSIntegerMin;
        self.cachedColumnHeights = [NSMutableDictionary new];
        self.cachedEarliestHours = [NSMutableDictionary new];
        self.cachedLatestHours = [NSMutableDictionary new];
        
        self.registeredDecorationClasses = [NSMutableDictionary new];
        
        self.allAttributes = [NSMutableArray new];
        self.itemAttributes = [NSMutableDictionary new];
        self.dayColumnHeaderAttributes = [NSMutableDictionary new];
        self.dayColumnHeaderBackgroundAttributes = [NSMutableDictionary new];
        self.timeRowHeaderAttributes = [NSMutableDictionary new];
        self.timeRowHeaderBackgroundAttributes = [NSMutableDictionary new];
        self.horizontalGridlineAttributes = [NSMutableDictionary new];
        self.currentTimeIndicatorAttributes = [NSMutableDictionary new];
        self.currentTimeHorizontalGridlineAttributes = [NSMutableDictionary new];
        
        self.hourHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80.0 : 80.0);
        //self.hourHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80.0 : 80.0);
        //self.sectionWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 236.0 : 234.0);
        self.sectionWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 130.0 : 234.0);
        self.dayColumnHeaderHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60.0 : 50.0);
        self.timeRowHeaderWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60.0 : 60.0);
        self.currentTimeIndicatorSize = CGSizeMake(20.0, 20.0);
        self.currentTimeHorizontalGridlineHeight = 1.0;
        self.horizontalGridlineHeight = 1.0;
        self.sectionMargin = UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0);
        self.cellMargin = UIEdgeInsetsMake(0.0, 1.0, 1.0, 0.0);
        self.contentMargin = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIEdgeInsetsMake(30.0, 0.0, 30.0, 30.0) : UIEdgeInsetsMake(20.0, 0.0, 20.0, 10.0));
        
        self.displayHeaderBackgroundAtOrigin = YES;
        self.sectionLayoutType = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? MSSectionLayoutTypeHorizontalTile : MSSectionLayoutTypeVerticalTile);
        self.headerLayoutType = MSHeaderLayoutTypeDayColumnAboveTimeRow;
        
        // Invalidate layout on minute ticks (to update the position of the current time indicator)
        NSDate *oneMinuteInFuture = [[NSDate date] dateByAddingTimeInterval:60];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:oneMinuteInFuture];
        NSDate *nextMinuteBoundary = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        // This needs to be a weak reference, otherwise we get a retain cycle
        MSTimerWeakTarget *timerWeakTarget = [[MSTimerWeakTarget alloc] initWithTarget:self selector:@selector(minuteTick:)];
        self.minuteTimer = [[NSTimer alloc] initWithFireDate:nextMinuteBoundary interval:60 target:timerWeakTarget selector:timerWeakTarget.fireSelector userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.minuteTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [self invalidateLayoutCache];
    
    // Update the layout with the new items
    [self prepareLayout];
    
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)finalizeCollectionViewUpdates
{
    // This is a hack to prevent the error detailed in :
    // http://stackoverflow.com/questions/12857301/uicollectionview-decoration-and-supplementary-views-can-not-be-moved
    // If this doesn't happen, whenever the collection view has batch updates performed on it, we get multiple instantiations of decoration classes
    for (UIView *subview in self.collectionView.subviews) {
        for (Class decorationViewClass in self.registeredDecorationClasses.allValues) {
            if ([subview isKindOfClass:decorationViewClass]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)decorationViewKind
{
    [super registerClass:viewClass forDecorationViewOfKind:decorationViewKind];
    self.registeredDecorationClasses[decorationViewKind] = viewClass;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.needsToPopulateAttributesForAllSections) {
        [self prepareSectionLayoutForSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
        self.needsToPopulateAttributesForAllSections = NO;
    }
    
    BOOL needsToPopulateAllAttribtues = (self.allAttributes.count == 0);
    if (needsToPopulateAllAttribtues) {
        [self.allAttributes addObjectsFromArray:[self.dayColumnHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.dayColumnHeaderBackgroundAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.timeRowHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.timeRowHeaderBackgroundAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.horizontalGridlineAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.itemAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.currentTimeIndicatorAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.currentTimeHorizontalGridlineAttributes allValues]];
    }
}

- (void)prepareSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
    switch (self.sectionLayoutType) {
        case MSSectionLayoutTypeHorizontalTile:
            [self prepareHorizontalTileSectionLayoutForSections:sectionIndexes];
            break;
        case MSSectionLayoutTypeVerticalTile:
            [self prepareVerticalTileSectionLayoutForSections:sectionIndexes];
            break;
    }
}

- (void)prepareHorizontalTileSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    BOOL needsToPopulateItemAttributes = (self.itemAttributes.count == 0);
    BOOL needsToPopulateHorizontalGridlineAttributes = (self.horizontalGridlineAttributes.count == 0);
    
    NSInteger earliestHour = [self earliestHour];
    NSInteger latestHour = [self latestHour];
    
    CGFloat sectionWidth = (self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right);
    CGFloat calendarGridMinX = (self.timeRowHeaderWidth + self.contentMargin.left);
    CGFloat calendarGridMinY = (self.dayColumnHeaderHeight + self.contentMargin.top);
    CGFloat calendarGridWidth = (self.collectionViewContentSize.width - self.timeRowHeaderWidth - self.contentMargin.right);
    
    // Time Row Header
    CGFloat timeRowHeaderMinX = fmaxf(self.collectionView.contentOffset.x, 0.0);
    BOOL timeRowHeaderFloating = ((timeRowHeaderMinX != 0) || self.displayHeaderBackgroundAtOrigin);;
    
    // Time Row Header Background
    NSIndexPath *timeRowHeaderBackgroundIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *timeRowHeaderBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:timeRowHeaderBackgroundIndexPath ofKind:MSCollectionElementKindTimeRowHeaderBackground withItemCache:self.timeRowHeaderBackgroundAttributes];
    // Frame
    CGFloat timeRowHeaderBackgroundHeight = fmaxf(self.collectionViewContentSize.height + self.collectionView.frame.size.height, self.collectionView.frame.size.height);
    CGFloat timeRowHeaderBackgroundWidth = fmaxf(self.collectionViewContentSize.width + self.collectionView.frame.size.width, self.collectionView.frame.size.width);
    CGFloat timeRowHeaderBackgroundMinX = (timeRowHeaderMinX - timeRowHeaderBackgroundWidth + self.timeRowHeaderWidth);
    CGFloat timeRowHeaderBackgroundMinY = -nearbyintf(self.collectionView.frame.size.height / 2.0);
    timeRowHeaderBackgroundAttributes.frame = CGRectMake(timeRowHeaderBackgroundMinX, timeRowHeaderBackgroundMinY, timeRowHeaderBackgroundWidth, timeRowHeaderBackgroundHeight);
    // Floating
    timeRowHeaderBackgroundAttributes.hidden = !timeRowHeaderFloating;
    timeRowHeaderBackgroundAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindTimeRowHeaderBackground floating:timeRowHeaderFloating];
    
    // Current Time Indicator
    NSIndexPath *currentTimeIndicatorIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *currentTimeIndicatorAttributes = [self layoutAttributesForDecorationViewAtIndexPath:currentTimeIndicatorIndexPath ofKind:MSCollectionElementKindCurrentTimeIndicator withItemCache:self.currentTimeIndicatorAttributes];
    
    // Current Time Horizontal Gridline
    NSIndexPath *currentTimeHorizontalGridlineIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *currentTimeHorizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:currentTimeHorizontalGridlineIndexPath ofKind:MSCollectionElementKindCurrentTimeHorizontalGridline withItemCache:self.currentTimeHorizontalGridlineAttributes];
    
    // The current time is within the day
    NSDateComponents *currentTimeDateComponents = [self currentTimeDateComponents];
    BOOL currentTimeIndicatorVisible = ((currentTimeDateComponents.hour >= earliestHour) && (currentTimeDateComponents.hour < latestHour));
    
    if (currentTimeIndicatorVisible) {
        // The y value of the current time
        CGFloat timeY = (calendarGridMinY + nearbyintf(((currentTimeDateComponents.hour - earliestHour) * self.hourHeight) + (currentTimeDateComponents.minute * self.minuteHeight)));
        
        CGFloat currentTimeIndicatorMinY = (timeY - nearbyintf(self.currentTimeIndicatorSize.height / 2.0));
        CGFloat currentTimeIndicatorMinX = (fmaxf(self.collectionView.contentOffset.x, 0.0) + (self.timeRowHeaderWidth - self.currentTimeIndicatorSize.width));
        currentTimeIndicatorAttributes.frame = (CGRect){{currentTimeIndicatorMinX, currentTimeIndicatorMinY}, self.currentTimeIndicatorSize};
        currentTimeIndicatorAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindCurrentTimeIndicator floating:timeRowHeaderFloating];
        
        CGFloat currentTimeHorizontalGridlineMinY = (timeY - nearbyintf(self.currentTimeHorizontalGridlineHeight / 2.0));
        currentTimeHorizontalGridlineAttributes.frame = CGRectMake(calendarGridMinX, currentTimeHorizontalGridlineMinY, calendarGridWidth, self.currentTimeHorizontalGridlineHeight);
        currentTimeHorizontalGridlineAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    } else {
        currentTimeIndicatorAttributes.frame = CGRectZero;
        currentTimeHorizontalGridlineAttributes.frame = CGRectZero;
    }

    // Day Column Header
    CGFloat dayColumnHeaderMinY = fmaxf(self.collectionView.contentOffset.y, 0.0);
    BOOL dayColumnHeaderFloating = ((dayColumnHeaderMinY != 0) || self.displayHeaderBackgroundAtOrigin);
    
    // Day Column Header Background
    NSIndexPath *dayColumnHeaderBackgroundIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *dayColumnHeaderBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:dayColumnHeaderBackgroundIndexPath ofKind:MSCollectionElementKindDayColumnHeaderBackground withItemCache:self.dayColumnHeaderBackgroundAttributes];
    // Frame
    CGFloat dayColumnHeaderBackgroundWidth = fmaxf(self.collectionViewContentSize.width + self.collectionView.frame.size.width, self.collectionView.frame.size.width);
    CGFloat dayColumnHeaderBackgroundHeight = fmaxf(self.collectionViewContentSize.height + self.collectionView.frame.size.height, self.collectionView.frame.size.height);
    CGFloat dayColumnHeaderBackgroundMinX = -nearbyintf(self.collectionView.frame.size.width / 2.0);
    CGFloat dayColumnHeaderBackgroundMinY = (dayColumnHeaderMinY - dayColumnHeaderBackgroundHeight + self.dayColumnHeaderHeight);
    dayColumnHeaderBackgroundAttributes.frame = CGRectMake(dayColumnHeaderBackgroundMinX, dayColumnHeaderBackgroundMinY, dayColumnHeaderBackgroundWidth, dayColumnHeaderBackgroundHeight);
    // Floating
    dayColumnHeaderBackgroundAttributes.hidden = !dayColumnHeaderFloating;
    dayColumnHeaderBackgroundAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindDayColumnHeaderBackground floating:dayColumnHeaderFloating];
    
    // Time Row Headers
    NSUInteger timeRowHeaderIndex = 0;
    for (NSInteger hour = earliestHour; hour <= latestHour; hour++) {
        NSIndexPath *timeRowHeaderIndexPath = [NSIndexPath indexPathForItem:timeRowHeaderIndex inSection:0];
        UICollectionViewLayoutAttributes *timeRowHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:timeRowHeaderIndexPath ofKind:MSCollectionElementKindTimeRowHeader withItemCache:self.timeRowHeaderAttributes];
        CGFloat titleRowHeaderMinY = (calendarGridMinY + (self.hourHeight * (hour - earliestHour)) - nearbyintf(self.hourHeight / 2.0));
        timeRowHeaderAttributes.frame = CGRectMake(timeRowHeaderMinX, titleRowHeaderMinY, self.timeRowHeaderWidth, self.hourHeight);
        timeRowHeaderAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindTimeRowHeader floating:timeRowHeaderFloating];
        timeRowHeaderIndex++;
    }
    
    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        
        CGFloat sectionMinX = (calendarGridMinX + self.sectionMargin.left + (sectionWidth * section));
        
        // Day Column Header
        UICollectionViewLayoutAttributes *dayColumnHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section] ofKind:MSCollectionElementKindDayColumnHeader withItemCache:self.dayColumnHeaderAttributes];
        // Frame
        dayColumnHeaderAttributes.frame = CGRectMake(sectionMinX, dayColumnHeaderMinY, self.sectionWidth, self.dayColumnHeaderHeight);
        dayColumnHeaderAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindDayColumnHeader floating:dayColumnHeaderFloating];
        
        if (needsToPopulateItemAttributes) {
            // Items
            NSMutableArray *sectionItemAttributes = [NSMutableArray new];
            for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
                
                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForCellAtIndexPath:itemIndexPath withItemCache:self.itemAttributes];
                [sectionItemAttributes addObject:itemAttributes];
                
                NSDateComponents *itemStartTime = [self startTimeForIndexPath:itemIndexPath];
                NSDateComponents *itemEndTime = [self endTimeForIndexPath:itemIndexPath];
                
                CGFloat startHourY = ((itemStartTime.hour - earliestHour) * self.hourHeight);
                CGFloat startMinuteY = (itemStartTime.minute * self.minuteHeight);
                
                CGFloat endHourY;
                if (itemEndTime.day != itemStartTime.day) {
                    endHourY = (([[NSCalendar currentCalendar] maximumRangeOfUnit:NSHourCalendarUnit].length - earliestHour) * self.hourHeight) + (itemEndTime.hour * self.hourHeight);
                } else {
                    endHourY = ((itemEndTime.hour - earliestHour) * self.hourHeight);
                }
                CGFloat endMinuteY = (itemEndTime.minute * self.minuteHeight);
                
                CGFloat itemMinY = (startHourY + startMinuteY + calendarGridMinY + self.cellMargin.top);
                CGFloat itemMaxY = (endHourY + endMinuteY + calendarGridMinY - self.cellMargin.bottom);
                CGFloat itemMinX = (sectionMinX + self.cellMargin.left);
                CGFloat itemMaxX = (itemMinX + (self.sectionWidth - self.cellMargin.left - self.cellMargin.right));
                itemAttributes.frame = CGRectMake(itemMinX, itemMinY, (itemMaxX - itemMinX), (itemMaxY - itemMinY));
                
                itemAttributes.zIndex = [self zIndexForElementKind:nil];
            }
            [self adjustItemsForOverlap:sectionItemAttributes inSection:section sectionMinX:sectionMinX];
        }
    }];
    
    // Horizontal Gridlines
    if (needsToPopulateHorizontalGridlineAttributes) {
        NSUInteger horizontalGridlineIndex = 0;
        for (NSInteger hour = earliestHour; hour <= latestHour; hour++) {
            NSIndexPath *horizontalGridlineIndexPath = [NSIndexPath indexPathForItem:horizontalGridlineIndex inSection:0];
            UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:horizontalGridlineIndexPath ofKind:MSCollectionElementKindHorizontalGridline withItemCache:self.horizontalGridlineAttributes];
            CGFloat horizontalGridlineMinY = (calendarGridMinY + (self.hourHeight * (hour - earliestHour))) - nearbyintf(self.horizontalGridlineHeight / 2.0);
            horizontalGridlineAttributes.frame = CGRectMake(calendarGridMinX, horizontalGridlineMinY, calendarGridWidth, self.horizontalGridlineHeight);
            horizontalGridlineIndex++;
        }
    }
}

- (void)prepareVerticalTileSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    // Current Time Indicator
    NSIndexPath *currentTimeIndicatorIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *currentTimeIndicatorAttributes = [self layoutAttributesForDecorationViewAtIndexPath:currentTimeIndicatorIndexPath ofKind:MSCollectionElementKindCurrentTimeIndicator withItemCache:self.currentTimeIndicatorAttributes];
    
    // Current Time Horizontal Gridline
    NSIndexPath *currentTimeHorizontalGridlineIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *currentTimeHorizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:currentTimeHorizontalGridlineIndexPath ofKind:MSCollectionElementKindCurrentTimeHorizontalGridline withItemCache:self.currentTimeHorizontalGridlineAttributes];

    // Start these off hidden, and unhide them in the case of the current time indicator being within a specified section
    currentTimeIndicatorAttributes.frame = CGRectZero;
    currentTimeHorizontalGridlineAttributes.frame = CGRectZero;
    
    BOOL needsToPopulateItemAttributes = (self.itemAttributes.count == 0);
    BOOL needsToPopulateHorizontalGridlineAttributes = (self.horizontalGridlineAttributes.count == 0);
    
    CGFloat calendarGridMinX = (self.timeRowHeaderWidth + self.contentMargin.left);
    CGFloat calendarGridWidth = (self.collectionViewContentSize.width - self.timeRowHeaderWidth - self.contentMargin.left - self.contentMargin.right);
    
    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        
        NSInteger earliestHour = [self earliestHourForSection:section];
        NSInteger latestHour = [self latestHourForSection:section];
        
        CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
        CGFloat nextColumnMinY = (section == (NSUInteger)self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
        CGFloat calendarGridMinY = (columnMinY + self.dayColumnHeaderHeight + self.contentMargin.top);
        
        // Day Column Header
        CGFloat dayColumnHeaderMinY = fminf(fmaxf(self.collectionView.contentOffset.y, columnMinY), (nextColumnMinY - self.dayColumnHeaderHeight));
        BOOL dayColumnHeaderFloating = ((dayColumnHeaderMinY > columnMinY) || self.displayHeaderBackgroundAtOrigin);
        NSIndexPath *dayColumnHeaderIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        UICollectionViewLayoutAttributes *dayColumnHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:dayColumnHeaderIndexPath ofKind:MSCollectionElementKindDayColumnHeader withItemCache:self.dayColumnHeaderAttributes];
        // Frame
        dayColumnHeaderAttributes.frame = CGRectMake(0.0, dayColumnHeaderMinY, self.collectionViewContentSize.width, self.dayColumnHeaderHeight);
        dayColumnHeaderAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindDayColumnHeader floating:dayColumnHeaderFloating];
        
        // Day Column Header Background
        NSIndexPath *dayColumnHeaderBackgroundIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        UICollectionViewLayoutAttributes *dayColumnHeaderBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:dayColumnHeaderBackgroundIndexPath ofKind:MSCollectionElementKindDayColumnHeaderBackground withItemCache:self.dayColumnHeaderBackgroundAttributes];
        // Frame
        CGFloat dayColumnHeaderBackgroundMinX = -nearbyintf(self.collectionView.frame.size.width / 2.0);
        CGFloat dayColumnHeaderBackgroundWidth = fmaxf(self.collectionViewContentSize.width + self.collectionView.frame.size.width, self.collectionView.frame.size.width);
        dayColumnHeaderBackgroundAttributes.frame = CGRectMake(dayColumnHeaderBackgroundMinX, dayColumnHeaderMinY, dayColumnHeaderBackgroundWidth, self.dayColumnHeaderHeight);
        // Floating
        dayColumnHeaderBackgroundAttributes.hidden = !dayColumnHeaderFloating;
        dayColumnHeaderBackgroundAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindDayColumnHeaderBackground floating:dayColumnHeaderFloating];
        
        NSDateComponents *currentDay = [self dayForSection:section];
        NSDateComponents *currentTimeDateComponents = [self currentTimeDateComponents];
        // The current time is within this section's day
        if ((currentTimeDateComponents.day == currentDay.day) && (currentTimeDateComponents.hour >= earliestHour) && (currentTimeDateComponents.hour < latestHour)) {
            
            // The y value of the current time
            CGFloat timeY = (calendarGridMinY + nearbyintf(((currentTimeDateComponents.hour - earliestHour) * self.hourHeight) + (currentTimeDateComponents.minute * self.minuteHeight)));

            CGFloat currentTimeIndicatorMinY = (timeY - nearbyintf(self.currentTimeIndicatorSize.height / 2.0));
            CGFloat currentTimeIndicatorMinX = (self.timeRowHeaderWidth - self.currentTimeIndicatorSize.width);
            currentTimeIndicatorAttributes.frame = (CGRect){{currentTimeIndicatorMinX, currentTimeIndicatorMinY}, self.currentTimeIndicatorSize};
            currentTimeIndicatorAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindCurrentTimeIndicator];
            
            CGFloat currentTimeHorizontalGridlineMinY = (timeY - nearbyintf(self.currentTimeHorizontalGridlineHeight / 2.0));
            currentTimeHorizontalGridlineAttributes.frame = CGRectMake(calendarGridMinX, currentTimeHorizontalGridlineMinY, calendarGridWidth, self.currentTimeHorizontalGridlineHeight);
            currentTimeHorizontalGridlineAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
        }
        
        // Time Row Headers
        NSUInteger timeRowHeaderIndex = 0;
        for (NSInteger hour = earliestHour; hour <= latestHour; hour++) {
            // Time Row Header
            NSIndexPath *timeRowHeaderIndexPath = [NSIndexPath indexPathForItem:timeRowHeaderIndex inSection:section];
            UICollectionViewLayoutAttributes *timeRowHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:timeRowHeaderIndexPath ofKind:MSCollectionElementKindTimeRowHeader withItemCache:self.timeRowHeaderAttributes];
            // Frame
            CGFloat titleRowHeaderMinY = (calendarGridMinY + (self.hourHeight * (hour - earliestHour)) - nearbyintf(self.hourHeight / 2.0));
            timeRowHeaderAttributes.frame = CGRectMake(0.0, titleRowHeaderMinY, self.timeRowHeaderWidth, self.hourHeight);
            timeRowHeaderAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindTimeRowHeader];
            timeRowHeaderIndex++;
        }
        
        if (needsToPopulateItemAttributes) {
            // Items
            CGFloat sectionMinX = (calendarGridMinX + self.sectionMargin.left);
            NSMutableArray *sectionItemAttributes = [NSMutableArray new];
            for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
                
                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForCellAtIndexPath:itemIndexPath withItemCache:self.itemAttributes];
                [sectionItemAttributes addObject:itemAttributes];
                
                NSDateComponents *itemStartTime = [self startTimeForIndexPath:itemIndexPath];
                NSDateComponents *itemEndTime = [self endTimeForIndexPath:itemIndexPath];
                
                CGFloat startHourY = ((itemStartTime.hour - earliestHour) * self.hourHeight);
                CGFloat startMinuteY = (itemStartTime.minute * self.minuteHeight);
                
                CGFloat endHourY;
                if (itemEndTime.day != itemStartTime.day) {
                    endHourY = (([[NSCalendar currentCalendar] maximumRangeOfUnit:NSHourCalendarUnit].length - earliestHour) * self.hourHeight) + ((itemEndTime.hour) * self.hourHeight);
                } else {
                    endHourY = ((itemEndTime.hour - earliestHour) * self.hourHeight);
                }
                CGFloat endMinuteY = (itemEndTime.minute * self.minuteHeight);
                
                CGFloat itemMinY = (startHourY + startMinuteY + calendarGridMinY + self.cellMargin.top);
                CGFloat itemMaxY = (endHourY + endMinuteY + calendarGridMinY - self.cellMargin.bottom);
                CGFloat itemMinX = (calendarGridMinX + self.sectionMargin.left + self.cellMargin.left);
                CGFloat itemMaxX = (itemMinX + (self.sectionWidth - self.cellMargin.left - self.cellMargin.right));
                itemAttributes.frame = CGRectMake(itemMinX, itemMinY, (itemMaxX - itemMinX), (itemMaxY - itemMinY));
                
                itemAttributes.zIndex = [self zIndexForElementKind:nil];
            }
            [self adjustItemsForOverlap:sectionItemAttributes inSection:section sectionMinX:sectionMinX];
        }
        
        // Horizontal Gridlines
        if (needsToPopulateHorizontalGridlineAttributes) {
            NSUInteger horizontalGridlineIndex = 0;
            for (NSInteger hour = earliestHour; hour <= latestHour; hour++) {
                NSIndexPath *horizontalGridlineIndexPath = [NSIndexPath indexPathForItem:horizontalGridlineIndex inSection:section];
                UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:horizontalGridlineIndexPath ofKind:MSCollectionElementKindHorizontalGridline withItemCache:self.horizontalGridlineAttributes];
                // Frame
                CGFloat horizontalGridlineMinY = (calendarGridMinY + (self.hourHeight * (hour - earliestHour))) - nearbyintf(self.horizontalGridlineHeight / 2.0);
                horizontalGridlineAttributes.frame = CGRectMake(calendarGridMinX, horizontalGridlineMinY, calendarGridWidth, self.horizontalGridlineHeight);
                horizontalGridlineAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindHorizontalGridline];
                horizontalGridlineIndex++;
            }
        }
    }];
}

- (void)adjustItemsForOverlap:(NSArray *)sectionItemAttributes inSection:(NSUInteger)section sectionMinX:(CGFloat)sectionMinX
{
    NSMutableSet *adjustedIndexPaths = [NSMutableSet new];
    for (UICollectionViewLayoutAttributes *itemAttributes in sectionItemAttributes) {
        
        // If an item's already been adjusted, move on to the next one
        if ([adjustedIndexPaths containsObject:itemAttributes.indexPath]) {
            continue;
        }
        
        // Find the other items that overlap with this item
        NSMutableArray *overlappingItems = [NSMutableArray new];
        CGRect itemFrame = itemAttributes.frame;
        [overlappingItems addObjectsFromArray:[sectionItemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
            if ((layoutAttributes != itemAttributes)) {
                return CGRectIntersectsRect(itemFrame, layoutAttributes.frame);
            } else {
                return NO;
            }
        }]]];
        
        // If there's items overlapping, we need to adjust them
        if (overlappingItems.count) {
            
            [overlappingItems insertObject:itemAttributes atIndex:0];
            
            // Find the minY and maxY of the first and last
            CGFloat minY = CGFLOAT_MAX;
            CGFloat maxY = CGFLOAT_MIN;
            for (UICollectionViewLayoutAttributes *overlappingItemAttributes in overlappingItems) {
                if (CGRectGetMinY(overlappingItemAttributes.frame) < minY) {
                    minY = CGRectGetMinY(overlappingItemAttributes.frame);
                }
                if (CGRectGetMaxY(overlappingItemAttributes.frame) > maxY) {
                    maxY = CGRectGetMaxY(overlappingItemAttributes.frame);
                }
            }
            
            // Determine the number of divisions needed (maximum number of currently overlapping items)
            NSInteger divisions = 1;
            for (CGFloat currentY = minY; currentY <= maxY; currentY += 1.0) {
                NSInteger numItemsForCurrentY = 0;
                for (UICollectionViewLayoutAttributes *overlappingItemAttributes in overlappingItems) {
                    if ((currentY >= CGRectGetMinY(overlappingItemAttributes.frame)) && (currentY < CGRectGetMaxY(overlappingItemAttributes.frame))) {
                        numItemsForCurrentY++;
                    }
                }
                if (numItemsForCurrentY > divisions) {
                    divisions = numItemsForCurrentY;
                }
            }
            
            // Adjust the items to have a width of the section size divided by the number of divisions needed
            CGFloat divisionWidth = nearbyintf(self.sectionWidth / divisions);
            
            NSMutableArray *dividedAttributes = [NSMutableArray array];
            for (UICollectionViewLayoutAttributes *divisionAttributes in overlappingItems) {
                
                CGRect divisionAttributesFrame = divisionAttributes.frame;
                divisionAttributesFrame.size.width = (divisionWidth - self.cellMargin.left - self.cellMargin.right);
                divisionAttributesFrame.origin.x = sectionMinX + self.cellMargin.left;
                
                NSInteger horizontalAdjustment = 1;
                for (UICollectionViewLayoutAttributes *dividedItemAttributes in dividedAttributes) {
                    if (CGRectIntersectsRect(dividedItemAttributes.frame, divisionAttributesFrame)) {
                        divisionAttributesFrame.origin.x = sectionMinX + ((divisionWidth * horizontalAdjustment) + self.cellMargin.left);
                        horizontalAdjustment++;
                    } else {
                        break;
                    }
                }
                divisionAttributes.frame = divisionAttributesFrame;
                [dividedAttributes addObject:divisionAttributes];
                [adjustedIndexPaths addObject:divisionAttributes.indexPath];
            }
        }
    }
}

- (CGSize)collectionViewContentSize
{
    CGFloat width;
    CGFloat height;
    switch (self.sectionLayoutType) {
        case MSSectionLayoutTypeHorizontalTile:
            height = [self maxSectionHeight];
            width = (self.timeRowHeaderWidth + self.contentMargin.left + ((self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right) * self.collectionView.numberOfSections) + self.contentMargin.right);
            break;
        case MSSectionLayoutTypeVerticalTile:
            height = [self stackedSectionHeight];
            width = (self.timeRowHeaderWidth + self.contentMargin.left + self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right + self.contentMargin.right);
            break;
    }
    return CGSizeMake(width, height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:MSCollectionElementKindDayColumnHeader]) {
        return self.dayColumnHeaderAttributes[indexPath];
    }
    else if ([kind isEqualToString:MSCollectionElementKindTimeRowHeader]) {
        return self.timeRowHeaderAttributes[indexPath];
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([decorationViewKind isEqualToString:MSCollectionElementKindCurrentTimeIndicator]) {
        return self.currentTimeIndicatorAttributes[indexPath];
    }
    else if ([decorationViewKind isEqualToString:MSCollectionElementKindCurrentTimeHorizontalGridline]) {
        return self.currentTimeHorizontalGridlineAttributes[indexPath];
    }
    else if ([decorationViewKind isEqualToString:MSCollectionElementKindHorizontalGridline]) {
        return self.horizontalGridlineAttributes[indexPath];
    }
    else if ([decorationViewKind isEqualToString:MSCollectionElementKindTimeRowHeaderBackground]) {
        return self.timeRowHeaderBackgroundAttributes[indexPath];
    }
    else if ([decorationViewKind isEqualToString:MSCollectionElementKindDayColumnHeader]) {
        return self.dayColumnHeaderBackgroundAttributes[indexPath];
    }
    return nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{   
    NSMutableIndexSet *visibleSections = [NSMutableIndexSet indexSet];
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        CGRect sectionRect = [self rectForSection:section];
        if (CGRectIntersectsRect(sectionRect, rect)) {
            [visibleSections addIndex:section];
        }
    }];
    
    // Update layout for only the visible sections
    [self prepareSectionLayoutForSections:visibleSections];
    
    // Return the visible attributes (rect intersection)
    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // Required for sticky headers
    return YES;
}

#pragma mark - MSCollectionViewCalendarLayout

#pragma mark Minute Updates

- (void)minuteTick:(id)sender
{
    // Invalidate cached current date componets (since the minute's changed!)
    [self.cachedCurrentDateComponents removeAllObjects];
    [self invalidateLayout];
}

#pragma mark - Layout

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (self.registeredDecorationClasses[kind] && !(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (void)invalidateLayoutCache
{
    self.needsToPopulateAttributesForAllSections = YES;
    
    // Invalidate cached Components
    [self.cachedDayDateComponents removeAllObjects];
    [self.cachedStartTimeDateComponents removeAllObjects];
    [self.cachedEndTimeDateComponents removeAllObjects];
    [self.cachedCurrentDateComponents removeAllObjects];
    
    // Invalidate cached interface sizing values
    self.cachedEarliestHour = NSIntegerMax;
    self.cachedLatestHour = NSIntegerMin;
    self.cachedMaxColumnHeight = CGFLOAT_MIN;
    [self.cachedColumnHeights removeAllObjects];
    [self.cachedEarliestHours removeAllObjects];
    [self.cachedLatestHours removeAllObjects];
    
    // Invalidate cached item attributes
    [self.itemAttributes removeAllObjects];
    [self.horizontalGridlineAttributes removeAllObjects];
    [self.dayColumnHeaderAttributes removeAllObjects];
    [self.dayColumnHeaderBackgroundAttributes removeAllObjects];
    [self.timeRowHeaderAttributes removeAllObjects];
    [self.timeRowHeaderBackgroundAttributes removeAllObjects];
    [self.allAttributes removeAllObjects];
}

#pragma mark Dates

- (NSDate *)dateForTimeRowHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger earliestHour;
    switch (self.sectionLayoutType) {
        case MSSectionLayoutTypeHorizontalTile:
            earliestHour = [self earliestHour];
            break;
        case MSSectionLayoutTypeVerticalTile:
            earliestHour = [self earliestHourForSection:indexPath.section];
            break;
    }
    NSDateComponents *dateComponents = [self dayForSection:indexPath.section];
    dateComponents.hour = (earliestHour + indexPath.item);
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

- (NSDate *)dateForDayColumnHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.delegate collectionView:self.collectionView layout:self dayForSection:indexPath.section] beginningOfDay];
}

#pragma mark Scrolling

- (void)scrollCollectionViewToClosetSectionToCurrentTimeAnimated:(BOOL)animated
{
    if (self.collectionView.numberOfSections != 0) {
        NSInteger closestSectionToCurrentTime = [self closestSectionToCurrentTime];
        CGPoint contentOffset;
        CGRect currentTimeHorizontalGridlineattributesFrame = [self.currentTimeHorizontalGridlineAttributes[[NSIndexPath indexPathForItem:0 inSection:0]] frame];
        if (self.sectionLayoutType == MSSectionLayoutTypeHorizontalTile) {
            CGFloat yOffset;
            if (!CGRectEqualToRect(currentTimeHorizontalGridlineattributesFrame, CGRectZero)) {
                yOffset = nearbyintf(CGRectGetMinY(currentTimeHorizontalGridlineattributesFrame) - (CGRectGetHeight(self.collectionView.frame) / 2.0));
            } else {
                yOffset = 0.0;
            }
            CGFloat xOffset = self.contentMargin.left + ((self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right) * closestSectionToCurrentTime);
            contentOffset = CGPointMake(xOffset, yOffset);
        } else {
            CGFloat yOffset;
            if (!CGRectEqualToRect(currentTimeHorizontalGridlineattributesFrame, CGRectZero)) {
                yOffset = fmaxf(nearbyintf(CGRectGetMinY(currentTimeHorizontalGridlineattributesFrame) - (CGRectGetHeight(self.collectionView.frame) / 2.0)), [self stackedSectionHeightUpToSection:closestSectionToCurrentTime]);
            } else {
                yOffset = [self stackedSectionHeightUpToSection:closestSectionToCurrentTime];
            }
            contentOffset = CGPointMake(0.0, yOffset);
        }
        // Prevent the content offset from forcing the scroll view content off its bounds
        if (contentOffset.y > (self.collectionView.contentSize.height - self.collectionView.frame.size.height)) {
            contentOffset.y = (self.collectionView.contentSize.height - self.collectionView.frame.size.height);
        }
        if (contentOffset.y < 0.0) {
            contentOffset.y = 0.0;
        }
        if (contentOffset.x > (self.collectionView.contentSize.width - self.collectionView.frame.size.width)) {
            contentOffset.x = (self.collectionView.contentSize.width - self.collectionView.frame.size.width);
        }
        if (contentOffset.x < 0.0) {
            contentOffset.x = 0.0;
        }
        [self.collectionView setContentOffset:contentOffset animated:animated];
    }
}

- (NSInteger)closestSectionToCurrentTime
{
    NSDate *currentDate = [[self.delegate currentTimeComponentsForCollectionView:self.collectionView layout:self] beginningOfDay];
    NSTimeInterval minTimeInterval = CGFLOAT_MAX;
    NSInteger closestSection = NSIntegerMax;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSDate *sectionDayDate = [self.delegate collectionView:self.collectionView layout:self dayForSection:section];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:sectionDayDate];
        if ((timeInterval <= 0) && abs(timeInterval) < minTimeInterval) {
            minTimeInterval = abs(timeInterval);
            closestSection = section;
        }
    }
    return ((closestSection != NSIntegerMax) ? closestSection : 0);
}

#pragma mark Section Sizing

- (CGRect)rectForSection:(NSInteger)section
{
    CGRect sectionRect;
    switch (self.sectionLayoutType) {
        case MSSectionLayoutTypeHorizontalTile: {
            CGFloat calendarGridMinX = (self.timeRowHeaderWidth + self.contentMargin.left);
            CGFloat sectionWidth = (self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right);
            CGFloat sectionMinX = (calendarGridMinX + self.sectionMargin.left + (sectionWidth * section));
            sectionRect = CGRectMake(sectionMinX, 0.0, sectionWidth, self.collectionViewContentSize.height);
            break;
        }
        case MSSectionLayoutTypeVerticalTile: {
            CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
            CGFloat nextColumnMinY = (section == self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
            sectionRect = CGRectMake(0.0, columnMinY, self.collectionViewContentSize.width, (nextColumnMinY - columnMinY));
            break;
        }
    }
    return sectionRect;
}

- (CGFloat)maxSectionHeight
{
    if (self.cachedMaxColumnHeight != CGFLOAT_MIN) {
        return self.cachedMaxColumnHeight;
    }
    CGFloat maxSectionHeight = 0.0;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        
        NSInteger earliestHour = [self earliestHour];
        NSInteger latestHour = [self latestHourForSection:section];
        CGFloat sectionColumnHeight;
        if ((earliestHour != NSUndefinedDateComponent) && (latestHour != NSUndefinedDateComponent)) {
            sectionColumnHeight = (self.hourHeight * (latestHour - earliestHour));
        } else {
            sectionColumnHeight = 0.0;
        }
        
        if (sectionColumnHeight > maxSectionHeight) {
            maxSectionHeight = sectionColumnHeight;
        }
    }
    CGFloat headerAdjustedMaxColumnHeight = (maxSectionHeight + (self.dayColumnHeaderHeight + self.contentMargin.top + self.contentMargin.bottom));
    if (maxSectionHeight != 0.0) {
        self.cachedMaxColumnHeight = headerAdjustedMaxColumnHeight;
        return headerAdjustedMaxColumnHeight;
    } else {
        return headerAdjustedMaxColumnHeight;
    }
}

- (CGFloat)stackedSectionHeight
{
    return [self stackedSectionHeightUpToSection:self.collectionView.numberOfSections];
}

- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection
{
    if (self.cachedColumnHeights[@(upToSection)]) {
        return [self.cachedColumnHeights[@(upToSection)] integerValue];
    }
    CGFloat stackedSectionHeight = 0.0;
    for (NSInteger section = 0; section < upToSection; section++) {
        CGFloat sectionColumnHeight = [self sectionHeight:section];
        stackedSectionHeight += sectionColumnHeight;
    }
    CGFloat headerAdjustedStackedColumnHeight = (stackedSectionHeight + ((self.dayColumnHeaderHeight + self.contentMargin.top + self.contentMargin.bottom) * upToSection));
    if (stackedSectionHeight != 0.0) {
        self.cachedColumnHeights[@(upToSection)] = @(headerAdjustedStackedColumnHeight);
        return headerAdjustedStackedColumnHeight;
    } else {
        return headerAdjustedStackedColumnHeight;
    }
}

- (CGFloat)sectionHeight:(NSInteger)section
{
    NSInteger earliestHour = [self earliestHourForSection:section];
    NSInteger latestHour = [self latestHourForSection:section];
    
    if ((earliestHour != NSUndefinedDateComponent) && (latestHour != NSUndefinedDateComponent)) {
        return (self.hourHeight * (latestHour - earliestHour));
    } else {
        return 0.0;
    }
}

- (CGFloat)minuteHeight
{
    return (self.hourHeight / 60.0);
}

#pragma mark Z Index

- (CGFloat)zIndexForElementKind:(NSString *)elementKind
{
    return [self zIndexForElementKind:elementKind floating:NO];
}

- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating
{
    switch (self.sectionLayoutType) {
        case MSSectionLayoutTypeHorizontalTile: {
            // Current Time Indicator
            if ([elementKind isEqualToString:MSCollectionElementKindCurrentTimeIndicator]) {
                return ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 12.0 : 7.0) : (floating ? 10.0 : 5.0));
            }
            // Time Row Header
            else if ([elementKind isEqualToString:MSCollectionElementKindTimeRowHeader]) {
                return ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 11.0 : 6.0) : (floating ? 9.0 : 4.0));
            }
            // Time Row Header Background
            else if ([elementKind isEqualToString:MSCollectionElementKindTimeRowHeaderBackground]) {
                return ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 10.0 : 5.0) : (floating ? 8.0 : 3.0));
            }
            // Day Column Header
            else if ([elementKind isEqualToString:MSCollectionElementKindDayColumnHeader]) {
                return ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 9.0 : 4.0) : (floating ? 12.0 : 7.0));
            }
            // Day Column Header Background
            else if ([elementKind isEqualToString:MSCollectionElementKindDayColumnHeaderBackground]) {
                return ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 8.0 : 3.0) : (floating ? 11.0 : 6.0));
            }
            // Cell
            else if (elementKind == nil) {
                return 2.0;
            }
            // Current Time Horizontal Gridline
            else if ([elementKind isEqualToString:MSCollectionElementKindCurrentTimeHorizontalGridline]) {
                return 1.0;
            }
            // Horizontal Gridline
            else if ([elementKind isEqualToString:MSCollectionElementKindHorizontalGridline]) {
                return 0.0;
            }
        }
        case MSSectionLayoutTypeVerticalTile: {
            // Day Column Header
            if ([elementKind isEqualToString:MSCollectionElementKindDayColumnHeader]) {
                return (floating ? 9.0 : 7.0);
            }
            // Day Column Header Background
            else if ([elementKind isEqualToString:MSCollectionElementKindDayColumnHeaderBackground]) {
                return (floating ? 8.0 : 6.0);
            }
            // Current Time Indicator
            else if ([elementKind isEqualToString:MSCollectionElementKindCurrentTimeIndicator]) {
                return 5.0;
            }
            // Time Row Header
            if ([elementKind isEqualToString:MSCollectionElementKindTimeRowHeader]) {
                return 4.0;
            }
            // Time Row Header Background
            else if ([elementKind isEqualToString:MSCollectionElementKindTimeRowHeaderBackground]) {
                return 3.0;
            }
            // Cell
            else if (elementKind == nil) {
                return 2.0;
            }
            // Current Time Horizontal Gridline
            else if ([elementKind isEqualToString:MSCollectionElementKindCurrentTimeHorizontalGridline]) {
                return 1.0;
            }
            // Horizontal Gridline
            else if ([elementKind isEqualToString:MSCollectionElementKindHorizontalGridline]) {
                return 0.0;
            }
        }
    }
    return CGFLOAT_MIN;
}

#pragma mark Hours

- (NSInteger)earliestHour
{
    if (self.cachedEarliestHour != NSIntegerMax) {
        return self.cachedEarliestHour;
    }
    NSInteger earliestHour = NSIntegerMax;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        CGFloat sectionEarliestHour = [self earliestHourForSection:section];
        if ((sectionEarliestHour < earliestHour) && (sectionEarliestHour != NSUndefinedDateComponent)) {
            earliestHour = sectionEarliestHour;
        }
    }
    if (earliestHour != NSIntegerMax) {
        self.cachedEarliestHour = earliestHour;
        return earliestHour;
    } else {
        return 0;
    }
}

- (NSInteger)latestHour
{
    if (self.cachedLatestHour != NSIntegerMin) {
        return self.cachedLatestHour;
    }
    NSInteger latestHour = NSIntegerMin;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        CGFloat sectionLatestHour = [self latestHourForSection:section];
        if ((sectionLatestHour > latestHour) && (sectionLatestHour != NSUndefinedDateComponent)) {
            latestHour = sectionLatestHour;
        }
    }
    if (latestHour != NSIntegerMin) {
        self.cachedLatestHour = latestHour;
        return latestHour;
    } else {
        return 0;
    }
}

- (NSInteger)earliestHourForSection:(NSInteger)section
{
    if (self.cachedEarliestHours[@(section)]) {
        return [self.cachedEarliestHours[@(section)] integerValue];
    }
    NSInteger earliestHour = NSIntegerMax;
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        NSDateComponents *itemStartTime = [self startTimeForIndexPath:itemIndexPath];
        if (itemStartTime.hour < earliestHour) {
            earliestHour = itemStartTime.hour;
        }
    }
    if (earliestHour != NSIntegerMax) {
        self.cachedEarliestHours[@(section)] = @(earliestHour);
        return earliestHour;
    } else {
        return 0;
    }
}

- (NSInteger)latestHourForSection:(NSInteger)section
{
    if (self.cachedLatestHours[@(section)]) {
        return [self.cachedLatestHours[@(section)] integerValue];
    }
    NSInteger latestHour = NSIntegerMin;
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        NSDateComponents *itemEndTime = [self endTimeForIndexPath:itemIndexPath];
        NSInteger itemEndTimeHour;
        if ([self dayForSection:section].day == itemEndTime.day) {
            itemEndTimeHour = (itemEndTime.hour + ((itemEndTime.minute > 0) ? 1 : 0));
        } else {
            itemEndTimeHour = [[NSCalendar currentCalendar] maximumRangeOfUnit:NSHourCalendarUnit].length + (itemEndTime.hour + ((itemEndTime.minute > 0) ? 1 : 0));;
        }
        if (itemEndTimeHour > latestHour) {
            latestHour = itemEndTimeHour;
        }
    }
    if (latestHour != NSIntegerMin) {
        self.cachedLatestHours[@(section)] = @(latestHour);
        return latestHour;
    } else {
        return 0;
    }
}

#pragma mark Delegate Wrappers

- (NSDateComponents *)dayForSection:(NSInteger)section
{
    if ([self.cachedDayDateComponents objectForKey:@(section)]) {
        return [self.cachedDayDateComponents objectForKey:@(section)];
    }
    
    NSDate *date = [self.delegate collectionView:self.collectionView layout:self dayForSection:section];
    date = [date beginningOfDay];
    NSDateComponents *dayDateComponents = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSEraCalendarUnit) fromDate:date];
    
    [self.cachedDayDateComponents setObject:dayDateComponents forKey:@(section)];
    return dayDateComponents;
}

- (NSDateComponents *)startTimeForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cachedStartTimeDateComponents objectForKey:indexPath]) {
        return [self.cachedStartTimeDateComponents objectForKey:indexPath];
    }
    
    NSDate *date = [self.delegate collectionView:self.collectionView layout:self startTimeForItemAtIndexPath:indexPath];
    NSDateComponents *itemStartTimeDateComponents = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    [self.cachedStartTimeDateComponents setObject:itemStartTimeDateComponents forKey:indexPath];
    return itemStartTimeDateComponents;
}

- (NSDateComponents *)endTimeForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cachedEndTimeDateComponents objectForKey:indexPath]) {
        return [self.cachedEndTimeDateComponents objectForKey:indexPath];
    }
    
    NSDate *date = [self.delegate collectionView:self.collectionView layout:self endTimeForItemAtIndexPath:indexPath];
    NSDateComponents *itemEndTime = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    [self.cachedEndTimeDateComponents setObject:itemEndTime forKey:indexPath];
    return itemEndTime;
}

- (NSDateComponents *)currentTimeDateComponents
{
    if ([self.cachedCurrentDateComponents objectForKey:@(0)]) {
        return [self.cachedCurrentDateComponents objectForKey:@(0)];
    }
    
    NSDate *date = [self.delegate currentTimeComponentsForCollectionView:self.collectionView layout:self];
    NSDateComponents *currentTime = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    [self.cachedCurrentDateComponents setObject:currentTime forKey:@(0)];
    return currentTime;
}

@end
