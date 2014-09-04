//
//  CCLCalendarViewController.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarViewController.h"

// Collaborators
#import "CCLHandleDaySelection.h"
#import "CCLProvidesCalendarObjects.h"
#import "CCLCalendarTableModelTranslator.h"

// Components
#import "CCLDayCellSelection.h"
#import "CCLCalendarView.h"
#import "CCLWeekRowView.h"
#import "CCLDayDetailRowView.h"
#import "CCLDayCellView.h"

NSString * const kCCLCalendarViewControllerNibName = @"CCLCalendarViewController";

@interface CCLCalendarViewController ()
@property (strong, readwrite) CCLDayCellSelection *cellSelection;
@property (nonatomic, strong, readwrite) CCLCalendarTableModelTranslator *tableModelTranslator;
@end

@implementation CCLCalendarViewController

+ (instancetype)calendarViewController
{
    return [[self alloc] initWithNibName:kCCLCalendarViewControllerNibName
                                  bundle:[NSBundle mainBundle]];
}

- (void)setObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider
{
    if (_objectProvider == objectProvider)
    {
        return;
    }
    
    _objectProvider = objectProvider;
    
    [self updateTableModelTranslator];
}

- (void)updateTableModelTranslator
{
    id<CCLProvidesCalendarObjects> objectProvider = self.objectProvider;
    
    if (objectProvider == nil)
    {
        self.tableModelTranslator = nil;
        return;
    }
    
    self.tableModelTranslator = [CCLCalendarTableModelTranslator calendarTableModelTranslatorFrom:objectProvider];
}

- (BOOL)hasSelectedDayCell
{
    return self.cellSelection != nil;
}

- (BOOL)hasSelectedDayCellInRowAbove:(NSInteger)row
{
    NSInteger rowAbove = row - 1;
    return [self hasSelectedDayCell] && self.cellSelection.row == rowAbove;
}


#pragma mark -
#pragma mark View Setup

- (void)awakeFromNib
{
    [self.calendarTableView setIntercellSpacing:NSMakeSize(0, 0)];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger numberOfRows = 20;
    [self.objectProvider dateRange];
    
    if ([self hasSelectedDayCell])
    {
        numberOfRows++;
    }
    
    return numberOfRows;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    if (row == 0)
    {
        return [tableView makeViewWithIdentifier:@"MonthRow" owner:self];
    }
    
    if ([self hasSelectedDayCellInRowAbove:row])
    {
        return [tableView makeViewWithIdentifier:@"DayDetailRow" owner:self];
    }
    
    return [tableView makeViewWithIdentifier:@"WeekRow" owner:self];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    BOOL isGroupRow = row == 0;
    if (isGroupRow)
    {
         return [tableView makeViewWithIdentifier:@"MonthCell" owner:self];
    }
    
    if ([self hasSelectedDayCellInRowAbove:row])
    {
        return nil;
    }
    
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    BOOL isLastColumn = (columnIndex == tableView.tableColumns.count - 1);
    
    if (isLastColumn)
    {
        NSTableRowView *row = [tableView makeViewWithIdentifier:@"WeekTotalCell" owner:self];
        row.backgroundColor = [NSColor grayColor];
        return row;
    }
    
    return [tableView makeViewWithIdentifier:@"WeekdayCell" owner:self];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0)
    {
        return 20.;
    }
    
    if ([self hasSelectedDayCellInRowAbove:row])
    {
        return 140.;
    }
    
    return 80.;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    
    return [self.tableModelTranslator objectValueForTableView:self.calendarTableView column:columnIndex row:rowIndex];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    if (row == 0)
    {
        return YES;
    }
    
    return NO;
}


#pragma mark Table Change Callbacks

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
{
    if (![rowView.identifier isEqualToString:@"DayDetailRow"])
    {
        return;
    }
    
    self.dayDetailRowView = (CCLDayDetailRowView *)rowView;
}


#pragma mark -
#pragma mark Cell Selection

- (void)tableView:(NSTableView *)tableView didSelectCellViewAtRow:(NSInteger)row column:(NSInteger)column
{
    NSTableRowView *selectedRow = [tableView rowViewAtRow:row makeIfNecessary:YES];
    if (![selectedRow.identifier isEqualToString:@"WeekRow"])
    {
        return;
    }
    
    NSTableCellView *selectedCell = [tableView viewAtColumn:column row:row makeIfNecessary:YES];
    BOOL newSelectionIsOnSameRow = NO;
    if ([self hasSelectedDayCell])
    {
        NSInteger oldSelectionRow = self.cellSelection.row;
        if (oldSelectionRow == row)
        {
            newSelectionIsOnSameRow = YES;
        }
        
        if (!newSelectionIsOnSameRow || [selectedCell.identifier isEqualToString:@"WeekTotalCell"])
        {
            [self removeDetailRow];
        }
        
        [self deselectDayCell];
        
        if (oldSelectionRow < row)
        {
            row--;
        }
    }
    
    if ([selectedCell.identifier isEqualToString:@"WeekTotalCell"])
    {
        return;
    }
    
    CCLDayCellView *dayCellView = (CCLDayCellView *)selectedCell;
    [self selectDayCell:dayCellView row:row column:column];
    
    if (newSelectionIsOnSameRow)
    {
        return;
    }
    
    [self insertDetailRow];
}

- (void)deselectDayCell
{
    [self.cellSelection deselectCell];
    self.cellSelection = nil;
}

- (void)removeDetailRow
{
    if (self.dayDetailRowView == nil)
    {
        return;
    }
    
    NSInteger rowBelow = [self.calendarTableView rowForView:self.dayDetailRowView];
    NSIndexSet *rowBelowIndexSet = [NSIndexSet indexSetWithIndex:rowBelow];
    [self.calendarTableView removeRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideUp];
}

- (void)selectDayCell:(CCLDayCellView *)selectedView row:(NSInteger)row column:(NSInteger)column
{
    self.cellSelection = [CCLDayCellSelection dayCellSelection:selectedView atRow:row column:column];
    
    id objectValue = selectedView.objectValue;
    NSView *detailView = [self.eventHandler detailViewForObjectValue:objectValue];
    // TODO display view in detail row
    
    [self.eventHandler calendarViewController:self
                 didSelectCellWithObjectValue:objectValue];
}

- (void)insertDetailRow
{
    NSInteger rowBelow = self.cellSelection.row + 1;
    NSIndexSet *rowBelowIndexSet = [NSIndexSet indexSetWithIndex:rowBelow];
    [self.calendarTableView insertRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideDown];
}

@end
