//
//  CCLDayLocatorTest.m
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLDayLocator.h"
#import "CCLMonth.h"

#import "TestCalendarSupplier.h"

@interface CCLDayLocatorTest : XCTestCase
@end

@implementation CCLDayLocatorTest
{
    NSCalendar *referenceCalendar;
}

- (void)setUp
{
    [super setUp];
    
    TestCalendarSupplier *testCalendarSupplier = [TestCalendarSupplier unifiedGregorianCalendarSupplier];
    referenceCalendar = testCalendarSupplier.testCalendar;
    [CTWCalendarSupplier setSharedInstance:testCalendarSupplier];
}

- (void)tearDown
{
    [CTWCalendarSupplier resetSharedInstance];
    [super tearDown];
}

- (CCLDayLocator *)augustLocatorForWeek:(NSUInteger)week weekday:(NSUInteger)weekday
{
    CCLMonth *august = [CCLMonth monthFromDate:[NSDate dateWithString:@"2014-08-02 12:12:00 +0000"]];
    return [CCLDayLocator dayLocatorInMonth:august week:week weekday:weekday];
}

- (CCLDayLocator *)septemberLocatorForWeek:(NSUInteger)week weekday:(NSUInteger)weekday
{
    CCLMonth *september = [CCLMonth monthFromDate:[NSDate dateWithString:@"2014-09-22 12:12:00 +0000"]];
    return [CCLDayLocator dayLocatorInMonth:september week:week weekday:weekday];
}

- (CCLDayLocator *)decemberLocatorForWeek:(NSUInteger)week weekday:(NSUInteger)weekday
{
    CCLMonth *december = [CCLMonth monthFromDate:[NSDate dateWithString:@"2012-12-12 12:12:00 +0000"]];
    return [CCLDayLocator dayLocatorInMonth:december week:week weekday:weekday];
}


#pragma mark First Week

- (void)testFirstWeekOfAugust_Monday_IsOutside
{
    CCLDayLocator *locator = [self augustLocatorForWeek:1 weekday:2];
    
    XCTAssertTrue([locator isOutsideDayRange], @"first 4 days of the first week of August should be outside of August");
}

- (void)testFirstWeekOfAugust_Thursday_IsLastDayOutside
{
    CCLDayLocator *locator = [self augustLocatorForWeek:1 weekday:5];
    
    XCTAssertTrue([locator isOutsideDayRange], @"first 4 days of the first week of August should be outside of August");
}

- (void)testFirstWeekOfAugust_Friday_IsADay
{
    CCLDayLocator *locator = [self augustLocatorForWeek:1 weekday:6];
    
    XCTAssertFalse([locator isOutsideDayRange], @"5th day of the first week of August should be a Friday 1st, inside August");
}

- (void)testFirstWeekOfAugust_Saturday_IsAWeekendDay
{
    CCLDayLocator *locator = [self augustLocatorForWeek:1 weekday:7];
    
    XCTAssertFalse([locator isOutsideDayRange], @"6th day of the first week of August should be a Sat. 2nd, inside August");
    XCTAssertTrue([locator isWeekend], @"Saturday should be on a weekend");
}


#pragma mark Last Week

- (void)testLastWeekOfSeptember_Tuesday_IsADay
{
    CCLDayLocator *locator = [self septemberLocatorForWeek:5 weekday:3];
    
    XCTAssertFalse([locator isOutsideDayRange], @"Tuesday of the last week of September should be the last day of September");
}

- (void)testLastWeekOfSeptember_Wednesday_IsOutside
{
    CCLDayLocator *locator = [self septemberLocatorForWeek:5 weekday:4];
    
    XCTAssertTrue([locator isOutsideDayRange], @"Wednesday of last week of September should be Oct 1st, outside");
}

- (void)testLastWeekOfSeptember_Sunday_ReportsDifferentlyDependingOnStartOfWeek
{
    referenceCalendar.firstWeekday = 2; // Start Monday, so Sunday is Oct. 5th
    CCLDayLocator *gerLocator = [self septemberLocatorForWeek:5 weekday:1];
    XCTAssertTrue([gerLocator isOutsideDayRange], @"Sunday of last week of September should be Oct 5th, outside");
    
    referenceCalendar.firstWeekday = 1; // Start Monday, so Sunday is Oct. 5th
    CCLDayLocator *usLocator = [self septemberLocatorForWeek:5 weekday:1];
    XCTAssertFalse([usLocator isOutsideDayRange], @"Sunday of last week of September should be Sep. 28th, inside");
}


#pragma mark Last Week of the Year, Wrapping Weeks

- (void)testLastWeekOfDecember2012_Monday_IsInside
{
    CCLDayLocator *locator = [self decemberLocatorForWeek:6 weekday:2];
    
    XCTAssertFalse([locator isOutsideDayRange], @"Monday of the last week of December 2012 should be the last day of December");
}

- (void)testLastWeekOfDecember2012_Tuesday_IsOutside
{
    CCLDayLocator *locator = [self decemberLocatorForWeek:6 weekday:3];
    
    // Dec 1st is on week of year 48 -- reports 49 instead
    // When week of year count > 52, wrap year
    XCTAssertTrue([locator isOutsideDayRange], @"Tuesday of the last week of December 2012 should be Jan 1st 2013");
    NSDateComponents *components = [locator dateComponents];
    XCTAssertEqual(components.year, 2013, @"should be in 2013");
    XCTAssertEqual(components.month, 1, @"should be Jan");
    XCTAssertEqual(components.day, 1, @"should be the 1st");
}


@end
