//
//  CCLCalendarViewController.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarViewController.h"

// Collaborators
#import "CCLHandlesDaySelection.h"
#import "CCLProvidesCalendarObjects.h"
#import "CCLCalendarViewModel.h"
#import "CCLRowAdjustment.h"

// Components
#import "CCLDayCellSelection.h"
#import "CCLCalendarView.h"
#import "CCLWeekRowView.h"
#import "CCLDayDetailRowView.h"
#import "CCLDayCellView.h"

NSString * const kCCLCalendarViewControllerNibName = @"CCLCalendarViewController";

@interface CCLCalendarViewController ()
@property (nonatomic, strong, readwrite) id<CCLProvidesTableData> tableDataProvider;
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
        self.tableDataProvider = nil;
        return;
    }
    
    CCLCalendarViewModel *model = [CCLCalendarViewModel calendarVieweModelFrom:objectProvider];
    CCLRowAdjustment *rowAdjustment = [CCLRowAdjustment rowAdjustmentForDelegate:model];
    self.tableDataProvider = rowAdjustment;
    self.selectionDelegate = rowAdjustment;
}

#pragma mark -
#pragma mark View Setup

- (void)awakeFromNib
{
    [self.calendarTableView setIntercellSpacing:NSMakeSize(0, 0)];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.tableDataProvider numberOfRows];
}


#pragma mark Row Views

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    CCLRowViewType rowViewType = [self.tableDataProvider rowViewTypeForRow:row];
    NSTableRowView *rowView = [self tableView:tableView rowViewForRowViewType:rowViewType];
    
    return rowView;
}

/// @returns Returns @p nil when @p rowViewType is not supported.
- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRowViewType:(CCLRowViewType)rowViewType
{
    [self guardRowViewTypeValidity:rowViewType];
    
    if (rowViewType == CCLRowViewTypeMonth)
    {
        return [tableView makeViewWithIdentifier:@"MonthRow" owner:self];
    }
    
    if (rowViewType == CCLRowViewTypeDayDetail)
    {
        return [tableView makeViewWithIdentifier:@"DayDetailRow" owner:self];
    }
    
    if (rowViewType == CCLRowViewTypeWeek)
    {
        return [tableView makeViewWithIdentifier:@"WeekRow" owner:self];
    }
    
    return nil;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    CCLRowViewType rowViewType = [self.tableDataProvider rowViewTypeForRow:row];
    
    if (rowViewType == CCLRowViewTypeMonth)
    {
        return YES;
    }
    
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    CCLRowViewType rowViewType = [self.tableDataProvider rowViewTypeForRow:row];
    CGFloat height = [self tableView:tableView heightOfRowViewType:rowViewType];
    
    return height;
}

- (CGFloat)tableView:(NSTableView *)tableview heightOfRowViewType:(CCLRowViewType)rowViewType
{
    [self guardRowViewTypeValidity:rowViewType];
    
    if (rowViewType == CCLRowViewTypeMonth)
    {
        return 20.;
    }
    
    if (rowViewType == CCLRowViewTypeDayDetail)
    {
        return 140.;
    }
    
    return 80.;
}

- (void)guardRowViewTypeValidity:(CCLRowViewType)rowViewType
{
    NSAssert(rowViewType != CCLRowViewTypeUndefined, @"rowViewType should never become Undefined");
}


#pragma mark Cell Views

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    CCLRowViewType rowViewType = [self.tableDataProvider rowViewTypeForRow:row];
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    BOOL isLastColumn = (columnIndex == tableView.tableColumns.count - 1);
    
    if (isLastColumn && rowViewType != CCLRowViewTypeDayDetail)
    {
        NSTableRowView *cell = [tableView makeViewWithIdentifier:@"WeekTotalCell" owner:self];
        cell.backgroundColor = [NSColor grayColor];
        return cell;
    }

    CCLCellType cellType = [self.tableDataProvider cellTypeForColumn:columnIndex row:row];
    NSView *cellView = [self tableView:tableView viewForCellType:cellType];
    
    return cellView;
}

- (NSView *)tableView:(NSTableView *)tableView viewForCellType:(CCLCellType)cellType
{
    if (cellType == CCLCellTypeMonth)
    {
        return [tableView makeViewWithIdentifier:@"MonthCell" owner:self];
    }
    
    if (cellType == CCLCellTypeDayDetail)
    {
        return nil;
    }
    
    if (cellType == CCLCellTypeBlank)
    {
#warning stub
        return nil;
    }
    
    if (cellType != CCLCellTypeWeekend && cellType != CCLCellTypeDay)
    {
        return nil;
    }
    
    CCLDayCellView *view = [tableView makeViewWithIdentifier:@"WeekdayCell" owner:self];
    view.isWeekend = (cellType == CCLCellTypeWeekend);
//    id object;
//    view.objectValue = object;
    
    return view;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    return [self.tableDataProvider objectValueForTableView:self.calendarTableView column:columnIndex row:rowIndex];
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
    CCLRowViewType rowViewType = [self.tableDataProvider rowViewTypeForRow:row];
    if (rowViewType != CCLRowViewTypeWeek)
    {
        return;
    }
    
    NSTableCellView *selectedCell = [tableView viewAtColumn:column row:row makeIfNecessary:YES];
    BOOL isUnselectableCell = (selectedCell == nil || [selectedCell.identifier isEqualToString:@"WeekTotalCell"]);
    
    if (![self hasSelectedDayCell])
    {
        if (isUnselectableCell)
        {
            return;
        }
        
        CCLDayCellView *dayCellView = (CCLDayCellView *)selectedCell;
        [self selectDayCell:dayCellView row:row column:column];
        [self insertDetailRow];
        [self displayDayDetail];
        return;
    }
    
    // Deselect on a second click into the same cell
    if (([self cellSelectionRow] == row && [self cellSelectionColumn] == column)
        || isUnselectableCell)
    {
        [self removeDetailRow];
        [self deselectDayCell];
        return;
    }
    
    NSInteger oldSelectionRow = [self cellSelectionRow];
    BOOL newSelectionIsOnSameRow = (oldSelectionRow == row);
    
    if (oldSelectionRow < row)
    {
        row--;
    }
    
    if (!newSelectionIsOnSameRow)
    {
        [self removeDetailRow];
    }
    
    [self deselectDayCell];
    CCLDayCellView *dayCellView = (CCLDayCellView *)selectedCell;
    [self selectDayCell:dayCellView row:row column:column];
    
    if (!newSelectionIsOnSameRow)
    {
        [self insertDetailRow];
    }
    
    [self displayDayDetail];
}

- (BOOL)hasSelectedDayCell
{
    return [self.selectionDelegate hasDayCellSelection];
}

- (NSUInteger)cellSelectionRow
{
    return [self.selectionDelegate dayCellSelectionRow];
}

- (NSUInteger)cellSelectionColumn
{
    return [self.selectionDelegate dayCellSelectionColumn];
}

- (void)deselectDayCell
{
    [self.selectionDelegate controllerDidDeselectDayCell];
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

- (void)selectDayCell:(CCLDayCellView *)selectedView row:(NSUInteger)row column:(NSUInteger)column
{
    CCLDayCellSelection *selection = [CCLDayCellSelection dayCellSelection:selectedView atRow:row column:column];
    [self.selectionDelegate controllerDidSelectDayCell:selection];
    
    id objectValue = selectedView.objectValue;
    [self.eventHandler calendarViewController:self
                 didSelectCellWithObjectValue:objectValue];
}

- (void)insertDetailRow
{
    NSUInteger selectionRow = [self cellSelectionRow];
    NSInteger rowBelow = selectionRow + 1;
    NSIndexSet *rowBelowIndexSet = [NSIndexSet indexSetWithIndex:rowBelow];
    [self.calendarTableView insertRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideDown];
}

- (void)displayDayDetail
{
    id objectValue = [self.selectionDelegate dayCellSelectionObjectValue];
    NSView *detailView = [self.eventHandler detailViewForObjectValue:objectValue];
    CCLDayDetailRowView *rowView = self.dayDetailRowView;
    [rowView displayDetailView:detailView];
}

@end
