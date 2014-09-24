//
//  CCLDateRange.h
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CCLMonthEnumerationBlock)(NSDate *);

@interface CCLDateRange : NSObject
@property (copy, readonly) NSDate *startDate;
@property (copy, readonly) NSDate *endDate;

/// Date range including both @p startDate and @p endDate;
+ (instancetype)dateRangeFrom:(NSDate *)startDate until:(NSDate *)endDate;
- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSDateComponents *)startDateCalendarComponents;
- (NSDateComponents *)endDateCalendarComponents;
- (NSUInteger)monthSpan;
- (void)enumerateMonthsUsingBlock:(CCLMonthEnumerationBlock)block;
@end
