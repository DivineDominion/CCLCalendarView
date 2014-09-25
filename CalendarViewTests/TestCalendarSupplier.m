//
//  TestCalendarSupplier.m
//  CalendarView
//
//  Created by Christian Tietze on 05.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "TestCalendarSupplier.h"

@implementation TestCalendarSupplier
+ (instancetype)unifiedGregorianCalendarSupplier
{
    TestCalendarSupplier *supplier = [[TestCalendarSupplier alloc] init];
    NSCalendar *unifiedCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unifiedCalendar.firstWeekday = 2; // Start on Monday to unify week calculation expectations
    supplier.testCalendar = unifiedCalendar;
    
    return supplier;
}

- (NSCalendar *)autoupdatingCalendar
{
    if (self.testCalendar)
    {
        return self.testCalendar;
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
