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

@end
