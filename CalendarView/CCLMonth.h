//
//  CCLMonth.h
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCLMonth : NSObject
@property (copy, readonly) NSDate *date;

+ (instancetype)monthFromDate:(NSDate *)date;
- (instancetype)initWithDate:(NSDate *)date;

- (NSString *)name;
- (NSUInteger)firstWeekday;
- (NSUInteger)lastWeekday;
- (NSUInteger)year;
- (NSUInteger)month;
- (NSUInteger)weekCount;
- (NSUInteger)firstCalenderWeek;
@end
