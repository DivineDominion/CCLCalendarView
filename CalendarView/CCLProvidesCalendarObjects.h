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
- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@optional
- (id)objectValueForYear:(NSUInteger)year week:(NSUInteger)week;
@end
