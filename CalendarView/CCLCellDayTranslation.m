//
//  CCLCellDayTranslation.m
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCellDayTranslation.h"
#import "CCLCalendarData.h"
#import "CCLDayLocator.h"
#import "CTWCalendarSupplier.h"

#import "CCLTitleRows.h"

@implementation CCLCellDayTranslation

+ (instancetype)cellDayTranslationFor:(CCLCalendarData *)calendarData
{
    return [[self alloc] initWithCalendarData:calendarData];
}

- (instancetype)init
{
    return [self initWithCalendarData:nil];
}

- (instancetype)initWithCalendarData:(CCLCalendarData *)calendarData
{
    NSParameterAssert(calendarData);
    
    self = [super init];
    
    if (self)
    {
        _calendarData = calendarData;
    }
    
    return self;
}

- (NSCalendar *)calendar
{
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
}


#pragma mark -

- (CCLDayLocator *)dayLocatorForColumn:(NSUInteger)column row:(NSUInteger)row
{
    CCLCalendarData *calendarData = self.calendarData;
    
    if ([calendarData rowViewTypeForRow:row] == CCLRowViewTypeMonth)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"row must not be a month's title row" userInfo:nil];
    }
    
    // TODO violates LoD, pull this out of CalendarData
    CCLMonth *month = [calendarData monthForRow:row];
    NSUInteger monthTitleRow = [calendarData.titleRows previousMonthRowOfRow:row];
    NSUInteger firstWeekRow = monthTitleRow + 1;
    NSUInteger week = row - firstWeekRow;
    NSUInteger weekday = [self weekdayForColumn:column];
    CCLDayLocator *dayLocator = [CCLDayLocator dayLocatorInMonth:month week:week weekday:weekday];
    
    return dayLocator;
}

- (NSUInteger)weekdayForColumn:(NSUInteger)column
{
    NSUInteger weekday = column + 1;
    NSUInteger firstWeekdayRollover = [self firstWeekdayRollover];
    
    return weekday + firstWeekdayRollover;
}

/// Returns the distance in days from the beginning of week to the weekday ordinal.
/// If @p firstWeekday is 2 (Monday), this method returns @p 1.
- (NSUInteger)firstWeekdayRollover
{
    NSCalendar *calendar = [self calendar];
    NSUInteger firstWeekday = calendar.firstWeekday;
    NSUInteger weekdayRollover = firstWeekday - 1;
    
    return weekdayRollover;
}
@end
