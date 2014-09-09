//
//  CCLCalendarTableModelTranslator.m
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarTableModelTranslator.h"
#import "CCLProvidesCalendarObjects.h"
#import "CCLSelectsDayCells.h"
#import "CCLDateRange.h"
#import "CCLMonthsFactory.h"
#import "CCLTitleRows.h"
#import "CCLMonths.h"
#import "CCLMonth.h"

#import "CTWCalendarSupplier.h"

@interface CCLCalendarTableModelTranslator ()
@property (nonatomic, strong, readwrite) CCLMonths *months;
@property (nonatomic, strong, readwrite) CCLTitleRows *titleRows;
@end

@implementation CCLCalendarTableModelTranslator
+ (instancetype)calendarTableModelTranslatorFrom:(id<CCLProvidesCalendarObjects>)objectProvider
{
    return [[self alloc] initWithObjectProvider:objectProvider];
}

- (instancetype)init
{
    return [self initWithObjectProvider:nil];
}

- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider
{
    NSParameterAssert(objectProvider);
    
    self = [super init];
    
    if (self)
    {
        _objectProvider = objectProvider;
        [self updateMonths];
    }
    
    return self;
}

- (void)setObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider
{
    if (_objectProvider == objectProvider)
    {
        return;
    }
    
    _objectProvider = objectProvider;
    
    [self updateMonths];
}

- (void)updateMonths
{
    CCLDateRange *dateRange = self.objectProvider.dateRange;
    CCLMonthsFactory *monthsFactory = self.monthsFactory;
    CCLMonths *months = [monthsFactory monthsInDateRange:dateRange];
    self.months = months;
    self.titleRows = [CCLTitleRows titleRowsForMonths:months];
}

- (CCLMonthsFactory *)monthsFactory
{
    if (!_monthsFactory)
    {
        _monthsFactory = [CCLMonthsFactory monthsFactory];
    }
    
    return _monthsFactory;
}

#pragma mark -
#pragma mark Translation

- (id)objectValueForTableView:(NSTableView *)tableView column:(NSInteger)column row:(NSInteger)row
{
    NSInteger lastColumnIndex = tableView.tableColumns.count - 1;
    BOOL isLastColumn = (column == lastColumnIndex);
    
    id<CCLProvidesCalendarObjects> objectProvider = self.objectProvider;
    CCLDateRange *dateRange = objectProvider.dateRange;
    NSDateComponents *startDateComponents = [dateRange startDateCalendarComponents];
    NSUInteger year = startDateComponents.year;
    
    if (isLastColumn)
    {
        if (![objectProvider respondsToSelector:@selector(objectValueForYear:week:)])
        {
            return nil;
        }
        NSUInteger week = startDateComponents.week;
        
        return [objectProvider objectValueForYear:year week:week];
    }
    
    NSUInteger month = startDateComponents.month;
    NSUInteger day = startDateComponents.day;
    
    return [objectProvider objectValueForYear:year month:month day:day];
}

- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row
{
    if (row == 0)
    {
        return CCLRowViewTypeMonth;
    }
    
    if ([self hasSelectedDayCellInRowAbove:row])
    {
        return CCLRowViewTypeDayDetail;
    }
    
    CCLMonth *lastMonth = [self.months lastMonth];
    NSUInteger lastWeekCount = lastMonth.weekCount;
    NSUInteger lastTitleRow = [self.titleRows lastRow];
    NSUInteger maximumRows = lastTitleRow + lastWeekCount;
//  TODO insert detail row into the volatile 'model'
//    if ([self hasSelectedDayCell])
//    {
//        maximumRows += 1;
//    }
    
    if (row > maximumRows)
    {
        NSString *reason = [NSString stringWithFormat:@"row %lu is out of bounds (max: %lu)", row, maximumRows];
        @throw [NSException exceptionWithName:NSRangeException reason:reason userInfo:nil];
    }
    
    return CCLRowViewTypeWeek;
}

- (BOOL)hasSelectedDayCell
{
    id<CCLSelectsDayCells> delegate = self.selectionDelegate;
    
    if (!delegate || ![delegate respondsToSelector:@selector(hasSelectedDayCell)])
    {
        return NO;
    }
    
    return [delegate hasSelectedDayCell];
}

- (BOOL)hasSelectedDayCellInRowAbove:(NSUInteger)row
{
    NSInteger rowAbove = row - 1;
    id<CCLSelectsDayCells> delegate = self.selectionDelegate;
    
    if (!delegate
        || ![delegate respondsToSelector:@selector(cellSelectionRow)]
        || rowAbove < 0)
    {
        return NO;
    }
    
    NSInteger selectedRow = [delegate cellSelectionRow];
    
    if (selectedRow != rowAbove)
    {
        return NO;
    }
    
    return YES;
}

- (NSCalendar *)calendar
{
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
}

@end
