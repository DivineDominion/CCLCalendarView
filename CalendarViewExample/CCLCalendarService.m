//
//  CCLCalendarService.m
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarService.h"
#import "CCLDateRange.h"

@interface CellObject : NSObject
@property (copy) NSNumber *day;
@property (copy) NSNumber *total;
+ (instancetype)cellObjectForDay:(NSUInteger)day total:(NSUInteger)total;
@end

@implementation CellObject
+ (instancetype)cellObjectForDay:(NSUInteger)day total:(NSUInteger)total
{
    CellObject *result = [[self alloc] init];
    result.day = @(day);
    result.total = @(total);
    return result;
}
@end

NSInteger refreshIncrement = 0;

@implementation CCLCalendarService

- (void)incrementDayCountToTestRefresh
{
    refreshIncrement++;
}

- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return [CellObject cellObjectForDay:day total:1234 + refreshIncrement];
}

- (CCLDateRange *)dateRange
{
    // Date range where 1st week of January is still counted to the previous year and tripped up calculations once. (Got 2022-01 instead of 2021-01)
//    NSDate *startDate = [self.formatter dateFromString:@"2020-11-04 14:00:00 +0200"];
//    NSDate *endDate = [self.formatter dateFromString:@"2021-01-14 23:00:00 +0200"];

    NSDate *startDate = [self.formatter dateFromString:@"2014-07-04 14:00:00 +0200"];
    NSDate *endDate = [self.formatter dateFromString:@"2014-07-12 23:00:00 +0200"];

    return [CCLDateRange dateRangeFrom:startDate until:endDate];
}

- (NSDateFormatter *)formatter
{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZZZ";
    }

    return _formatter;
}

- (NSView *)detailViewForObjectValue:(id)objectValue
{
    NSTextField *label = [[NSTextField alloc] init];
    label.stringValue = @"test";
    
    return label;
}

- (BOOL)allowsEmptyCellSelection
{
    return NO;
}
@end
