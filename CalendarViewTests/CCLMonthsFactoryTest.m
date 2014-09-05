//
//  CCLMonthsFactoryTest.m
//  CalendarView
//
//  Created by Christian Tietze on 05.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLMonthsFactory.h"

#import "CCLMonth.h"
#import "CCLMonths.h"
#import "CCLDateRange.h"
#import "TestCalendarSupplier.h"

@interface CCLMonthsFactoryTest : XCTestCase
@end

@implementation CCLMonthsFactoryTest
{
    CCLMonthsFactory *factory;
    TestCalendarSupplier *testCalendarSupplier;
}

- (void)setUp
{
    [super setUp];
    factory = [CCLMonthsFactory monthsFactory];
    
    testCalendarSupplier = [[TestCalendarSupplier alloc] init];
    testCalendarSupplier.testCalender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [CTWCalendarSupplier setSharedInstance:testCalendarSupplier];
}

- (void)tearDown
{
    [CTWCalendarSupplier resetSharedInstance];
    testCalendarSupplier = nil;
    factory = nil;
    [super tearDown];
}

- (void)testMonthsFromDateRange_WithNil_Throws
{
    XCTAssertThrows([factory monthsInDateRange:nil], @"nil should throw");
}

- (void)testMonthsFromDateRange_ForTwoDaysInSeptember_ReturnsCollectionWithSeptember
{
    CCLDateRange *dateRange = [CCLDateRange dateRangeFrom:[NSDate dateWithString:@"2014-09-05 09:50:00 +0000"] until:[NSDate dateWithString:@"2014-09-15 13:30:00 +0000"]];
    
    CCLMonths *returnedMonths = [factory monthsInDateRange:dateRange];
    
    XCTAssertEqual(returnedMonths.count, 1, @"months should include 1 entry");
    CCLMonth *firstMonth = [returnedMonths firstMonth];
    XCTAssertEqual(firstMonth.month, 9, @"should be september");
}

- (void)testMonthsFromDateRange_ForADayInSeptemberAndOctober_ReturnsCollectionWithBothMonths
{
    CCLDateRange *dateRange = [CCLDateRange dateRangeFrom:[NSDate dateWithString:@"2012-09-05 09:50:00 +0000"] until:[NSDate dateWithString:@"2012-10-15 13:30:00 +0000"]];
    
    CCLMonths *returnedMonths = [factory monthsInDateRange:dateRange];
    
    XCTAssertEqual(returnedMonths.count, 2, @"months should include 2 entries");
    XCTAssertEqual([returnedMonths monthAtIndex:0].month, 9, @"should be September");
    XCTAssertEqual([returnedMonths monthAtIndex:1].month, 10, @"should be October");
}

- (void)testMonthsFromDateRange_FromAugustToMarch_ReturnsCollectionWithAllMonths
{
    CCLDateRange *dateRange = [CCLDateRange dateRangeFrom:[NSDate dateWithString:@"2012-08-05 09:50:00 +0000"] until:[NSDate dateWithString:@"2013-03-15 13:30:00 +0000"]];
    
    CCLMonths *returnedMonths = [factory monthsInDateRange:dateRange];
    
    XCTAssertEqual(returnedMonths.count, 8, @"months should include 8 entries");
}

@end
