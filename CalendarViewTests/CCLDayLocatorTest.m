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
}

- (void)setUp
{
    [super setUp];
    TestCalendarSupplier *testCalendarSupplier = [[TestCalendarSupplier alloc] init];
    NSCalendar *referenceCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    referenceCalendar.firstWeekday = 2;
    testCalendarSupplier.testCalender = referenceCalendar;
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

#pragma mark First Week

- (void)testFirstWeekOfAugust_Monday_IsOutside
{
    CCLDayLocator *locator = [self augustLocatorForWeek:0 weekday:2];
    
    XCTAssertTrue([locator isOutsideDayRange], @"first 4 days of the first week of August should be outside of August");
    XCTAssertTrue([locator nextDayIsOutsideDayRange], @"first 4 days of the first week of August should be outside of August");
}

- (void)testFirstWeekOfAugust_Thursday_IsLastDayOutside
{
    CCLDayLocator *locator = [self augustLocatorForWeek:0 weekday:5];
    
    XCTAssertTrue([locator isOutsideDayRange], @"first 4 days of the first week of August should be outside of August");
    XCTAssertFalse([locator nextDayIsOutsideDayRange], @"first 4 days of the first week of August should be outside of August");
}

- (void)testFirstWeekOfAugust_Friday_IsADay
{
    CCLDayLocator *locator = [self augustLocatorForWeek:0 weekday:6];
    
    XCTAssertFalse([locator isOutsideDayRange], @"5th day of the first week of August should be a Friday 1st, inside August");
}

- (void)testFirstWeekOfAugust_Saturday_IsAWeekendDay
{
    CCLDayLocator *locator = [self augustLocatorForWeek:0 weekday:7];
    
    XCTAssertFalse([locator isOutsideDayRange], @"6th day of the first week of August should be a Sat. 2nd, inside August");
    XCTAssertTrue([locator isWeekend], @"Saturday should be on a weekend");
}

#pragma mark Last Week

- (void)testLastWeekOfSeptember_Tuesday_IsADay
{
    CCLDayLocator *locator = [self septemberLocatorForWeek:4 weekday:3];
    
    XCTAssertFalse([locator isOutsideDayRange], @"Tuesday of the last week of September should be the last day of September");
    XCTAssertTrue([locator nextDayIsOutsideDayRange], @"the day after Tuesday 30th should be outside");
}

- (void)testLastWeekOfSeptember_Wednesday_IsOutside
{
    CCLDayLocator *locator = [self septemberLocatorForWeek:4 weekday:4];
    
    XCTAssertTrue([locator isOutsideDayRange], @"Wednesday of last week of September should be Oct 1st, outside");
    XCTAssertTrue([locator nextDayIsOutsideDayRange], @"following day should be outside, too");
}
@end
