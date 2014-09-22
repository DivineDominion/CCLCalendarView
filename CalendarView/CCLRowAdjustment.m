//
//  CCLRowAdjustment.m
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLRowAdjustment.h"
#import "CCLDayCellSelection.h"

@implementation CCLRowAdjustment
+ (instancetype)rowAdjustmentWithDelegate:(id<CCLProvidesTableData>)delegate
{
    return [[self alloc] initWithSelection:nil delegate:delegate];
}

+ (instancetype)rowAdjustmentForSelection:(CCLDayCellSelection *)selection delegate:(id<CCLProvidesTableData>)delegate
{
    return [[self alloc] initWithSelection:selection delegate:delegate];
}

- (instancetype)init
{
    return [self initWithSelection:nil delegate:nil];
}

- (instancetype)initWithSelection:(CCLDayCellSelection *)selection delegate:(id<CCLProvidesTableData>)delegate
{
    NSParameterAssert(delegate);
    
    self = [super init];
    
    if (self)
    {
        _dayCellSelection = selection;
        _delegate = delegate;
    }
    
    return self;
}


#pragma mark -

- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row
{
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate rowViewTypeForRow:row];
}

- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row
{
    row = [self rowAdjustedToSelectionWithRow:row];
    return [self.delegate cellTypeForColumn:column row:row];;
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

@end
