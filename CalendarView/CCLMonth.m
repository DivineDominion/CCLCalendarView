//
//  CCLMonth.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLMonth.h"
#import "CTWCalendarSupplier.h"

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
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
}

- (NSLocale *)locale
{
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingLocale];
}

#pragma mark -

- (NSUInteger)year
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:self.date];
    
    return components.year;
}

- (NSUInteger)month
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit fromDate:self.date];
    
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
    NSDate *firstOfMonth = [self firstOfMonth:self.date];
    NSInteger component = [calendar component:NSWeekdayCalendarUnit fromDate:firstOfMonth];
    
    return component;
}

- (NSDate *)firstOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [self calendar];
    NSRange daysOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    dateComponents.day = daysOfMonth.location;
    NSDate *normalizedDate = [calendar dateFromComponents:dateComponents];
    
    return normalizedDate;
}

- (NSUInteger)lastWeekday
{
    NSCalendar *calendar = [self calendar];
    NSDate *lastOfMonth = [self lastOfMonth:self.date];
    NSInteger component = [calendar component:NSWeekdayCalendarUnit fromDate:lastOfMonth];
    
    return component;
}

- (NSDate *)lastOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [self calendar];
    NSRange daysOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    dateComponents.day = daysOfMonth.length;
    NSDate *normalizedDate = [calendar dateFromComponents:dateComponents];
    
    return normalizedDate;
}

- (NSUInteger)weekCount
{
    NSCalendar *calendar = [self calendar];
    NSRange weekRange = [calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date];
    NSUInteger weekCount = weekRange.length;
    
    return weekCount;
}

- (NSUInteger)firstCalenderWeek
{
    NSCalendar *calendar = [self calendar];
    NSDate *firstOfMonth = [self firstOfMonth:self.date];
    NSInteger component = [calendar component:NSWeekOfYearCalendarUnit fromDate:firstOfMonth];
    
    return component;
}
@end
