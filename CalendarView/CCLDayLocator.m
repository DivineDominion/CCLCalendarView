//
//  CCLDayLocator.m
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDayLocator.h"
#import "CCLMonth.h"

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

- (BOOL)isOutsideDayRange
{
    CCLMonth *month = self.month;
    NSUInteger week = self.week;
    NSUInteger weekday = self.weekday;
    
    if (week == 0)
    {
        return month.firstWeekday > weekday;
    }
    
    if (week == month.weekCount - 1)
    {
        return weekday > month.lastWeekday;
    }
    
    return NO;
}

- (BOOL)isWeekend
{
    NSUInteger weekday = self.weekday;
    
#warning assumes gregorian calendar only
    if (weekday == 1 || weekday == 7)
    {
        return YES;
    }
    
    return NO;
}

@end
