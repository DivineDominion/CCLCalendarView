//
//  CTWCalendarSupplier.m
//  WordCounter
//
//  Created by Christian Tietze on 14.04.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CTWCalendarSupplier.h"

@implementation CTWCalendarSupplier
+ (instancetype)calendarSupplier
{
    return [[self alloc] init];
}

- (NSCalendar *)autoupdatingCalendar
{
    return [NSCalendar autoupdatingCurrentCalendar];
}
@end
