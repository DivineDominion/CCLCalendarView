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
         return [tableView makeViewWithIdentifier:@"MonthRow" owner:self];
    }
    
    if ([self hasSelectedDayCellInRowAbove:row])
    {
        return nil;
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
        return 120.;
    }
    
    return 80.;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
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
    if ([selectedRow.identifier isEqualToString:@"DayDetailRow"]
        || [selectedRow.identifier isEqualToString:@"MonthRow"]
        || selectedRow.isGroupRowStyle)
    {
        return;
    }
    
    CCLWeekRowView *week = (CCLWeekRowView *)selectedRow;
    // TODO select column -> display gap in grid line
    
    BOOL newSelectionIsOnSameRow = NO;
    if ([self hasSelectedDayCell])
    {
        NSInteger oldSelectionRow = self.cellSelection.row;
        if (oldSelectionRow == row)
        {
            newSelectionIsOnSameRow = YES;
        }
        
        if (!newSelectionIsOnSameRow)
        {
            [self removeDetailRow];
        }
        
        [self deselectDayCell];
        
        if (oldSelectionRow < row)
        {
            row--;
        }
    }
    
    CCLDayCellView *dayCellView = [tableView viewAtColumn:column row:row makeIfNecessary:YES];
    [self selectDayCell:dayCellView row:row column:column];
    
    if (!newSelectionIsOnSameRow)
    {
        [self insertDetailRow];
    }
}

- (void)deselectDayCell
{
    [self.cellSelection deselectCell];
}

- (void)removeDetailRow
{
    NSInteger rowBelow = self.cellSelection.row + 1;
    NSIndexSet *rowBelowIndexSet = [NSIndexSet indexSetWithIndex:rowBelow];
    [self.calendarTableView removeRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideUp];
}

- (void)selectDayCell:(CCLDayCellView *)selectedView row:(NSInteger)row column:(NSInteger)column
{
    CellObject *object = selectedView.objectValue;
    NSLog(@"%@", object.day);
    
    self.cellSelection = [CCLDayCellSelection dayCellSelection:selectedView atRow:row column:column];
}

- (void)insertDetailRow
{
    NSInteger rowBelow = self.cellSelection.row + 1;
    NSIndexSet *rowBelowIndexSet = [NSIndexSet indexSetWithIndex:rowBelow];
    [self.calendarTableView insertRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideDown];
}

@end
