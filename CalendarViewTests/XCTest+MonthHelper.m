//
//  XCTest+MonthHelper.m
//  CalendarView
//
//  Created by Christian Tietze on 08.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "XCTest+MonthHelper.h"
#import "CCLMonth.h"

@implementation XCTest (MonthHelper)
- (CCLMonth *)monthWithYear:(NSUInteger)year month:(NSUInteger)month
{
    NSUInteger irrelevantDay = 6;
    return [self monthWithYear:year month:month day:irrelevantDay];
}

- (CCLMonth *)monthWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    NSString *irrelevantTime = @"12:13:14 +0000";
    NSString *dateString = [NSString stringWithFormat:@"%lu-%02lu-%02lu %@", (unsigned long)year, (unsigned long)month, (unsigned long)day, irrelevantTime];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZZ";

    NSDate *date = [formatter dateFromString:dateString];
    NSAssert(date, @"date components invalid");
    return [CCLMonth monthFromDate:date];
}
@end
