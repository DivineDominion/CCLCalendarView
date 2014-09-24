//
//  CCLDayLocator.m
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDayLocator.h"
#import "CCLMonth.h"
#import "CTWCalendarSupplier.h"

@implementation CCLDayLocator
+ (instancetype)dayLocatorInMonth:(CCLMonth *)month week:(NSUInteger)week weekday:(NSUInteger)weekday
{
    return [[self alloc] initWithMonth:month week:week weekday:weekday];
}

- (instancetype)initWithMonth:(CCLMonth *)month week:(NSUInteger)week weekday:(NSUInteger)weekday
{
    self = [super init];
    
    if (self)
    {
        _month = month;
        _week = week;
        _weekday = weekday;
    }
    
    return self;
}

- (NSCalendar *)calendar
{
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
}


#pragma mark -
#pragma mark Weekday in Range of Month

- (BOOL)isOutsideDayRange
{
    if ([self isDuringFirstWeekOfMonth])
    {
        return [self isBeforeBeginningOfMonth];
    }
    
    if ([self isDuringLastWeekOfMonth])
    {
        return [self isAfterEndOfMonth];
    }
    
    return NO;
}

- (BOOL)isDuringFirstWeekOfMonth
{
    NSUInteger week = self.week;
    
    return week == 1;
}

- (BOOL)isBeforeBeginningOfMonth
{
    NSDate *day = [self day];
    NSDate *firstDay = [self firstDayOfMonth];
    
    if ([firstDay isEqualToDate:day])
    {
        return NO;
    }
    
    return [firstDay earlierDate:day] == day;
}

- (BOOL)isDuringLastWeekOfMonth
{
    CCLMonth *month = self.month;
    NSUInteger week = self.week;
    
    return week == month.weekCount;
}

- (BOOL)isAfterEndOfMonth
{
    NSDate *day = [self day];
    NSDate *lastDay = [self lastDayOfMonth];
    
    if ([lastDay isEqualToDate:day])
    {
        return NO;
    }
    
    return [day laterDate:lastDay] == day;
}

- (NSDate *)day
{
    CCLMonth *month = self.month;
    NSUInteger week = self.week;
    NSUInteger weekday = self.weekday;
    
    return [self dateForWeek:week weekday:weekday month:month];
}

- (NSDate *)firstDayOfMonth
{
    CCLMonth *month = self.month;
    NSUInteger week = 1;
    NSUInteger weekday = month.firstWeekday;
    
    return [self dateForWeek:week weekday:weekday month:month];
}

- (NSDate *)lastDayOfMonth
{
    CCLMonth *month = self.month;
    NSUInteger week = month.weekCount;
    NSUInteger weekday = month.lastWeekday;
    
    return [self dateForWeek:week weekday:weekday month:month];
}

- (NSDate *)dateForWeek:(NSUInteger)week weekday:(NSUInteger)weekday month:(CCLMonth *)month
{
    NSCalendar *calendar = [self calendar];
    
    NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
    dayComponents.year = month.year;
    dayComponents.month = month.month;
    dayComponents.weekOfMonth = week;
    dayComponents.weekday = weekday;
    
    return [calendar dateFromComponents:dayComponents];
}


#pragma mark Weekend

- (BOOL)isWeekend
{
    NSCalendar *calendar = self.calendar;
    
    if (![[calendar calendarIdentifier] isEqualTo:NSGregorianCalendar])
    {
        return NO;
    }
    
    return [self isWeekendInGregorianCalendar];
}

- (BOOL)isWeekendInGregorianCalendar
{
    NSUInteger weekday = self.weekday;
    
    if (weekday == 1  || weekday == 7)
    {
        return YES;
    }
    
    // For locales starting on Monday, Sunday becomes 8
    if (weekday > 7 && (weekday - 7) == 1)
    {
        return YES;
    }
    
    return NO;
}


@end
