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
#import "CCLProvidesDetailView.h"
#import "CCLCalendarViewModel.h"
#import "CCLRowAdjustment.h"
#import "CTKCalendarSupplier.h"

// Components
#import "CCLDayCellSelection.h"
#import "CCLCalendarView.h"
#import "CCLWeekRowView.h"
#import "CCLDayDetailRowView.h"
#import "CCLMonthRowView.h"
#import "CCLDayCellView.h"

NSString * const kCCLCalendarViewControllerNibName = @"CCLCalendarViewController";

@interface CCLCalendarViewController ()
{
    dispatch_once_t initializationToken;
}

@property (nonatomic, strong, readwrite) id<CCLProvidesTableData> tableDataProvider;
@property (assign, readwrite) BOOL showsAllWeekColumn;
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
    
    [self updateAllWeekColumn];
    [self updateTableModelTranslator];
}

- (void)updateAllWeekColumn
{
    id<CCLProvidesCalendarObjects> objectProvider = self.objectProvider;
    NSTableView *tableView = self.calendarTableView;
    
    if (tableView == nil)
    {
        return;
    }
    
    if (objectProvider == nil || ![objectProvider respondsToSelector:@selector(objectValueForYear:week:)])
    {
        [self hideWeekColumnInTableView:tableView];
        return;
    }
    
    [self showWeekColumnInTableView:tableView];
}

- (void)hideWeekColumnInTableView:(NSTableView *)tableView;
{
    NSTableColumn *allWeekColumn = [tableView tableColumnWithIdentifier:@"AllWeekColumn"];
    if (allWeekColumn == nil)
    {
        return;
    }
    
    [tableView removeTableColumn:allWeekColumn];
    self.showsAllWeekColumn = NO;
}

- (void)showWeekColumnInTableView:(NSTableView *)tableView;
{
    NSTableColumn *existingAllWeekColumn = [tableView tableColumnWithIdentifier:@"AllWeekColumn"];
    if (existingAllWeekColumn != nil)
    {
        return;
    }
    
    NSTableColumn *allWeekColumn = [[NSTableColumn alloc] initWithIdentifier:@"AllWeekColumn"];
    [tableView addTableColumn:allWeekColumn];
    self.showsAllWeekColumn = YES;
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
    dispatch_once(&initializationToken, ^{
        NSTableView *tableView = self.calendarTableView;
        [tableView setIntercellSpacing:NSMakeSize(0, 0)];
        
        [self addWeekdayColumns];
        [self updateAllWeekColumn];
    });
}

- (void)addWeekdayColumns
{
    NSUInteger weekdays = [self weekdays];
    NSTableView *tableView = self.calendarTableView;
    
    [tableView removeTableColumn:[tableView tableColumnWithIdentifier:@"Templates"]];
    
    for (int i = 0; i < weekdays; i++)
    {
        [self addWeekdayColumnInTableView:tableView];
    }
}

- (void)addWeekdayColumnInTableView:(NSTableView *)tableView
{
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:@"WeekdayColumn"];
    [tableView addTableColumn:tableColumn];
}

- (NSUInteger)weekdays
{
    NSCalendar *calendar = [self calendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    return weekdayRange.length;
}

- (NSCalendar *)calendar
{
    return [[CTKCalendarSupplier calendarSupplier] autoupdatingCalendar];
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
        return [self heightOfDetailView];
    }
    
    return 70.;
}

- (NSUInteger)heightOfDetailView
{
    id<CCLProvidesDetailView> detailViewProvider = self.detailViewProvider;
    
    if ([detailViewProvider respondsToSelector:@selector(heightOfDetailView)])
    {
        return [self.detailViewProvider heightOfDetailView];
    }
    
    return 140.;
}

- (void)guardRowViewTypeValidity:(CCLRowViewType)rowViewType
{
    NSAssert(rowViewType != CCLRowViewTypeUndefined, @"rowViewType should never become Undefined");
}


#pragma mark Cell Views

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    CCLRowViewType rowViewType = [self.tableDataProvider rowViewTypeForRow:rowIndex];
    
    if (self.showsAllWeekColumn && rowViewType != CCLRowViewTypeDayDetail)
    {
        BOOL isLastColumn = (columnIndex == tableView.tableColumns.count - 1);
        if (isLastColumn)
        {
            [self.tableDataProvider objectValueForRow:rowIndex];
        }
    }
    
    return [self.tableDataProvider objectValueForColumn:columnIndex row:rowIndex];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    BOOL isLastColumn = (columnIndex == tableView.tableColumns.count - 1);
    CCLRowViewType rowViewType = [self.tableDataProvider rowViewTypeForRow:rowIndex];
    
    if (self.showsAllWeekColumn && isLastColumn && rowViewType != CCLRowViewTypeDayDetail)
    {
#warning stub: add Week Total Cell
        CCLBorderedCellView *cellView = [tableView makeViewWithIdentifier:@"WeekTotalCell" owner:self];
        return cellView;
    }
    
    CCLCellType cellType = [self.tableDataProvider cellTypeForColumn:columnIndex row:rowIndex];
    
    if (cellType == CCLCellTypeBlank && !isLastColumn)
    {
        NSUInteger nextColumnIndex = columnIndex + 1;
        CCLCellType nextCellType = [self.tableDataProvider cellTypeForColumn:nextColumnIndex row:rowIndex];
        if (nextCellType != CCLCellTypeBlank)
        {
            CCLBorderedCellView *cellView = [[CCLBorderedCellView alloc] init];
            //[tableView makeViewWithIdentifier:@"WeekdayCell" owner:self];
            return cellView;
        }
    }
    
    if (cellType != CCLCellTypeWeekend && cellType != CCLCellTypeDay)
    {
        return nil;
    }
    
    CCLDayCellView *cellView = [tableView makeViewWithIdentifier:@"WeekdayCell" owner:self];
    cellView.isWeekend = (cellType == CCLCellTypeWeekend);
    
    return cellView;
}


#pragma mark Table Change Callbacks

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
{
    if ([rowView.identifier isEqualToString:@"MonthRow"])
    {
        CCLMonthRowView *monthView = (CCLMonthRowView *)rowView;
        NSString *monthName = [self.tableDataProvider monthNameForTableView:tableView row:row];
        monthView.monthName = monthName;
        return;
    }
    
    CGFloat zPosition = 100;
    if ([rowView.identifier isEqualToString:@"DayDetailRow"])
    {
        // Set subview values in -displayDayDetail manually b/c the row may stay
        // in place but the selection changes, so this method won't be called.
        self.dayDetailRowView = (CCLDayDetailRowView *)rowView;
        zPosition = -100;
    }
    
    [rowView.layer setZPosition:zPosition];
}


#pragma mark -
#pragma mark Cell Selection

- (void)tableView:(NSTableView *)tableView didSelectCellViewAtRow:(NSInteger)row column:(NSInteger)column
{
    if (row < 0 || [self.tableDataProvider rowViewTypeForRow:row] != CCLRowViewTypeWeek)
    {
        [self collapseDetailView];
        return;
    }
    
    NSTableCellView *selectedCell = [tableView viewAtColumn:column row:row makeIfNecessary:YES];
    BOOL isUnselectableCell = (selectedCell == nil || ![selectedCell.identifier isEqualToString:@"WeekdayCell"]);
    
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
    if ([self isSelectionInRow:row column:column] || isUnselectableCell)
    {
        [self collapseDetailView];
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

- (void)collapseDetailView
{
    [self removeDetailRow];
    [self deselectDayCell];
}

- (BOOL)isSelectionInRow:(NSInteger)row column:(NSInteger)column
{
    if (![self hasSelectedDayCell])
    {
        return NO;
    }
    
    return [self cellSelectionRow] == row && [self cellSelectionColumn] == column;
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
    [self.calendarTableView removeRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideDown];
    
    [self fireWillRemoveDetailView];
}

- (void)selectDayCell:(CCLDayCellView *)selectedView row:(NSUInteger)row column:(NSUInteger)column
{
    CCLDayCellSelection *selection = [CCLDayCellSelection dayCellSelection:selectedView atRow:row column:column];
    id objectValue = selectedView.objectValue;
    
    [self.selectionDelegate controllerDidSelectDayCell:selection];
    [self fireDidSelectCellWithObjectValue:objectValue];
}

- (void)insertDetailRow
{
    NSUInteger selectionRow = [self cellSelectionRow];
    NSInteger rowBelow = selectionRow + 1;
    NSIndexSet *rowBelowIndexSet = [NSIndexSet indexSetWithIndex:rowBelow];
    [self.calendarTableView insertRowsAtIndexes:rowBelowIndexSet withAnimation:NSTableViewAnimationSlideUp];
    
    const double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    id<CCLHandlesDaySelection> eventHandler = self.eventHandler;
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (![eventHandler respondsToSelector:@selector(calendarViewControllerDidAddDetailView:)])
        {
            return;
        }
        
        [eventHandler calendarViewControllerDidAddDetailView:self];
    });
}

- (void)displayDayDetail
{
    id objectValue = [self.selectionDelegate dayCellSelectionObjectValue];
    NSView *detailView = [self.detailViewProvider detailViewForObjectValue:objectValue];
    CCLDayDetailRowView *rowView = self.dayDetailRowView;
    [rowView displayDetailView:detailView];
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
{
    [self fireDidRemoveDetailView];
}


#pragma mark -
#pragma mark Delegate Notifications

- (void)fireDidSelectCellWithObjectValue:(id)objectValue
{
    id<CCLHandlesDaySelection> eventHandler = self.eventHandler;
    
    if (![eventHandler respondsToSelector:@selector(calendarViewController:didSelectCellWithObjectValue:)])
    {
        return;
    }
    
    [eventHandler calendarViewController:self didSelectCellWithObjectValue:objectValue];
}

- (void)fireWillRemoveDetailView
{
    id<CCLHandlesDaySelection> eventHandler = self.eventHandler;

    if (![eventHandler respondsToSelector:@selector(calendarViewControllerWillRemoveDetailView:)])
    {
        return;
    }
    
    [eventHandler calendarViewControllerWillRemoveDetailView:self];
}

- (void)fireDidRemoveDetailView
{
    id<CCLHandlesDaySelection> eventHandler = self.eventHandler;
    
    if (![eventHandler respondsToSelector:@selector(calendarViewControllerDidRemoveDetailView:)])
    {
        return;
    }
    
    [eventHandler calendarViewControllerDidRemoveDetailView:self];
}

@end
