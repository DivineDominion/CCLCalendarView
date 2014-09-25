//
//  CCLMonthTest.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLMonth.h"
#import "CTWCalendarSupplier.h"
#import "TestCalendarSupplier.h"

@interface CCLMonthTest : XCTestCase
@end

@implementation CCLMonthTest
{
    TestCalendarSupplier *testCalendarSupplier;
}

- (void)setUp
{
    [super setUp];
    testCalendarSupplier = [TestCalendarSupplier unifiedGregorianCalendarSupplier];
    [CTWCalendarSupplier setSharedInstance:testCalendarSupplier];
}

- (void)tearDown
{
    [CTWCalendarSupplier resetSharedInstance];
    testCalendarSupplier = nil;
    [super tearDown];
}

- (void)testYear_ReturnsTheYear
{
    NSDate *date = [NSDate dateWithString:@"1997-08-12 16:08:34 +0200"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    XCTAssertEqual(month.year, 1997, @"should expose year of date");
}

- (void)testMonth_ReturnsTheMonth
{
    NSDate *date = [NSDate dateWithString:@"1951-07-04 02:33:05 +0100"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    XCTAssertEqual(month.month, 7, @"should expose month of date");
}

- (void)testName_ForFrenchLocale_ReturnsFrenchName
{
    testCalendarSupplier.testLocale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
    NSDate *date = [NSDate dateWithString:@"1951-01-04 02:33:05 +0100"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    NSString *name = month.name;
    
    XCTAssert([name isEqualToString:@"Janvier"], @"%@ should be Janvier, the month name in the users format", name);
}

- (void)testFirstWeekday_OfMay2014_ReturnsThursday
{
    NSDate *date = [NSDate dateWithString:@"2014-05-24 12:33:05 +0100"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    NSUInteger weekday = [month firstWeekday];
    
    XCTAssertEqual(weekday, 5, @"weekday %lu should be 5 for thursday", weekday);
}

- (void)testLastWeekday_OfOct2012_ReturnsWednesday
{
    NSDate *date = [NSDate dateWithString:@"2012-10-07 19:13:05 +0200"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    NSUInteger weekday = [month lastWeekday];
    
    XCTAssertEqual(weekday, 4, @"weekday %lu should be 4 for wednesday", weekday);
}

- (void)testNumberOfWeeks_OfJun2014InGermany_Returns6
{
    [testCalendarSupplier.testCalendar setFirstWeekday:2]; // Start on Monday so it gets longer
    NSDate *date = [NSDate dateWithString:@"2014-06-07 19:13:05 +0200"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    NSUInteger weeks = [month weekCount];
    
    XCTAssertEqual(weeks, 6, @"Jun. 2014 should have 6 weeks");
}

- (void)testNumberOfWeeks_OfFeb2010_Returns4
{
    [testCalendarSupplier.testCalendar setFirstWeekday:2]; // Start on Monday so Feb 2014 is more compact
    NSDate *date = [NSDate dateWithString:@"2010-02-07 19:13:05 +0200"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    NSUInteger weeks = [month weekCount];
    
    XCTAssertEqual(weeks, 4, @"Feb. 2010 should have 4 weeks");
}

- (void)testCalendarWeekOfFirstWeek_OfAug2014_Returns31
{
    NSDate *date = [NSDate dateWithString:@"2014-08-07 19:13:05 +0200"];
    CCLMonth *month = [CCLMonth monthFromDate:date];
    
    NSUInteger week = [month firstCalendarWeek];
    
    XCTAssertEqual(week, 31, @"Aug. 2014 should start in the #31 week of the year");
}

@end
