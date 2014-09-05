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
#import "CCLMonthsFactory.h"

@interface TestObjectProvider : NSObject <CCLProvidesCalendarObjects>
@property (strong) CCLDateRange *dateRange;
@end
@implementation TestObjectProvider
- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return nil;
}
@end

@interface TestMonthsFactory : CCLMonthsFactory
@property (strong) CCLDateRange *dateRangeProvided;
@end
@implementation TestMonthsFactory
- (CCLMonths *)monthsInDateRange:(CCLDateRange *)dateRange
{
    self.dateRangeProvided = dateRange;
    return nil;
}
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

- (void)testInitially_ComesWithAMonthsFactory
{
    XCTAssertNotNil(translator.monthsFactory, @"should have a default MonthsFactory");
}

- (void)testSettingObjectProvider_UpdatesMonths
{
    TestMonthsFactory *factory = [[TestMonthsFactory alloc] init];
    translator.monthsFactory = factory;
    
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    id dateRangeDouble = [[NSObject alloc] init];
    objectProvider.dateRange = dateRangeDouble;
    
    [translator setObjectProvider:objectProvider];
    
    XCTAssertEqual(factory.dateRangeProvided, dateRangeDouble, @"should delegate creation of months from dateRange");
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
