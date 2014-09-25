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
    referenceCalendar = nil;
    [super tearDown];
}

- (CCLCellDayTranslation *)cellDayTranslation
{
    CCLCalendarData *data = [self calendarData];
    return [CCLCellDayTranslation cellDayTranslationFor:data];
}

- (CCLCalendarData *)calendarData
{
    // Generate data fresh to take calendar settings into account upon Month initialization
    CCLMonth *aug2014 = [CCLMonth monthFromDate:[NSDate dateWithString:@"2014-08-02 12:12:00 +0000"]];
    CCLMonth *sep2014 = [CCLMonth monthFromDate:[NSDate dateWithString:@"2014-09-13 12:12:00 +0000"]];
    CCLMonths *months = [CCLMonths monthsFromArray:@[aug2014, sep2014]];
    return [CCLCalendarData calendarDataForMonths:months];
}

- (void)testDayLocator_ForFirstMonthRow_Throws
{
    CCLCellDayTranslation *translator = [self cellDayTranslation];
    XCTAssertThrows([translator dayLocatorForColumn:3 row:0], @"should throw for August title row");
}

- (void)testDayLocator_ForFirstWeek_FirstColumn_WeekStartingSunday_ReturnsSunday
{
    referenceCalendar.firstWeekday = 1; // Starts on Sunday
    CCLCellDayTranslation *translator = [self cellDayTranslation];
    
    CCLDayLocator *locator = [translator dayLocatorForColumn:0 row:1];
    
    XCTAssertEqual(locator.week, 1, @"should compute first week");
    XCTAssertEqual(locator.weekday, 1, @"should compute first weekday");
}

- (void)testDayLocator_ForFirstWeek_FirstColumn_WeekStartingTuesday_ReturnsTuesday
{
    referenceCalendar.firstWeekday = 3; // Starts on Tuesday
    CCLCellDayTranslation *translator = [self cellDayTranslation];
    
    CCLDayLocator *locator = [translator dayLocatorForColumn:0 row:1];
    
    XCTAssertEqual(locator.week, 1, @"should compute first week");
    XCTAssertEqual(locator.weekday, 3, @"should compute first weekday");
}

- (void)testDayLocator_ForSecondMonthRow_Throws
{
    CCLCellDayTranslation *translator = [self cellDayTranslation];
    XCTAssertThrows([translator dayLocatorForColumn:3 row:6], @"should throw for August title row");
}
@end
