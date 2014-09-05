//
//  TestCalendarSupplier.m
//  CalendarView
//
//  Created by Christian Tietze on 05.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "TestCalendarSupplier.h"

@implementation TestCalendarSupplier
- (NSCalendar *)autoupdatingCalendar
{
    if (self.testCalender)
    {
        return self.testCalender;
    }
    
    return [super autoupdatingCalendar];
}

- (NSLocale *)autoupdatingLocale
{
    if (self.testLocale)
    {
        return self.testLocale;
    }
    
    return [super autoupdatingLocale];
}
@end
