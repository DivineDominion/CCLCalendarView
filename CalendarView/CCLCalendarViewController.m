//
//  CCLCalendarViewController.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarViewController.h"
#import "CCLCalendarView.h"

#import "CCLDayCellView.h"
#import "CCLWeekRowView.h"
#import "CCLDayCellSelection.h"
#import "CCLDayDetailRowView.h"

@interface CellObject : NSObject
@property (copy) NSNumber *day;
@property (copy) NSNumber *total;

+ (instancetype)cellObjectForDay:(NSUInteger)day total:(NSUInteger)total;
@end

@implementation CellObject
+ (instancetype)cellObjectForDay:(NSUInteger)day total:(NSUInteger)total
{
    CellObject *result = [[self alloc] init];
    result.day = @(day);
    result.total = @(total);
    return result;
}
@end


@interface CCLCalendarViewController ()

@end

@implementation CCLCalendarViewController

- (void)awakeFromNib
{
    [self.calendarTableView setIntercellSpacing:NSMakeSize(0, 0)];
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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger numberOfRows = 20;
    
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

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    BOOL isLastColumn = (columnIndex == tableView.tableColumns.count - 1);
    
    if (isLastColumn)
    {
        return nil;
    }
    
    NSInteger counter = ((row-1) * 7) + columnIndex + 1;
    return [CellObject cellObjectForDay:counter total:678];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    if (row == 0)
    {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(NSTableView *)tableView didSelectCellViewAtRow:(NSInteger)row column:(NSInteger)column
{
    NSTableRowView *selectedRow = [tableView rowViewAtRow:row makeIfNecessary:YES];
    if (![selectedRow.identifier isEqualToString:@"WeekRow"])
    {
        return;
    }
    
    CCLWeekRowView *week = (CCLWeekRowView *)selectedRow;
    // TODO select column -> display gap in grid line
    
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
    CellObject *object = selectedView.objectValue;
    // TODO pass cell object to adapter
    
    self.cellSelection = [CCLDayCellSelection dayCellSelection:selectedView atRow:row column:column];
}

- (void)insertDetailRow
{
    NSInteger rowBelow = self.cellSelection.row + 1;
    NSIndexSet *rowBelowIndexSet = [NSIndexSet indexSetWithIndex:rowBelow];
    [self.calendarTableView insertRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideDown];
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
{
    if (![rowView.identifier isEqualToString:@"DayDetailRow"])
    {
        return;
    }
    
    self.dayDetailRowView = (CCLDayDetailRowView *)rowView;
}

@end
