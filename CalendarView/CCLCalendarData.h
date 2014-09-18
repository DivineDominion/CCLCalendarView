//
//  CCLCalendarData.h
//  CalendarView
//
//  Created by Christian Tietze on 09.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CCLRowViewType) {
    /// Denotes a missing calculation, really. Should never appear in production.
    CCLRowViewTypeUndefined = -1,
    
    CCLRowViewTypeMonth = 0,
    CCLRowViewTypeWeek,
    CCLRowViewTypeDayDetail
};

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

@class CCLMonth;
@class CCLMonths;
@class CCLTitleRows;

extern NSInteger const kCLLNoDetailRow;

@interface CCLCalendarData : NSObject
@property (strong, readonly) CCLMonths *months;
@property (strong, readonly) CCLTitleRows *titleRows;
@property (assign, readonly) NSInteger detailRow;

+ (instancetype)calendarDataForMonths:(CCLMonths *)months;
- (instancetype)initWithMonths:(CCLMonths *)months;

- (void)insertDayDetailRowBelow:(NSUInteger)row;
- (void)removeDayDetailRow;

- (CCLMonth *)monthForRow:(NSUInteger)row;
- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row;
- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row;
- (NSUInteger)numberOfRows;
@end
