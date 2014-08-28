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
    return self.selectedView != nil;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    CCLWeekRowView *week = [tableView makeViewWithIdentifier:@"WeekRow" owner:self];
    
    if (row == 5)
    {
        week = [tableView makeViewWithIdentifier:@"DayDetailRow" owner:self];
    }
    
    return week;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cell;
    
    if (row == 0)
    {
         cell = [tableView makeViewWithIdentifier:@"GroupCell" owner:self];
    }
    else if (row == 5)
    {
        cell = nil;
    }
    else
    {
         cell = [tableView makeViewWithIdentifier:@"WeekdayCell" owner:self];
    }
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0)
    {
        return 20.;
    }
    
    return 80.;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    NSInteger counter = ((row-1) * 7) + columnIndex + 1;
    return [CellObject cellObjectForDay:counter total:678];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 20;
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
    CCLWeekRowView *week = [tableView rowViewAtRow:row makeIfNecessary:YES];
    // TODO select column -> display gap in grid line
    
    CCLDayCellView *view = [self.calendarTableView viewAtColumn:column row:row makeIfNecessary:YES];
    CellObject *object = view.objectValue;
    NSLog(@"%@", object.day);
    
    if ([self hasSelectedDayCell])
    {
        [self.selectedView deselect];
    }
    
    self.selectedView = view;
    [view select];
}

@end
