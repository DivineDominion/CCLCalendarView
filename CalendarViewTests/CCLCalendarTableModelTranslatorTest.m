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
#import "CCLMonths.h"
#import "CCLMonth.h"
#import "CCLMonthsFactory.h"
#import "CCLSelectsDayCells.h"
#import "CCLDateRange.h"

@interface TestObjectProvider : NSObject <CCLProvidesCalendarObjects>
@property (strong) CCLDateRange *dateRange;
- (instancetype)initWithDateRange:(CCLDateRange *)dateRange;
@end
@implementation TestObjectProvider
- (instancetype)initWithDateRange:(CCLDateRange *)dateRange
{
    self = [super init];
    if (self)
    {
        _dateRange = dateRange;
    }
    return self;
}

- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return nil;
}
@end


@interface TestMonths : NSObject
@property (assign) NSUInteger count;
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


@interface TestSelectionDelegate : NSObject <CCLSelectsDayCells>
@property (assign) NSInteger cellSelectionRow;
@end
@implementation TestSelectionDelegate
- (BOOL)hasSelectedDayCell
{
    return NO;
}
@end


@interface CCLCalendarTableModelTranslatorTest : XCTestCase
@end

@implementation CCLCalendarTableModelTranslatorTest
{
    CCLCalendarTableModelTranslator *translator;
}

- (void)setUp
{
    [super setUp];
    // Initialize with dumb object provider to satisfy checks
    translator = [CCLCalendarTableModelTranslator calendarTableModelTranslatorFrom:[[TestObjectProvider alloc] initWithDateRange:[self dateRange]]];
}

- (void)tearDown
{
    translator = nil;
    [super tearDown];
}

- (void)testInitially_ComesWithAMonthsFactory
{
    XCTAssertNotNil(translator.monthsFactory, @"should have a default MonthsFactory");
}

- (void)testInitialization_GenerateMonthsFromObjectProvider
{
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    objectProvider.dateRange = [self dateRangeWithAMonthIn1970];
    
    translator = [CCLCalendarTableModelTranslator calendarTableModelTranslatorFrom:objectProvider];

    XCTAssertNotNil(translator.months, @"should have set up months");
    XCTAssertNotNil(translator.titleRows, @"should have set up title rows");
    XCTAssertEqual(translator.months.firstMonth.year, 1970, @"should have adopted the month");
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
    XCTAssertNotNil(translator.titleRows, @"should have set up title rows");
}

#pragma mark -
#pragma mark Translating Row View Types

- (void)testRowViewType_FirstRow_ReturnsMonth
{
    TestSelectionDelegate *testDelegate = [[TestSelectionDelegate alloc] init];
    testDelegate.cellSelectionRow = 5;
    translator.selectionDelegate = testDelegate;
    
    CCLRowViewType returnedType = [translator rowViewTypeForRow:0];
    
    XCTAssertEqual(returnedType, CCLRowViewTypeMonth, @"first row should be Month type");
}

- (void)testRowViewType_ForRowAboveSelection_ReturnsDayDetail
{
    TestSelectionDelegate *testDelegate = [[TestSelectionDelegate alloc] init];
    testDelegate.cellSelectionRow = 5;
    translator.selectionDelegate = testDelegate;
    
    CCLRowViewType returnedType = [translator rowViewTypeForRow:6];
    
    XCTAssertEqual(returnedType, CCLRowViewTypeDayDetail, @"row below selection should be DayDetail type");
}

- (void)testRowViewType_ForSelectionRow_ReturnsWeek
{
    [self setupObjectProviderFor1970];
    
    TestSelectionDelegate *testDelegate = [[TestSelectionDelegate alloc] init];
    testDelegate.cellSelectionRow = 4;
    translator.selectionDelegate = testDelegate;
    
    CCLRowViewType returnedType = [translator rowViewTypeForRow:4];
    
    XCTAssertEqual(returnedType, CCLRowViewTypeWeek, @"usual row should be Week type");
}

- (void)testRowViewType_RowOutOfBounds_Throws
{
    [self setupObjectProviderFor1970];
    
    XCTAssertThrows([translator rowViewTypeForRow:100], @"waaaay to high a row index should throw");
}

- (void)setupObjectProviderFor1970
{
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    CCLDateRange *sometimeIn1970 = [self dateRangeWithAMonthIn1970];
    objectProvider.dateRange = sometimeIn1970;
    translator.objectProvider = objectProvider;
}

- (CCLDateRange *)dateRange
{
    return [CCLDateRange dateRangeFrom:[NSDate dateWithTimeIntervalSinceNow:-1] until:[NSDate date]];
}

- (CCLDateRange *)dateRangeWithAMonthIn1970
{
    return [CCLDateRange dateRangeFrom:[NSDate dateWithTimeIntervalSince1970:-100] until:[NSDate dateWithTimeIntervalSince1970:100]];
}
@end
