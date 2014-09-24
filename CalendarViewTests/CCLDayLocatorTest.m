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
    TestCalendarSupplier *testCalendarSupplier = [[TestCalendarSupplier alloc] init];
    referenceCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
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
@end
