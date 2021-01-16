//
//  CCLRowAdjustment.m
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLRowAdjustment.h"
#import "CCLDayCellSelection.h"
#import "CCLDayCellView.h"

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
    self.dayCellSelection = nil;
}

- (BOOL)hasDayCellSelection
{
    return self.dayCellSelection != nil;
}

- (NSUInteger)dayCellSelectionRow
{
    if (self.dayCellSelection == nil)
    {
        NSAssert(false, @"dayCellSelection is nil; check hasDayCellSelection first");
        return 0;
    }

    return self.dayCellSelection.row;
}

- (NSUInteger)dayCellSelectionColumn
{
    if (self.dayCellSelection == nil)
    {
        NSAssert(false, @"dayCellSelection is nil; check hasDayCellSelection first");
        return 0;
    }

    return self.dayCellSelection.column;
}

- (id)dayCellSelectionObjectValue
{
    if (self.dayCellSelection == nil)
    {
        NSAssert(false, @"dayCellSelection is nil; check hasDayCellSelection first");
        return nil;
    }

    return self.dayCellSelection.objectValue;
}

- (void)configureDayCellView:(CCLDayCellView *)dayCellView row:(NSUInteger)row column:(NSUInteger)column
{
    if (self.dayCellSelection == nil
        || self.dayCellSelectionRow != row
        || self.dayCellSelectionColumn != column)
    {
        [dayCellView deselect];
        return;
    }

    [dayCellView select];
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
        return CCLCellTypeUndefined;
    }
    
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate cellTypeForColumn:column row:row];;
}

- (id)objectValueForColumn:(NSInteger)column row:(NSInteger)row
{
    if ([self isDayDetailRow:row])
    {
        return nil;
    }
    
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate objectValueForColumn:column row:row];
}

- (id)objectValueForRow:(NSInteger)row
{
    if ([self isDayDetailRow:row])
    {
        return nil;
    }
    
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate objectValueForRow:row];
}

- (NSString *)monthNameForTableView:(NSTableView *)tableView row:(NSInteger)row
{
    if ([self isDayDetailRow:row])
    {
        return nil;
    }
    
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate monthNameForTableView:tableView row:row];
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
        NSUInteger dayDetailRow = [self dayDetailRow];
        if (row >= dayDetailRow)
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
    
    NSUInteger dayDetailRow = [self dayDetailRow];
    return row == dayDetailRow;
}

- (NSUInteger)dayDetailRow
{
    return [self dayCellSelectionRow] + 1;
}

@end
