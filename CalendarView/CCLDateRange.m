//
//  CCLDateRange.m
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDateRange.h"
#import "CTKCalendarSupplier.h"

@implementation CCLDateRange
+ (instancetype)dateRangeFrom:(NSDate *)startDate until:(NSDate *)endDate
{
    return [[self alloc] initWithStartDate:startDate endDate:endDate];
}

- (instancetype)init
{
    return [self initWithStartDate:nil endDate:nil];
}

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSParameterAssert(startDate);
    NSParameterAssert(endDate);
    
    self = [super init];
    
    [[self class] guardStartDate:startDate endDate:endDate];
    
    if (self)
    {
        _startDate = [startDate copy];
        _endDate = [endDate copy];
    }
    
    return self;
}

+ (void)guardStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    BOOL startDateIsBeforeEndDate = ([startDate earlierDate:endDate] == startDate);
    
    if (startDateIsBeforeEndDate)
    {
        return;
    }
    
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:@"start date %@ must be before end date %@", startDate, endDate]
                                 userInfo:nil];
}

#pragma mark -
#pragma mark Getting the Components

- (NSDateComponents *)startDateCalendarComponents
{
    NSCalendar *calendar = [self calendar];
    NSUInteger calendarComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:calendarComponents fromDate:self.startDate];
    
    return components;
}

- (NSDateComponents *)endDateCalendarComponents
{
    NSCalendar *calendar = [self calendar];
    NSUInteger calendarComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:calendarComponents fromDate:self.endDate];
    
    return components;
}

- (NSCalendar *)calendar
{
    return [[CTKCalendarSupplier calendarSupplier] autoupdatingCalendar];
}

#pragma mark Calendar Calculations

- (NSUInteger)monthSpan
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit fromDate:self.startDate toDate:self.endDate options:0];
    NSUInteger monthCount = ABS(components.month);
    NSUInteger monthSpan = monthCount + 1;
    
    return monthSpan;
}

- (void)enumerateMonthsUsingBlock:(CCLMonthEnumerationBlock)block
{
    NSDate *startDate = [self normalizedStartDate];
    NSDate *endDate = [self normalizedEndDate];
    NSCalendar *calendar = [self calendar];
    
    NSDateComponents *monthIncrement = [[NSDateComponents alloc] init];
    monthIncrement.month = 1;
    
    for (NSDate *nextDate = startDate;
         [nextDate earlierDate:endDate] == nextDate;
         nextDate = [calendar dateByAddingComponents:monthIncrement toDate:nextDate options:0])
    {
        block(nextDate);
    }
}

- (NSDate *)normalizedStartDate
{
    NSDate *normalizedDate = [self normalizedDate:self.startDate];
    return normalizedDate;
}

- (NSDate *)normalizedEndDate
{
    NSDate *normalizedDate = [self normalizedDate:self.endDate];
    return normalizedDate;
}

- (NSDate *)normalizedDate:(NSDate *)date
{
    NSCalendar *calendar = [self calendar];
    NSUInteger yearAndMonth = NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:yearAndMonth fromDate:date];
    NSDate *normalizedDate = [calendar dateFromComponents:dateComponents];
    
    return normalizedDate;
}
@end
