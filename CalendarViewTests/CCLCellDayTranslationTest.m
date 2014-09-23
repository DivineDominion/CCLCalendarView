//
//  CCLCellDayTranslationTest.m
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLCellDayTranslation.h"

#import "CCLDayLocator.h"
#import "CCLMonth.h"
#import "CCLMonths.h"
#import "CCLCalendarData.h"

#import "TestCalendarSupplier.h"

@interface CCLCellDayTranslationTest : XCTestCase
@end

@implementation CCLCellDayTranslationTest
{
    CCLCellDayTranslation *translator;
    CCLCalendarData *data;
    
    NSCalendar *referenceCalendar;
}

- (void)setUp
{
    [super setUp];
    
    CCLMonth *aug2014 = [CCLMonth monthFromDate:[NSDate dateWithString:@"2014-08-02 12:12:00 +0000"]];
    CCLMonth *sep2014 = [CCLMonth monthFromDate:[NSDate dateWithString:@"2014-09-13 12:12:00 +0000"]];
    CCLMonths *months = [CCLMonths monthsFromArray:@[aug2014, sep2014]];
    data = [CCLCalendarData calendarDataForMonths:months];
    
    translator = [CCLCellDayTranslation cellDayTranslationFor:data];
    
    TestCalendarSupplier *testCalendarSupplier = [[TestCalendarSupplier alloc] init];
    referenceCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    testCalendarSupplier.testCalender = referenceCalendar;
    [CTWCalendarSupplier setSharedInstance:testCalendarSupplier];
}

- (void)tearDown
{
    [CTWCalendarSupplier resetSharedInstance];
    data = nil;
    translator = nil;
    [super tearDown];
}

- (void)testDayLocator_ForFirstMonthRow_Throws
{
    XCTAssertThrows([translator dayLocatorForColumn:3 row:0], @"should throw for August title row");
}

- (void)testDayLocator_ForFirstWeek_FirstColumn_WeekStartingSunday_ReturnsSunday
{
    referenceCalendar.firstWeekday = 1; // Starts on Sunday
    
    CCLDayLocator *locator = [translator dayLocatorForColumn:0 row:1];
    
    XCTAssertEqual(locator.week, 0, @"should compute first week");
    XCTAssertEqual(locator.weekday, 1, @"should compute first weekday");
}

- (void)testDayLocator_ForFirstWeek_FirstColumn_WeekStartingTuesday_ReturnsTuesday
{
    referenceCalendar.firstWeekday = 3; // Starts on Sunday
    
    CCLDayLocator *locator = [translator dayLocatorForColumn:0 row:1];
    
    XCTAssertEqual(locator.week, 0, @"should compute first week");
    XCTAssertEqual(locator.weekday, 3, @"should compute first weekday");
}

- (void)testDayLocator_ForSecondMonthRow_Throws
{
    XCTAssertThrows([translator dayLocatorForColumn:3 row:6], @"should throw for August title row");
}
@end
