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
    CCLMonth *month = [self monthWithYear:2010 month:10];
    NSArray *entries = @[month];
    
    CCLMonths *months = [CCLMonths monthsFromArray:entries];
    
    XCTAssertEqual([months monthAtIndex:0], month, @"should contain month object");
}

- (void)testMonths_WithBogusObject_Throws
{
    NSArray *entries = @[@"I am the wrong type of object"];
    
    XCTAssertThrows([CCLMonths monthsFromArray:entries], @"array with non-Month objects should throw exception");
}

#pragma mark Month consecutivity

- (void)testMonths_WithTwoAdjacentDaysInTheSameMonth_Throws
{
    CCLMonth *januarySecond = [self monthWithYear:2012 month:1 day:2];
    CCLMonth *januaryTwentieth = [self monthWithYear:2012 month:1 day:20];
    NSArray *entries = @[januarySecond, januaryTwentieth];
    
    XCTAssertThrows([CCLMonths monthsFromArray:entries], @"array with elements too close should throw exception");
}

- (void)testMonths_WithTwoAdjacentMonths_ContainsBoth
{
    CCLMonth *january = [self monthWithYear:2012 month:1];
    CCLMonth *february = [self monthWithYear:2012 month:2];
    NSArray *entries = @[january, february];
    
    CCLMonths *months = [CCLMonths monthsFromArray:entries];
    
    XCTAssertEqual([months monthAtIndex:0], january, @"should contain first month object");
    XCTAssertEqual([months monthAtIndex:1], february, @"should contain second month object");
}

- (void)testMonths_WithTwoAdjacentDaysIndifferentMonths_ContainsBoth
{
    CCLMonth *january = [self monthWithYear:2012 month:1 day:31];
    CCLMonth *february = [self monthWithYear:2012 month:2 day:1];
    NSArray *entries = @[january, february];
    
    CCLMonths *months = [CCLMonths monthsFromArray:entries];
    
    XCTAssertEqual([months monthAtIndex:0], january, @"should contain first month object");
    XCTAssertEqual([months monthAtIndex:1], february, @"should contain second month object");
}

- (void)testMonths_WithTwoNonAdjacentMonths_Throws
{
    CCLMonth *january = [self monthWithYear:2012 month:1];
    CCLMonth *march = [self monthWithYear:2012 month:3];
    NSArray *entries = @[january, march];
    
    XCTAssertThrows([CCLMonths monthsFromArray:entries], @"non-consecutive array should throw exception");
}

#pragma mark -

- (CCLMonth *)monthWithYear:(NSUInteger)year month:(NSUInteger)month
{
    NSUInteger irrelevantDay = 6;
    return [self monthWithYear:year month:month day:irrelevantDay];
}

- (CCLMonth *)monthWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    NSString *irrelevantTime = @"12:13:14 +0000";
    NSString *dateString =[NSString stringWithFormat:@"%lu-%02lu-%02lu %@", (unsigned long)year, (unsigned long)month, (unsigned long)day, irrelevantTime];
    NSDate *date = [NSDate dateWithString:dateString];
    NSAssert(date, @"date components invalid");
    return [CCLMonth monthFromDate:date];
}

@end
