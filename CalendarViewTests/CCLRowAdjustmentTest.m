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
    return [CCLRowAdjustment rowAdjustmentForSelection:selection delegate:testProvider];
}

- (CCLRowAdjustment *)rowAdjustment_NoSelection
{
    return [CCLRowAdjustment rowAdjustmentWithDelegate:testProvider];
}


#pragma mark -
#pragma mark Row View Type

- (void)testRowViewType_WithSelection_BeforeSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    
    [adjustment rowViewTypeForRow:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index before selected row");
    
    NSUInteger row = selection.row - 1;
    [adjustment rowViewTypeForRow:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index before selected row");
}

- (void)testRowViewType_WithSelection_AtSelectedRow_AdjustsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row;
    
    [adjustment rowViewTypeForRow:row];
    
    XCTAssertEqual(testProvider.lastRowIndex, row - 1, @"modify index at the selected row");
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


#pragma mark -
#pragma mark Cell View Type

- (void)testCellType_WithSelection_BeforeSelectedRow_ForwardsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    
    [adjustment cellTypeForColumn:3 row:0];
    XCTAssertEqual(testProvider.lastRowIndex, 0, @"shouldn't modify index before selected row");
    
    NSUInteger row = selection.row - 1;
    [adjustment cellTypeForColumn:10 row:row];
    XCTAssertEqual(testProvider.lastRowIndex, row, @"shouldn't modify index before selected row");
}

- (void)testCellType_WithSelection_AtSelectedRow_AdjustsRow
{
    CCLRowAdjustment *adjustment = [self rowAdjustment_IncludingSelection];
    NSUInteger row = selection.row;
    
    [adjustment cellTypeForColumn:6 row:row];
    
    XCTAssertEqual(testProvider.lastRowIndex, row - 1, @"modify index at the selected row");
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


@end
