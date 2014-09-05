//
//  CCLMonthsFactory.m
//  CalendarView
//
//  Created by Christian Tietze on 05.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLMonthsFactory.h"
#import "CCLDateRange.h"
#import "CCLMonths.h"
#import "CCLMonth.h"

@implementation CCLMonthsFactory
+ (instancetype)monthsFactory
{
    return [[self alloc] init];
}

- (CCLMonths *)monthsInDateRange:(CCLDateRange *)dateRange
{
    NSParameterAssert(dateRange);
    
    NSUInteger monthSpan = dateRange.monthSpan;
    NSMutableArray *monthsArray = [NSMutableArray arrayWithCapacity:monthSpan];
    
    [dateRange enumerateMonthsUsingBlock:^(NSDate *date) {
        CCLMonth *month = [CCLMonth monthFromDate:date];
        [monthsArray addObject:month];
    }];
    
    CCLMonths *months = [CCLMonths monthsFromArray:monthsArray];
    
    return months;
}
@end
