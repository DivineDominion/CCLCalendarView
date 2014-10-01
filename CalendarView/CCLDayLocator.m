//
//  CCLDayLocator.m
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDayLocator.h"
#import "CCLMonth.h"
#import "CTKCalendarSupplier.h"

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
    return [[CTKCalendarSupplier calendarSupplier] autoupdatingCalendar];
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
    return self.month.firstOfMonth;
}

- (NSDate *)lastDayOfMonth
{
    return self.month.lastOfMonth;
}

- (NSDate *)dateForWeek:(NSUInteger)week weekday:(NSUInteger)weekday month:(CCLMonth *)month
{
    NSCalendar *calendar = [self calendar];
    NSUInteger weeksToAdd = week - 1;
    NSUInteger weekOfYear = month.firstCalendarWeek + weeksToAdd;
    
    NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
    dayComponents.yearForWeekOfYear = month.year;
    dayComponents.weekOfYear = weekOfYear;
    dayComponents.weekday = weekday;
    
    return [calendar dateFromComponents:dayComponents];
}


#pragma mark Weekend

- (BOOL)isWeekend
{
    if ([self calendarDoesNotSupportWeekends])
    {
        return NO;
    }
    
    return [self isWeekendInGregorianCalendar];
}

- (BOOL)calendarDoesNotSupportWeekends
{
    NSCalendar *calendar = [self calendar];
    return ![[calendar calendarIdentifier] isEqualTo:NSGregorianCalendar];
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


#pragma mark Date Component

- (NSDateComponents *)dateComponents
{
    NSDate *day = [self day];
    NSCalendar *calendar = [self calendar];
    NSCalendarUnit components = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekOfYearCalendarUnit;
    
    return [calendar components:components fromDate:day];
}

@end
