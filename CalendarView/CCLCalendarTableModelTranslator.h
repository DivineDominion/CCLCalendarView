//
//  CCLCalendarTableModelTranslator.h
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLHandlesCellSelection.h"

#import "CCLCalendarData.h"

@protocol CCLProvidesCalendarObjects;
@class CCLDateRange;
@class CCLMonths;
@class CCLMonthsFactory;

@interface CCLCalendarTableModelTranslator : NSObject <CCLHandlesCellSelection>
@property (nonatomic, strong) id<CCLProvidesCalendarObjects> objectProvider;
@property (strong, readonly) CCLDayCellSelection *cellSelection;

@property (strong) CCLCalendarData *calendarData;
@property (nonatomic, strong) CCLMonthsFactory *monthsFactory;

+ (instancetype)calendarTableModelTranslatorFrom:(id<CCLProvidesCalendarObjects>)objectProvider;
- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider;

- (id)objectValueForTableView:(NSTableView *)tableView column:(NSInteger)column row:(NSInteger)row;
- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row;
- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row;
- (NSUInteger)numberOfRows;

@end
