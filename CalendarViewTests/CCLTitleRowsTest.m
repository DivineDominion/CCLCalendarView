//
//  CCLTitleRowsTest.m
//  CalendarView
//
//  Created by Christian Tietze on 08.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTest+MonthHelper.h"
#import "TestCalendarSupplier.h"

#import "CCLTitleRows.h"
#import "CCLMonths.h"
#import "CCLMonth.h"


@interface CCLTitleRowsTest : XCTestCase
@end

@implementation CCLTitleRowsTest
{
    TestCalendarSupplier *testCalendarSupplier;
}

- (void)setUp
{
    [super setUp];
    testCalendarSupplier = [[TestCalendarSupplier alloc] init];
    // Unify test results across platforms
    testCalendarSupplier.testCalender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [testCalendarSupplier.testCalender setFirstWeekday:2];
    [CTWCalendarSupplier setSharedInstance:testCalendarSupplier];
}

- (void)tearDown
{
    [CTWCalendarSupplier resetSharedInstance];
    testCalendarSupplier = nil;
    [super tearDown];
}


#pragma mark -
#pragma mark Creation

- (void)testCreation_WithNil_Throws
{
    XCTAssertThrows([CCLTitleRows titleRowsForMonths:nil], @"parameter should be required");
}

- (void)testCreation_WithOneMonth_CreatesArrayWith0
{
    CCLMonths *months = [CCLMonths monthsFromArray:@[[CCLMonth monthFromDate:[NSDate date]]]];
    CCLTitleRows *titleRows = [CCLTitleRows titleRowsForMonths:months];
    
    XCTAssertEqual(titleRows.titleRows.count, 1, @"should include 1 element");
    XCTAssert([titleRows.titleRows.firstObject isEqualToNumber:@0], @"should include first row");
    XCTAssert([titleRows containsRow:0], @"should report it contains first row");
}

- (void)testCreation_WithSepToNov2014_CreatesArrayWith0_6_12
{
    NSArray *monthArray = @[[self monthWithYear:2014 month:9],
                            [self monthWithYear:2014 month:10],
                            [self monthWithYear:2014 month:11]];
    CCLMonths *months = [CCLMonths monthsFromArray:monthArray];
    CCLTitleRows *titleRows = [CCLTitleRows titleRowsForMonths:months];
    
    XCTAssertEqual(titleRows.titleRows.count, 3, @"should include 3 elements");

    XCTAssert([titleRows.titleRows[0] isEqualToNumber:@0], @"should include first row");
    XCTAssert([titleRows containsRow:0], @"should report it contains first row, includes %lu instead", [titleRows.titleRows[0] unsignedIntegerValue]);
    
    XCTAssert([titleRows.titleRows[1] isEqualToNumber:@6], @"should include 6th row, includes %lu instead", [titleRows.titleRows[1] unsignedIntegerValue]);
    XCTAssert([titleRows containsRow:6], @"should report it contains 6th row");
    
    XCTAssert([titleRows.titleRows[2] isEqualToNumber:@12], @"should include 12th row, includes %lu instead", [titleRows.titleRows[2] unsignedIntegerValue]);
    XCTAssert([titleRows containsRow:12], @"should report it contains 12th row");
}


#pragma mark -
#pragma mark Determining Month Indexes

- (CCLTitleRows *)titleRows
{
    // Expected month rows: 0, 6, 12
    NSArray *monthArray = @[[self monthWithYear:2014 month:9],   // 5 weeks + 1
                            [self monthWithYear:2014 month:10],  // 5 weeks + 1
                            [self monthWithYear:2014 month:11]]; // 5 weeks + 1
    CCLMonths *months = [CCLMonths monthsFromArray:monthArray];
    CCLTitleRows *titleRows = [CCLTitleRows titleRowsForMonths:months];
    return titleRows;
}

- (void)testMonthIndex_ForFirstMonthRow_Returns1stMonth
{
    CCLTitleRows *titleRows = [self titleRows];
    
    NSUInteger monthIndex = [titleRows monthIndexOfRow:0];
    
    XCTAssertEqual(monthIndex, 0, @"1st month row should return itself");
}

- (void)testMonthIndex_ForWeek1_OfMonth1_Returns1stMonth
{
    CCLTitleRows *titleRows = [self titleRows];
    
    NSUInteger monthIndex = [titleRows monthIndexOfRow:1];
    
    XCTAssertEqual(monthIndex, 0, @"1st week row of 1st month row should return 1st month");
}

- (void)testMonthIndex_ForWeek1_OfMonth2_Returns2ndMonth
{
    CCLTitleRows *titleRows = [self titleRows];
    
    NSUInteger monthIndex = [titleRows monthIndexOfRow:7];
    
    XCTAssertEqual(monthIndex, 1, @"1st week row of 2nd month row should return 2nd month");
}

- (void)testMonthIndex_ForTitleRow_OfMonth3_Returns3rdMonth
{
    CCLTitleRows *titleRows = [self titleRows];
    
    NSUInteger monthIndex = [titleRows monthIndexOfRow:12];
    
    XCTAssertEqual(monthIndex, 2, @"title row of 3rd month row should return 3rd month");
}

- (void)testMonthIndex_ForSomethingOutOfBounds_Throws
{
    NSArray *monthArray = @[[self monthWithYear:2014 month:9]]; // 5 weeks + 1
    CCLMonths *months = [CCLMonths monthsFromArray:monthArray];
    CCLTitleRows *titleRows = [CCLTitleRows titleRowsForMonths:months];
    
    XCTAssertThrows([titleRows monthIndexOfRow:6], @"should be out of bounds");
}

@end
