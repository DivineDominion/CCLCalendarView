//
//  CCLMonthTest.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLMonth.h"

@interface CCLMonthTest : XCTestCase
@end

@implementation CCLMonthTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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

@end
