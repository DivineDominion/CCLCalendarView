//
//  CCLCalendarTableModelTranslator.h
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLCalendarData.h"

@protocol CCLProvidesCalendarObjects;
@class CCLDateRange;
@class CCLMonths;
@class CCLMonthsFactory;

typedef NS_ENUM(NSInteger, CCLCellType) {
    /// Denotes a missing calculation, really. Should never appear in production.
    CCLCellTypeUndefined = -1,
    
    CCLCellTypeMonth = 0,
    CCLCellTypeDay,
    CCLCellTypeWeekend,
    
    CCLCellTypeDayDetail,
    
    /// Used when a weekday in a week is out of the calendar bounds.
    CCLCellTypeBlank,
    /// Same as @p CCLCellTypeBlank, only this denotes it's coming before the first,
    /// so you can draw it differently, i.e. with a right border.
    CCLCellTypeBlankLast
};

@interface CCLCalendarTableModelTranslator : NSObject
@property (nonatomic, strong) id<CCLProvidesCalendarObjects> objectProvider;

@property (strong) CCLCalendarData *calendarData;
@property (nonatomic, strong) CCLMonthsFactory *monthsFactory;
@property (nonatomic, strong, readonly) CCLMonths *months;

+ (instancetype)calendarTableModelTranslatorFrom:(id<CCLProvidesCalendarObjects>)objectProvider;
- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider;

- (id)objectValueForTableView:(NSTableView *)tableView column:(NSInteger)column row:(NSInteger)row;
- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row;
- (NSUInteger)weeksOfMonthFromDateComponents:(NSDateComponents *)monthComponents;

@end
