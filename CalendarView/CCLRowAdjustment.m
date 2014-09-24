//
//  CCLRowAdjustment.m
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLRowAdjustment.h"
#import "CCLDayCellSelection.h"

@interface CCLRowAdjustment ()
@property (strong, readwrite) CCLDayCellSelection *dayCellSelection;
@end

@implementation CCLRowAdjustment
+ (instancetype)rowAdjustmentForDelegate:(id<CCLProvidesTableData>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}

- (instancetype)init
{
    return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id<CCLProvidesTableData>)delegate
{
    NSParameterAssert(delegate);
    
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
    }
    
    return self;
}

#pragma mark -
#pragma mark Cell Selection

- (void)controllerDidSelectDayCell:(CCLDayCellSelection *)selection
{
    NSParameterAssert(selection);
    
    self.dayCellSelection = selection;
}

- (void)controllerDidDeselectDayCell
{
    [self.dayCellSelection deselectCell];
    self.dayCellSelection = nil;
}

- (BOOL)hasDayCellSelection
{
    return self.dayCellSelection != nil;
}

- (NSUInteger)dayCellSelectionRow
{
    return self.dayCellSelection.row;
}

- (CCLDayCellView *)dayCellSelectionView
{
    return self.dayCellSelection.selectedView;
}


#pragma mark -
#pragma mark Adapting the data source

- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row
{
    if ([self isDayDetailRow:row])
    {
        return CCLRowViewTypeDayDetail;
    }
    
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate rowViewTypeForRow:row];
}

- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row
{
    if ([self isDayDetailRow:row])
    {
        return CCLCellTypeDayDetail;
    }
    
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate cellTypeForColumn:column row:row];;
}

- (id)objectValueForTableView:(NSTableView *)tableView column:(NSInteger)column row:(NSInteger)row
{
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate objectValueForTableView:tableView column:column row:row];
}

- (NSUInteger)numberOfRows
{
    NSUInteger count = [self.delegate numberOfRows];
    
    if ([self hasSelection])
    {
        return count + 1;
    }
    
    return count;
}

- (NSUInteger)rowAdjustedToSelectionWithRow:(NSUInteger)row
{
    if ([self hasSelection])
    {
        NSUInteger selectionRow = self.dayCellSelection.row;
        if (row >= selectionRow)
        {
            return row - 1;
        }
    }
    
    return row;
}

- (BOOL)hasSelection
{
    return self.dayCellSelection != nil;
}

- (BOOL)isDayDetailRow:(NSUInteger)row
{
    if (![self hasSelection])
    {
        return NO;
    }
    
    NSUInteger dayDetailRow = [self dayCellSelectionRow] + 1;
    return row == dayDetailRow;
}

@end
