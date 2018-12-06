//
//  CCLMonth.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLMonth.h"
#import "CTKCalendarSupplier.h"

@implementation CCLMonth

+ (instancetype)monthFromDate:(NSDate *)date
{
    return [[self alloc] initWithDate:date];
}

- (instancetype)init
{
    return [self initWithDate:nil];
}

- (instancetype)initWithDate:(NSDate *)date
{
    NSParameterAssert(date);

    self = [super init];

    if (self)
    {
        _date = [date copy];
    }

    return self;
}

- (NSCalendar *)calendar
{
    return [[CTKCalendarSupplier calendarSupplier] autoupdatingCalendar];
}

- (NSLocale *)locale
{
    return [[CTKCalendarSupplier calendarSupplier] autoupdatingLocale];
}

#pragma mark -

- (NSUInteger)year
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self.date];

    return components.year;
}

- (NSUInteger)month
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self.date];

    return components.month;
}

- (NSString *)name
{
    NSLocale *locale = [self locale];
    NSCalendar *calendar = [self calendar];
    NSDate *date = self.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM";
    dateFormatter.locale = locale;
    dateFormatter.calendar = calendar;
    NSString *monthName = [dateFormatter stringFromDate:date];

    return [monthName capitalizedString];
}

- (NSUInteger)firstWeekday
{
    NSCalendar *calendar = [self calendar];
    NSDate *firstOfMonth = [self firstOfMonth];
    NSInteger component = [calendar component:NSCalendarUnitWeekday fromDate:firstOfMonth];

    return component;
}

- (NSDate *)firstOfMonth
{
    return [self firstOfMonth:self.date];
}

- (NSDate *)firstOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [self calendar];
    NSRange daysOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    dateComponents.day = daysOfMonth.location;
    NSDate *normalizedDate = [calendar dateFromComponents:dateComponents];

    return normalizedDate;
}

- (NSUInteger)lastWeekday
{
    NSCalendar *calendar = [self calendar];
    NSDate *lastOfMonth = [self lastOfMonth];
    NSInteger component = [calendar component:NSCalendarUnitWeekday fromDate:lastOfMonth];

    return component;
}

- (NSDate *)lastOfMonth
{
    return [self lastOfMonth:self.date];
}

- (NSDate *)lastOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [self calendar];
    NSRange daysOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    dateComponents.day = daysOfMonth.length;
    NSDate *normalizedDate = [calendar dateFromComponents:dateComponents];

    return normalizedDate;
}

- (NSUInteger)weekCount
{
    NSCalendar *calendar = [self calendar];
    NSRange weekRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self.date];
    NSUInteger weekCount = weekRange.length;

    return weekCount;
}

- (NSUInteger)firstCalendarWeek
{
    NSCalendar *calendar = [self calendar];
    NSDate *firstOfMonth = [self firstOfMonth:self.date];
    NSInteger component = [calendar component:NSCalendarUnitWeekOfYear fromDate:firstOfMonth];

    return component;
}
@end
