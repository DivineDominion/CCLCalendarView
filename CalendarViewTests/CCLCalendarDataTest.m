//
//  CCLCalendarDataTest.m
//  CalendarView
//
//  Created by Christian Tietze on 09.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestCalendarSupplier.h"

#import "CCLCalendarData.h"
#import "CCLMonths.h"
#import "CCLMonth.h"

@interface CCLCalendarDataTest : XCTestCase
@end

@implementation CCLCalendarDataTest
{
    CCLCalendarData *data;
}

- (void)setUp
{
    [super setUp];
    
    TestCalendarSupplier *testCalendarSupplier = [TestCalendarSupplier unifiedGregorianCalendarSupplier];
    [CTKCalendarSupplier setSharedInstance:testCalendarSupplier];
    
    CCLMonth *aug2014 = [CCLMonth monthFromDate:[Helper dateWithString:@"2014-08-02 12:12:00 +0000"]];
    CCLMonth *sep2014 = [CCLMonth monthFromDate:[Helper dateWithString:@"2014-09-13 12:12:00 +0000"]];
    CCLMonths *months = [CCLMonths monthsFromArray:@[aug2014, sep2014]];
    data = [CCLCalendarData calendarDataForMonths:months];
}

- (void)tearDown
{
    [CTKCalendarSupplier resetSharedInstance];
    data = nil;
    [super tearDown];
}

#pragma mark -
#pragma mark Translating Row View Types

- (void)testRowViewType_FirstRowOfAugust_ReturnsMonth
{
    CCLRowViewType returnedType = [data rowViewTypeForRow:0];
    
    XCTAssertEqual(returnedType, CCLRowViewTypeMonth, @"first row should be Month type");
}

- (void)testRowViewType_FirstRowOfSeptember_ReturnsMonth
{
    CCLRowViewType returnedType = [data rowViewTypeForRow:6];
    
    XCTAssertEqual(returnedType, CCLRowViewTypeMonth, @"6th row should be Month type");
}

- (void)testRowViewType_ForUsualRow_ReturnsWeek
{
    CCLRowViewType returnedType = [data rowViewTypeForRow:8];
    
    XCTAssertEqual(returnedType, CCLRowViewTypeWeek, @"usual row should be Week type");
}

- (void)testRowViewType_RowOutOfBounds_Throws
{
    XCTAssertThrows([data rowViewTypeForRow:100], @"waaaay to high a row index should throw");
}

@end
