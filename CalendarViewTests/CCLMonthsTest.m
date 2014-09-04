//
//  CCLMonthsTest.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLMonths.h"
#import "CCLMonth.h"

@interface CCLMonthsTest : XCTestCase
@end

@implementation CCLMonthsTest
- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMonths_WithNil_Throws
{
    XCTAssertThrows([CCLMonths monthsFromArray:nil], @"empty array should throw exception");
}

- (void)testMonths_WithNoEntries_Throws
{
    XCTAssertThrows([CCLMonths monthsFromArray:@[]], @"empty array should throw exception");
}

- (void)testMonths_WithSingleMonth_ContainsOne
{
    CCLMonth *month = [[CCLMonth alloc] init];
    NSArray *entries = @[month];
    
    CCLMonths *months = [CCLMonths monthsFromArray:entries];
    
    XCTAssertEqual([months monthAtIndex:0], month, @"should contain month object");
}

- (void)testMonths_WithBogusObject_Throws
{
    NSArray *entries = @[@"I am the wrong type of object"];
    
    XCTAssertThrows([CCLMonths monthsFromArray:entries], @"array with non-Month objects should throw exception");
}

- (void)testMonths_WithTwoAdjacentMonths_ContainsBoth
{
    CCLMonth *january = [[CCLMonth alloc] init];
    CCLMonth *february = [[CCLMonth alloc] init];
    NSArray *entries = @[january, february];
    
    CCLMonths *months = [CCLMonths monthsFromArray:entries];
    
    XCTAssertEqual([months monthAtIndex:0], january, @"should contain first month object");
    XCTAssertEqual([months monthAtIndex:1], february, @"should contain second month object");
}

- (void)testMonths_WithTwoNonAdjacentMonths_Throws
{
    CCLMonth *january = [[CCLMonth alloc] init];
    CCLMonth *march = [[CCLMonth alloc] init];
    NSArray *entries = @[january, march];
    
    XCTAssertThrows([CCLMonths monthsFromArray:entries], @"non-consecutive array should throw exception");
}

@end
