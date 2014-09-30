//
//  CCLRowAdjustmentTest.m
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLRowAdjustment.h"
#import "CCLProvidesTableData.h"
#import "CCLTableDataTypes.h"
#import "CCLDayCellSelection.h"
#import "CCLDayCellView.h"

@interface TestProvider : NSObject <CCLProvidesTableData>
@property (assign) NSUInteger numberOfRows;
@property (assign) NSUInteger lastRowIndex;
@end

@implementation TestProvider
- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row
{
    self.lastRowIndex = row;
    return CCLCellTypeUndefined;
}

- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row
{
    self.lastRowIndex = row;
    return CCLRowViewTypeUndefined;
}

- (id)objectValueForColumn:(NSInteger)column row:(NSInteger)row
{
    self.lastRowIndex = row;
    return nil;
}

- (id)objectValueForRow:(NSInteger)row
{
    self.lastRowIndex = row;
    return nil;
}


- (NSString *)monthNameForTableView:(NSTableView *)tableView row:(NSInteger)row
{
    self.lastRowIndex = row;
    return nil;
}
@end


@interface CCLRowAdjustmentTest : XCTestCase
@end

@implementation CCLRowAdjustmentTest
{
    TestProvider *testProvider;
    CCLDayCellSelection *selection;
    NSUInteger selectedRow;
}

- (void)setUp
{
    [super setUp];
    testProvider = [[TestProvider alloc] init];
    selection = [CCLDayCellSelection dayCellSelection:[[CCLDayCellView alloc] init] atRow:10 column:0];
}

- (void)tearDown
{
    testProvider = nil;
    [super tearDown];
}

- (CCLRowAdjustment *)rowAdjustment_IncludingSelection
{
    CCLRowAdjustment *rowAdjustment = [CCLRowAdjustment rowAdjustmentForDelegate:testProvider];
    [rowAdjustment controllerDidSelectDayCell:selection];
    
    return rowAdjustment;
}

- (CCLRowAdjustment *)rowAdjustment_NoSelection
{
    return [CCLRowAdjustment rowAdjustmentForDelegate:testProvider];
}


#pragma mark -
#pragma mark Wrapping Row View Type

- (void)testRowViewType_WithSelection_BeforeSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    
    [adjustment rowViewTypeForRow:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index before selected row");
    
    NSUInteger row = selection.row - 1;
    [adjustment rowViewTypeForRow:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index before selected row");
}

- (void)testRowViewType_WithSelection_AtSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row;
    
    [adjustment rowViewTypeForRow:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index at the selected row");
}

- (void)testRowViewType_WithSelection_AtDetailRow_ReturnsDayDetailType
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row + 1;
    
    CCLRowViewType returnedType = [adjustment rowViewTypeForRow:row];
    XCTAssertEqual(returnedType, CCLRowViewTypeDayDetail, @"intercept & return day detail");
}

- (void)testRowViewType_WithSelection_AfterSelectedRow_AdjustsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row + 10;
    
    [adjustment rowViewTypeForRow:row];
    XCTAssertEqual(testProvider.lastRowIndex, row - 1, @"modify index after selected row");
}

- (void)testRowViewType_WithoutAnySelection_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_NoSelection];
    
    [adjustment rowViewTypeForRow:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index");
    
    [adjustment rowViewTypeForRow:10];
    XCTAssertEqual(testProvider.lastRowIndex, 10, @"shouldn't modify index");
    
    [adjustment rowViewTypeForRow:100];
    XCTAssertEqual(testProvider.lastRowIndex, 100, @"shouldn't modify index");
}


#pragma mark Wrapping Cell View Type

- (void)testCellType_WithSelection_BeforeSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    
    [adjustment cellTypeForColumn:3 row:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index before selected row");
    
    NSUInteger row = selection.row - 1;
    [adjustment cellTypeForColumn:10 row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index before selected row");
}

- (void)testCellType_WithSelection_AtSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row;
    
    [adjustment cellTypeForColumn:6 row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index at the selected row");
}

- (void)testCellType_WithSelection_AtDetailRow_ReturnsUndefined
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row + 1;
    
    CCLCellType returnedType = [adjustment cellTypeForColumn:6 row:row];
    XCTAssertEqual(returnedType, CCLCellTypeUndefined, @"intercept & return day detail");
}

- (void)testCellType_WithSelection_AfterSelectedRow_AdjustsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row + 10;
    
    [adjustment cellTypeForColumn:9 row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row - 1, @"modify index after selected row");
}

- (void)testCellType_WithoutAnySelection_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_NoSelection];
    
    [adjustment cellTypeForColumn:9 row:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index");
    
    [adjustment cellTypeForColumn:55 row:10];
    XCTAssertEqual(testProvider.lastRowIndex, 10, @"shouldn't modify index");
    
    [adjustment cellTypeForColumn:3 row:100];
    XCTAssertEqual(testProvider.lastRowIndex, 100, @"shouldn't modify index");
}


#pragma mark Wrapping Object Value For Day

- (void)testObjectValue_WithSelection_BeforeSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    
    [adjustment objectValueForColumn:4 row:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index before selected row");
    
    NSUInteger row = selection.row - 1;
    [adjustment objectValueForColumn:14 row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index before selected row");
}

- (void)testObjectValue_WithSelection_AtSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row;
    
    [adjustment objectValueForColumn:8 row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index at the selected row");
}

- (void)testObjectValue_WithSelection_AfterSelectedRow_AdjustsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row + 10;
    
    [adjustment objectValueForColumn:9 row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row - 1, @"modify index after selected row");
}

- (void)testObjectValue_WithoutAnySelection_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_NoSelection];
    
    [adjustment objectValueForColumn:4 row:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index");
    
    [adjustment objectValueForColumn:22 row:10];
    XCTAssertEqual(testProvider.lastRowIndex, 10, @"shouldn't modify index");
    
    [adjustment objectValueForColumn:7 row:100];
    XCTAssertEqual(testProvider.lastRowIndex, 100, @"shouldn't modify index");
}


#pragma mark Wrapping Object Value For Week

- (void)testObjectValueRow_WithSelection_BeforeSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    
    [adjustment objectValueForRow:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index before selected row");
    
    NSUInteger row = selection.row - 1;
    [adjustment objectValueForRow:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index before selected row");
}

- (void)testObjectValueRow_WithSelection_AtSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row;
    
    [adjustment objectValueForRow:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index at the selected row");
}

- (void)testObjectValueRow_WithSelection_AfterSelectedRow_AdjustsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row + 10;
    
    [adjustment objectValueForRow:row];
    XCTAssertEqual(testProvider.lastRowIndex, row - 1, @"modify index after selected row");
}

- (void)testObjectValueRow_WithoutAnySelection_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_NoSelection];
    
    [adjustment objectValueForRow:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index");
    
    [adjustment objectValueForRow:10];
    XCTAssertEqual(testProvider.lastRowIndex, 10, @"shouldn't modify index");
    
    [adjustment objectValueForRow:100];
    XCTAssertEqual(testProvider.lastRowIndex, 100, @"shouldn't modify index");
}


#pragma mark Wrapping Month Name

- (void)testMonthName_WithSelection_BeforeSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    
    [adjustment monthNameForTableView:nil row:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index before selected row");
    
    NSUInteger row = selection.row - 1;
    [adjustment monthNameForTableView:nil row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index before selected row");
}

- (void)testMonthName_WithSelection_AtSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row;
    
    [adjustment monthNameForTableView:nil row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index at the selected row");
}

- (void)testMonthName_WithSelection_AfterSelectedRow_AdjustsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row + 10;
    
    [adjustment monthNameForTableView:nil row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row - 1, @"modify index after selected row");
}

- (void)testMonthName_WithoutAnySelection_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_NoSelection];
    
    [adjustment monthNameForTableView:nil row:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index");
    
    [adjustment monthNameForTableView:nil row:10];
    XCTAssertEqual(testProvider.lastRowIndex, 10, @"shouldn't modify index");
    
    [adjustment monthNameForTableView:nil row:100];
    XCTAssertEqual(testProvider.lastRowIndex, 100, @"shouldn't modify index");
}


#pragma mark Wrapping Row Count

- (void)testNumberOfRows_WithSelection_IncreasesRowCount
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    testProvider.numberOfRows = 33;
    
    NSUInteger count = [adjustment numberOfRows];
    
    XCTAssertEqual(count, 34, @"should increase number of rows in the model");
}

- (void)testNumberOfRows_WithoutAnySelection_ForwardsRowCount
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_NoSelection];
    testProvider.numberOfRows = 111;
    
    NSUInteger count = [adjustment numberOfRows];
    
    XCTAssertEqual(count, 111, @"should forward number of rows in the model");
}

@end
