//
//  CCLCalendarTableModelTranslatorTest.m
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLCalendarViewModel.h"
#import "TestObjectProvider.h"

#import "CCLProvidesCalendarObjects.h"
#import "CCLMonths.h"
#import "CCLMonth.h"
#import "CCLMonthsFactory.h"
#import "CCLDateRange.h"


@interface TestMonths : NSObject
@property (assign) NSUInteger count;
@property (strong) CCLMonth *lastMonth;
- (void)enumerateMonthsUsingBlock:(void (^)(id month, NSUInteger index, BOOL *stop))block;
@end
@implementation TestMonths
- (void)enumerateMonthsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    // no-op
}
@end


@interface TestMonthsFactory : CCLMonthsFactory
@property (strong) CCLDateRange *dateRangeProvided;
@end
@implementation TestMonthsFactory
- (id)monthsInDateRange:(CCLDateRange *)dateRange
{
    self.dateRangeProvided = dateRange;
    return [[TestMonths alloc] init];
}
@end

@interface CCLCalendarViewModelTest : XCTestCase
@end

@implementation CCLCalendarViewModelTest
{
    CCLCalendarViewModel *model;
}

- (void)setUp
{
    [super setUp];
    // Initialize with dumb object provider to satisfy checks
    model = [CCLCalendarViewModel calendarVieweModelFrom:[[TestObjectProvider alloc] init]];
}

- (void)tearDown
{
    model = nil;
    [super tearDown];
}

- (void)testInitially_ComesWithAMonthsFactory
{
    XCTAssertNotNil(model.monthsFactory, @"should have a default MonthsFactory");
}

- (void)testInitialization_GenerateMonthsFromObjectProvider
{
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    objectProvider.dateRange = [self dateRangeWithAMonthIn1970];
    
    model = [CCLCalendarViewModel calendarVieweModelFrom:objectProvider];

    XCTAssertNotNil(model.calendarData, @"should have set up data");
    XCTAssertEqual(model.calendarData.months.firstMonth.year, 1970, @"should have adopted the month");
}

- (void)testSettingObjectProvider_UpdatesMonths
{
    TestMonthsFactory *factory = [[TestMonthsFactory alloc] init];
    model.monthsFactory = factory;
    
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    id dateRangeDouble = [[NSObject alloc] init];
    objectProvider.dateRange = dateRangeDouble;
    
    [model setObjectProvider:objectProvider];
    
    XCTAssertEqual(factory.dateRangeProvided, dateRangeDouble, @"should delegate creation of months from dateRange");
}

- (void)setupObjectProviderFor1970
{
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    CCLDateRange *sometimeIn1970 = [self dateRangeWithAMonthIn1970];
    objectProvider.dateRange = sometimeIn1970;
    model.objectProvider = objectProvider;
}

- (CCLDateRange *)dateRangeWithAMonthIn1970
{
    return [CCLDateRange dateRangeFrom:[NSDate dateWithTimeIntervalSince1970:-100] until:[NSDate dateWithTimeIntervalSince1970:100]];
}
@end
