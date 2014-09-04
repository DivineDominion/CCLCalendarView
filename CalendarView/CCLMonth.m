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
        
    }
    
    return self;
}

- (NSCalendar *)calendar
{
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
}

#pragma mark -

@end
