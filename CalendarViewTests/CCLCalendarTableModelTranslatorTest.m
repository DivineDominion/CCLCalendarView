//
//  CCLCalendarTableModelTranslatorTest.m
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLCalendarTableModelTranslator.h"

#import "CCLProvidesCalendarObjects.h"
#import "CCLDateRange.h"

@interface TestObjectProvider : NSObject <CCLProvidesCalendarObjects>
@property (strong) CCLDateRange *dateRange;
@end
@implementation TestObjectProvider
- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return nil;
}
@end

@interface TestDateRange : CCLDateRange
@property (strong) CCLMonths *months;
@end
@implementation TestDateRange
@end

@interface CCLCalendarTableModelTranslatorTest : XCTestCase

@end

@implementation CCLCalendarTableModelTranslatorTest
{
    CCLCalendarTableModelTranslator *translator;
    id<CCLProvidesCalendarObjects> testObjectProvider;
}

- (void)setUp
{
    [super setUp];
    testObjectProvider = [[TestObjectProvider alloc] init];
    translator = [CCLCalendarTableModelTranslator calendarTableModelTranslatorFrom:testObjectProvider];
}

- (void)tearDown
{
    testObjectProvider = nil;
    translator = nil;
    [super tearDown];
}


- (void)testSettingObjectProvider_UpdatesMonths
{
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    TestDateRange *dateRange = [[TestDateRange alloc] initWithStartDate:[NSDate date] endDate:[NSDate dateWithTimeIntervalSinceNow:1000]];
    dateRange.months = (id)[[NSObject alloc] init];
    objectProvider.dateRange = dateRange;
    
    [translator setObjectProvider:objectProvider];
    
    XCTAssertEqual(translator.months, dateRange.months, @"should retrieve months from dateRange");
}


- (void)testWeekRange_OfSep2014_Returns5
{
    NSDateComponents *september2014Components = [[NSDateComponents alloc] init];
    september2014Components.month = 9;
    september2014Components.year = 2014;
    
    NSUInteger weeks = [translator weeksOfMonthFromDateComponents:september2014Components];
    
    XCTAssertEqual(weeks, 5, @"Sep. 2014 should have 5 weeks");
}

@end
