//
//  CCLDateRangeTest.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLDateRange.h"

@interface NSDate (IsoYearMonth)
- (NSString *)isoYearAndMonth;
@end
@implementation NSDate (IsoYearMonth)
- (NSString *)isoYearAndMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    return [formatter stringFromDate:self];
}
@end

@interface CCLDateRangeTest : XCTestCase
@end

@implementation CCLDateRangeTest
{
    CCLDateRange *dateRange;
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


#pragma mark -monthSpan

- (void)testMonthsSpanning_OneHourOnTheSameDay_Returns1
{
    NSDate *startDate = [NSDate dateWithString:@"2014-07-04 14:00:00 +0200"];
    NSDate *endDate = [NSDate dateWithString:@"2014-07-04 15:00:00 +0200"];
    dateRange = [CCLDateRange dateRangeFrom:startDate until:endDate];
    
    NSUInteger months = [dateRange monthSpan];
    
    XCTAssertEqual(months, 1, @"expected to return spanning 1 month");
}

- (void)testMonthsSpanning_MidJulyToMidSeptember_Returns3
{
    NSDate *startDate = [NSDate dateWithString:@"2014-07-04 14:00:00 +0200"];
    NSDate *endDate = [NSDate dateWithString:@"2014-09-12 23:00:00 +0200"];
    dateRange = [CCLDateRange dateRangeFrom:startDate until:endDate];
    
    NSUInteger months = [dateRange monthSpan];
    
    XCTAssertEqual(months, 3, @"expected to return 3 full months");
}


#pragma mark -enumerateMonthsUsingBlock:

- (void)testMonthEnumeration_ForTwoMonths_CallsBlockTwiceWithEachMonthsDate
{
    // Given
    NSDate *startDate = [NSDate dateWithString:@"2014-01-04 09:00:00 +0200"];
    NSDate *endDate = [NSDate dateWithString:@"2014-02-23 12:00:00 +0200"];
    dateRange = [CCLDateRange dateRangeFrom:startDate until:endDate];
    
    __block NSMutableArray *calls = [NSMutableArray array];
    CCLMonthEnumerationBlock block = ^void(NSDate *date)
    {
        [calls addObject:date];
    };
    
    
    // When
    [dateRange enumerateMonthsUsingBlock:block];
    
    
    // Then
    XCTAssertEqual([calls count], 2, @"block not called as many times as there are months");
    
    NSString *expectedMonth = @"2014-01";
    XCTAssert([[calls[0] isoYearAndMonth] isEqualToString:expectedMonth], @"first added date is wrong");
    
    expectedMonth = @"2014-02";
    XCTAssert([[calls[1] isoYearAndMonth] isEqualToString:expectedMonth], @"second added date is wrong");
}

- (void)testMonthEnumeration_For20DaysSpanningTwoMonths_CallsBlockTwice
{
    // Given
    NSDate *startDate = [NSDate dateWithString:@"2014-01-15 09:00:00 +0200"];
    NSDate *endDate = [NSDate dateWithString:@"2014-02-05 12:00:00 +0200"];
    dateRange = [CCLDateRange dateRangeFrom:startDate until:endDate];
    
    __block NSMutableArray *calls = [NSMutableArray array];
    CCLMonthEnumerationBlock block = ^void(NSDate *date)
    {
        [calls addObject:date];
    };
    
    
    // When
    [dateRange enumerateMonthsUsingBlock:block];
    
    
    // Then
    XCTAssertEqual([calls count], 2, @"block not called as many times as there are months");
    
    NSString *expectedMonth = @"2014-01";
    XCTAssert([[calls[0] isoYearAndMonth] isEqualToString:expectedMonth], @"first added date is wrong");
    
    expectedMonth = @"2014-02";
    XCTAssert([[calls[1] isoYearAndMonth] isEqualToString:expectedMonth], @"second added date is wrong");
}

- (void)testMonthEnumeration_ForASecond_CallsBlockOnceWithTheDate
{
    // Given
    NSDate *startDate = [NSDate dateWithString:@"2012-01-04 09:11:22 +0200"];
    NSDate *endDate = [NSDate dateWithString:@"2012-01-04 09:11:23 +0200"];
    dateRange = [CCLDateRange dateRangeFrom:startDate until:endDate];
    
    __block NSMutableArray *calls = [NSMutableArray array];
    CCLMonthEnumerationBlock block = ^void(NSDate *date)
    {
        [calls addObject:date];
    };
    
    
    // When
    [dateRange enumerateMonthsUsingBlock:block];
    
    
    // Then
    XCTAssertEqual([calls count], 1, @"block not called as many times as there are months");
    NSString *expectedMonth = @"2012-01";
    XCTAssert([[calls[0] isoYearAndMonth] isEqualToString:expectedMonth], @"added date is wrong");
}
@end
