//
//  TestObjectProvider.m
//  CalendarView
//
//  Created by Christian Tietze on 09.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "TestObjectProvider.h"
#import "CCLDateRange.h"

@implementation TestObjectProvider
- (instancetype)init
{
    CCLDateRange *dateRange = [CCLDateRange dateRangeFrom:[NSDate dateWithTimeIntervalSinceNow:-1] until:[NSDate date]];
    return [self initWithDateRange:dateRange];
}

- (instancetype)initWithDateRange:(CCLDateRange *)dateRange
{
    self = [super init];
    if (self)
    {
        _dateRange = dateRange;
    }
    return self;
}

- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return nil;
}
@end