//
//  CCLProvidesCalendarObjects.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLDateRange;

@protocol CCLProvidesCalendarObjects <NSObject>
@required
- (CCLDateRange *)dateRange;

/// The calendar view will treat @p nil values differently. Depending on your
/// configuration, the cell may not be selectable.
/// @return An object with @p -day and @p -number properties; @p nil if no value is known.
- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@optional
/// If this method is implemented, the calendar view will show a week's summary column.
- (id)objectValueForYear:(NSUInteger)year week:(NSUInteger)week;
@end
